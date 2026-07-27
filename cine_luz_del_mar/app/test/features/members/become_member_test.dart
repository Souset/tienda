import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cine_luz_del_mar/features/members/presentation/providers/members_providers.dart';
import 'package:cine_luz_del_mar/features/members/presentation/screens/become_member_screen.dart';
import 'package:cine_luz_del_mar/shared/models/membership_plan.dart';
import 'package:cine_luz_del_mar/shared/widgets/app_shimmer.dart';

void main() {
  const plans = [
    MembershipPlan(id: 'joven', name: 'Socio Joven', price: 15, order: 0),
    MembershipPlan(
      id: 'general',
      name: 'Socio General',
      price: 25,
      order: 1,
      highlight: true,
    ),
    MembershipPlan(id: 'familiar', name: 'Socio Familiar', price: 40, order: 2),
    MembershipPlan(
      id: 'protector',
      name: 'Socio Protector',
      price: 60,
      order: 3,
    ),
  ];

  Widget buildSubject({required Stream<List<MembershipPlan>> stream}) {
    return ProviderScope(
      overrides: [
        activePlansProvider.overrideWith((ref) => stream),
        myMemberProvider.overrideWith((ref) => Stream.value(null)),
      ],
      child: const MaterialApp(home: BecomeMemberScreen()),
    );
  }

  testWidgets('mientras carga muestra el esqueleto en rejilla', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Stream sin emisiones: el estado de carga se mantiene.
    await tester.pumpWidget(
      buildSubject(stream: const Stream<List<MembershipPlan>>.empty()),
    );
    await tester.pump();

    // Esqueleto presente y acotado: ninguna pieza ocupa el ancho completo.
    final shimmers = tester.widgetList<AppShimmer>(find.byType(AppShimmer));
    expect(shimmers, isNotEmpty);
    for (final element in find.byType(AppShimmer).evaluate()) {
      expect(element.size!.width, lessThan(1000));
    }
  });

  testWidgets('en escritorio los packs se reparten en varias columnas', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildSubject(stream: Stream.value(plans)));
    await tester.pumpAndSettle();

    expect(find.text('Socio Joven'), findsOneWidget);
    expect(find.text('Socio Protector'), findsOneWidget);
    expect(find.text('Recomendado'), findsOneWidget);

    // Con 1280px de ancho, Joven y Familiar comparten fila (misma Y) y las
    // tarjetas no se estiran a todo el ancho.
    final joven = tester.getTopLeft(find.text('Socio Joven'));
    final familiar = tester.getTopLeft(find.text('Socio Familiar'));
    expect(joven.dy, familiar.dy);
    final protector = tester.getTopLeft(find.text('Socio Protector'));
    expect(protector.dy, greaterThan(joven.dy));
  });

  testWidgets('en móvil los packs van en una sola columna', (tester) async {
    tester.view.physicalSize = const Size(390, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildSubject(stream: Stream.value(plans)));
    await tester.pumpAndSettle();

    final joven = tester.getTopLeft(find.text('Socio Joven'));
    final general = tester.getTopLeft(find.text('Socio General'));
    expect(general.dy, greaterThan(joven.dy));
  });
}
