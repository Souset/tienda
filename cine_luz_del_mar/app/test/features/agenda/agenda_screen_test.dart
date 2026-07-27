import 'package:cine_luz_del_mar/core/theme/app_theme.dart';
import 'package:cine_luz_del_mar/features/agenda/presentation/providers/agenda_providers.dart';
import 'package:cine_luz_del_mar/features/agenda/presentation/screens/agenda_screen.dart';
import 'package:cine_luz_del_mar/shared/models/event_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    // Evita descargas de fuentes y prepara los símbolos de fecha para 'es'.
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('es');
  });

  // Ventana amplia para que el calendario y las dos tarjetas quepan sin
  // desbordes y ambas se construyan (la lista perezosa solo pinta lo visible).
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1000, 2400);
    view.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  // Dos eventos futuros fijos para la lista de próximos.
  final events = <EventItem>[
    EventItem(
      id: 'e1',
      type: 'proyeccion',
      title: 'El gabinete del doctor Caligari',
      status: 'published',
      start: DateTime.now().add(const Duration(days: 2)),
      capacity: 60,
      reservedCount: 12,
      venue: const Venue(name: 'Sala Municipal'),
    ),
    EventItem(
      id: 'e2',
      type: 'taller',
      title: 'Taller de guion cinematográfico',
      status: 'published',
      start: DateTime.now().add(const Duration(days: 5)),
      capacity: 20,
      reservedCount: 20,
      venue: const Venue(name: 'Aula de cultura'),
    ),
  ];

  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        upcomingEventsProvider.overrideWith(
          (ref) => Stream<List<EventItem>>.value(events),
        ),
        monthEventsProvider.overrideWith(
          (ref) => Stream<List<EventItem>>.value(events),
        ),
      ],
      child: MaterialApp(theme: AppTheme.dark, home: const AgendaScreen()),
    );
  }

  testWidgets('pinta los títulos de los próximos eventos', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('El gabinete del doctor Caligari'), findsOneWidget);
    expect(find.text('Taller de guion cinematográfico'), findsOneWidget);
    // El segundo evento está completo (20/20).
    expect(find.text('Completo'), findsOneWidget);
    // El primero muestra las plazas disponibles.
    expect(find.text('12/60 plazas'), findsOneWidget);
  });
}
