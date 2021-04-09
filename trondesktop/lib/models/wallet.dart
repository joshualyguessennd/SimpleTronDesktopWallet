// To parse this JSON data, do
//
//     final wallet = walletFromJson(jsonString);

import 'dart:convert';

import 'package:trondesktop/models/TransactionModel.dart';

Wallet walletFromJson(String str) => Wallet.fromJson(json.decode(str));

String walletToJson(Wallet data) => json.encode(data.toJson());

class Wallet {
  Wallet({
    this.seed,
    this.account,
  });

  String seed;
  List<Account> account = [];

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        seed: json["seed"],
        account:
            
            List<Account>.from(json["account"].map((x) => Account.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "seed": seed,
        "account": List<dynamic>.from(account.map((x) => x.toJson())),
      };
}

class Account {
  Account({
    this.privateKey,
    this.address,
   
  });

  String privateKey;
  String address;
  

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        privateKey: json["privateKey"],
        address: json["address"],
        
    );
  }
        
      

 Map<String, dynamic> toJson() => {
        "address": address,
        "privateKey": privateKey,
  
      };
  
  
  
  
  
}
