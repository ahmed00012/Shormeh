import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/OrderModel.dart';
import 'package:shormeh/Models/OrderModel2.dart';
import 'package:shormeh/Screens/Card/Card5OdrerStatus.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:http/http.dart' as http;


class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<OrderModel> allOrders = new List<OrderModel>();
  int statusID = 0;

  bool isIndicatorActive = true;
  String lan='';

  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();
  }

  Future getDataFromSharedPrfs() async {
    final prefs = await SharedPreferences.getInstance();
    final _cardToken = prefs.getString("cardToken");
    final _token = prefs.getString("token");
    final _translateLanguage = prefs.getInt('translateLanguage');

    setState(() {
      token = _token;
      _translateLanguage == 0 ?lan = 'en':lan='ar';
    });

    print("$token");
    getMyOrders();
  }

  Future getMyOrders() async {
    var response = await http.get("${HomePage.URL}orders", headers: {
      "Authorization": "Bearer $token",
      "Content-Language": lan
    });
    var data = json.decode(response.body);

    if (data["success"] == "1") {
       // log(data['orders'].toString());
      setState(() {
        for (int i = 0; i < data['orders'].length; i++) {
           log(data['orders'].toString());
           print(data['orders'][0]);

          allOrders.add(new OrderModel(
              id: data['orders'][i]['id'],
              uuid: "${data['orders'][i]['uuid']}",
              status: "${data['orders'][i]['status']}",
              statusId: data['orders'][i]['status_id'],
              sub_total: "${data['orders'][i]['sub_total']}",
              discount: "${data['orders'][i]['cart']['discount']}",
              tax: "${data['orders'][i]['tax']}",
              total: "${data['orders'][i]['total']}",
            items: ( data['orders'][i]['cart']['items'] as List)?.
            map((order) => OrderModel2.fromJson(order)).toList(),
             vendor: "${data['orders'][i]['cart']['vendor']['name']}"
              ));


        }

        isIndicatorActive = false;
      });

    } else {
      print("Error");
    }

  }

  // recreateOrder() async{
  //   var response = await http.post("${HomePage.URL}cart/add_order_method",body: {
  //     "order_method": "$id",
  //     "cart_token": "$cardToken",
  //   });
  //
  //   var dataResponseChooseMethode = json.decode(response.body);
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString("orderMethod",dataResponseChooseMethode['cart']['order_method']);
  //
  //   if(dataResponseChooseMethode['cart']['order_method']=="1"){
  //     chooseBranche(id);
  //
  //   }else if(dataResponseChooseMethode['cart']['order_method']=="2"){
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => CarsList()),
  //     );
  //
  //   }else if(dataResponseChooseMethode['cart']['order_method']=="3"){
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => AdressList()),
  //     );
  //   }
  //
  //
  //   var response2 = await http.post("${HomePage.URL}cart/choose_branch",headers: {
  //     "Authorization": "Bearer $token"
  //   },body: {
  //     "branch_id": "$vendorID",
  //     "cart_token": "$cardToken",
  //   });
  //
  //   var dataResponseChooseMethode = json.decode(response.body);
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => OrderDetails(dataOrderDetails:dataResponseChooseMethode)),
  //   );
  // }



  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    double sHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        elevation: 5.0,
        backgroundColor: HexColor('#40976c'),
        title: Text(
          translate('lan.myOrders'),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => onBackPressed(context),
        ),
      ),
      body: isIndicatorActive
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allOrders.length,
                  itemBuilder: (_, index,) {
                    return Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: Color(0xfff7f7f7),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xfff7f7f7), spreadRadius: 0.0),
                        ],
                      ),
                      child: ExpansionTile(
                        leading: Container(
                            child: CircleAvatar(
                          child: Icon(
                            Icons.done,
                            size: MediaQuery.of(context).size.width / 20,
                            color: Colors.white,
                          ),
                          backgroundColor: Color(0xff748b9d),
                          radius: MediaQuery.of(context).size.width / 30,
                        )),
                        title:Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderStatus(
                                          orderID: "${allOrders[index].id}",
                                          backToMyOrders: true,
                                        )),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${allOrders[index].vendor}',
                                      style: TextStyle(
                                          fontSize: sWidth / 30, color: Color(0xff748b9d)),
                                    ),
                                    Text(
                                      translate('lan.orderNo')+ ' '+ allOrders[index].uuid.toString(),
                                      style: TextStyle(
                                          fontSize: sWidth / 30,
                                          color: HomePage.colorGreen),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            // allOrders[index].statusId==8?
                            InkWell(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: new BorderRadius.all(Radius.circular(10),),

                                ),
                                child: Center(
                                  child: Icon(Icons.replay_circle_filled,color: HexColor('#40976c'),),
                                ),
                              ),
                            ),
                                // : Container(),
                           const SizedBox(width: 7,),
                            // allOrders[index].statusId==8?
                           InkWell(

                             child:  Container(
                               width: 30,
                               height: 30,

                               decoration: BoxDecoration(
                                 color: Colors.black12,
                                 borderRadius: BorderRadius.all(Radius.circular(10),),

                               ),
                               child: Center(
                                 child: Icon(Icons.delete,color: HexColor('#40976c'),),
                               ),
                             ),
                           )
                                // : Container(),
                          ],
                        ),
                        subtitle:Text(
                          '${allOrders[index].status}',
                          style: TextStyle(
                              fontSize: sWidth / 30, color: Color(0xff748b9d)),
                        ),
                        children: [
                          //المنتجات
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: allOrders[index].items.length,
                              itemBuilder: (_, index2) {
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
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: <Widget>[
                                        //image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5.0),
                                          child: Image(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                7,
                                            image: NetworkImage(allOrders[index]
                                                    .items[index2]
                                                    .product_image
                                                // '${allOrdersProducts[index2].product_image
                                                ),
                                            fit: BoxFit.fill,
                                          ),

                                        ),
                                        //Name
                                        Expanded(
                                          child: Container(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      30),
                                              child: Text(
                                                "${allOrders[index].items[index2].product_name}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                  "${allOrders[index].items[index2].productTotal}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              30),
                                                ),
                                                Text(
                                                  translate('lan.rs'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              30),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  translate(
                                                      'lan.count')+ ' : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              30),
                                                ),
                                                Text(
                                                  "${allOrders[index].items[index2].productCount}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              30),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          //Total
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text(
                                  translate('lan.total'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  "${allOrders[index].total}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                                Text(
                                  translate('lan.rs'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                              ],
                            ),
                          ),

                          //tax القيمة المضافة
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text(
                                  translate('lan.tax'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  "${allOrders[index].tax}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                                Text(
                                  translate('lan.rs'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                              ],
                            ),
                          ),

                          //discount كوبون الخصم
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text(
                                  translate('lan.discound'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  "${allOrders[index].discount}"=='null'?'0':"${allOrders[index].discount}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                                Text(
                                  translate('lan.rs'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
    );
  }

  onBackPressed(BuildContext context) async {
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //     HomePage(index:0)), (Route<dynamic> route) => false);
  }
}
