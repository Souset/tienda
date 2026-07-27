import 'package:cine_luz_del_mar/core/theme/app_theme.dart';
import 'package:cine_luz_del_mar/features/home/presentation/providers/home_providers.dart';
import 'package:cine_luz_del_mar/features/home/presentation/screens/home_screen.dart';
import 'package:cine_luz_del_mar/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:cine_luz_del_mar/shared/widgets/brand_wordmark.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    // Evita descargas de fuentes durante los tests (usa el fallback local).
    GoogleFonts.config.allowRuntimeFetching = false;
    // Los formateadores de fecha usan locale 'es'; hay que inicializarlo.
    await initializeDateFormatting('es');
  });

  const config = HomeConfig(
    bannerTitle: 'Ciclo de cine de verano',
    bannerSubtitle: 'Del 1 al 15 de agosto en la terraza',
    bannerRoute: '/agenda',
  );

  final event = EventItem(
    id: 'ev1',
    type: 'proyeccion',
    title: 'Noche de cine clásico',
    start: DateTime.now().add(const Duration(days: 2)),
    venue: const Venue(name: 'Sala Luz del Mar'),
    capacity: 40,
    reservedCount: 10,
    status: 'published',
  );

  const film = Film(
    id: 'f1',
    title: 'Cinema Paradiso',
    year: 1988,
    featured: true,
  );

  final news = NewsItem(
    id: 'n1',
    title: 'Nueva sala inaugurada',
    body: 'Contenido de la noticia',
    status: 'published',
    publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
  );

  /// Pumpea sin usar pumpAndSettle: AppShimmer usa una animación infinita
  /// (shimmer) que nunca "asienta", así que avanzamos frames a mano hasta
  /// que los streams (Stream.value) hayan emitido su dato.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 400));
  }

  Widget buildSubject({
    HomeConfig? config,
    List<EventItem> events = const [],
    List<Film> films = const [],
    List<NewsItem> news = const [],
  }) {
    return ProviderScope(
      overrides: [
        homeConfigProvider.overrideWith((ref) => Stream.value(config)),
        upcomingEventsProvider.overrideWith((ref) => Stream.value(events)),
        featuredFilmsProvider.overrideWith((ref) => Stream.value(films)),
        latestNewsProvider.overrideWith((ref) => Stream.value(news)),
      ],
      child: MaterialApp(theme: AppTheme.dark, home: const HomeScreen()),
    );
  }

  testWidgets('pinta el banner y las tres secciones con datos', (tester) async {
    // Superficie amplia para que todas las secciones se construyan sin
    // necesidad de hacer scroll (ListView no construye lo que está fuera de
    // la vista, así que find.text no lo encontraría).
    await tester.binding.setSurfaceSize(const Size(1080, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildSubject(
        config: config,
        events: [event],
        films: const [film],
        news: [news],
      ),
    );
    await settle(tester);

    expect(find.byType(BrandWordmark), findsOneWidget);
    expect(find.text('Ciclo de cine de verano'), findsOneWidget);
    expect(find.text('Próximas actividades'), findsOneWidget);
    expect(find.text('Noche de cine clásico'), findsOneWidget);
    expect(find.text('Películas destacadas'), findsOneWidget);
    expect(find.text('Cinema Paradiso'), findsOneWidget);
    expect(find.text('Noticias'), findsOneWidget);
    expect(find.text('Nueva sala inaugurada'), findsOneWidget);
    expect(find.text('Ver todo'), findsNWidgets(3));
  });

  testWidgets('sin contenido en ninguna sección muestra el estado vacío', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await settle(tester);

    expect(find.text('Todavía no hay nada por aquí'), findsOneWidget);
    expect(find.text('Próximas actividades'), findsNothing);
    expect(find.text('Películas destacadas'), findsNothing);
  });
}
