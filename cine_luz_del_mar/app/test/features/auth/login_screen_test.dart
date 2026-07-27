import 'package:cine_luz_del_mar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cine_luz_del_mar/features/auth/presentation/providers/auth_providers.dart';
import 'package:cine_luz_del_mar/features/auth/presentation/screens/login_screen.dart';
import 'package:cine_luz_del_mar/shared/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Doble de prueba manual del repositorio de autenticación.
///
/// Registra las llamadas recibidas para poder verificarlas en los tests.
class _FakeAuthRepository implements AuthRepository {
  final List<String> calls = <String>[];
  String? lastEmail;
  String? lastPassword;

  @override
  Stream<AppUser?> watchSession() => Stream<AppUser?>.value(null);

  @override
  Future<void> signInWithEmail(String email, String password) async {
    calls.add('signInWithEmail');
    lastEmail = email;
    lastPassword = password;
  }

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async => calls.add('registerWithEmail');

  @override
  Future<void> signInWithGoogle() async => calls.add('signInWithGoogle');

  @override
  Future<void> signInWithApple() async => calls.add('signInWithApple');

  @override
  Future<void> sendPasswordReset(String email) async =>
      calls.add('sendPasswordReset');

  @override
  Future<void> sendEmailVerification() async =>
      calls.add('sendEmailVerification');

  @override
  Future<void> reloadUser() async => calls.add('reloadUser');

  @override
  Future<void> signOut() async => calls.add('signOut');
}

void main() {
  setUpAll(() {
    // Evita descargas de fuentes durante los tests (usa el fallback local).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget buildSubject(_FakeAuthRepository fake) {
    return ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(fake)],
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  testWidgets('muestra los campos de correo y contraseña', (tester) async {
    await tester.pumpWidget(buildSubject(_FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('un correo inválido muestra error de validación', (tester) async {
    final fake = _FakeAuthRepository();
    await tester.pumpWidget(buildSubject(fake));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'correo-invalido');
    await tester.enterText(find.byType(TextFormField).at(1), 'Password1');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('El correo no es válido'), findsOneWidget);
    expect(fake.calls, isEmpty);
  });

  testWidgets('con datos válidos invoca al repositorio', (tester) async {
    final fake = _FakeAuthRepository();
    await tester.pumpWidget(buildSubject(fake));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'socio@cineluzdelmar.org',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Password1');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();

    expect(fake.calls, contains('signInWithEmail'));
    expect(fake.lastEmail, 'socio@cineluzdelmar.org');
    expect(fake.lastPassword, 'Password1');
  });
}
