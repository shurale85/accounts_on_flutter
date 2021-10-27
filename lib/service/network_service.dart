import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/service/token_service.dart';

class NetworkService with ChangeNotifier{

  List<Account> _dataSource = [];
  bool _isLoading = false;

  List<Account> getData() => _dataSource;

  bool getIsLoading() => _isLoading;

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
      final tokenResult = TokenService.GetToken();
      if(tokenResult.isOk() && tokenResult.data != null) {
        _setLoading();
        final response = await http.get(
            Uri.parse(
                'https://flutterback.crm4.dynamics.com/api/data/v9.0/accounts'),
            headers: <String, String>{
              'Authorization': 'Bearer ${tokenResult.data}'
            });
        var accountsJson = json.decode(response.body)['value'] as List;
        _dataSource = accountsJson.map((item) => Account.fromJson(item)).toList();
        _resetLoading();
      } else {
        return Future.error(tokenResult.error!);
      }
    } catch (e) {
        _resetLoading();
        return Future.error(e);
    }
  }

  Future getFilteredAccounts() async {
    print('f');
    _setLoading();
    Future.delayed(const Duration(seconds: 4), () {
      _resetLoading();
      print('done');
    });

  }
}