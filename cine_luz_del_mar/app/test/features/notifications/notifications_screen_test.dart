import 'package:cine_luz_del_mar/core/theme/app_theme.dart';
import 'package:cine_luz_del_mar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cine_luz_del_mar/features/auth/presentation/providers/auth_providers.dart';
import 'package:cine_luz_del_mar/features/notifications/presentation/providers/notifications_providers.dart';
import 'package:cine_luz_del_mar/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:cine_luz_del_mar/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Doble de prueba: sesión ya iniciada con un socio fijo.
///
/// Solo se usa para que `currentUserProvider`/`currentRoleProvider` resuelvan
/// un usuario válido; ninguna otra acción del repositorio se ejercita aquí.
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
  setUpAll(() async {
    // Evita descargas de fuentes durante los tests (usa el fallback local).
    GoogleFonts.config.allowRuntimeFetching = false;
    // Los formateadores de fecha usan locale 'es'; hay que inicializarlo.
    await initializeDateFormatting('es');
  });

  final unread = AppNotification(
    id: 'n1',
    title: 'Nueva película en cartelera',
    body: 'Ya puedes reservar tu entrada.',
    type: 'general',
    read: false,
    createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
  );

  final read = AppNotification(
    id: 'n2',
    title: 'Recordatorio de asamblea',
    body: 'La asamblea anual es este viernes.',
    type: 'general',
    read: true,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  );

  /// Pumpea sin pumpAndSettle: el shimmer de carga usa una animación
  /// infinita que nunca "asienta" por sí sola.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 100));
  }

  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        inboxProvider.overrideWith((ref) => Stream.value([unread, read])),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        home: const NotificationsScreen(),
      ),
    );
  }

  testWidgets('pinta las notificaciones de la bandeja con su punto de no leída', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await settle(tester);

    expect(find.text('Notificaciones'), findsOneWidget);
    expect(find.text('Nueva película en cartelera'), findsOneWidget);
    expect(find.text('Recordatorio de asamblea'), findsOneWidget);

    // Punto de no leída: un único DecoratedBox circular en la fila no leída.
    final dotFinder = find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).shape == BoxShape.circle,
    );
    expect(dotFinder, findsOneWidget);

    // Con notificaciones no leídas, la acción "Marcar todas leídas" es visible.
    expect(find.byIcon(Icons.done_all), findsOneWidget);
  });

  testWidgets('sin notificaciones muestra el estado vacío', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          inboxProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const NotificationsScreen(),
        ),
      ),
    );
    await settle(tester);

    expect(find.text('Sin novedades por ahora'), findsOneWidget);
    expect(find.byIcon(Icons.done_all), findsNothing);
  });
}
