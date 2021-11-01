import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/models/filter_model.dart';
import 'package:mobile_projects/models/operation_result.dart';
import 'package:mobile_projects/service/repository.dart';
import 'package:mobile_projects/service/token_service.dart';

typedef ResponseMapper = void Function(Response response);

class NetworkService with ChangeNotifier{
  bool _isLoading = false;
  bool getIsLoading() => _isLoading;
  final Repository _repository;
  final TokenService _tokenService;

  NetworkService({required Repository repository, required TokenService tokenService}) : _repository = repository, _tokenService = tokenService;

  _setLoading() {
    _isLoading = true;
    notifyListeners();
  }
  _resetLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future getAccounts() async {
    try {
      void map(Response response)  {
        _repository.setData(response.data['value'].map<Account>((item) =>
           Account.fromJson(item)).toList());
      }

      var result = await _httpGet(qParams:null, callback: map);
      if(!result.isOk()) {
        //TODO: add debug logging, err handling logic
        print(result.error);
      }
    } catch (e) {
      //TODO: add debug logging, err handling logic
      print(e);
    }
  }

  Future searchAccount(String query) async{
    try {
      void map(Response response)  {
          _repository.setData(response.data['value'].map<Account>((item) =>
            Account.fromJson(item)).toList());
      }

      final qParam = "\$filter=(contains(accountnumber, '$query') or contains(name, '$query'))";
      var result = await _httpGet(qParams:qParam, callback: map);
      if(!result.isOk()) {
        //TODO: add debug logging, err handling logic
        print(result.error);
      }
    } catch (e) {
      //TODO: add debug logging, err handling logic
      print(e);
    }
  }


  Future getFilteredAccounts(FilterModel filterModel) async {
    try {
      void map(Response response)  {
          _repository.setData(response.data['value'].map<Account>((item) =>
            Account.fromJson(item)).toList());
      }

      print(filterModel.getQueryParam());
      var result = await _httpGet(qParams: filterModel.getQueryParam(), callback: map);
      if(!result.isOk()) {
        //TODO: add debug logging, err handling logic
        print(result.error);
      }
    } catch (e) {
      //TODO: add debug logging, err handling logic
      print(e);
    }

  }

  Future<OperationResult> _httpGet( {String? qParams, required ResponseMapper callback}) async {
    var url = r"https://flutterback.crm4.dynamics.com/api/data/v9.0/accounts"
        r"?$select=name,accountid,statecode,emailaddress1,accountnumber,address1_stateorprovince,entityimage_url,address1_composite";

    if(qParams != null) {
      url = "$url&$qParams";
    }

    try {
        final tokenResult = _tokenService.getToken();
        if(tokenResult.isOk() && tokenResult.data != null) {
          _setLoading();

          var _dio = Dio();
          var opts = Options(headers: <String, String>{});
          opts.headers?['Authorization'] = 'Bearer ${tokenResult.data}';
          final response = await _dio.get(url, options: opts);
          if(response.statusCode != 200) {
            print('Status code: ${response.statusCode} ,msg: ${response.statusMessage}');

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