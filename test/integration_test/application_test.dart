import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_projects/constants.dart';
import 'package:mobile_projects/main_test.dart' as app;
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/models/operation_result.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mobile_projects/service/token_service.dart';
import 'package:mobile_projects/views/car_grid_view.dart';
import 'package:mobile_projects/views/card_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../ui_test/widget_test.mocks.dart';
import '../unit_test/network_service_test.mocks.dart';

@GenerateMocks([TokenService, Repository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final repositoryMock = MockRepository();
  //final networkService = MockNetworkService();
  final tokenService = MockTokenService();

  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);

  const getAccountResponseData =
      r'''{"value": [{"name": "name1", "statecode": 1, "accountid": "A"},{"name": "name2", "statecode": 0, "accountid": "B"}]}''';

  setUp(() {
    dio.httpClientAdapter = dioAdapter;
  });

  testWidgets('App shows no data if datasource is empty',
      (WidgetTester tester) async {
    //Arrange
    dioAdapter.onGet(baseUrl, (request) {
      return request.reply(200, jsonDecode(getAccountResponseData));
    },
        data: null,
        queryParameters: {},
        headers: {'Authorization': 'Bearer acces_token'});

    when(tokenService.getToken())
        .thenReturn(OperationResult(data: 'acces_token'));

    final repo = Repository();

    //Act
    final networkService =
        NetworkService(repository: repo, tokenService: tokenService, dio: dio);

    app.main(['Success test case'], networkService, repo);
    await tester.pumpAndSettle();

    //Assert
    expect(find.text('No account is found'), findsNWidgets(0));
    expect(find.text('name1'), findsNWidgets(1));

    expect(find.byKey(const Key('searchTextFiledKey')), findsNWidgets(1));
    expect(find.byKey(const Key('searchIconKey')), findsNWidgets(1));
    expect(find.byKey(const Key('filterIconKey')), findsNWidgets(1));
    expect(find.byKey(const Key('listIconKey')), findsNWidgets(1));
    expect(find.byKey(const Key('gridIconKey')), findsNWidgets(1));
    expect(find.byKey(const Key('listViewKey')), findsNWidgets(0));
    expect(find.byKey(const Key('gridViewKey')), findsNWidgets(1));
    expect(find.byType(CardView), findsNWidgets(0));
    expect(find.byType(CardGridView), findsNWidgets(2));

    verify(networkService.getAccounts()).called(1);

  /*   final listView = find.byKey(const ValueKey('listIconKey'));
    await tester.tap(listView);
    expect(find.byKey(const Key('listViewKey')), findsNWidgets(0));
    expect(find.byKey(const Key('gridViewKey')), findsNWidgets(1));
   sleep(Duration(seconds: 2));
    final gridView = find.byKey(const ValueKey('gridViewKey'));
    await tester.tap(gridView);

    expect(find.byKey(const Key('listViewKey')), findsNWidgets(0));
    expect(find.byKey(const Key('gridViewKey')), findsNWidgets(1));*/
  });
}
