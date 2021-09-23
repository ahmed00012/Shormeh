import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:shormeh/Screens/SelectBrabche.dart';
import 'package:shormeh/Screens/user/signup.dart';

class VerfySignup extends StatefulWidget {

  @override
  _VerfySignupState createState() => _VerfySignupState();
}

class _VerfySignupState extends State<VerfySignup> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();



  final phoneNumberCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  var datauser;


  bool enable=true;
  bool showPassword=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()=>onBackPressed(context),
        child:Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.0), // here the desired height
              child: AppBar(
              )
          ),
          body: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: AssetImage('assets/images/loginBackground.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: new Column(children: <Widget>[
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
                                boxShadow: [
                                  //BoxShadow(color: HomePage.colorBlue, spreadRadius: 1.5),
                                ],
                              ),
                              child: Icon(Icons.arrow_back,color: Colors.white,size: MediaQuery.of(context).size.width/15,)
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width/15,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Login",
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
                      hintText: "Phone Number",
                      labelText: "Phone Number",

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
                    controller: codeCtrl,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                      icon:Icon(Icons.phone),

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
                InkWell(onTap: (){
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ForgetPassword()),
                  // );
                },child: Text("Forget Password")),
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
                          "Log In",
                          style:TextStyle(fontSize:  MediaQuery.of(context).size.width/20,color: Colors.white)
                      ),
                      color: HomePage.colorGreen,
                      onPressed: () {
                        if(enable){
                          //getFirebaseToken();
                        }
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
                    child: Text("New Account",style: TextStyle(fontSize: MediaQuery.of(context).size.width/25),),
                  ),
                ),




              ])),
    )
      );
  }
  var tokenFCM="";


  Future SendDataToServer(BuildContext context) async {

    setState(() {
      enable=false;
    });
    var response = await http.post("${HomePage.URL}user_api/login",body: {
      "key": "1234567890",
      "phone": phoneNumberCtrl.text,
      "password": codeCtrl.text,
      "device_id": tokenFCM,
    });
    datauser = json.decode(response.body);
    if(datauser['status']){
      displayToastMessage(datauser['message'].toString());
      if(datauser['message'].toString()=="تم تسجيل الدخول بنجاح"){
        saveDataInSharedPref(context);
      }

    }else{
      setState(() {
        enable=true;
      });
      displayToastMessage(datauser['message'].toString());
    }
  }


  void saveDataInSharedPref(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLogin', true);
    await prefs.setString('id', "${datauser['result']['customer_info']['id'].toString()}");
    await prefs.setString('name', "${datauser['result']['customer_info']['name']}");
    await prefs.setString('phone', "${datauser['result']['customer_info']['phone']}");
    await prefs.setString('email', "${datauser['result']['customer_info']['email']}");
    await prefs.setString('token', "${datauser['result']['customer_info']['token_id']}");
    await prefs.setString('activation_status', "${datauser['result']['customer_info']['activation_status']}");
    setState(() {
      // HomePage.islogin = true;
      // HomePage.id = "${datauser['result']['customer_info']['id'].toString()}";
      // HomePage.name = "${datauser['result']['customer_info']['name']}";
      // HomePage.phone = "${datauser['result']['customer_info']['phone']}";
      // HomePage.email = "${datauser['result']['customer_info']['email']}";
      // HomePage.token =  "${datauser['result']['customer_info']['token_id']}";
      // HomePage.activation_status = "${datauser['result']['customer_info']['activation_status']}";
    });
    goToHome(context);

  }
  goToHome(BuildContext context){
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);


//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => Login(fromMyAccount: false,)),
//    );
  }

  onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
