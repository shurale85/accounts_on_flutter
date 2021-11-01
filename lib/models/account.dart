import 'package:flutter/cupertino.dart';

///Main data model of the application
///
///Model maps to entity from https://docs.microsoft.com/en-us/powerapps/developer/data-platform/reference/entities/account
@immutable
class Account {
  final String name;
  final String accountid;

  ///Shows whether the account is active or inactive
  final int statecode;
  final String? emailaddress1;
  final String? accountnumber;
  final String? address1_composite;

  ///State or province of the primary address
  final String? address1_stateorprovince;
  final String? entityimage_url;

  const Account(this.name, this.statecode, this.accountid,
      {this.emailaddress1,
      this.accountnumber,
      this.address1_composite,
      this.address1_stateorprovince,
      this.entityimage_url});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(json['name'], json['statecode'] as int, json['accountid'],
        emailaddress1: json['emailaddress1'],
        accountnumber: json['accountnumber'],
        address1_composite: json['address1_composite'],
        address1_stateorprovince: json['address1_stateorprovince'],
        entityimage_url: json['entityimage_url']);
  }

  /// Returns collection of account stub
  static List<Account> get accounts => List<Account>.generate(
      10,
      (i) => Account('Name_$i', 1, 'id_$i',
          accountnumber: "$i",
          address1_stateorprovince: "Address of account $i"));
}
