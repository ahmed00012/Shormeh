import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/CardModel2.dart';
import 'package:shormeh/Screens/Card/Card3OrderDetails.dart';
import 'package:shormeh/Screens/Card/Cars/CarsList.dart';
import 'package:shormeh/Screens/Card/OrderHome/AdressList.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:http/http.dart' as http;

import 'Card1MyProductDetials.dart';

class Card2 extends StatefulWidget {
  @override
  _Card2State createState() => _Card2State();
}

class _Card2State extends State<Card2> with TickerProviderStateMixin {
  bool isIndicatorActive = true;

  List<Card2Model> allOrderMethods = new List<Card2Model>();

  String cardToken = "";
  String token = "";
  List<String> images = [
    'assets/lottieBoy.json',
    'assets/lottieBranche.json',
    'assets/lottieHome.json',
    'assets/lottieRate.json'
  ];

  int translationLanguage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();
    print("Card 2");
  }

  int vendorID;
  Future getDataFromSharedPrfs() async {
    final prefs = await SharedPreferences.getInstance();
    final _translateLanguage = prefs.getInt('translateLanguage');
    final _cardToken = prefs.getString("cardToken");
    final _token = prefs.getString("token");
    final _vendorID = prefs.getInt("vendorID");
    setState(() {
      cardToken = _cardToken;
      token = _token;
      vendorID = _vendorID;
      translationLanguage = _translateLanguage;
    });
    getMyCardOrderMethods();
  }

  Future getMyCardOrderMethods() async {
    var response =
        await http.get("${HomePage.URL}vendors/$vendorID/ordermethods");

    var dataMyCardProducts = json.decode(response.body);

    setState(() {
      print("${dataMyCardProducts.length}");
      for (int i = 0; i < dataMyCardProducts.length; i++) {
        allOrderMethods.add(new Card2Model(
          dataMyCardProducts[i]['id'],
          "${dataMyCardProducts[i]['title_ar']}",
          "${dataMyCardProducts[i]['title_en']}",
          "${dataMyCardProducts[i]['image']}",
        ));
      }

      isIndicatorActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          translationLanguage == 1 ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            translate('lan.trkEltawseel'),
            style: TextStyle(fontSize: MediaQuery.of(context).size.width / 25),
          ),
          centerTitle: true,
          backgroundColor: HexColor('#40976c'),
          elevation: 5.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: MediaQuery.of(context).size.width / 15,
            ),
            onPressed: () => onBackPressed(context),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isIndicatorActive
              ? Center(
                  child: CircularProgressIndicator(
                    color: HexColor('#40976c'),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Lottie.asset(
                          'assets/images/69733-food-beverage.json',
                          fit: BoxFit.fill),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: allOrderMethods.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: GestureDetector(
                                onTap: () {
                                  sendMethodeOrderDeliver(
                                      allOrderMethods[index].id);
                                },
                                child: Container(
                                  height: 80,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: Color(0xfff7f7f7),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 10,),
                                      //image
                                      Lottie.asset(images[index],
                                          fit: BoxFit.fill),


                                      //Name
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            translationLanguage == 0
                                                ? "${allOrderMethods[index].title_en}"
                                                : "${allOrderMethods[index].title_ar}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    25),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Future sendMethodeOrderDeliver(int id) async {
    var response =
        await http.post("${HomePage.URL}cart/add_order_method", body: {
      "order_method": "$id",
      "cart_token": "$cardToken",
    });

    var dataResponseChooseMethode = json.decode(response.body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "orderMethod", dataResponseChooseMethode['cart']['order_method']);

    if (dataResponseChooseMethode['cart']['order_method'] == "1") {
      chooseBranche(id);
    } else if (dataResponseChooseMethode['cart']['order_method'] == "2") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarsList()),
      );
    } else if (dataResponseChooseMethode['cart']['order_method'] == "3") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdressList()),
      );
    }
  }

  Future chooseBranche(int id) async {
    setState(() {
      isIndicatorActive = true;
    });
    var response =
        await http.post("${HomePage.URL}cart/choose_branch", headers: {
      "Authorization": "Bearer $token"
    }, body: {
      "branch_id": "$vendorID",
      "cart_token": "$cardToken",
    });

    var dataResponseChooseMethode = json.decode(response.body);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OrderDetails(dataOrderDetails: dataResponseChooseMethode)),
    );

    isIndicatorActive = false;
  }

  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  onBackPressed(BuildContext context) async {
    Navigator.pop(context);
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //     HomePage(index:0)), (Route<dynamic> route) => false);
  }
}
