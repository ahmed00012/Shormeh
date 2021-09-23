import 'dart:convert';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Screens/Cats/1Categories.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:shormeh/Screens/SelectBrabche.dart';
import 'package:shormeh/Screens/user/signup.dart';


class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final phoneNumberCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  var datauser;


  bool enable=true;
  bool showPassword=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      setState((){
        tokenFCM=value;
      });
    });
  }





  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: ()=>onBackPressed(context),
        child:Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: AssetImage('assets/images/loginBackground.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: new ListView(children: <Widget>[
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
                        child: Text(translate('lan.login'),
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

                //الموبايل
                Container(
                  padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),

                  child: TextFormField(
                    enabled: enable,
                    controller: phoneNumberCtrl,
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
                      hintText: translate('lan.phoneNumber'),
                      labelText:translate('lan.phoneNumber'),

                    ),
                    cursorColor: HomePage.colorGrey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/20),
                //تحميل

                //كلمة السر
                Container(
                  padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/15, right: MediaQuery.of(context).size.width/15),
                  child: TextFormField(
                    obscureText: !showPassword,
                    enabled: enable,
                    controller: passwordCtrl,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                      icon:Icon(Icons.security),

                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                          new BorderSide(color: HomePage.colorGrey)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HomePage.colorGrey),
                      ),
                      labelStyle: new TextStyle(color: HomePage.colorGrey),
                      hintText:translate('lan.password'),
                      labelText: translate('lan.password'),
                    ),
                    cursorColor: HomePage.colorGrey,

                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width/20),
                InkWell(onTap: (){
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ForgetPassword()),
                  // );
                },child: Container(
                    alignment: Alignment.center,
                    child: Text(translate('lan.forgetPassword'),))),
                //Forget Password

                SizedBox(height: MediaQuery.of(context).size.width/20,),

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
                          translate('lan.login'),
                          style:TextStyle(fontSize:  MediaQuery.of(context).size.width/20,color: Colors.white)
                      ),
                      color: HomePage.colorGreen,
                      onPressed: () {
                        SendDataToServer(context);
                      },
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(top:  MediaQuery.of(context).size.width/20),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Center(
                    child: Text(translate('lan.newAccount'),style: TextStyle(fontSize: MediaQuery.of(context).size.width/25),),
                  ),
                ),




              ])),
    )
      );
  }
  var tokenFCM="";


  Future SendDataToServer(BuildContext context) async {

    print("RRRR $tokenFCM");

    var response = await http.post("${HomePage.URL}auth/login",body: {
      "phone": phoneNumberCtrl.text,
      "password": passwordCtrl.text,
      "device_id": tokenFCM,
    });
    datauser = json.decode(response.body);
    print(datauser);
    if("${datauser['success']}"=="1"){
        saveDataInSharedPref(context);
    }else{

      displayToastMessage(datauser['message'].toString());
    }
  }


  void saveDataInSharedPref(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLogin', true);
    await prefs.setString('name', "${datauser['name']}");
    await prefs.setString('phone', "${datauser['phone']}");
    await prefs.setString('email', "${datauser['email']}");
    await prefs.setString('token', "${datauser['access_token']}");

    print("=>${datauser['name']}");
    print("=>${datauser['phone']}");
    print("=>${datauser['email']}");
    print("=>${datauser['access_token']}");


    goToHome(context);

  }
  goToHome(BuildContext context){
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(isHomeScreen: true,)),);

//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => Login(fromMyAccount: false,)),
//    );
  }

  onBackPressed(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(isHomeScreen: true,)));
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
