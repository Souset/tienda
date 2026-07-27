import 'package:cine_luz_del_mar/core/theme/app_theme.dart';
import 'package:cine_luz_del_mar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cine_luz_del_mar/features/auth/presentation/providers/auth_providers.dart';
import 'package:cine_luz_del_mar/features/library/presentation/providers/library_providers.dart';
import 'package:cine_luz_del_mar/features/library/presentation/screens/library_screen.dart';
import 'package:cine_luz_del_mar/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Doble de prueba: sesión ya iniciada con un socio fijo.
///
/// Solo se usa para que `currentRoleProvider` resuelva un rol válido; el
/// filtrado por `minRole` ya vive en el repositorio y no se ejercita aquí.
class _FakeAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> watchSession() =>
      Stream.value(const AppUser(id: 'u1', displayName: 'Ana', role: 'socio'));

  @override
  Future<void> signInWithEmail(String email, String password) async {}

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> reloadUser() async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  setUpAll(() {
    // Evita descargas de fuentes durante los tests (usa el fallback local).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  final document = LibraryResource(
    id: 'r1',
    type: 'document',
    title: 'Manual de la sala de proyecciones',
    description: 'Guía de uso para socios voluntarios.',
    url: 'https://example.org/manual.pdf',
    category: 'Manuales',
    minRole: 'invitado',
  );

  final video = LibraryResource(
    id: 'r2',
    type: 'video',
    title: 'Documental del festival inaugural',
    description: 'Resumen audiovisual del primer festival.',
    url: 'https://youtube.com/watch?v=abc',
    category: 'Documentales',
    minRole: 'socio',
  );

  final all = [document, video];

  /// Pumpea sin pumpAndSettle: el shimmer de carga usa una animación
  /// infinita que nunca "asienta" por sí sola.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// El doble de [resourcesProvider] reacciona al tipo seleccionado, igual
  /// que haría la consulta real a Firestore, para poder probar el filtrado.
  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        resourcesProvider.overrideWith((ref) {
          final type = ref.watch(selectedTypeProvider);
          final items = type == null
              ? all
              : all.where((r) => r.type == type).toList();
          return Stream.value(items);
        }),
      ],
      child: MaterialApp(theme: AppTheme.dark, home: const LibraryScreen()),
    );
  }

  testWidgets('pinta los títulos y los chips de tipo', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildSubject());
    await settle(tester);

    expect(find.text('Biblioteca'), findsOneWidget);
    expect(find.text('Manual de la sala de proyecciones'), findsOneWidget);
    expect(find.text('Documental del festival inaugural'), findsOneWidget);

    // Chips de tipo.
    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('Documentos'), findsOneWidget);
    expect(find.text('Podcasts'), findsOneWidget);
    expect(find.text('Vídeos'), findsOneWidget);
    expect(find.text('Enlaces'), findsOneWidget);
  });

  testWidgets('pulsar el chip "Documentos" filtra la lista por tipo', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildSubject());
    await settle(tester);

    expect(find.text('Documental del festival inaugural'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Documentos'));
    await settle(tester);

    expect(find.text('Manual de la sala de proyecciones'), findsOneWidget);
    expect(find.text('Documental del festival inaugural'), findsNothing);
  });
}
