import 'account_state_enum.dart';

///Simplified filter state
class FilterState {

  AccountState _state = AccountState.all;
  String? _provinceOrCiyAddress;

  static final FilterState _origin = FilterState();

  FilterState();

  factory FilterState.create() => _origin;

  String? getProvinceOrCiyAddress() => _origin._provinceOrCiyAddress;
  AccountState getAccountState() => _origin._state;

  void setState(String? provinceOrCiyAddress, AccountState state) {
    _origin._provinceOrCiyAddress = provinceOrCiyAddress?.trim();
    _origin._state = state;
  }
}