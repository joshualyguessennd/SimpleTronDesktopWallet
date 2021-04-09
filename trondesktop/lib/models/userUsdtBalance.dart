// To parse this JSON data, do
//
//     final usdtBalance = usdtBalanceFromJson(jsonString);

import 'dart:convert';

UsdtBalance usdtBalanceFromJson(String str) => UsdtBalance.fromJson(json.decode(str));

String usdtBalanceToJson(UsdtBalance data) => json.encode(data.toJson());

class UsdtBalance {
    UsdtBalance({
        this.balance,
    });

    String balance;

    factory UsdtBalance.fromJson(Map<String, dynamic> json) => UsdtBalance(
        balance: json["BALANCE"],
    );

    Map<String, dynamic> toJson() => {
        "BALANCE": balance,
    };
    @override
    String toString() {
    return '$balance';
  }
}


