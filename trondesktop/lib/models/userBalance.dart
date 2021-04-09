// To parse this JSON data, do
//
//     final balance = balanceFromJson(jsonString);

import 'dart:convert';

Balance balanceFromJson(String str) => Balance.fromJson(json.decode(str));

String balanceToJson(Balance data) => json.encode(data.toJson());

class Balance {
  Balance({
    this.getUserBalance,
  });

  String getUserBalance;

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        getUserBalance: json["getUserBalance"],
      );

  Map<String, dynamic> toJson() => {
        "getUserBalance": getUserBalance,
      };
  @override
  String toString() {
    return '$getUserBalance';
  }
}
