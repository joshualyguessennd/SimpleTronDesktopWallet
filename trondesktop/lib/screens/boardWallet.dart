import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trondesktop/models/usdt.dart';
import 'package:trondesktop/models/userBalance.dart';
import 'package:trondesktop/models/userUsdtBalance.dart';
import 'package:http/http.dart' as http;
import 'package:trondesktop/models/wallet.dart';
import 'package:trondesktop/models/TransactionModel.dart';

class BoardScreen extends StatefulWidget {
  String address;
  String privateKey;
  final String mnemonic;

  BoardScreen(this.address, this.mnemonic, this.privateKey);

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  Wallet _wallet;
  Transaction _transaction;
  Usdt _usdt;
  int selectedIndex = 0;
  String walletAddress;
  final _formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final amountController = TextEditingController();

  Future<Balance> getBalance(String address) async {
    var url = 'http://localhost:3000/balance';
    var client = http.Client();
    Uri _uri = Uri.parse(url);
    final response = await client.post(_uri,
        headers: {"Accept": "application/json"},
        body: {"address": widget.address});

    if (response.statusCode == 200 || response.statusCode == 201) {
      final String responseString = response.body.toString();

      return balanceFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<UsdtBalance> getUsdtBalance(String address) async {
    var url = 'http://localhost:3000/balanceUSDT';
    var client = http.Client();
    Uri _uri = Uri.parse(url);
    final response = await client.post(_uri,
        headers: {"Accept": "application/json"},
        body: {"fromAddress": widget.address, "privateKey": widget.privateKey});

    if (response.statusCode == 200 || response.statusCode == 201) {
      final String responseString = response.body.toString();

      return usdtBalanceFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<Usdt> sendUSDT(String toAddress, String amount) async {
    var url = 'http://localhost:3000/sendUSDT';
    var client = http.Client();
    Uri _uri = Uri.parse(url);
    final response = await client.post(_uri, headers: {
      "Accept": "application/json"
    }, body: {
      "toAddress": toAddress,
      "privateKey": widget.privateKey,
      "amount": amount
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final String responseString = response.body.toString();

      return usdtFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<Transaction> sendTron(String toAddress, String amount) async {
    var url = 'http://localhost:3000/sendTron';
    var client = http.Client();
    Uri _uri = Uri.parse(url);
    final response = await client.post(_uri, headers: {
      "Accept": "application/json"
    }, body: {
      "fromAddress": widget.address,
      "toAddress": toAddress,
      "privateKey": widget.privateKey,
      "amount": amount
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final String responseString = response.body.toString();

      return transactionFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<Wallet> createWithMnemonic() async {
    var url = 'http://localhost:3000/createWithExistingMnemonice';
    var client = http.Client();
    Uri _uri = Uri.parse(url);
    final response = await client.post(_uri,
        headers: {"Accept": "application/json"},
        body: {"number": '10', "seed": widget.mnemonic.toString()});

    if (response.statusCode == 200 || response.statusCode == 201) {
      final String responseString = response.body.toString();

      return walletFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<Balance> _future;
  Future<UsdtBalance> _future1;
  @override
  Widget build(BuildContext context) {
    void _handleSuccess(dynamic result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xff10752d),
          content: Text('address copied'),
        ),
      );
    }

    void _handleError(Object exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('_handleError called with exception $exception.'),
        ),
      );
    }

    setUpTimedFetch() {
      Timer.periodic(Duration(milliseconds: 5000), (timer) {
        setState(() {
          _future = getBalance(widget.address);
          _future1 = getUsdtBalance(widget.address);
        });
      });
    }

    @override
    void initState() {
      super.initState();
      setUpTimedFetch();
    }

    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                Center(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(width: 350),
                      Container(
                        height: 150,
                        width: 400,
                        decoration: BoxDecoration(
                            color: Color(0xff5f0ff5),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              child: Image(
                                  image: AssetImage(
                                    'assets/images/tronwallet.png',
                                  ),
                                  height: 80,
                                  width: 80,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Address',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.address,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final Wallet wallet =
                                            await createWithMnemonic();
                                        setState(() {
                                          _wallet = wallet;
                                        });
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            content: Container(
                                              width: 625,
                                              height: 550,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 620,
                                                    height: 500,
                                                    child: Container(
                                                      width: 620,
                                                      height: 500,
                                                      child: ListView.builder(
                                                          itemCount: _wallet
                                                              .account.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              selected: index ==
                                                                  selectedIndex,
                                                              title: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedIndex =
                                                                        index;

                                                                    widget.address = _wallet
                                                                        .account[
                                                                            index]
                                                                        .address;
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 50,
                                                                  width: 560,
                                                                  child:
                                                                      Container(
                                                                    width: 660,
                                                                    decoration: BoxDecoration(
                                                                        color: (index % 2 ==
                                                                                0)
                                                                            ? Colors
                                                                                .grey
                                                                            : Colors
                                                                                .white,
                                                                        border: Border.all(
                                                                            color: selectedIndex == index
                                                                                ? Colors.blue
                                                                                : Colors.transparent)),
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                            '${_wallet.account[index].address}',
                                                                            textAlign: TextAlign
                                                                                .left,
                                                                            style: GoogleFonts.lato(
                                                                                textStyle: Theme.of(context).textTheme.headline4,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontStyle: FontStyle.italic,
                                                                                color: Colors.black)),
                                                                        SizedBox(
                                                                          width:
                                                                              260,
                                                                        ),
                                                                        IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await Clipboard
                                                                                .setData(
                                                                              ClipboardData(text: '${_wallet.account[index].address}'),
                                                                            ).then(_handleSuccess,
                                                                                onError: _handleError);
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.copy,
                                                                            color:
                                                                                Colors.black,
                                                                            size:
                                                                                20.0,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 100),
                                                    child: Container(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          SizedBox(
                                                            width: 45,
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'close',
                                                                  style: GoogleFonts.lato(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline4,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: Colors
                                                                          .red))),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Switch',
                                          style: GoogleFonts.lato(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white),
                                        )),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await Clipboard.setData(
                                          ClipboardData(
                                              text: this.widget.address),
                                        ).then(_handleSuccess,
                                            onError: _handleError);
                                      },
                                      icon: Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        height: 150,
                        width: 400,
                        decoration: BoxDecoration(
                            color: Color(0xff1a78d6),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              child: Image(
                                  image: AssetImage(
                                    'assets/images/wallet.png',
                                  ),
                                  height: 80,
                                  width: 80,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Balance',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        StreamBuilder(
                                          stream: Stream.periodic(
                                                  Duration(seconds: 5))
                                              .asyncMap((i) => getBalance(this
                                                  .widget
                                                  .address)), // i is null here (check periodic docs)
                                          builder: (context, snapshot) => Text(
                                            snapshot.data.toString(),
                                            style: GoogleFonts.lato(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white),
                                          ), // builder should also handle the case when data is not fetched yet
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'TRX',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        StreamBuilder(
                                          stream: Stream.periodic(
                                                  Duration(seconds: 5))
                                              .asyncMap((i) => getUsdtBalance(this
                                                  .widget
                                                  .address)), // i is null here (check periodic docs)
                                          builder: (context, snapshot) => Text(
                                            snapshot.data.toString(),
                                            style: GoogleFonts.lato(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white),
                                          ), // builder should also handle the case when data is not fetched yet
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'USDT',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => AlertDialog(
                              content: Container(
                                width: 625,
                                height: 550,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 100),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                            ),
                                            SizedBox(
                                              width: 45,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('close',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline4,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.red))),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Center(
                                              child: TextFormField(
                                                controller: addressController,
                                                decoration: InputDecoration(
                                                  hintText: 'Address',
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Center(
                                              child: TextFormField(
                                                controller: amountController,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                  hintText: 'Amount',
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 100,
                                          ),
                                          Center(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Color(0xff2f57c4)),
                                                child: InkWell(
                                                  onTap: () async {
                                                    String toAddress =
                                                        addressController.text;
                                                    String amount =
                                                        amountController.text;
                                                    final Transaction
                                                        transaction =
                                                        await sendTron(
                                                            toAddress, amount);
                                                    setState(() {
                                                      _transaction =
                                                          transaction;
                                                      amountController.clear();
                                                      addressController.clear();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Icon(
                                                    Icons.send,
                                                    color: Colors.white,
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 25),
                                              Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Color(0xff10752d)),
                                                child: InkWell(
                                                  onTap: () async {
                                                    String toAddress =
                                                        addressController.text;
                                                    String amount =
                                                        amountController.text;
                                                    final Usdt usdt =
                                                        await sendUSDT(toAddress, amount);

                                                    setState(() {
                                                      _usdt = usdt;
                                                      amountController.clear();
                                                      addressController.clear();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Icon(
                                                    Icons.send,
                                                    color: Colors.white,
                                                    size: 30.0,
                                                  ),
                                                ),

                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: 400,
                          decoration: BoxDecoration(
                              color: Color(0xff2f57c4),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                _transaction == null
                    ? Container()
                    : Expanded(
                        child: Container(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
