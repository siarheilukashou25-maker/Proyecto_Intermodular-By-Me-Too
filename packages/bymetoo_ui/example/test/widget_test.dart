import 'package:flutter_test/flutter_test.dart';

import 'package:bymetoo_ui_example/main.dart';

void main() {
  testWidgets('La app de ejemplo arranca', (tester) async {
    await tester.pumpWidget(const EjemploApp());
    expect(find.textContaining('ByMeTooBottomBar'), findsOneWidget);
  });
}
