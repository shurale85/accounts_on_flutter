import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_projects/main_test.dart' as app;
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../ui_test/widget_test.mocks.dart';

@GenerateMocks([Repository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final repositoryMock = MockRepository();

  testWidgets('App shows no data if datasource is empty', (WidgetTester tester) async {

    app.main();
    await tester.pumpAndSettle();
    expect(find.text('No account is found'), findsOneWidget);
  });
}