// To parse this JSON data, do
//
//     final usdt = usdtFromJson(jsonString);

import 'dart:convert';

Usdt usdtFromJson(String str) => Usdt.fromJson(json.decode(str));

String usdtToJson(Usdt data) => json.encode(data.toJson());

class Usdt {
    Usdt({
        this.send,
    });

    String send;

    factory Usdt.fromJson(Map<String, dynamic> json) => Usdt(
        send: json["send"],
    );

    Map<String, dynamic> toJson() => {
        "send": send,
    };
}