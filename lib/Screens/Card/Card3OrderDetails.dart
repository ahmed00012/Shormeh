import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/CardModel1.dart';
import 'package:http/http.dart' as http;
import 'package:shormeh/Models/PaymentMethodsModel.dart';
import 'package:shormeh/Screens/Card/Card4PaymentMethods.dart';
import 'package:shormeh/Screens/Card/Card5OdrerStatus.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';

class OrderDetails extends StatefulWidget {
  var dataOrderDetails;

  OrderDetails({
    Key key,
    this.dataOrderDetails,
  }) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final couponCtrl = TextEditingController();
  List<PaymentMethodsModel> allPaymentMethods = new List<PaymentMethodsModel>();

  List<Card1Model> allMyCardProducts = new List<Card1Model>();
  bool isIndicatorActive = true;

  String id = '';
  String cardToken = "";
  String token = "";
  int method ;
  String code = 'cash';
  String lan = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();
    getPaymentMethods();
  }

  Future getDataFromSharedPrfs() async {
    final prefs = await SharedPreferences.getInstance();
    final _cardToken = prefs.getString("cardToken");
    final _token = prefs.getString("token");
    final _translateLanguage = prefs.getInt('translateLanguage');
    setState(() {
      _translateLanguage == 0 ? lan = 'en' : lan = 'ar';
      cardToken = _cardToken;
      token = _token;
    });
    getData();
  }

  getData() {
    setState(() {
      print(widget.dataOrderDetails['cart']['items'][0]);
      for (int i = 0;
          i < widget.dataOrderDetails['cart']['items'].length;
          i++) {
        allMyCardProducts.add(new Card1Model(
            widget.dataOrderDetails['cart']['id'],
            widget.dataOrderDetails['cart']['sub_total'],
            "${widget.dataOrderDetails['cart']['tax']}",
            "${widget.dataOrderDetails['cart']['total']}",
            "${widget.dataOrderDetails['cart']['delivery_fee']}",
            "${widget.dataOrderDetails['cart']['points_to_cash']}",
            "${widget.dataOrderDetails['cart']['discount']}",
            widget.dataOrderDetails['cart']['items'][i]['product_id'],
            widget.dataOrderDetails['cart']['items'][i]['product_name'],
            widget.dataOrderDetails['cart']['items'][i]['product_image'],
            widget.dataOrderDetails['cart']['items'][i]['total'].toString(),
            widget.dataOrderDetails['cart']['items'][i]['count'],
            false));
      }
      isIndicatorActive = false;
    });
  }

  Future getPaymentMethods() async {
    try {
      var response =
          await http.get("${HomePage.URL}cart/payment_method", headers: {
        "Authorization": "Bearer $token",

      });
      var dataMyPaymentMethods = json.decode(response.body);

      setState(() {
        print("Payment Methods${dataMyPaymentMethods}");
        for (int i = 0; i < dataMyPaymentMethods.length; i++) {
          allPaymentMethods.add(new PaymentMethodsModel(
            dataMyPaymentMethods[i]['id'],
            "${dataMyPaymentMethods[i]['title_en']}",
            "${dataMyPaymentMethods[i]['title_ar']}",
            "${dataMyPaymentMethods[i]['image']}",
            "${dataMyPaymentMethods[i]['code']}",
          ));
        }
print(dataMyPaymentMethods[0]['image']);
        //فى اللحظة دية كل الصيدليات بكل الاقسام اتحملت
        isIndicatorActive = false;
      });
    } catch (e) {
      print("WWWWW $e");
    }
  }

  Future SendPaymentMethode(BuildContext context, String code) async {
    var response = await http.post("${HomePage.URL}cart/add_payment", headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "cart_token": cardToken,
      "payment_type": "$code",
    });
    var dataOrder = json.decode(response.body);

    print("$dataOrder");

    // if("${dataOrder['success']}"=="1"){
    //   confirm();
    // }
  }

  void confirm() async {
    var response = await http.post("${HomePage.URL}cart/confirm", headers: {
      "Authorization": "Bearer $token"
    }, body: {
      'cart_token': cardToken,
    });
    print(cardToken);
    var dataOrderAfterCoupon = json.decode(response.body);
    print(dataOrderAfterCoupon);
    setPrfs("${dataOrderAfterCoupon['order']['id']}");
  }

  setPrfs(String id0) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("cardToken", "");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderStatus(orderID: id0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:   lan == 'ar'?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            translate('lan.tanfeezAltalb'),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: HexColor('#40976c'),
          elevation: 5.0,
        ),
        body: isIndicatorActive
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
              shrinkWrap: true,
              children: [
                ListView.builder(
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
                        decoration: new BoxDecoration(
                          color: Color(0xfff7f7f7),
                          borderRadius: new BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(
                                '${allMyCardProducts[index].productImage}',
                                width: MediaQuery.of(context).size.width / 7,
                                height: MediaQuery.of(context).size.width / 7,
                                fit: BoxFit.fill,
                              ),
                            ),
                            //Name
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width / 30),
                                  child: Text(
                                    "${allMyCardProducts[index].productName}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context)
                                            .size
                                            .width /
                                            25),
                                  )),
                            ),

                            //Price & Count
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${allMyCardProducts[index].productPrice}" +
                                          ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                              .size
                                              .width /
                                              30),
                                    ),
                                    Text(
                                      translate('lan.rs'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                              .size
                                              .width /
                                              30),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      translate('lan.count') + ' : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                              .size
                                              .width /
                                              30),
                                    ),
                                    Text(
                                      "${allMyCardProducts[index].count}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                              .size
                                              .width /
                                              30),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                const SizedBox(
                  height: 50,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: allPaymentMethods.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            method = allPaymentMethods[index].id;
                          });
                          SendPaymentMethode(
                              context, allPaymentMethods[index].code);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            height: 65,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, color: HexColor('#40976c')),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      5.0) //                 <--- border radius here
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Radio<int>(
                                  value: allPaymentMethods[index].id,
                                  groupValue: method,
                                  onChanged: (value) {
                                    setState(() {
                                      method = value;
                                      code = allPaymentMethods[index].code;
                                    });
                                  },
                                ),
                                Image.network(
                                  allPaymentMethods[index].image,
                                  height: 60,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(lan == 'ar'?allPaymentMethods[index].title_ar:allPaymentMethods[index].title_en,
                                  style: TextStyle(fontSize: 18),)
                              ],
                            ),
                          ),
                        ),

                        // Container(
                        //   width: MediaQuery.of(context).size.width/7,
                        //   alignment: Alignment.center,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(Radius.circular(15)),
                        //     color: HomePage.colorGrey,
                        //
                        //   ),
                        //   margin: EdgeInsets.all(
                        //     MediaQuery.of(context).size.width/20,),
                        //   child: Column(
                        //     children: [
                        //       Container(
                        //         child: Image(
                        //           image: NetworkImage('${allPaymentMethods[index].image}'),
                        //           fit: BoxFit.fill,
                        //         ),
                        //       ),
                        //       SizedBox(height: MediaQuery.of(context).size.width/20,),
                        //       Text("${allPaymentMethods[index].title_en}")
                        //     ],
                        //   ),),
                      );
                    }),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      //Total
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                translate('lan.total'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    MediaQuery.of(context).size.width /
                                        30),
                              ),
                            ),
                            Text(
                              "${allMyCardProducts[0].total}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                            Text(
                              translate('lan.rs'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                          ],
                        ),
                      ),

                      //Delivery Fees قيمة التوصيل
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 2),
                        child: Row(
                          children: [
                            Text(
                              translate('lan.deliveryFee'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              "${allMyCardProducts[0].delivery_fee}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                            Text(
                              translate('lan.rs'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                          ],
                        ),
                      ),
                      //tax القيمة المضافة
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 2),
                        child: Row(
                          children: [
                            Text(
                              translate('lan.tax'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              "${allMyCardProducts[0].tax}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                            Text(
                              translate('lan.rs'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                          ],
                        ),
                      ),
                      //discount كوبون الخصم
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: [
                            Text(
                              translate('discound'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              allMyCardProducts[0].discount != 'null'
                                  ? "${allMyCardProducts[0].discount}"
                                  : '0',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                            Text(
                              translate('lan.rs'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                          ],
                        ),
                      ),
                      //Coupon
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Send Coupon Button
                            Expanded(
                              child: Text(
                                translate('lan.saveOn'),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: ButtonTheme(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(10.0)),
                                child: RaisedButton(
                                  child: Text(translate('lan.senCoupoun'),
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .size
                                              .width /
                                              25,
                                          color: Colors.white)),
                                  color: HomePage.colorGreen,
                                  onPressed: () =>
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return Directionality(
                                              textDirection:   lan == 'ar'?TextDirection.rtl:TextDirection.ltr,
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: MediaQuery.of(context).viewInsets.bottom),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                              25),
                                                      topRight: Radius.circular(
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                              25),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      //ايقونة النزول
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(10.0),
                                                        child: Align(
                                                          alignment:lan == 'ar'?Alignment.topLeft: Alignment
                                                              .topRight,
                                                          child: CircleAvatar(
                                                            child:
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .expand_more,
                                                                size: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .width /
                                                                    10,
                                                                color: HomePage
                                                                    .colorGreen,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                            Colors
                                                                .transparent,
                                                            radius: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width /
                                                                25,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 10.0,
                                                            right: 10),
                                                        child: Text(
                                                          translate(
                                                              'lan.useCo'),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        width:
                                                        double.infinity,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(10.0),
                                                          child:
                                                          TextFormField(
                                                            controller:
                                                            couponCtrl,
                                                            decoration:
                                                            new InputDecoration(
                                                              contentPadding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                  15,
                                                                  bottom:
                                                                  11,
                                                                  top: 11,
                                                                  right:
                                                                  15),
                                                              hintText: translate(
                                                                  'lan.enterCo'),
                                                              enabledBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                    color:
                                                                    HexColor('#40976c')),
                                                                //  when the TextFormField in unfocused
                                                              ),
                                                              focusedBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                    color:
                                                                    HexColor('#40976c')),
                                                                //  when the TextFormField in focused
                                                              ),

                                                            ),
                                                            cursorColor: HexColor('#40976c'),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        width:
                                                        double.infinity,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(30, 5,
                                                              30, 5),
                                                          child: Container(
                                                            height: 50,
                                                            decoration:
                                                            BoxDecoration(
                                                              color: HexColor(
                                                                  '#40976c'),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                  .circular(
                                                                  15)),
                                                            ),
                                                            child:
                                                            GestureDetector(
                                                              child: Center(
                                                                child: Text(
                                                                  translate('lan.senCoupoun'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          }),
                                ),
                              ),
                            ),
                            //Send Coupon TextField
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: new EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 15,
                            right: MediaQuery.of(context).size.width / 15),
                        child: ButtonTheme(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: RaisedButton(
                            child: Text(translate('lan.sendOrder'),
                                style: TextStyle(
                                    fontSize:
                                    MediaQuery.of(context).size.width /
                                        25,
                                    color: Colors.white)),
                            color: HomePage.colorGreen,
                            onPressed: () {
                              confirm();
                              // SendPaymentMethode(context,code);
                              //Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
      ),
    );
  }

  Future sendCouponDiscound() async {
    if (couponCtrl.text.isEmpty) {
      displayToastMessage("Add Coupon Please");
      return;
    }
    print("TOKEN $token");
    var response = await http.post("${HomePage.URL}cart/add_coupon", headers: {
      "Authorization": "Bearer $token"
    }, body: {
      'code': '${couponCtrl.text}',
      'cart_token': '$cardToken',
    });
    var dataOrderAfterCoupon = json.decode(response.body);
    print(dataOrderAfterCoupon['cart']['items'][0]);
    if (dataOrderAfterCoupon['success'] == "1") {
      setState(() {
        isIndicatorActive = true;
        allMyCardProducts.clear();
        for (int i = 0; i < dataOrderAfterCoupon['cart']['items'].length; i++) {
          allMyCardProducts.add(new Card1Model(
              dataOrderAfterCoupon['cart']['id'],
              dataOrderAfterCoupon['cart']['sub_total'],
              "${dataOrderAfterCoupon['cart']['tax']}",
              "${dataOrderAfterCoupon['cart']['total']}",
              "${dataOrderAfterCoupon['cart']['delivery_fee']}",
              "${dataOrderAfterCoupon['cart']['points_to_cash']}",
              "${dataOrderAfterCoupon['cart']['discount']}",
              dataOrderAfterCoupon['cart']['items'][i]['product_id'],
              dataOrderAfterCoupon['cart']['items'][i]['product_name'],
              dataOrderAfterCoupon['cart']['items'][i]['product_image'],
              dataOrderAfterCoupon['cart']['items'][i]['price'],
              dataOrderAfterCoupon['cart']['items'][i]['count'],
              false));
        }
        isIndicatorActive = false;
      });
    } else {
      displayToastMessage("${dataOrderAfterCoupon['message']}");
    }
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
