import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Screens/Card/Cars/CarsList.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:http/http.dart' as http;


class AddCar extends StatefulWidget {
  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  bool circularIndicatorActive=false;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();


  final carModelCtrl = TextEditingController();
  final platCtrl = TextEditingController();
  final colorCtrl = TextEditingController();

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

  }


  onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()=>onBackPressed(context),
        child:Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            elevation: 5.0,
            backgroundColor:HexColor('#40976c'),
            title: Text(
              translate('lan.addCar'),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () => onBackPressed(context),
            ),
          ),
          body: ListView(children: <Widget>[
SizedBox(height: 30,),
            //الاسم
            Container(
              padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
              child: TextFormField(
                controller: carModelCtrl,
                keyboardType: TextInputType.name,
                decoration: new InputDecoration(
                  //icon:Icon(Icons.),
                  enabledBorder: new UnderlineInputBorder(
                      borderSide:
                      new BorderSide(color: HomePage.colorGrey)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HomePage.colorGrey),
                  ),
                  labelStyle: new TextStyle(color: HomePage.colorGrey),
                  hintText: translate('lan.carModel'),
                  labelText: translate('lan.carModel'),

                ),
                cursorColor: HomePage.colorGrey,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width/20),
            //plat
            Container(
              padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
              child: TextFormField(
                controller: platCtrl,
                decoration: new InputDecoration(
                  //icon:Icon(Icons.email),
                  enabledBorder: new UnderlineInputBorder(
                      borderSide:
                      new BorderSide(color: HomePage.colorGrey)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HomePage.colorGrey),
                  ),
                  labelStyle: new TextStyle(color: HomePage.colorGrey),
                  hintText:translate('lan.platNumber'),
                  labelText:translate('lan.platNumber'),

                ),
                cursorColor: HomePage.colorGrey,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width/20),

           //color
            Container(
              padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
              child: TextFormField(
                controller: colorCtrl,
                decoration: new InputDecoration(
                  //icon:Icon(Icons.email),
                  enabledBorder: new UnderlineInputBorder(
                      borderSide:
                      new BorderSide(color: HomePage.colorGrey)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HomePage.colorGrey),
                  ),
                  labelStyle: new TextStyle(color: HomePage.colorGrey),
                  hintText: translate('lan.carColor'),
                  labelText: translate('lan.carColor'),

                ),
                cursorColor: HomePage.colorGrey,
              ),
            ),
            SizedBox(height: 60),


            Container(
              margin: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
              child: ButtonTheme(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                minWidth: 500.0,
                height: MediaQuery.of(context).size.width/8,
                child: RaisedButton(
                  child: Text(
                      translate('lan.submit'),
                      style:TextStyle(fontSize:  MediaQuery.of(context).size.width/20,color: Colors.white)
                  ),
                  color: HomePage.colorGreen,
                  onPressed: () {
                    SendDataToServer(context);
                  },
                ),
              ),
            ),

          ]),
        )
    );
  }

  Future SendDataToServer(BuildContext context) async {


    var response = await http.post("${HomePage.URL}cart/add_car",
        headers:
        {
        "Authorization": "Bearer $token",
        },
    body: {
      "car_model": "${carModelCtrl.text}",
      "plate_number": "${platCtrl.text}",
      "car_color": "${colorCtrl.text}",
      "cart_token": cardToken
    });
    print("${carModelCtrl.text}");
    print("${platCtrl.text}");
    print("${colorCtrl.text}");

    print("$cardToken");


    var datauser = json.decode(response.body);
    print("$datauser");
    if ("${datauser['success']}"=="1"){

      displayToastMessage("تم التسجيل بنجاح");
      print("${datauser['message']}");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => CarsList()),
              (route) => false);

    } else {
      displayToastMessage(datauser['errors'][0]['message'].toString());
    }





  }

  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        textColor: Colors.white,
        fontSize: 16.0
    );
    // _goToHome();
  }
}
