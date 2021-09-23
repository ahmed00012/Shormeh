import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConditionsAndRules extends StatefulWidget {
  @override
  _ConditionsAndRulesState createState() => _ConditionsAndRulesState();
}

class _ConditionsAndRulesState extends State<ConditionsAndRules> {
  Color colorGreen=Color(0xff119546);
  onBackPressed(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
  String terms;
  bool circularIndicatorActive=true;
  String URL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPref();
  }

  Future<void> getDataFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url');
    setState(() {
      URL=url;
      getTerms();
    });

  }

  Future getTerms() async {

    var response = await http.post("$URL/api/preparation_register",body: {
      "key": "1234567890",
    });

    var dataTerms = json.decode(response.body);

    if(dataTerms['status'].toString()=="true"){
      setState(() {
        terms=dataTerms['result']['Terms'][0]['Terms'];
        circularIndicatorActive=false;
      });

    }else{
    }

  }
  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorGreen,
        textColor: Colors.white,
        fontSize: 16.0
    );
    // _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor:  HexColor('#40976c'),
        elevation: 0.0,
        leading: new Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(300),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
              },
              child: Image(
                image: AssetImage('assets/images/close.png'),
              ),
            )),
        title: new Center(
          child: Container(
              width: MediaQuery.of(context).size.width/8.5,
              height: MediaQuery.of(context).size.width/8,

              // margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(300),
                onTap: () {
                  Navigator.of(context).pushNamed('/home', arguments: 1);
                },
                child: Image(
//                  backgroundColor: Colors.transparent,
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
              )),
        ),
        actions: <Widget>[
          Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(300),
                onTap: () {
                  onBackPressed(context);
                },
                child: Icon(Icons.arrow_forward_ios,size: MediaQuery.of(context).size.width/15,
                  color: Colors.black,),
              )),
        ],
      ),
      body:  circularIndicatorActive?
        Center(child: new CircularProgressIndicator(),):
      Container(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 15.0,),
            Center(
              child: Container(color: colorGreen, height: 2, width: 900,),
            ),
            SizedBox(height: 15.0,),
            Text("الشروط والقوانين",style: TextStyle(fontSize: 20.0,color: colorGreen),),
            SizedBox(height: 15.0,),
            Text(terms,
              style: TextStyle(fontSize: MediaQuery.of(context).size.width/25),),
          ],
        ),
      ),
    );
  }
}
