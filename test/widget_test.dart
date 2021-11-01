import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/integration_test_driver_extended.dart';
import 'package:mobile_projects/main.dart';
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mobile_projects/views/content_view.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:mobile_projects/main.dart' as app;

class MockRepository extends Mock implements Repository {
  @override
  getData() => Account.accounts;
}


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test', (WidgetTester tester) async {

    app.main();
    //await tester.pumpAndSettle()

    await tester.pumpWidget(
      Provider<Repository>.value(
        value: MockRepository(),
        child: ContentView(),
      )
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('Name_1'), findsOneWidget);
    //  expect(find.text('1'), findsNothing);
    // Tap the '+' icon and trigger a frame.
  });
}
