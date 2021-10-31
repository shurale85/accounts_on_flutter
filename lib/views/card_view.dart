import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/models/account.dart';

class CardView extends StatelessWidget {

  final Account _account;

  const CardView(this._account);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white60,
        border: Border.all(color: Colors.lightBlueAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(7))
                ),
                child: Text( _account.name),
                ),
              ),


            Expanded(
                flex: 10,
                child: Container(
                  margin: const EdgeInsets.all(15),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: SelectableText(_account.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      SelectableText('Number: ${_account.accountnumber}'),
                      SelectableText('Address: ${_account.address1_stateorprovince}'),
                      SelectableText('IsActive: ${(_account.statecode == 0 ? 'Inactive' : 'Active')}')
                    ],
                  ),
                )
            )
          ]
      ),
    );

  }
}