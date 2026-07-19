import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/attendance_record.dart';
import '../../../../shared/models/member.dart';
import '../../../../shared/widgets/brand_wordmark.dart';
import '../../../../shared/widgets/brightness_boost.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../agenda/presentation/widgets/event_type_labels.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/members_providers.dart';
import 'check_in_screen.dart';

/// Pantalla del carné de socio digital (ruta `/carne`).
///
/// Si el usuario no tiene documento en `members` muestra cómo hacerse socio.
/// Si es socio, presenta un carné premium con QR, estado de cuota, ventajas
/// e historiales. Los coordinadores+ ven un botón para escanear entradas.
class MemberCardScreen extends ConsumerWidget {
  const MemberCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(myMemberProvider);
    final role = ref.watch(currentRoleProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Carné de socio')),
      floatingActionButton: role.canManageContent
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CheckInScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Escanear entrada'),
            )
          : null,
      body: memberAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(myMemberProvider),
        ),
        data: (member) {
          if (member == null) {
            return const EmptyState(
              icon: Icons.badge_outlined,
              title: 'Todavía no eres socio',
              message:
                  'Hazte socio de la asociación para conseguir tu carné '
                  'digital. Habla con la junta en cualquier actividad o '
                  'escríbenos.',
            );
          }
          final displayName = user?.displayName.trim().isNotEmpty == true
              ? user!.displayName
              : 'Socio/a';
          return BrightnessBoost(
            child: _MemberCardBody(member: member, displayName: displayName),
          );
        },
      ),
    );
  }
}

/// Cuerpo desplazable del carné cuando el usuario es socio.
class _MemberCardBody extends ConsumerWidget {
  const _MemberCardBody({required this.member, required this.displayName});

  final Member member;
  final String displayName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feesAsync = ref.watch(myFeesProvider);
    final attendanceAsync = ref.watch(myAttendanceProvider);
    final fees = feesAsync.value ?? const [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _DigitalCard(member: member, displayName: displayName),
        const SizedBox(height: 20),
        _FeeStatusChip(fees: fees),
        if (member.benefits.isNotEmpty) ...[
          const SizedBox(height: 24),
          _BenefitsSection(benefits: member.benefits),
        ],
        const SizedBox(height: 24),
        _FeesHistorySection(feesAsync: feesAsync),
        const SizedBox(height: 24),
        _AttendanceHistorySection(attendanceAsync: attendanceAsync),
      ],
    );
  }
}

/// La tarjeta física del carné (ratio de tarjeta de crédito, fondo negro).
class _DigitalCard extends StatelessWidget {
  const _DigitalCard({required this.member, required this.displayName});

  final Member member;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final number = member.memberNumber.toString().padLeft(4, '0');
    final year = member.joinedAt?.year;
    // Carga útil del QR: identifica al socio para el check-in del coordinador.
    final qrData = jsonEncode({'uid': member.id, 'n': member.memberNumber});

    return AspectRatio(
          // Proporción estándar de tarjeta de crédito (ISO/IEC 7810 ID-1).
          aspectRatio: 85.6 / 54,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BrandWordmark(fontSize: 22, color: Colors.white),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Socio nº $number',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          if (year != null)
                            Text(
                              'Desde $year',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white54,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: QrImageView(
                    data: qrData,
                    size: 96,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(0.94, 0.94),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
          duration: 400.ms,
        );
  }
}

/// Chip con el estado de la cuota del año en curso.
class _FeeStatusChip extends StatelessWidget {
  const _FeeStatusChip({required this.fees});

  final List<MemberFee> fees;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final year = DateTime.now().year;
    MemberFee? current;
    for (final fee in fees) {
      if (fee.id == year.toString()) {
        current = fee;
        break;
      }
    }
    final status = current?.status ?? 'pending';

    final (IconData icon, String label) = switch (status) {
      'paid' => (Icons.check_circle_rounded, 'Cuota $year pagada'),
      'exempt' => (Icons.verified_rounded, 'Exento de cuota $year'),
      _ => (Icons.schedule_rounded, 'Cuota $year pendiente'),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurface),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

/// Sección "Ventajas de socio".
class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection({required this.benefits});

  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ventajas de socio', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        ...benefits.map(
          (benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(benefit, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Sección "Historial de cuotas".
class _FeesHistorySection extends StatelessWidget {
  const _FeesHistorySection({required this.feesAsync});

  final AsyncValue<List<MemberFee>> feesAsync;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historial de cuotas', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        feesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          ),
          error: (error, _) => ErrorView(error: error),
          data: (fees) {
            if (fees.isEmpty) {
              return Text(
                'Sin cuotas registradas todavía.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            }
            return Column(
              children: fees.map((fee) => _FeeTile(fee: fee)).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Fila de una cuota anual concreta.
class _FeeTile extends StatelessWidget {
  const _FeeTile({required this.fee});

  final MemberFee fee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (IconData icon, String label) = switch (fee.status) {
      'paid' => (Icons.check_circle_rounded, 'Pagada'),
      'exempt' => (Icons.verified_rounded, 'Exento'),
      _ => (Icons.schedule_rounded, 'Pendiente'),
    };
    final subtitle = fee.status == 'paid' && fee.paidAt != null
        ? 'Pagada el ${Formatters.fullDate.format(fee.paidAt!)}'
        : label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fee.id.isEmpty ? 'Cuota' : 'Cuota ${fee.id}',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Formatters.currency.format(fee.amount),
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

/// Sección "Historial de asistencia".
class _AttendanceHistorySection extends StatelessWidget {
  const _AttendanceHistorySection({required this.attendanceAsync});

  final AsyncValue<List<AttendanceRecord>> attendanceAsync;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historial de asistencia', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        attendanceAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          ),
          error: (error, _) => ErrorView(error: error),
          data: (records) {
            if (records.isEmpty) {
              return Text(
                'Aún no has asistido a ninguna actividad.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            }
            return Column(
              children: records
                  .map((record) => _AttendanceTile(record: record))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Fila de un registro de asistencia.
class _AttendanceTile extends StatelessWidget {
  const _AttendanceTile({required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = record.eventType ?? '';
    final date = record.checkedInAt;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            EventTypeLabels.icon(type),
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.eventTitle ?? 'Actividad',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  [
                    EventTypeLabels.label(type),
                    if (date != null) Formatters.dateTime.format(date),
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
