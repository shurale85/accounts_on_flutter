import 'package:mobile_projects/models/account.dart';
import 'package:mobile_projects/models/account_state_enum.dart';

/// Constructs $filter query param from fields [Account.state] and [Account.address1_stateorprovince]
///
/// Modre details on https://docs.microsoft.com/en-us/powerapps/developer/data-platform/webapi/query-data-web-api
class FilterModel {
  final AccountStateFilter? accountState;

  final String? stateOrProvince;

  FilterModel({this.accountState, this.stateOrProvince});

  String? getQueryParam() {
    var stateCodeParam =
        accountState != null && accountState != AccountStateFilter.all
            ? "statecode eq ${accountState!.index}"
            : '';
    var stateOrProvinceParam =
        stateOrProvince != null && stateOrProvince!.trim().isNotEmpty
            ? "contains(address1_stateorprovince, '${stateOrProvince!.trim()}')"
            : '';
    var conjunction =
        stateCodeParam != '' && stateOrProvinceParam != '' ? " and " : '';

    return stateCodeParam == '' && stateOrProvinceParam == ''
        ? null
        : "\$filter=($stateCodeParam$conjunction$stateOrProvinceParam)";
  }
}
