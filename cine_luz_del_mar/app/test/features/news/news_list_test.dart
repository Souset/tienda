import 'package:cine_luz_del_mar/core/theme/app_theme.dart';
import 'package:cine_luz_del_mar/features/news/presentation/providers/news_providers.dart';
import 'package:cine_luz_del_mar/features/news/presentation/screens/news_list_screen.dart';
import 'package:cine_luz_del_mar/shared/models/models.dart';
import 'package:flutter/material.dart';
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

  final featured = NewsItem(
    id: 'n1',
    title: 'Se inaugura la nueva sala de proyecciones',
    body: 'La asociación estrena espacio este mes.',
    status: 'published',
    publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
  );

  final secondary = NewsItem(
    id: 'n2',
    title: 'Convocatoria de socios para el nuevo curso',
    body: 'Abierta la inscripción de nuevos socios.',
    status: 'published',
    publishedAt: DateTime.now().subtract(const Duration(days: 3)),
  );

  /// Pumpea sin pumpAndSettle: el shimmer de carga usa una animación
  /// infinita que nunca "asienta" por sí sola.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('muestra la noticia destacada y el resto en filas', (
    tester,
  ) async {
    // Superficie amplia para que la fila bajo la tarjeta destacada se
    // construya sin necesidad de hacer scroll.
    await tester.binding.setSurfaceSize(const Size(1080, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publishedNewsProvider.overrideWith(
            (ref) => Stream.value([featured, secondary]),
          ),
        ],
        child: MaterialApp(theme: AppTheme.dark, home: const NewsListScreen()),
      ),
    );
    await settle(tester);

    expect(find.text('Noticias'), findsOneWidget);
    expect(
      find.text('Se inaugura la nueva sala de proyecciones'),
      findsOneWidget,
    );
    expect(
      find.text('Convocatoria de socios para el nuevo curso'),
      findsOneWidget,
    );
  });

  testWidgets('sin noticias publicadas muestra el estado vacío', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publishedNewsProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: MaterialApp(theme: AppTheme.dark, home: const NewsListScreen()),
      ),
    );
    await settle(tester);

    expect(find.text('Sin noticias todavía'), findsOneWidget);
  });
}
