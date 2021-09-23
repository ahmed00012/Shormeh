import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shormeh/Models/CardModel1.dart';
import 'package:shormeh/Models/OrderHome.dart';
import 'package:shormeh/Screens/Card/Card3OrderDetails.dart';
import 'package:shormeh/Screens/Card/OrderHome/AddAddress.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';


class AdressList extends StatefulWidget {
  @override
  _AdressListState createState() => _AdressListState();
}

class _AdressListState extends State<AdressList> {

  bool isIndicatorActive=true;

  List<OrderToHomeModel> allOrderToHome= new List<OrderToHomeModel>();
  List<Card1Model> allMyCardProducts= new List<Card1Model>();


  String cardToken="";
  String token="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();
  }
  Future getDataFromSharedPrfs()async{
    final prefs = await SharedPreferences.getInstance();
    final _cardToken= prefs.getString("cardToken");
    final _token= prefs.getString("token");
    setState((){
      cardToken=_cardToken;
      token=_token;
    });

    print("Cars List");
    print("$cardToken");
    getMyAdress();

  }


  Future getMyAdress() async {
   try{
     var response = await http.get("${HomePage.URL}customer/addresses",headers: {
       "Authorization": "Bearer $token",
     });
     var dataMyadress = json.decode(response.body);

     setState(() {
       for(int i=0;i<dataMyadress.length;i++){
         allOrderToHome.add(new OrderToHomeModel(
           dataMyadress[i]['id'],
           "${dataMyadress[i]['district']}",
           "${dataMyadress[i]['address']}",
         ));
       }

       //فى اللحظة دية كل الصيدليات بكل الاقسام اتحملت
       isIndicatorActive=false;
     });
   }catch(e){
     print("WWWWW $e");
   }

  }

  onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  new AppBar(
        centerTitle: true,
        backgroundColor:  HexColor('#40976c'),
        elevation: 5.0,
        title: Container(
          child: Text(translate('lan.enwany'),style: TextStyle(fontSize: MediaQuery.of(context).size.width/25),),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,size: MediaQuery.of(context).size.width/15,),
          onPressed:(){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (c) => HomePage(isHomeScreen: true,)),
            );
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child:isIndicatorActive?Center(child: CircularProgressIndicator(),):
        Column(
          children: [
            Expanded(
              flex: 9,
              child: ListView.builder(
                  shrinkWrap : true,
                  physics: ScrollPhysics(),
                  itemCount: allOrderToHome.length,
                  padding: EdgeInsets.fromLTRB(0.0,MediaQuery.of(context).size.width/50,0.0,MediaQuery.of(context).size.width/50),

                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        setCatAndGetMyCardProducts(allOrderToHome[index].id);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width/50,
                            MediaQuery.of(context).size.width/100,
                            MediaQuery.of(context).size.width/50,
                            MediaQuery.of(context).size.width/100),
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width/50,
                            MediaQuery.of(context).size.width/100,
                            MediaQuery.of(context).size.width/50,
                            MediaQuery.of(context).size.width/100
                        ),
                        child: IntrinsicHeight(
                          child: Row(children: <Widget>[
                            //Checkbox
                            //Name
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width/30),
                                  child: Text("${allOrderToHome[index].address}",
                                    style:TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width/25),)),
                            ),

                            InkWell(
                              onTap:(){
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => OrderDetails(allOrderToHome:allOrderToHome)),
                                // );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width/7,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: HomePage.colorGrey,

                                ),
                                child: Icon(Icons.edit,color: Colors.white,),
                              ),
                            ),

                          ],),
                        ),),
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child : Container(
                width: 250,
                margin: EdgeInsets.all(MediaQuery.of(context).size.width/30),
                child:  ButtonTheme(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  height: MediaQuery.of(context).size.width/8,
                  child: RaisedButton(
                    child: Text(
                       translate('lan.adfEnwanAkhr'),
                        style:TextStyle(fontSize:  MediaQuery.of(context).size.width/25,color: Colors.white)
                    ),
                    color: HomePage.colorGreen,
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddAddress()),
                      );

                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
  Future setCatAndGetMyCardProducts(int idAddress) async  {


    print("$idAddress");
    print("$cardToken");
    var response = await http.post("${HomePage.URL}cart/choose_address",
        headers: {
          'Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xMjcuMC4wLjE6ODAwMFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTYyNTExOTI1MSwiZXhwIjo1MjU2NjU1MjUxLCJuYmYiOjE2MjUxMTkyNTEsImp0aSI6InJsM3o3MnczTmdNS0pLbXEiLCJzdWIiOjEsInBydiI6ImE1YmI5ODE5OGJiNDNkYTZiNDU3NDljMDQ3NTljODFjMTIyNDMzYzEifQ.2aQaThLvKuK3K0lcgvmb_qef1JsagE9Rl52zuuW9NS0',
        },body: {
          'address_id':'$idAddress',
          'cart_token': "$cardToken",
        });

    var dataOrderDetails = json.decode(response.body);

    print("${dataOrderDetails}");
    print("${dataOrderDetails['cart']['items'].length}");
    if(dataOrderDetails['success']=="1"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderDetails(dataOrderDetails:dataOrderDetails)),
      );
    }else{
      displayToastMessage("${dataOrderDetails['message']}");
    }

  }
  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
