import 'package:cine_luz_del_mar/core/theme/app_theme.dart';
import 'package:cine_luz_del_mar/features/auth/presentation/providers/auth_providers.dart';
import 'package:cine_luz_del_mar/features/members/presentation/providers/members_providers.dart';
import 'package:cine_luz_del_mar/features/members/presentation/screens/member_card_screen.dart';
import 'package:cine_luz_del_mar/shared/models/app_user.dart';
import 'package:cine_luz_del_mar/shared/models/attendance_record.dart';
import 'package:cine_luz_del_mar/shared/models/member.dart';
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

  // Ventana amplia para que el carné y las secciones quepan sin desbordes.
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1200, 2600);
    view.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  const user = AppUser(
    id: 'uid-1',
    displayName: 'Marina Torres',
    email: 'marina@example.com',
    role: 'socio',
  );

  final member = Member(
    id: 'uid-1',
    memberNumber: 1,
    status: 'active',
    joinedAt: DateTime(2021, 3, 10),
    benefits: const [
      'Entrada gratuita a proyecciones',
      'Descuento en talleres',
    ],
  );

  final fees = [
    MemberFee(
      id: DateTime.now().year.toString(),
      amount: 20,
      status: 'paid',
      paidAt: DateTime(DateTime.now().year, 1, 15),
    ),
  ];

  final attendance = [
    AttendanceRecord(
      id: 'e1',
      eventTitle: 'Cinefórum: Metrópolis',
      eventType: 'proyeccion',
      checkedInAt: DateTime(2026, 2, 1, 20),
    ),
  ];

  Widget buildSubject({
    required Member? member,
    List<MemberFee> fees = const [],
    List<AttendanceRecord> attendance = const [],
  }) {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWithValue(user),
        myMemberProvider.overrideWith((ref) => Stream<Member?>.value(member)),
        myFeesProvider.overrideWith(
          (ref) => Stream<List<MemberFee>>.value(fees),
        ),
        myAttendanceProvider.overrideWith(
          (ref) => Stream<List<AttendanceRecord>>.value(attendance),
        ),
      ],
      child: MaterialApp(theme: AppTheme.dark, home: const MemberCardScreen()),
    );
  }

  testWidgets('pinta el carné del socio con número, nombre y cuota', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(member: member, fees: fees, attendance: attendance),
    );
    await tester.pumpAndSettle();

    expect(find.text('Marina Torres'), findsOneWidget);
    expect(find.text('Socio nº 0001'), findsOneWidget);
    expect(find.text('Cuota ${DateTime.now().year} pagada'), findsOneWidget);
    // Secciones e historiales.
    expect(find.text('Ventajas de socio'), findsOneWidget);
    expect(find.text('Cinefórum: Metrópolis'), findsOneWidget);
  });

  testWidgets('muestra el estado vacío cuando no hay socio', (tester) async {
    await tester.pumpWidget(buildSubject(member: null));
    await tester.pumpAndSettle();

    expect(find.text('Todavía no eres socio'), findsOneWidget);
    expect(find.textContaining('Habla con la junta'), findsOneWidget);
    expect(find.text('Socio nº 0001'), findsNothing);
  });
}
