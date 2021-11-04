import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/constants.dart';
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/models/filter_model.dart';
import 'package:mobile_projects/models/operation_result.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mobile_projects/service/token_service.dart';
import 'package:logger/logger.dart';

/// Callback function type.
///
/// @param response is serialized result of API request
typedef ResponseMapper = void Function(Response response);

///Service with API methods
///
///API methods description can be found on https://docs.microsoft.com/en-us/powerapps/developer/data-platform/webapi/query-data-web-api
class NetworkService with ChangeNotifier {
  ///Indicates if request is in progress
  bool _isLoading = false;
  ///http Client
  final Dio _dio;
  ///Application datasource
  final Repository _repository;
  final TokenService _tokenService;
  final Logger logger = Logger(printer: PrettyPrinter());

  NetworkService(
      {required Repository repository,
      required TokenService tokenService,
      Dio? dio,
      Logger? logger})
      : _repository = repository,
        _tokenService = tokenService,
        _dio = dio ?? Dio();

  bool getIsLoading() => _isLoading;

  _setLoading() {
    _isLoading = true;
    notifyListeners();
  }

  _resetLoading() {
    _isLoading = false;
    notifyListeners();
  }

  /// Returns available [Account] collection
  Future getAccounts() async {
    try {
      void map(Response response) {
        _repository.setData(response.data['value']
            .map<Account>((item) => Account.fromJson(item))
            .toList());
      }

      var result = await _httpGet(qParams: null, callback: map);
      if (!result.isOk()) {
        //TODO: add err handling
        logger.w(result.error);
      }
    } catch (e) {
      //TODO: add err handling
      logger.e(e);
      rethrow;
    }
  }

  /// Returns [Account] collection that matches to search criteria [query]
  Future searchAccount(String query) async {
    try {
      void map(Response response) {
        _repository.setData(response.data['value']
            .map<Account>((item) => Account.fromJson(item))
            .toList());
      }

      final qParam =
          "\$filter=(contains(accountnumber, '$query') or contains(name, '$query'))";
      var result = await _httpGet(qParams: qParam, callback: map);
      if (!result.isOk()) {
        //TODO: add err handling
        logger.w(result.error);
      }
    } catch (e) {
      //TODO: add err handling
      logger.e(e);
      rethrow;
    }
  }

  /// Returns [Account] collection filtered by [filterModel]
  Future getFilteredAccounts(FilterModel filterModel) async {
    try {
      void map(Response response) {
        _repository.setData(response.data['value']
            .map<Account>((item) => Account.fromJson(item))
            .toList());
      }

      var result =
          await _httpGet(qParams: filterModel.getQueryParam(), callback: map);
      if (!result.isOk()) {
        //TODO: add err handling
        logger.w(result.error);
      }
    } catch (e) {
      //TODO: add err handling
      logger.e(e);
      rethrow;
    }
  }

  ///Makes GET request and call for [callback] on request result
  Future<OperationResult> _httpGet(
      {String? qParams, required ResponseMapper callback}) async {
    String url = baseUrl;
    if (qParams != null) {
      url = "$baseUrl&$qParams";
    }

    try {
      final tokenResult = _tokenService.getToken();
      if (tokenResult.isOk() && tokenResult.data != null) {
        _setLoading();

        var opts = Options(headers: <String, String>{});
        opts.headers?['Authorization'] = 'Bearer ${tokenResult.data}';
        final response = await _dio.get(url, options: opts);
        if (response.statusCode != 200) {
          OperationResult(
              error:
                  'Status code: ${response.statusCode} ,msg: ${response.statusMessage}');
        }
        callback(response);
        _resetLoading();
        return OperationResult.success();
      } else {
        return OperationResult(error: tokenResult.error);
      }
    } catch (e) {
      _resetLoading();
      return OperationResult(error: e.toString());
    }
  }
}
