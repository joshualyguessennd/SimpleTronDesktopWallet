import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trondesktop/models/wallet.dart';
import 'package:http/http.dart' as http;
import 'package:trondesktop/screens/boardWallet.dart';

class AccessWallet extends StatefulWidget {
  @override
  _AccessWallet createState() => _AccessWallet();
}

Future<Wallet> createWithMnemonic(String mnemonic) async {
  var url = 'http://localhost:3000/createWithExistingMnemonice';

  var client = http.Client();
  Uri _uri = Uri.parse(url);
  final response = await client.post(_uri,
      headers: {"Accept": "application/json"},
      body: {"number": '10', "seed": mnemonic});

  if (response.statusCode == 200 || response.statusCode == 201) {
    final String responseString = response.body.toString();

    return walletFromJson(responseString);
  } else {
    return null;
  }
}

class _AccessWallet extends State<AccessWallet> {
  String walletAddress;
  String privateKey;
  int selectedIndex = 0;
  Wallet _wallet;
  final _formKey = GlobalKey<FormState>();
  final mnemonicController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
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
              height: 90,
            ),
            Center(
              child: Container(
                height: 300,
                width: 550,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(7)),
                child: Container(
                  width: 300,
                  child: Form(
                    key: _formKey,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: mnemonicController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  final mnemonic = mnemonicController.text;
                  final Wallet wallet = await createWithMnemonic(mnemonic);
                  print(mnemonicController.text);
                  if (mnemonicController.text.isNotEmpty) {
                    setState(() {
                      _wallet = wallet;
                      mnemonicController.clear();
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
                                      itemCount: _wallet.account.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          selected: index == selectedIndex,
                                          title: InkWell(
                                            onTap: () {
                                              selectedIndex = index;
                                              walletAddress = _wallet
                                                  .account[index].address;
                                              privateKey = _wallet
                                                  .account[index].privateKey;
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BoardScreen(
                                                            walletAddress,
                                                            mnemonic.toString(),
                                                            privateKey),
                                                  ));
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 560,
                                              child: Container(
                                                width: 660,
                                                decoration: BoxDecoration(
                                                    color: (index % 2 == 0)
                                                        ? Colors.grey
                                                        : Colors.white,
                                                    border: Border.all(
                                                        color: selectedIndex ==
                                                                index
                                                            ? Colors.blue
                                                            : Colors
                                                                .transparent)),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                        '${_wallet.account[index].address}',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lato(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color:
                                                                Colors.black)),
                                                    SizedBox(
                                                      width: 260,
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        await Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  '${_wallet.account[index].address}'),
                                                        ).then(_handleSuccess,
                                                            onError:
                                                                _handleError);
                                                      },
                                                      icon: Icon(
                                                        Icons.copy,
                                                        color: Colors.black,
                                                        size: 20.0,
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
                                padding: const EdgeInsets.only(left: 100),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.red))),
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
                  } else {
                    return null;
                  }
                },
                child: Container(
                  height: 80,
                  width: 200,
                  color: Color(0xff10752d),
                  child: Center(
                    child: Text(
                      'Continue',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
