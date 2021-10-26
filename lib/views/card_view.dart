import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_projects/models/account.dart';

class CardView extends StatelessWidget {

  final Account _account;

  const CardView(this._account);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white30,
        border: Border()
      ),
      child: Row(

          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [ _account.entityimage_url == null
                    ? Text(_account.name)
                    :Image.network(_account.entityimage_url!)
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child:Column(
                  children: [
                    Padding(padding: EdgeInsets.all(3), child:SelectableText(_account.name)),
                    Padding(padding: EdgeInsets.all(3), child:Text(_account.address1_composite??''))],
                ))
          ]
      ),
      margin: EdgeInsets.all(5),

    );

  }
}