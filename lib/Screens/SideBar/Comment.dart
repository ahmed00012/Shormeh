import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:http/http.dart' as http;


class Comment extends StatefulWidget {
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController tECCommentSubject= new TextEditingController();
  TextEditingController tECComment= new TextEditingController();


  senToMustafa() async {

    var response = await http.post("${HomePage.URL}settings/contactus",body: {
      "title": tECCommentSubject.text,
      "message": tECComment.text,
    });
    var data = json.decode(response.body);
    if("${data['success']}"=="1"){
      displayToastMessage(data['message'].toString());
    }else{
      displayToastMessage(data['message'].toString());
    }
  }

  onBackPressed(BuildContext context) async{Navigator.of(context).pop();}

  @override
  Widget build(BuildContext context) {
    double shadow=.8;

    return WillPopScope(
      onWillPop: ()=>onBackPressed(context),
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor('#40976c'),
          title: Text(translate('lan.contactUs'),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,),
            onPressed:()=>onBackPressed(context),
          ),
        ),
        body: Container(
          color: Color(0xfff8f9f9),
          child: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                alignment:Alignment.center,
                margin: EdgeInsets.all(MediaQuery.of(context).size.width/12),
                child: Text("من فضلك اترك رسالتك ....",
                    style: TextStyle(fontSize:MediaQuery.of(context).size.width / 25,
                        color: Colors.black)),
              ),
              //Subject
              Container(
                margin: EdgeInsets.all(MediaQuery.of(context).size.width/20),
                child: Stack(
                  children: <Widget>[


                    //المحتوى
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/10,
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
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width/30),
                          child: TextField(

                            controller: tECCommentSubject,

                            decoration: new InputDecoration(
                              hintText: 'الموضوع',
                              hintStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width/25),
                            ),
                            cursorColor: HomePage.colorGreen,
                          ),
                        )
                      ],),

                  ],
                ),

              ),
              //Message
              Container(
                margin: EdgeInsets.all(MediaQuery.of(context).size.width/20),
                child: Stack(
                  children: <Widget>[


                    //المحتوى
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/7,
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
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width/30),
                          child: TextField(

                            controller: tECComment,

                            decoration: new InputDecoration(
                              hintText: 'أضف سؤال أو استفسار...',
                              hintStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width/25),
                            ),
                            cursorColor: HomePage.colorGreen,
                            maxLines: 3,
                          ),
                        )
                      ],),

                  ],
                ),

              ),
              //SEND
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
                      senToMustafa();
                    },
                  ),
                ),
              ),

            ],
          ),
        ),

      ),
    );
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
