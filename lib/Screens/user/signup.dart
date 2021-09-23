import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:shormeh/Screens/SelectBrabche.dart';

import 'package:shormeh/Screens/user/login.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  bool circularIndicatorActive=false;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();


  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()=>onBackPressed(context),
        child:Scaffold(

          body: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: AssetImage('assets/images/loginBackground.png',),
                  fit: BoxFit.fill,
                ),
              ),
              child: ListView(children: <Widget>[
                // Logo Image
                SizedBox(height: MediaQuery.of(context).size.height/20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/10,),
                      Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SelectBranche()),
                            );
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width/8,
                              height: MediaQuery.of(context).size.width/8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                                color: HomePage.colorYellow,
                              ),
                              child: Icon(Icons.arrow_back,color: Colors.white,size: MediaQuery.of(context).size.width/15,)
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width/15,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Sign Up",
                            style:TextStyle(fontSize:  MediaQuery.of(context).size.width/18,
                              color: Colors.white,fontWeight: FontWeight.bold,
                            )
                        ),),
                      Expanded(child: Container()),

                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/10,),

                Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: MediaQuery.of(context).size.width/3,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/15),

                //الاسم
                Container(
                  padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
                  child: TextFormField(
                    controller: nameCtrl,
                    keyboardType: TextInputType.name,
                    decoration: new InputDecoration(
                      icon:Icon(Icons.person),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                          new BorderSide(color: HomePage.colorGrey)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HomePage.colorGrey),
                      ),
                      labelStyle: new TextStyle(color: HomePage.colorGrey),
                      hintText: translate('lan.name'),
                      labelText: translate('lan.name'),

                    ),
                    cursorColor: HomePage.colorGrey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/20),
                //الايميل
                Container(
                  padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
                  child: TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                      icon:Icon(Icons.email),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                          new BorderSide(color: HomePage.colorGrey)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HomePage.colorGrey),
                      ),
                      labelStyle: new TextStyle(color: HomePage.colorGrey),
                      hintText:   translate('lan.ema'),
                      labelText: translate('lan.name'),
                    ),
                    cursorColor: HomePage.colorGrey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/20),

                //الموبايل
                Container(
                  padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),

                  child: TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,

                    decoration: new InputDecoration(
                      icon:Icon(Icons.phone),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                          new BorderSide(color: HomePage.colorGrey)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HomePage.colorGrey),
                      ),
                      labelStyle: new TextStyle(color: HomePage.colorGrey),
                      hintText: "Phone Number",
                      labelText: "Phone Number",

                    ),
                    cursorColor: HomePage.colorGrey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/20),
                //كلمة السر
                Container(
                  padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
                  child: TextFormField(
                    controller: passwordCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: new InputDecoration(
                      icon:Icon(Icons.security),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                          new BorderSide(color: HomePage.colorGrey)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HomePage.colorGrey),
                      ),
                      labelStyle: new TextStyle(color: HomePage.colorGrey),
                      hintText: "Password",
                      labelText: "Password",

                    ),
                    cursorColor: HomePage.colorGrey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/20),
                //تأكيد
                /*
                Container(
                  padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
                  child: TextFormField(
                    controller: confirmPasswordCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: new InputDecoration(
                      icon:Icon(Icons.security),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                          new BorderSide(color: HomePage.colorGrey)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HomePage.colorGrey),
                      ),
                      labelStyle: new TextStyle(color: HomePage.colorGrey),
                      hintText: "Confirm Password",
                      labelText: "Confirm Password",

                    ),
                    cursorColor: HomePage.colorGrey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/20),
                */
                //Submit
                Container(
                  margin: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
                  child: ButtonTheme(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    minWidth: 500.0,
                    height: MediaQuery.of(context).size.width/8,
                    child: RaisedButton(
                      child: Text(
                          "Sign Up",
                          style:TextStyle(fontSize:  MediaQuery.of(context).size.width/20,color: Colors.white)
                      ),
                      color: HomePage.colorGreen,
                      onPressed: () {
                        SendDataToServer(context);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(top:  MediaQuery.of(context).size.width/20),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Center(
                    child: Text("Log In",style: TextStyle(fontSize: MediaQuery.of(context).size.width/25),),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/10,)

              ])),
        )
    );
  }

  Future SendDataToServer(BuildContext context) async {


         var response = await http.post("${HomePage.URL}auth/register",headers:
            {
              "Accept": "application/json",
              "Content-Language": 'ar'
            },body: {
           "name": nameCtrl.text,
           "email": emailCtrl.text,
           "password": passwordCtrl.text,
           "phone": phoneCtrl.text
         });


          var datauser = json.decode(response.body);
           if ("${datauser['success']}"=="1"){

             displayToastMessage("تم التسجيل بنجاح");
             print("${datauser['message']}");
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => Login()),
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


//Status Code
// if(response.statusCode == 200){
//   print("Data posted successfully");
// }else{
//   displayToastMessage("${datauser['message']}");
//   print("Something went wrong! Status Code is: ${response.statusCode}");
// }