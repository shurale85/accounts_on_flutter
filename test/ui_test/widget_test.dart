import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mobile_projects/views/content_view.dart';
import 'package:mobile_projects/views/splash_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'widget_test.mocks.dart';

@GenerateMocks([NetworkService])
@GenerateMocks([Repository])
void main() {
  final repositoryMock = MockRepository();
  final networkServiceMock = MockNetworkService();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ContentView shows content', (WidgetTester tester) async {
    when(repositoryMock.getData()).thenReturn(Account.accounts);
    when(networkServiceMock.getIsLoading()).thenReturn(false);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Repository>(create: (_) => repositoryMock),
          ChangeNotifierProvider<NetworkService>(
              create: (ctx) => networkServiceMock)
        ],
        child: Builder(
          builder: (_) => MaterialApp(
              home: Scaffold(
            body: ContentView(),
          )),
        ),
      ),
    );

    expect(find.text('No account is found'), findsNWidgets(0));
    var accounts = Account.accounts;
    for (int i = 0; i < accounts.length; i++) {
      expect(find.text(accounts[i].name), findsNWidgets(1));
      expect(
          find.text('Number: ${accounts[i].accountnumber!}'), findsNWidgets(1));
      expect(find.text('Address: ${accounts[i].address1_stateorprovince!}'),
          findsNWidgets(1));
    }

    verify(networkServiceMock.getIsLoading()).called(1);
    verify(repositoryMock.getData()).called(1);
  });

  testWidgets('ContentView shows preloader while API request is ongoing',
      (WidgetTester tester) async {
    when(repositoryMock.getData()).thenReturn(Account.accounts);
    when(networkServiceMock.getIsLoading()).thenReturn(true);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Repository>(create: (_) => repositoryMock),
          ChangeNotifierProvider<NetworkService>(
              create: (ctx) => networkServiceMock)
        ],
        child: Builder(
          builder: (_) => MaterialApp(
              home: Scaffold(
            body: ContentView(),
          )),
        ),
      ),
    );

    expect(find.text('No account is found'), findsNWidgets(0));
    expect(find.byType(SplashScreen), findsNWidgets(1));
    verify(repositoryMock.getData()).called(1);
    verify(networkServiceMock.getIsLoading()).called(1);
  });

  testWidgets('ContentView displays No account found when no account',
      (WidgetTester tester) async {
    when(repositoryMock.getData()).thenReturn(<Account>[]);
    when(networkServiceMock.getIsLoading()).thenReturn(false);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Repository>(create: (_) => repositoryMock),
          ChangeNotifierProvider<NetworkService>(
              create: (ctx) => networkServiceMock)
        ],
        child: Builder(
          builder: (_) => MaterialApp(
              home: Scaffold(
            body: ContentView(),
          )),
        ),
      ),
    );

    expect(find.text('No account is found'), findsNWidgets(1));
    verify(repositoryMock.getData()).called(1);
    verify(networkServiceMock.getIsLoading()).called(1);
  });
}
