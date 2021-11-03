import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mobile_projects/constants.dart';
import 'package:mobile_projects/models/operation_result.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mobile_projects/service/token_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_service_test.mocks.dart';

@GenerateMocks([TokenService])
Future<void> main() async {
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);

  var tokenService = MockTokenService();
  final repository = Repository();
  const testResponseData =
      r'''{"value": [{"name": "name1", "statecode": 1, "accountid": "A"},{"name": "name2", "statecode": 0, "accountid": "B"}]}''';
  setUp(() {
    dio.httpClientAdapter = dioAdapter;
  });

  group('NetworkService class methods test', () {
    test('GetAccounts test', () async {
      //Arrange
      dioAdapter.onGet(baseUrl, (request) {
        return request.reply(200, jsonDecode(testResponseData));
      },
          data: null,
          queryParameters: {},
          headers: {'Authorization': 'Bearer acces_token'});

      when(tokenService.getToken())
          .thenReturn(OperationResult(data: 'acces_token'));

      //Act
      final networkService = NetworkService(
          repository: repository, tokenService: tokenService, dio: dio);
      await networkService.getAccounts();

      //Assert
      verify(tokenService.getToken()).called(1);
      var data = repository.getData();
      expect(data.length, 2);
      expect(data[0].name, 'name1');
      expect(data[1].name, 'name2');
    });
  });
}
