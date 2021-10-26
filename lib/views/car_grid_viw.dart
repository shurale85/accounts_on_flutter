import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/models/account.dart';

class CardGridView extends StatelessWidget {

  final Account _account;
  CardGridView(this._account);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white60
      ),
      child: Column(
                children: [Expanded(
          child:_account.entityimage_url == null
              ? Text(_account.name)
              :Image.network(_account.entityimage_url!)
        ),
        SelectableText(_account.name),
        Text(_account.address1_composite??'')
        ],
      ),
    );
  }
}