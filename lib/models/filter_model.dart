import 'package:mobile_projects/models/account_state_enum.dart';

class FilterModel {
  final AccountState? accountState ;
  final String? stateOrProvince;

  FilterModel({this.accountState, this.stateOrProvince});

  String? getQueryParam() {

    var stateCodeParam = accountState != null && accountState != AccountState.all
      ? "statecode eq ${accountState!.index}"
      : '';
    var stateOrProvinceParam = stateOrProvince != null && stateOrProvince!.trim().isNotEmpty
      ? "contains(address1_stateorprovince, '${stateOrProvince!.trim()}')"
      : '';
    var conjunction = stateCodeParam != '' && stateOrProvinceParam != ''
      ? " and "
      : '';

    return stateCodeParam == '' && stateOrProvinceParam == ''
      ? null
      :"\$filter=($stateCodeParam$conjunction$stateOrProvinceParam)";
  }
}