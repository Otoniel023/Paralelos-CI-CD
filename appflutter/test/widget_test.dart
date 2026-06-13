import 'package:flutter_test/flutter_test.dart';
import 'package:appflutter/main.dart';

void main() {
  testWidgets('App arranca sin errores', (WidgetTester tester) async {
    await tester.pumpWidget(const CalzadoApp());
    expect(find.byType(CalzadoApp), findsOneWidget);
  });
}
