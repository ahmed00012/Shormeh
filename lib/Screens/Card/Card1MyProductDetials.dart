import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/CardModel1.dart';
import 'package:http/http.dart' as http;
import 'package:shormeh/Screens/Card/Card2MyAllProductsDetails.dart';
import 'package:shormeh/Screens/Cats/3ProductDetails.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:shormeh/Screens/SelectBrabche.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Card1 extends StatefulWidget {
  bool fromHome;
  Card1({this.fromHome});

  @override
  _Card1State createState() => _Card1State();
}

class _Card1State extends State<Card1> {
  bool isIndicatorActive = true;
  List<Card1Model> allMyCardProducts = new List<Card1Model>();

  String cardToken = "";
  String lan = '';
  int translationLanguage = 0;
  int cardItems = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();
  }

  Future getDataFromSharedPrfs() async {
    final prefs = await SharedPreferences.getInstance();
    final _cardToken = prefs.getString("cardToken");
    final _translateLanguage = prefs.getInt('translateLanguage');
    final _cardItems = prefs.getInt('cardItems');

    if (_cardToken != null) {
      setState(() {
        cardToken = _cardToken;
      });
    }

    if (_cardItems != null) {
      setState(() {
        cardItems = _cardItems;
      });
    }

    getMyCardProducts();

    setState(() {
      translationLanguage = _translateLanguage;
    });
  }

  Future getMyCardProducts() async {
    allMyCardProducts.clear();
    final prefs = await SharedPreferences.getInstance();
    var response = await http.get("${HomePage.URL}cart/get_cart/$cardToken");

    var dataMyCardProducts = json.decode(response.body).cast<String, dynamic>();

    print(dataMyCardProducts);

    setState(() {
      if (dataMyCardProducts['items'] != null) {

        isIndicatorActive = false;
        for (int i = 0; i < dataMyCardProducts['items'].length; i++) {
          allMyCardProducts.add(new Card1Model(
              dataMyCardProducts['id'],
              dataMyCardProducts['sub_total'],
              "${dataMyCardProducts['tax']}",
              "${dataMyCardProducts['total']}",
              "${dataMyCardProducts['delivery_fee']}",
              "${dataMyCardProducts['points_to_cash']}",
              "${dataMyCardProducts['discount']}",
              dataMyCardProducts['items'][i]['product_id'],
              dataMyCardProducts['items'][i]['product_name'],
              dataMyCardProducts['items'][i]['product_image'],
              dataMyCardProducts['items'][i]['total'].toString(),
              dataMyCardProducts['items'][i]['count'],
              false));
        }
      }
      prefs.setInt('cardItems', allMyCardProducts.length);
      cardItems = allMyCardProducts.length;
      isIndicatorActive = false;
    });
  }

  void removeProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isIndicatorActive = true;
    });


    var respons = await http.post("${HomePage.URL}cart/remove_product", body: {
      "product_id": "$id",
      "cart_token": "$cardToken",
    });
    var data = json.decode(respons.body);
    print(data);
    if (data['success'] == "1") {
      displayToastMessage("${data['message']}");
      getMyCardProducts();
      setState(() {
        isIndicatorActive = false;
        cardItems--;
        prefs.setInt('cardItems', cardItems);
      });
      if (cardItems == 0) {
        setState(() {
          prefs.setString('cardToken', '');
        });
      }
    } else {
      displayToastMessage("${data['message']}");
      setState(() {
        isIndicatorActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:   lan == 'ar'?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            translate('lan.saltElshraa'),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal'),
          ),
          backgroundColor: HexColor('#40976c'),
          elevation: 5.0,
          leading: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(isHomeScreen: true,)));
            },
            child: Icon(Icons.arrow_back_ios,color: Colors.white,),
          ),
        ),
        body: isIndicatorActive
            ? Container(
          color: Colors.white,
          child: Center(
              child:Container(
                height: 80,
                width: 80,
                child: Lottie.asset('assets/images/lf20_8tcvbixe.json'),
              )
          ),
        )
            : cardItems == 0
                ? Center(
                    child: Text(
                      translate('lan.saltElshraaFargaa'),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 25,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: allMyCardProducts.length,
                            padding: EdgeInsets.fromLTRB(
                                0.0,
                                MediaQuery.of(context).size.width / 50,
                                0.0,
                                MediaQuery.of(context).size.width / 50),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  height: 70,
                                  margin: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width / 50,
                                      MediaQuery.of(context).size.width / 100,
                                      MediaQuery.of(context).size.width / 50,
                                      MediaQuery.of(context).size.width / 100),
                                  padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width / 50,
                                      MediaQuery.of(context).size.width / 100,
                                      MediaQuery.of(context).size.width / 50,
                                      MediaQuery.of(context).size.width / 100),
                                  child: Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    child: new Container(
                                      color: HexColor('#F2F2F2'),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  ' ${allMyCardProducts[index].productImage}'
                                                      .replaceAll(' ', ''),
                                                ),
                                                radius: 25,
                                                backgroundColor: Colors.black12,
                                              ),
                                              title: new Text(
                                                "${allMyCardProducts[index].productName}",
                                                style: TextStyle(
                                                    fontFamily: 'Tajawal'),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${allMyCardProducts[index].productPrice} ' +
                                                      translate('lan.rs'),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Tajawal'),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    '${allMyCardProducts[index].count} ' +
                                                        ' : ' +
                                                        translate('lan.pieces'),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'Tajawal',
                                                        color: HexColor(
                                                            '#40976C')))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    secondaryActions: <Widget>[
                                      new IconSlideAction(
                                        color: HexColor('#FCC747'),
                                        iconWidget: SvgPicture.asset(
                                          'assets/images/edit.svg',
                                          height: 30,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          print(allMyCardProducts[index].id);
                                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                                           productID:allMyCardProducts[index].productId,
                                           productTotal: allMyCardProducts[index].productPrice,
                                         )));
                                        },
                                      ),
                                      new IconSlideAction(
                                        color: Colors.red[800],
                                        iconWidget: Image.asset(
                                            'assets/images/delete.png',
                                            height: 30,
                                            color: Colors.white),
                                        onTap: () {
                                          removeProduct(allMyCardProducts[index]
                                              .productId);
                                        },
                                      ),
                                    ],
                                  ));
                            }),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(child: Container()),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: ButtonTheme(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  height: MediaQuery.of(context).size.width / 8,
                                  child: RaisedButton(
                                    child: Text(translate('lan.sendOrder'),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.white,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.bold)),
                                    color: HomePage.colorGreen,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Card2()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: ButtonTheme(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  height: MediaQuery.of(context).size.width / 8,
                                  child: RaisedButton(
                                    child: Text(translate('lan.addMore'),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: Colors.black,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.bold)),
                                    color: Colors.white,
                                    onPressed: () {
                                      //Navigator.pop(context);
                                      //EditAyaDialoge(allSurahListD);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                      ),
                      widget.fromHome != null
                          ? const SizedBox(
                              height: 75,
                            )
                          : const SizedBox(
                              height: 30,
                            ),
                    ],
                  ),
      ),
    );
  }

  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
