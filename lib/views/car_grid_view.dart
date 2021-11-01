import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/models/account.dart';

class CardGridView extends StatelessWidget {
  final Account _account;

  const CardGridView(this._account, {Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Colors.white60,
          border: Border.all(color: Colors.lightBlueAccent),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: SelectableText(
              _account.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SelectableText('Number: ${_account.accountnumber}'),
          SelectableText('Address: ${_account.address1_stateorprovince}'),
          SelectableText(
              'IsActive: ${(_account.statecode == 0 ? 'Inactive' : 'Active')}')
        ],
      ),
    );
  }
}
