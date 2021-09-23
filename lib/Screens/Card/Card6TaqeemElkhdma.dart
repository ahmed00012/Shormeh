import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:http/http.dart' as http;

class Card6TaqeemElkhdma extends StatefulWidget {
  @override
  _Card6TaqeemElkhdmaState createState() => _Card6TaqeemElkhdmaState();
}

class _Card6TaqeemElkhdmaState extends State<Card6TaqeemElkhdma> {
  TextEditingController _ratingController;
  double _rating;
  TextEditingController tECComment= new TextEditingController();

   @override
   void initState() {
     super.initState();
     _ratingController = TextEditingController(text: '3.0');
     //_rating = _initialRating;
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translate('lan.takeemElkhdma'),),
          centerTitle: true,
          backgroundColor:  HexColor('#40976c'),
          elevation: 5.0,
        ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/8,),
            Center(child: Text(translate('lan.takeemElkhdma')),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/5,
                  height: MediaQuery.of(context).size.width/5,
                  child: Lottie.asset('assets/lottieRate.json')
                ),
                SizedBox(width: MediaQuery.of(context).size.width/20,),
                Text(translate('lan.pleaseTakeemElkhdma'),style: TextStyle(
                    color:HomePage.colorGrey
                ),),
              ],
            ),
            Center(
              child: RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print("XXXXXXX$rating");

                  setState(() {
                    _rating=rating;
                  });
                },
              ),
            ),

            Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width/20),
              child: Stack(
                children: <Widget>[

                  //خلفية الكارت
                  Container(

                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width/2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          //مستوى الوضوح مع اللون
                          color: Colors.grey.withOpacity(0.7),
                          //مدى انتشارة
                          spreadRadius: 2,
                          //مدى تقلة
                          blurRadius: 5,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  //المحتوى
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(MediaQuery.of(context).size.width/20),
                        child: TextField(

                          controller: tECComment,

                          decoration: new InputDecoration(
                            hintText: translate('lan.molhazatawektrahet')+' ...',
                            hintStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width/30),
                          ),
                          cursorColor: HomePage.colorGreen,
                          maxLines: 3,
                        ),
                      )
                    ],),

                ],
              ),

            ),
            Container(
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/3.5, MediaQuery.of(context).size.width/10, MediaQuery.of(context).size.width/3.5, 0.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width/3,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                height: MediaQuery.of(context).size.width/8,
                child: RaisedButton(
                  child: Text(
                      "ارسل",
                      style:TextStyle(fontSize:  MediaQuery.of(context).size.width/20,color: Colors.white)
                  ),
                  color: HomePage.colorGreen,
                  onPressed: () {
                    senToRate();
                  },
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/20,),

            Center(child: Text("سعدنا بخدمتكم"),),

          ],
        ),
      )
    );
  }

  void senToRate() async{

    var response = await http.post("${HomePage.URL}rate/vendor",
        headers:
        {
          "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xMjcuMC4wLjE6ODAwMFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTYyNTExOTI1MSwiZXhwIjo1MjU2NjU1MjUxLCJuYmYiOjE2MjUxMTkyNTEsImp0aSI6InJsM3o3MnczTmdNS0pLbXEiLCJzdWIiOjEsInBydiI6ImE1YmI5ODE5OGJiNDNkYTZiNDU3NDljMDQ3NTljODFjMTIyNDMzYzEifQ.2aQaThLvKuK3K0lcgvmb_qef1JsagE9Rl52zuuW9NS0",
        },
        body: {
          "vendor_id": "37",
          "rate": "$_rating",
          "comment": "${tECComment.text}",
          "order_id": "54"
        });



    var datauser = json.decode(response.body);
    print("$datauser");
    if ("${datauser['success']}"=="1"){
      print("${datauser['message']}");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/selectBranche', (Route<dynamic> route) => false);

    } else {
      //displayToastMessage(datauser['errors'][0]['message'].toString());
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
