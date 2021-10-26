import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/service/token_service.dart';

class NetworkService {
  static Future<List<Account>> getAccounts() async {
    try {
      final tokenResult = TokenService.GetToken();

      if(tokenResult.isOk() && tokenResult.data != null) {
        final response = await http.get(
            Uri.parse(
                'https://flutterback.crm4.dynamics.com/api/data/v9.0/accounts'),
            headers: <String, String>{
              'Authorization': 'Bearer ${tokenResult.data}'
            });
        var accountsJson = json.decode(response.body)['value'] as List;
        List<Account> accounts = accountsJson.map((item) => Account.fromJson(item)).toList();
        return accounts;
      }
      return Future.error(tokenResult.error!);
    } catch (e) {
        return Future.error(e);
    }
  }
}