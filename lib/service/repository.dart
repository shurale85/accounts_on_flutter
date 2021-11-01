import 'package:mobile_projects/models/account.dart';

/// Simplified application datasource
class Repository {
  var _dataSource = <Account>[];

  Repository();

  /// Returns accounts from datasource
  List<Account> getData() => _dataSource;

  /// Set accounts into datasource
  void setData(List<Account> accounts) {_dataSource = accounts; }
}