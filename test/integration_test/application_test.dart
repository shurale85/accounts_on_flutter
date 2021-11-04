import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_projects/constants.dart';
import 'package:mobile_projects/main_test.dart' as app;
import 'package:mobile_projects/models/account_state_enum.dart';
import 'package:mobile_projects/models/filter_model.dart';
import 'package:mobile_projects/models/operation_result.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mobile_projects/service/token_service.dart';
import 'package:mobile_projects/views/car_grid_view.dart';
import 'package:mobile_projects/views/card_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../unit_test/network_service_test.mocks.dart';

@GenerateMocks([TokenService, Repository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final tokenService = MockTokenService();

  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  final filterModel = FilterModel(
      accountState: AccountStateFilter.active, stateOrProvince: 'testState');

  const getAccountResponseData =
      r'''{"value": [{"name": "name1", "statecode": 1, "accountid": "A", "address1_stateorprovince": "testState"},{"name": "name2", "statecode": 0, "accountid": "B", "address1_stateorprovince": "testState"}]}''';
  const getFilteredResponseData =
      r'''{"value": [{"name": "name1", "statecode": 1, "accountid": "A", "address1_stateorprovince": "testState"}]}''';

  setUp(() {
    dio.httpClientAdapter = dioAdapter;
    setDioAdapter(dioAdapter, getAccountResponseData);
    final filterUrl = baseUrl +
        '&\$filter=(statecode eq ${filterModel.accountState?.index} and contains(address1_stateorprovince, \'${filterModel.stateOrProvince}\'))';
    setDioAdapter(dioAdapter, getFilteredResponseData, url: filterUrl);
  });

  testWidgets('Success case', (WidgetTester tester) async {
    //Arrange
    when(tokenService.getToken())
        .thenReturn(OperationResult(data: 'acces_token'));

    final repo = Repository();

    //Act
    final networkService =
        NetworkService(repository: repo, tokenService: tokenService, dio: dio);

    app.main(['Success test case'], networkService, repo);
    await tester.pumpAndSettle();

    //Assert
    checkMainScreen(2);
    verify(networkService.getAccounts()).called(1);

    await tapAndCheckListView(tester);
    await tapAndCheckGridView(tester);

    var element = find.byKey(const Key(Keys.filterViewIconKey));
    await tester.tap(element);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key(Keys.filterViewKey)), findsNWidgets(1));

    expect(
        find.text(EnumToString.convertToString(AccountStateFilter.all,
            camelCase: true)),
        findsNWidgets(1));
    element = find.text(
        EnumToString.convertToString(AccountStateFilter.all, camelCase: true));
    await tester.tap(element);
    await tester.pumpAndSettle();
    expect(
        find.text(EnumToString.convertToString(AccountStateFilter.inactive,
            camelCase: true)),
        findsNWidgets(2));
    expect(
        find.text(EnumToString.convertToString(AccountStateFilter.active,
            camelCase: true)),
        findsNWidgets(2));

    await tapAndCheckFilters(element, tester, filterModel);

    verify(networkService.getFilteredAccounts(FilterModel(
            accountState: AccountStateFilter.active,
            stateOrProvince: 'testState')))
        .called(1);

    expect(find.text('name1'), findsNWidgets(1));
    checkMainScreen(1);
  });
}

void checkMainScreen(cardCounts) {
  expect(find.text('No account is found'), findsNWidgets(0));
  expect(find.text('name1'), findsNWidgets(1));
  expect(find.byKey(const Key(Keys.searchTextFieldKey)), findsNWidgets(1));
  expect(find.byKey(const Key(Keys.searchIconKey)), findsNWidgets(1));
  expect(find.byKey(const Key(Keys.filterViewIconKey)), findsNWidgets(1));
  expect(find.byKey(const Key(Keys.listViewIconKey)), findsNWidgets(1));
  expect(find.byKey(const Key(Keys.gridViewIconKey)), findsNWidgets(1));
  expect(find.byKey(const Key(Keys.listViewKey)), findsNWidgets(0));
  expect(find.byKey(const Key(Keys.gridViewKey)), findsNWidgets(1));
  expect(find.byType(CardView), findsNWidgets(0));
  expect(find.byType(CardGridView), findsNWidgets(cardCounts));
}

void setDioAdapter(DioAdapter dioAdapter, String getAccountResponseData,
    {String url = baseUrl}) {
  dioAdapter.onGet(url, (request) {
    return request.reply(200, jsonDecode(getAccountResponseData));
  },
      data: null,
      queryParameters: {},
      headers: {'Authorization': 'Bearer acces_token'});
}

Future<void> tapAndCheckFilters(
    Finder element, WidgetTester tester, FilterModel filterModel) async {
  element = find.byKey(Key(filterModel.accountState.toString())).last;
  await tester.tap(element);
  await tester.pumpAndSettle();

  element = find.byKey(const Key(Keys.filterTextFieldKey));
  await tester.tap(element);
  await tester.pumpAndSettle();
  await tester.enterText(element, filterModel.stateOrProvince!);

  element = element = find.byKey(const Key(Keys.filterSearchButtonKey));
  await tester.tap(element);
  await tester.pumpAndSettle();
}

Future tapAndCheckListView(WidgetTester tester) async {
  final listView = find.byKey(const ValueKey(Keys.listViewIconKey));
  await tester.tap(listView);
  await tester.pumpAndSettle();
  expect(find.byKey(const Key(Keys.listViewKey)), findsNWidgets(1));
  expect(find.byKey(const Key(Keys.gridViewKey)), findsNWidgets(0));
}

Future<void> tapAndCheckGridView(WidgetTester tester) async {
  final gridView = find.byKey(const ValueKey(Keys.gridViewIconKey));
  await tester.tap(gridView);
  await tester.pumpAndSettle();

  expect(find.byKey(const Key(Keys.listViewKey)), findsNWidgets(0));
  expect(find.byKey(const Key(Keys.gridViewKey)), findsNWidgets(1));
}
