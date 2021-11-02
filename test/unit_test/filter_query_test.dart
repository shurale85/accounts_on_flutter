import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_projects/models/account_state_enum.dart';
import 'package:mobile_projects/models/filter_model.dart';

void main() {
  group('Filter test', () {
    test('Filter is null When neither State nor ProvinceOrCite are provided',
        () {
      final queryParam = FilterModel().getQueryParam();
      expect(queryParam, null);
    });

    test(
        'Filter is correct When State param only is provided and Has value Active or Inactive',
        () {
      var state = AccountStateFilter.active;
      var queryParam = FilterModel(accountState: state).getQueryParam();
      expect(queryParam, '\$filter=(statecode eq ${state.index})');

      state = AccountStateFilter.inactive;
      queryParam = FilterModel(accountState: state).getQueryParam();
      expect(queryParam, '\$filter=(statecode eq ${state.index})');
    });

    test('State is not filter param  When state Has value All', () {
      final queryParam = FilterModel(
              accountState: AccountStateFilter.all, stateOrProvince: 'test')
          .getQueryParam();
      expect(
          queryParam, "\$filter=(contains(address1_stateorprovince, 'test'))");
    });

    test(
        'Filter has params State adn StateOrProvince When correct values are provided',
        () {
      final queryParam = FilterModel(
              accountState: AccountStateFilter.inactive,
              stateOrProvince: 'test')
          .getQueryParam();
      expect(queryParam,
          "\$filter=(statecode eq ${AccountStateFilter.inactive.index} and contains(address1_stateorprovince, 'test'))");
    });

    test(
        'Filter has params State and StateOrProvince When correct values are provided',
        () {
      final queryParam = FilterModel(
              accountState: AccountStateFilter.inactive,
              stateOrProvince: 'test')
          .getQueryParam();
      expect(queryParam,
          "\$filter=(statecode eq ${AccountStateFilter.inactive.index} and contains(address1_stateorprovince, 'test'))");
    });

    test('Filter is empty When params  are null or empty or space', () {
      var queryParam = FilterModel().getQueryParam();
      expect(queryParam, null);

      queryParam = FilterModel(accountState: null, stateOrProvince: null)
          .getQueryParam();
      expect(queryParam, null);

      queryParam = FilterModel(accountState: null, stateOrProvince: '  ')
          .getQueryParam();
      expect(queryParam, null);
    });
  });
}
