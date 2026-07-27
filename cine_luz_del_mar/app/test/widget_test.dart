import 'package:cine_luz_del_mar/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('la app arranca y muestra el shell de navegación', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CineLuzDelMarApp()));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Agenda'), findsWidgets);
    expect(find.text('Perfil'), findsWidgets);
  });
}
