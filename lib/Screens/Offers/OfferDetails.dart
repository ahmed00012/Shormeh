import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';

class OfferDetails extends StatefulWidget {
  int id;
  String description;
  String image;

  OfferDetails({
    Key key,
    this.id,
    this.description,
    this.image,
  }) : super(key: key);

  @override
  _OfferDetailsState createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor:  HexColor('#40976c'),
        title: Text(translate('lan.offerDetails'),),

        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,),
          onPressed:()=>onBackPressed(context),
        ),
      ),
      body: ListView(
        children: [

          Container(
            margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width/30,
              MediaQuery.of(context).size.width/50,
              MediaQuery.of(context).size.width/30,
              MediaQuery.of(context).size.width/50,
            ),

            decoration:  BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: HomePage.colorGreen, spreadRadius: 0.0),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height / 4.5,
                image:NetworkImage("https://post.healthline.com/wp-content/uploads/2020/07/pizza-beer-1200x628-facebook-1200x628.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width/30,
              MediaQuery.of(context).size.width/50,
              MediaQuery.of(context).size.width/30,
              MediaQuery.of(context).size.width/50,
            ),
            child:  Text("${widget.description}",
              style: TextStyle(fontSize: MediaQuery.of(context).size.width/30),),
          ),
        ],
      ),
    );
  }
  onBackPressed(BuildContext context) {

  }



  goToHome(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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
