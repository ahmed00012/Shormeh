import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/Car.dart';
import 'package:http/http.dart' as http;
import 'package:shormeh/Models/CardModel1.dart';
import 'package:shormeh/Screens/Card/Cars/AddCar.dart';
import 'package:shormeh/Screens/Card/Card3OrderDetails.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';

import '../Card2MyAllProductsDetails.dart';

class CarsList extends StatefulWidget {
  @override
  _CarsListState createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {

  bool isIndicatorActive=true;

  List<CarModel> allCarsModel= new List<CarModel>();
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
    getMyCars();

  }
  Future getMyCars() async {
   try{
     var response = await http.get("${HomePage.URL}customer/cars",headers: {

       "Authorization": "Bearer $token",
     });
     var dataMyCars = json.decode(response.body);

     setState(() {
       print("ZZZZZZ${dataMyCars}");
       for(int i=0;i<dataMyCars.length;i++){
         allCarsModel.add(new CarModel(
           dataMyCars[i]['id'],
           "${dataMyCars[i]['car_model']}",
           "${dataMyCars[i]['plate_number']}",
           "${dataMyCars[i]['car_color']}",
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
        appBar: new AppBar(
          centerTitle: true,
          elevation: 5.0,
          backgroundColor: HexColor('#40976c'),
          title: Text(
            translate('lan.myCars'),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () => onBackPressed(context),
          ),
        ),
      body: isIndicatorActive?Center(child: CircularProgressIndicator(),):
      WillPopScope(
        onWillPop: (){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => Card2()),
                  (route) => false);
        },
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: ListView.builder(
                  shrinkWrap : true,
                  physics: ScrollPhysics(),
                  itemCount: allCarsModel.length,
                  padding: EdgeInsets.fromLTRB(0.0,MediaQuery.of(context).size.width/50,0.0,MediaQuery.of(context).size.width/50),

                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        setCatAndGetMyCardProducts(allCarsModel[index].id);
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
                                  child: Text("${allCarsModel[index].plate_number}",
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
                height: MediaQuery.of(context).size.width/8,
                width: MediaQuery.of(context).size.width/2.3,

                margin: EdgeInsets.all(MediaQuery.of(context).size.width/30),
                child:  ButtonTheme(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  height: MediaQuery.of(context).size.width/8,
                  child: RaisedButton(
                    child: Text(
                        translate('lan.adfCar'),
                        style:TextStyle(fontSize:  MediaQuery.of(context).size.width/25,color: Colors.white)
                    ),
                    color: HomePage.colorGreen,
                    onPressed: () {
                      //Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCar()),
                      );

                    },
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );

  }

  Future setCatAndGetMyCardProducts(int idCar) async  {

    print("$idCar");
    print("$cardToken");
    var response = await http.post("${HomePage.URL}cart/choose_car",
    headers: {
      'Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xMjcuMC4wLjE6ODAwMFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTYyNTExOTI1MSwiZXhwIjo1MjU2NjU1MjUxLCJuYmYiOjE2MjUxMTkyNTEsImp0aSI6InJsM3o3MnczTmdNS0pLbXEiLCJzdWIiOjEsInBydiI6ImE1YmI5ODE5OGJiNDNkYTZiNDU3NDljMDQ3NTljODFjMTIyNDMzYzEifQ.2aQaThLvKuK3K0lcgvmb_qef1JsagE9Rl52zuuW9NS0',
    },body: {
      'car_id':'$idCar',
      'cart_token': "$cardToken",
    });

    var dataOrderDetails = json.decode(response.body);

    print("${dataOrderDetails}");
    print("${dataOrderDetails['cart']['items'].length}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetails(dataOrderDetails:dataOrderDetails)),
    );
  }
}
