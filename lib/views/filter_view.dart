import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/models/account_state_enum.dart';
import 'package:mobile_projects/models/filter_model.dart';
import 'package:mobile_projects/service/network_service.dart';
import 'package:provider/src/provider.dart';
import 'package:enum_to_string/enum_to_string.dart';


class FilterView extends StatefulWidget {
  FilterView({Key? key}) : super(key: key);
  @override
  FilterViewState createState() => FilterViewState();
}

class FilterViewState extends State<FilterView> {
  AccountState? stateValue = AccountState.all;
  final textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return     AlertDialog(
      scrollable: true,
      title: const Text('Set search criteria'),
      content: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          children: <Widget> [
            const Text('Accounts state'),
            InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                contentPadding: const EdgeInsets.all(10),
              ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AccountState>(
                      value: stateValue,
                      isExpanded:true,
                      isDense: true,
                      onChanged: (AccountState? state){
                        setState(() {
                          stateValue = state;
                        });
                      },
                      items: AccountState.values.map((AccountState state) {
                        return DropdownMenuItem<AccountState>(
                            value: state,
                            child: Text(EnumToString.convertToString(state, camelCase: true)));
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
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                /* Clear the search field */
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
          onPressed: () {
            context.read<NetworkService>().getFilteredAccounts(FilterModel(accountState: stateValue, stateOrProvince: textEditingController.text));
            Navigator.pop(context);},
          child: const Text('Search'),
        ),
      ],
    );
  }
}