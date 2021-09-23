import 'dart:convert';

import 'package:android_intent/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Screens/Card/OrderHome/AdressList.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:http/http.dart' as http;


class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  bool circularIndicatorActive=false;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();


  final distictCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  bool isIndicatorActive=true;
  Position currentLocation;

  String cardToken="";
  String token="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();

  }

  getLocationStatus()async{

    var geoLocator = Geolocator();
    var status = await Geolocator.isLocationServiceEnabled();
    if(status){
      setState(() {
        // هفعل السيركل عشان الفيو وهى هتطفى تانى من تحت وهقول ان فى صيدليات بعد ماكان الموقع مش متفعل
        getUserLocation();
      });
    }else{
      setState(() {
        _showDialog(context);
      });
    }
  }
  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("الموقع",style: TextStyle(color: HomePage.colorGreen),),
          content: new Text("لكى تتمكن من مشاهدة المطاعم بالقرب منك الرجاء تفعيل الموقع"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("تفعيل",style: TextStyle(color: HomePage.colorGreen),),
                onPressed: () {
                  Navigator.of(context).pop();
                  setActiveLocation();
                  setState(() {
                    circularIndicatorActive=false;
                  });
                }
            ),
            new FlatButton(
              child: new Text("الغاء",style: TextStyle(color: HomePage.colorGreen),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
  setActiveLocation()async{
    var platform = Theme.of(context).platform;

    if(platform == TargetPlatform.iOS){
      AppSettings.openAppSettings();
    }else{
      final AndroidIntent intent = new AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch();
    }
  }

  getUserLocation() async {
    currentLocation = await locateUser();
  }

  Future<Position> locateUser() async {
    return Geolocator
        .getCurrentPosition();
  }


  Future getDataFromSharedPrfs()async{
    final prefs = await SharedPreferences.getInstance();
    final _cardToken= prefs.getString("cardToken");
    final _token= prefs.getString("token");
    setState((){
      cardToken=_cardToken;
      token=_token;
    });
    getLocationStatus();
  }


  onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()=>onBackPressed(context),
        child:Scaffold(
          appBar:  new AppBar(
            centerTitle: true,
            backgroundColor: HexColor('#40976c'),
            elevation: 0,
            title: Text(translate('lan.addAdress')),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,),
              onPressed:(){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => HomePage(isHomeScreen: true,)),
                );
              },
            ),
          ),
          body: new Container(

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(

                    children: <Widget>[

                  //الاسم
                  Container(
                    padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
                    child: TextFormField(
                      controller: distictCtrl,
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
                        hintText:translate('lan.addAdress'),
                        labelText:translate('lan.addAdress'),

                      ),
                      cursorColor: HomePage.colorGrey,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width/20),
                  //plat
                  Container(
                    padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
                    child: TextFormField(
                      controller: noteCtrl,
                      decoration: new InputDecoration(
                        //icon:Icon(Icons.email),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide:
                            new BorderSide(color: HomePage.colorGrey)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HomePage.colorGrey),
                        ),
                        labelStyle: new TextStyle(color: HomePage.colorGrey),
                        hintText: translate('lan.notes'),
                        labelText: translate('lan.notes'),

                      ),
                      cursorColor: HomePage.colorGrey,
                    ),
                  ),
                const  SizedBox(height: 80),



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
              )),
        )
    );
  }

  Future SendDataToServer(BuildContext context) async {


    var response = await http.post("${HomePage.URL}cart/add_address",
        headers:
        {
        "Authorization": "Bearer $token",
        },
    body: {
      "district": "${distictCtrl.text}",
      "address": "${noteCtrl.text}",
      "lat": "${currentLocation.latitude}",
      "lng": "${currentLocation.longitude}",
      "cart_token": cardToken
    });
    print("${distictCtrl.text}");
    print("${noteCtrl.text}");
    print("${currentLocation.latitude}");

    print("$cardToken");


    var datauser = json.decode(response.body);
    print("$datauser");
    if ("${datauser['success']}"=="1"){

      displayToastMessage("تم التسجيل بنجاح");
      print("${datauser['message']}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdressList()),
      );

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
