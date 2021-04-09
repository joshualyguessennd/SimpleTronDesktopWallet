import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trondesktop/screens/accessWallet.dart';
import 'package:trondesktop/screens/createWallet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7fcff),
      body: Container(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Image(
                    image: AssetImage(
                      'assets/images/logo.png',
                    ),
                    height: 80,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Tron Wallet Generator',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black
                                )),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              width: 400,
                              child: Text(
                                  'TronWallet  is a free, client-side interface helping you interact with the Tron blockchain. Our easy-to-use, open-source platform allows you to generate wallets, interact with smart contracts, and so much more',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 7),
                      Container(
                        child: Image(
                          image: AssetImage(
                            'assets/images/astronaute.png',
                          ),
                          height: 280,
                          width: 250,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateWallet()),
                          );
                        },
                        child: Container(
                          height: 250,
                          width: 480,
                          decoration: BoxDecoration(
                              color: Color(0xff0d73d9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Image(
                                        image: AssetImage(
                                          'assets/images/wallet.png',
                                        ),
                                        height: 100,
                                        width: 100,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Create A New Wallet',
                                            style: GoogleFonts.lato(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white)),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                            'Generate your own unique Tron wallet. Receive a public address (T...) and choose a method for access and recovery. ',
                                            style: GoogleFonts.lato(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white)),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            Text('Get Started',
                                                style: GoogleFonts.lato(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white)),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccessWallet()),
                          );
                        },
                        child: Container(
                          height: 250,
                          width: 480,
                          decoration: BoxDecoration(
                              color: Color(0xff10752d),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Image(
                                        image: AssetImage(
                                          'assets/images/tronwallet.png',
                                        ),
                                        height: 100,
                                        width: 100,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Access Wallet',
                                            style: GoogleFonts.lato(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white)),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                            ' Connect to the blockchain using the wallet of your choice. ',
                                            style: GoogleFonts.lato(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white)),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          children: [
                                            Text('Access Now',
                                                style: GoogleFonts.lato(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white)),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
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
