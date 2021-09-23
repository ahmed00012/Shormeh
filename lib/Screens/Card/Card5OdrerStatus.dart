import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/Card5OrderStatusModel.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:shormeh/Screens/SideBar/MyOdrers.dart';

class OrderStatus extends StatefulWidget {
  String orderID;
  bool backToMyOrders;


  OrderStatus({
    Key key,
    this.orderID,
    this.backToMyOrders,
  }) : super(key: key);
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
 // List<Card5OrderStatusModel> allStatus= new List<Card5OrderStatusModel>();
  List<Card5OrderStatusModel> allStatusHistory= new List<Card5OrderStatusModel>();
  int statusID=0;

  bool isIndicatorActive=true;

  String orderMethod="0";

  String token;
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Order Status ${widget.orderID}");
    getDataFromSharedPrfs();
  }

  Future getDataFromSharedPrfs()async{
    final prefs = await SharedPreferences.getInstance();
    final _cardToken= prefs.getString("cardToken");
    final _token= prefs.getString("token");
    setState((){
      token=_token;
      isIndicatorActive=true;
      allStatusHistory.clear();
    });

    getData();
  }
  getData()async{
    var response =
        await http.get("${HomePage.URL}orders/${widget.orderID}/details",headers: {
          "Authorization": "Bearer $token",
        });

    var dataAllOrderDetails = json.decode(response.body);


    setState(() {
      for(int i=0;i<dataAllOrderDetails['order']['status_histories'].length;i++){

        statusID=dataAllOrderDetails['order']['status_histories'][i]['status_id'];
        orderMethod=dataAllOrderDetails['order']['cart']['order_method'];
        print("KK$orderMethod");
        print("JJ$statusID");
        allStatusHistory.add(
            Card5OrderStatusModel(
                dataAllOrderDetails['order']['status_histories'][i]['status']['id'],
                dataAllOrderDetails['order']['status_histories'][i]['status']['name'],
                dataAllOrderDetails['order']['status_histories'][i]['status']['created_at'],
                dataAllOrderDetails['order']['status_histories'][i]['status']['image'],
            ));

      }
      //فى اللحظة دية كل الصيدليات بكل الاقسام اتحملت
      isIndicatorActive=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate('lan.motabaaHaltEltlb'),),
          centerTitle: true,
          backgroundColor: HexColor('#40976c'),
          elevation: 5.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,),
            onPressed:()=>onBackPressed(context),
          ),
        ),

        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child:isIndicatorActive?Center(child: CircularProgressIndicator(color:  HexColor('#40976c'),),):
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: MediaQuery.of(context).size.width/3,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height/2,
                  child: ListView.builder(
                      shrinkWrap : true,
                      physics: ScrollPhysics(),
                      itemCount: allStatusHistory.length,
                      padding: EdgeInsets.fromLTRB(0.0,MediaQuery.of(context).size.width/50,0.0,MediaQuery.of(context).size.width/50),

                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            //SendPaymentMethode(context,allPaymentMethods[index].code);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/7,
                            alignment: Alignment.center,

                            margin: EdgeInsets.all(
                              MediaQuery.of(context).size.width/20,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Image(
                                    width: MediaQuery.of(context).size.width/7 ,
                                    height: MediaQuery.of(context).size.width / 7,
                                    image: NetworkImage('${allStatusHistory[index].image}'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/20,),
                                Column(
                                  children: [
                                    // Container(
                                    //   child: Image(
                                    //     image: NetworkImage('${allPaymentMethods[index].image}'),
                                    //     fit: BoxFit.fill,
                                    //   ),
                                    // ),

                                    SizedBox(height: MediaQuery.of(context).size.width/20,),
                                    Text("${allStatusHistory[index].name}",style: TextStyle(
                                      color:HomePage.colorGreen
                                    ),),
                                    Text("${allStatusHistory[index].created_at}",style: TextStyle(
                                        color:HomePage.colorGreen
                                    ),)
                                  ],
                                ),
                              ],
                            ),),
                        );
                      }),
                ),
                 Visibility(
                  visible: orderMethod=="1"&&statusID==7,
                   child: Container(
                    height: MediaQuery.of(context).size.width/8,
                    alignment: Alignment.center,

                    child:  ButtonTheme(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      height: MediaQuery.of(context).size.width/8,
                      child: RaisedButton(
                        child: Text(
                            translate('lan.alameelAmamAlfar'),
                            style:TextStyle(fontSize:  MediaQuery.of(context).size.width/25,color: Colors.black)
                        ),
                        color: Colors.white,
                        onPressed: () {
                          //Navigator.pop(context);
                          //EditAyaDialoge(allSurahListD);
                          reachFromBranche();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/20,),

                Container(
                  width: MediaQuery.of(context).size.width,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Container()),
                      Container(
                        height: MediaQuery.of(context).size.width/8,
                        width: MediaQuery.of(context).size.width/2.3,

                        child:  ButtonTheme(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          height: MediaQuery.of(context).size.width/8,
                          child: RaisedButton(
                            child: Text(
                                translate('lan.myOrders'),
                                style:TextStyle(fontSize:  MediaQuery.of(context).size.width/25,color: Colors.white)
                            ),
                            color:Color(0xff40976C),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrders()));


                            },
                          ),
                        ),
                      ),
                      Expanded(child: Container()),

                      Container(
                        height: MediaQuery.of(context).size.width/8,
                        width: MediaQuery.of(context).size.width/2.3,

                        child:  ButtonTheme(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          height: MediaQuery.of(context).size.width/8,
                          child: RaisedButton(
                            child: Text(
                                translate('lan.tahdeeth'),
                                style:TextStyle(fontSize:  MediaQuery.of(context).size.width/25,color: Colors.white)
                            ),
                            color:Color(0xff40976C),
                            onPressed: () {
                              //Navigator.pop(context);
                              //EditAyaDialoge(allSurahListD);
                              getDataFromSharedPrfs();
                            },
                          ),
                        ),
                      ),
                      Expanded(child: Container()),

                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
  void reachFromBranche() async{
    print(" 0000000000000 ${widget.orderID}");
    var response = await http.post("${HomePage.URL}orders/${widget.orderID}/branch",headers: {
      "Authorization": "Bearer $token"
    });
    var dataOrderAfterCoupon = json.decode(response.body);
    if(dataOrderAfterCoupon['success']=="1"){
      displayToastMessage("${dataOrderAfterCoupon['message']}");
    }else{
      displayToastMessage(" ZZZZZZ ${dataOrderAfterCoupon['message']}");
    }

  }
  onBackPressed(BuildContext context) async{

   // if(widget.backToMyOrders==null||widget.backToMyOrders==false){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          HomePage()), (Route<dynamic> route) => false);
    // }else{
    //   Navigator.of(context).pop();
    // }

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



/*
  Text("${allStatus[index].name}",style: TextStyle(
    color:index==0&&statusID>=1?HomePage.colorGreen:index==1&&statusID>=2?HomePage.colorGreen:index==2&&statusID>=5?HomePage.colorGreen:HomePage.colorGrey
  ),),
  Text("${allStatusHistory[index].created_at}",style: TextStyle(
      color:index==0&&statusID>=1?HomePage.colorGreen:index==1&&statusID>=2?HomePage.colorGreen:index==2&&statusID>=5?HomePage.colorGreen:HomePage.colorGrey
  ),)
*
 */
