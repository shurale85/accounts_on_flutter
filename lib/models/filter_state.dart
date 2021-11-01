import 'account_state_enum.dart';

///Simplified filter state
class FilterState {
  AccountStateFilter _state = AccountStateFilter.all;
  String? _provinceOrCiyAddress;

  static final FilterState _origin = FilterState();

  FilterState();

  factory FilterState.create() => _origin;

  String? getProvinceOrCiyAddress() => _origin._provinceOrCiyAddress;

  AccountStateFilter getAccountState() => _origin._state;

  void setState(String? provinceOrCiyAddress, AccountStateFilter state) {
    _origin._provinceOrCiyAddress = provinceOrCiyAddress?.trim();
    _origin._state = state;
  }
}
