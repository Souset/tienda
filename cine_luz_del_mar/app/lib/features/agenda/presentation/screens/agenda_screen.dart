import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/event_item.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/section_header.dart';
import '../providers/agenda_providers.dart';
import '../widgets/event_card.dart';

/// Pantalla de Agenda: calendario mensual con marcadores en días con eventos
/// y lista de próximos eventos (o del día seleccionado).
class AgendaScreen extends ConsumerStatefulWidget {
  const AgendaScreen({super.key});

  @override
  ConsumerState<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends ConsumerState<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _format = CalendarFormat.month;

  /// Compara solo año/mes/día (ignora la hora).
  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Eventos de un día concreto a partir de la lista del mes.
  List<EventItem> _eventsForDay(DateTime day, List<EventItem> monthEvents) {
    return monthEvents
        .where((e) => e.start != null && _sameDay(e.start!, day))
        .toList();
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      // Un segundo toque en el mismo día deselecciona (vuelve a próximos).
      if (_selectedDay != null && _sameDay(_selectedDay!, selected)) {
        _selectedDay = null;
      } else {
        _selectedDay = selected;
      }
      _focusedDay = focused;
    });
  }

  void _onPageChanged(DateTime focused) {
    _focusedDay = focused;
    // Sincroniza el mes consultado a Firestore con el mes visible.
    ref.read(selectedMonthProvider.notifier).state = DateTime(
      focused.year,
      focused.month,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthEventsAsync = ref.watch(monthEventsProvider);
    final upcomingAsync = ref.watch(upcomingEventsProvider);
    final monthEvents = monthEventsAsync.value ?? const <EventItem>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar',
            onPressed: () => context.push('/buscar'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _Calendar(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                format: _format,
                eventLoader: (day) => _eventsForDay(day, monthEvents),
                onDaySelected: _onDaySelected,
                onFormatChanged: (f) => setState(() => _format = f),
                onPageChanged: _onPageChanged,
                sameDay: _sameDay,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: _selectedDay == null
                  ? 'Próximos eventos'
                  : 'Eventos del día',
            ),
          ),
          if (_selectedDay != null)
            _buildDayList(_eventsForDay(_selectedDay!, monthEvents))
          else
            _buildUpcomingList(upcomingAsync),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  /// Lista de próximos eventos con sus estados (carga/error/vacío).
  Widget _buildUpcomingList(AsyncValue<List<EventItem>> async) {
    return async.when(
      loading: () => const SliverToBoxAdapter(
        // Altura acotada: ShimmerList es un ListView y necesita límites dentro
        // de un sliver (evita el "unbounded height" del viewport).
        child: SizedBox(
          height: 560,
          child: ShimmerList(itemCount: 4, itemHeight: 120),
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(upcomingEventsProvider),
        ),
      ),
      data: (events) {
        if (events.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.event_busy_outlined,
              title: 'Sin eventos próximos',
              message: 'Vuelve pronto para descubrir nuevas proyecciones.',
            ),
          );
        }
        return _eventSliverList(events);
      },
    );
  }

  /// Lista de eventos del día seleccionado.
  Widget _buildDayList(List<EventItem> events) {
    if (events.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: EmptyState(
            icon: Icons.event_available_outlined,
            title: 'Nada este día',
            message: 'No hay eventos programados para la fecha seleccionada.',
          ),
        ),
      );
    }
    return _eventSliverList(events);
  }

  Widget _eventSliverList(List<EventItem> events) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        itemCount: events.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            event: event,
            onTap: () => context.push('/agenda/${event.id}'),
          );
        },
      ),
    );
  }
}

/// Calendario mensual estilizado con el tema monocromo y marcadores de puntos.
class _Calendar extends StatelessWidget {
  const _Calendar({
    required this.focusedDay,
    required this.selectedDay,
    required this.format,
    required this.eventLoader,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.sameDay,
  });

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat format;
  final List<EventItem> Function(DateTime) eventLoader;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(CalendarFormat) onFormatChanged;
  final void Function(DateTime) onPageChanged;
  final bool Function(DateTime, DateTime) sameDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = DateTime.now();
    final fallback = theme.textTheme.bodyMedium ?? const TextStyle();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TableCalendar<EventItem>(
          locale: 'es',
          firstDay: DateTime(now.year - 1, 1, 1),
          lastDay: DateTime(now.year + 2, 12, 31),
          focusedDay: focusedDay,
          currentDay: now,
          calendarFormat: format,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Mes',
            CalendarFormat.twoWeeks: '2 semanas',
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) =>
              selectedDay != null && sameDay(selectedDay!, day),
          eventLoader: eventLoader,
          onDaySelected: onDaySelected,
          onFormatChanged: onFormatChanged,
          onPageChanged: onPageChanged,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonShowsNext: false,
            titleTextStyle: theme.textTheme.titleMedium ?? fallback,
            formatButtonTextStyle: theme.textTheme.labelMedium ?? fallback,
            formatButtonDecoration: BoxDecoration(
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: scheme.onSurfaceVariant,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: scheme.onSurfaceVariant,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle:
                theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ) ??
                fallback,
            weekendStyle:
                theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ) ??
                fallback,
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            defaultTextStyle: fallback,
            weekendTextStyle: fallback,
            todayDecoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            todayTextStyle:
                theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface) ??
                fallback,
            selectedDecoration: BoxDecoration(
              color: scheme.onSurface,
              shape: BoxShape.circle,
            ),
            selectedTextStyle:
                theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.surface,
                  fontWeight: FontWeight.w600,
                ) ??
                fallback,
            markerDecoration: BoxDecoration(
              color: scheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 3,
            markerSize: 5,
            markerMargin: const EdgeInsets.symmetric(horizontal: 1),
          ),
        ),
      ),
    );
  }
}
