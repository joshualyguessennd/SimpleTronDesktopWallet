import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trondesktop/models/wallet.dart';
import 'package:http/http.dart' as http;
import 'package:trondesktop/screens/boardWallet.dart';

class CreateWallet extends StatefulWidget {
  

  @override
  _CreateWallet createState() => _CreateWallet();
}

int selectedIndex;
String walletAddress;
String mnemonic;
String privateKey;
bool _visible = false;

var colors = [
  Colors.grey,
  Colors.white,
];

Future<Wallet> createWallet(String number) async {
  var url = 'http://localhost:3000/createNewone';
  var client = http.Client();
  Uri _uri = Uri.parse(url);
  final response = await client.post(_uri,
      headers: {"Accept": "application/json"}, body: {"number": number});

  if (response.statusCode == 200 || response.statusCode == 201) {
    final String responseString = response.body.toString();

    return walletFromJson(responseString);
  } else {
    return null;
  }
}

class _CreateWallet extends State<CreateWallet> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  
  Wallet _wallet;
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

    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            width: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _visible = false;
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text('Generate New Wallet',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 200, right: 10),
                          child: Container(
                            width: 300,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                              child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: nameController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            _visible = false;
                            final String number = nameController.text;

                            if (nameController.text.isNotEmpty) {
                              final Wallet wallet = await createWallet(number);
                              setState(() {
                                _wallet = wallet;
                                nameController.clear();
                              });
                            } else {
                              return null;
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                                color: Color(0xff10752d)),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey,
                        height: 50,
                        width: 600,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text('Address',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white)),
                            SizedBox(
                              width: 420,
                            ),
                          ],
                        ),
                      ),
                      _wallet == null
                          ? Container()
                          : SizedBox(
                              width: 620,
                              height: 500,
                              child: Container(
                                width: 620,
                                height: 50,
                                child: ListView.builder(
                                    itemCount: _wallet.account.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              walletAddress = _wallet.account[index].address;
                                              privateKey = _wallet.account[index].privateKey;
                                              mnemonic = _wallet.seed;
                                              _visible = true;
                                            });
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
                                                          ? Color(0xff4fc96f)
                                                          : Colors
                                                              .transparent)),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      '${_wallet.account[index].address}',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.lato(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.black)),
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
                            )
                    ],
                  ),
                ),
                Visibility(
                  visible: _visible,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoardScreen(walletAddress, mnemonic.toString(), privateKey),
                          ));
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
        ),
      ),
    );
  }
}
