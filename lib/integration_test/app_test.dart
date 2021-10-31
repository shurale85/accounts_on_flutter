import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_projects/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('e2e test', () {
    testWidgets('test', (WidgetTester tester) async{
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('text'), findsOneWidget);
    });
  });

}