import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/event_item.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../agenda/presentation/providers/agenda_providers.dart';
import '../../../agenda/presentation/widgets/event_type_labels.dart';
import '../providers/members_providers.dart';

/// Pantalla de validación de entradas por QR (solo coordinador+).
///
/// Primero se elige el evento a validar; después se abre el escáner a
/// pantalla completa. Se navega a ella con `Navigator.push`, sin tocar el
/// router principal.
class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  EventItem? _event;

  @override
  Widget build(BuildContext context) {
    final event = _event;
    if (event == null) {
      return _EventPicker(
        onSelected: (selected) => setState(() => _event = selected),
      );
    }
    return _ScannerView(
      event: event,
      onChangeEvent: () => setState(() => _event = null),
    );
  }
}

/// Paso 1: selección del evento a validar.
///
/// Muestra los eventos publicados de hoy y mañana. Si no hay ninguno, permite
/// continuar con cualquier evento de los próximos 7 días.
class _EventPicker extends ConsumerWidget {
  const _EventPicker({required this.onSelected});

  final ValueChanged<EventItem> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingAsync = ref.watch(upcomingEventsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Elegir evento')),
      body: upcomingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(upcomingEventsProvider),
        ),
        data: (events) {
          final now = DateTime.now();
          final startToday = DateTime(now.year, now.month, now.day);
          // Fin de mañana (23:59:59) para incluir eventos de los dos días.
          final endTomorrow = startToday
              .add(const Duration(days: 2))
              .subtract(const Duration(seconds: 1));
          final endWeek = startToday.add(const Duration(days: 7));

          bool inRange(EventItem e, DateTime from, DateTime to) {
            final start = e.start;
            if (start == null) return false;
            return !start.isBefore(from) && !start.isAfter(to);
          }

          final todayTomorrow = events
              .where((e) => inRange(e, startToday, endTomorrow))
              .toList();
          final nextWeek = events
              .where((e) => inRange(e, startToday, endWeek))
              .toList();

          if (todayTomorrow.isEmpty && nextWeek.isEmpty) {
            return const EmptyState(
              icon: Icons.event_busy_outlined,
              title: 'Sin eventos próximos',
              message:
                  'No hay eventos publicados en los próximos días para '
                  'validar entradas.',
            );
          }

          final showFallback = todayTomorrow.isEmpty;
          final list = showFallback ? nextWeek : todayTomorrow;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                showFallback
                    ? 'No hay eventos hoy ni mañana. Elige uno de los '
                          'próximos 7 días:'
                    : 'Eventos de hoy y mañana:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              ...list.map(
                (event) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(EventTypeLabels.icon(event.type)),
                    title: Text(event.title),
                    subtitle: Text(
                      [
                        EventTypeLabels.label(event.type),
                        if (event.start != null)
                          Formatters.dateTime.format(event.start!),
                      ].join(' · '),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => onSelected(event),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Paso 2: escáner de QR a pantalla completa con recuento de validados.
class _ScannerView extends ConsumerStatefulWidget {
  const _ScannerView({required this.event, required this.onChangeEvent});

  final EventItem event;
  final VoidCallback onChangeEvent;

  @override
  ConsumerState<_ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends ConsumerState<_ScannerView> {
  final MobileScannerController _controller = MobileScannerController();
  final TextEditingController _manualController = TextEditingController();

  /// Últimos uid procesados (para ignorar lecturas repetidas durante 5 s).
  final Map<String, DateTime> _recentUids = {};

  int _validated = 0;
  bool _processing = false;
  _ScanResult? _result;
  Timer? _resultTimer;

  @override
  void dispose() {
    _resultTimer?.cancel();
    _controller.dispose();
    _manualController.dispose();
    super.dispose();
  }

  /// Muestra un resultado temporal (éxito/error) durante 2 segundos.
  void _showResult(_ScanResult result) {
    _resultTimer?.cancel();
    setState(() => _result = result);
    _resultTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _result = null);
    });
  }

  /// Procesa una lectura del escáner: parsea el QR y valida la entrada.
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    final raw = capture.barcodes.isNotEmpty
        ? capture.barcodes.first.rawValue
        : null;
    if (raw == null || raw.isEmpty) return;

    String? uid;
    int? number;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      uid = decoded['uid'] as String?;
      final n = decoded['n'];
      number = n is int ? n : int.tryParse(n?.toString() ?? '');
    } catch (_) {
      _showResult(const _ScanResult.error('Código QR no reconocido'));
      return;
    }
    if (uid == null || uid.isEmpty) {
      _showResult(const _ScanResult.error('Código QR sin socio válido'));
      return;
    }

