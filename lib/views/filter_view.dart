import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/models/account_state_enum.dart';
import 'package:mobile_projects/models/filter_model.dart';
import 'package:mobile_projects/models/filter_state.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:provider/src/provider.dart';
import 'package:enum_to_string/enum_to_string.dart';
import '../constants.dart';

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  FilterViewState createState() => FilterViewState();
}

class FilterViewState extends State<FilterView> {
  AccountStateFilter stateValue = AccountStateFilter.all;
  String? provinceOrCity;
  late FilterState _filterState;

  final textEditingController = TextEditingController();

  @override
  void initState() {
    _filterState = context.read<FilterState>();
    textEditingController.text = _filterState.getProvinceOrCiyAddress() ?? '';
    stateValue = _filterState.getAccountState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Set search criteria'),
      content: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Accounts state'),
            InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                contentPadding: const EdgeInsets.all(10),
              ),
              child: DropdownButtonHideUnderline(
                key: const Key(Keys.filterDropDownKey),
                child: DropdownButton<AccountStateFilter>(
                  value: stateValue,
                  isExpanded: true,
                  isDense: true,
                  onChanged: (AccountStateFilter? state) {
                    setState(() {
                      stateValue = state ?? AccountStateFilter.all;
                    });
                  },
                  items:
                      AccountStateFilter.values.map((AccountStateFilter state) {
                    return DropdownMenuItem<AccountStateFilter>(
                        value: state,
                        child: Text(
                          EnumToString.convertToString(state, camelCase: true),
                          key: Key(state.toString()),
                        ));
                  }).toList(),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              height: 50,
            ),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all()),
              child: Center(
                child: TextField(
                  key: const Key(Keys.filterTextFieldKey),
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          textEditingController.text = '';
                        },
                      ),
                      hintText: 'State or Province...',
                      border: InputBorder.none),
                  controller: textEditingController,
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          key: const Key(Keys.filterSearchButtonKey),
          onPressed: () {
            _filterState.setState(textEditingController.text, stateValue);
            context.read<NetworkService>().getFilteredAccounts(FilterModel(
                accountState: stateValue,
                stateOrProvince: textEditingController.text));
            Navigator.pop(context);
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
}
