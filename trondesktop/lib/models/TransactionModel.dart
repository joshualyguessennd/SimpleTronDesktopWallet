import 'dart:convert';

Transaction transactionFromJson(String str) => Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
    Transaction({
        this.tradeobj,
        this.fromAddress,
        this.toAddress,
        this.amount,
    });

    Tradeobj tradeobj;
    String fromAddress;
    String toAddress;
    String amount;

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        tradeobj: Tradeobj.fromJson(json["tradeobj"]),
        fromAddress: json["fromAddress"],
        toAddress: json["toAddress"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "tradeobj": tradeobj.toJson(),
        "fromAddress": fromAddress,
        "toAddress": toAddress,
        "amount": amount,
    };
}

class Tradeobj {
    Tradeobj({
        this.visible,
        this.txId,
    });

    bool visible;
    String txId;

    factory Tradeobj.fromJson(Map<String, dynamic> json) => Tradeobj(
        visible: json["visible"],
        txId: json["txID"],
        
    );

    Map<String, dynamic> toJson() => {
        "visible": visible,
        "txID": txId,

    };
}