    // Debounce: ignora el mismo uid durante 5 segundos.
    final last = _recentUids[uid];
    final now = DateTime.now();
    if (last != null && now.difference(last) < const Duration(seconds: 5)) {
      return;
    }
    _recentUids[uid] = now;

    await _validate(uid: uid, number: number);
  }

  /// Ejecuta el check-in y refleja el resultado en la UI.
  Future<void> _validate({required String uid, int? number}) async {
    setState(() => _processing = true);
    final label = number != null
        ? 'Socio nº ${number.toString().padLeft(4, '0')}'
        : 'Socio';
    await ref
        .read(checkInControllerProvider.notifier)
        .checkIn(
          eventId: widget.event.id,
          eventTitle: widget.event.title,
          eventType: widget.event.type,
          uid: uid,
        );
    final state = ref.read(checkInControllerProvider);
    if (!mounted) return;
    if (state.hasError) {
      final error = state.error;
      final message = error is AppException
          ? error.message
          : 'No se pudo validar la entrada';
      _showResult(_ScanResult.error(message));
    } else {
      setState(() => _validated++);
      _showResult(_ScanResult.success('$label — entrada validada'));
    }
    setState(() => _processing = false);
  }

  /// Búsqueda manual por número de socio (requiere permiso junta+ para leer
  /// la colección de socios).
  Future<void> _manualSearch() async {
    final text = _manualController.text.trim();
    final number = int.tryParse(text);
    if (number == null) {
      _showResult(const _ScanResult.error('Introduce un número válido'));
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _processing = true);
    try {
      final member = await ref
          .read(membersRepositoryProvider)
          .findByMemberNumber(number);
      if (!mounted) return;
      if (member == null) {
        setState(() => _processing = false);
        _showResult(_ScanResult.error('No existe el socio nº $number'));
        return;
      }
      setState(() => _processing = false);
      _manualController.clear();
      await _validate(uid: member.id, number: member.memberNumber);
    } on PermissionException {
      if (!mounted) return;
      setState(() => _processing = false);
      _showResult(
        const _ScanResult.error(
          'La búsqueda manual requiere permisos de junta',
        ),
      );
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _processing = false);
      _showResult(_ScanResult.error(error.message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
              ),
            ),
            // Marco de escaneo con esquinas blancas sobre fondo oscurecido.
            Positioned.fill(
              child: CustomPaint(painter: _ScannerOverlayPainter()),
            ),
            _buildTopBar(context),
            if (_result != null) _buildResultBanner(context, _result!),
            _buildManualPanel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      right: 8,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            tooltip: 'Cerrar',
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Validados: $_validated',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: widget.onChangeEvent,
            child: const Text('Cambiar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultBanner(BuildContext context, _ScanResult result) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 24,
      right: 24,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(
              color: result.success ? Colors.white : Colors.redAccent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                result.success
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: result.success ? Colors.white : Colors.redAccent,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  result.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualPanel(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _manualController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Nº de socio (entrada manual)',
                  hintStyle: TextStyle(color: Colors.white54),
                  isDense: true,
                ),
                onSubmitted: (_) => _processing ? null : _manualSearch(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _processing ? null : _manualSearch,
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              tooltip: 'Buscar y validar',
            ),
          ],
        ),
      ),
    );
  }
}

/// Resultado puntual de un intento de validación.
class _ScanResult {
  const _ScanResult.success(this.message) : success = true;
  const _ScanResult.error(this.message) : success = false;

  final bool success;
  final String message;
}

/// Dibuja el marco de escaneo: fondo oscurecido con una ventana central y
/// esquinas blancas al estilo de los escáneres nativos.
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide * 0.7;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: side,
      height: side,
    );

    // Oscurecido exterior (todo menos la ventana central).
    final overlay = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final path = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlay);

    // Esquinas blancas.
    final corner = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const len = 28.0;
    // Superior izquierda.
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(len, 0), corner);
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(0, len), corner);
    // Superior derecha.
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(-len, 0),
      corner,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(0, len),
      corner,
    );
    // Inferior izquierda.
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(len, 0),
      corner,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(0, -len),
      corner,
    );
    // Inferior derecha.
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(-len, 0),
      corner,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(0, -len),
      corner,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) => false;
}
