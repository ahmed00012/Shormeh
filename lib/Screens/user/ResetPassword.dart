// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:market/screens/user/forgetpassword.dart';
//
// import '../../main.dart';
//
// class ResetPassword extends StatefulWidget {
//   @override
//   _ResetPasswordState createState() => _ResetPasswordState();
// }
//
// class _ResetPasswordState extends State<ResetPassword> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController currentPasswordCtrl =new TextEditingController();
//   TextEditingController newPasswordCtrl =new TextEditingController();
//   TextEditingController confirmNewPasswordCtrl =new TextEditingController();
//
//   bool showPassword=false;
//   bool enable=true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: new Text(
//           'تغيير كلمة السر',
//           style: TextStyle(color: Colors.black),
//         ),
//         iconTheme: IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//       ),
//       body: Form(
//         key: _formKey,
//         child: new ListView(children: <Widget>[
//           new Padding(
//             padding: new EdgeInsets.only(top: MediaQuery.of(context).size.width/10),
//           ),
//           new Container(
//               padding: new EdgeInsets.only(left: MediaQuery.of(context).size.width/10, right: MediaQuery.of(context).size.width/10),
//               child: new Column(children: <Widget>[
//                 // Logo Image
//                 new Container(
//                   width: MediaQuery.of(context).size.width/2,
//                   height: MediaQuery.of(context).size.width/2,
//                   decoration: new BoxDecoration(
//                     image: new DecorationImage(
//                       image: AssetImage('assets/images/logo.png'),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.width/15),
//
//                 //كلمة السر الحالية
//                 new TextFormField(
//                   obscureText: !showPassword,
//                   controller: currentPasswordCtrl,
//                   style: TextStyle(fontSize: MediaQuery.of(context).size.width/20),
//                   decoration: new InputDecoration(
//                     prefixIcon: IconButton(
//                       icon:showPassword?Icon(Icons.visibility): Icon(Icons.visibility_off),
//                       onPressed: (){
//                         setState(() {
//                           if(showPassword){
//                             showPassword=false;
//                           }else{
//                             showPassword=true;
//                           }
//                         });
//                       },
//                     ),
//                     enabledBorder: new UnderlineInputBorder(
//                         borderSide:
//                         new BorderSide(color: HomePage.colorHintAndUnderline)),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: HomePage.colorHintAndUnderline),
//                     ),
//                     labelStyle: new TextStyle(color: HomePage.colorHintAndUnderline),
//                     hintText: "كلمة السر الحالية",
//                     labelText: "كلمة السر الحالية",
//                   ),
//                   cursorColor: HomePage.colorHintAndUnderline,
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.width/20),
//                 //كلمة السر الجديدة
//                 new TextFormField(
//                   obscureText: !showPassword,
//                   controller: newPasswordCtrl,
//                   style: TextStyle(fontSize: MediaQuery.of(context).size.width/20),
//                   decoration: new InputDecoration(
//                     prefixIcon: IconButton(
//                       icon:showPassword?Icon(Icons.visibility): Icon(Icons.visibility_off),
//                       onPressed: (){
//                         setState(() {
//                           if(showPassword){
//                             showPassword=false;
//                           }else{
//                             showPassword=true;
//                           }
//                         });
//                       },
//                     ),
//                     enabledBorder: new UnderlineInputBorder(
//                         borderSide:
//                         new BorderSide(color: HomePage.colorHintAndUnderline)),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: HomePage.colorHintAndUnderline),
//                     ),
//                     labelStyle: new TextStyle(color: HomePage.colorHintAndUnderline),
//                     hintText: "كلمة السر الجديدة",
//                     labelText: "كلمة السر الجديدة",
//                   ),
//                   cursorColor: HomePage.colorHintAndUnderline,
//
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.width/20),
//                 //تأكيد كلمة السر الجديدة
//                 new TextFormField(
//                   obscureText: !showPassword,
//                   controller: confirmNewPasswordCtrl,
//                   style: TextStyle(fontSize: MediaQuery.of(context).size.width/20),
//                   decoration: new InputDecoration(
//                     prefixIcon: IconButton(
//                       icon:showPassword?Icon(Icons.visibility): Icon(Icons.visibility_off),
//                       onPressed: (){
//                         setState(() {
//                           if(showPassword){
//                             showPassword=false;
//                           }else{
//                             showPassword=true;
//                           }
//                         });
//                       },
//                     ),
//                     enabledBorder: new UnderlineInputBorder(
//                         borderSide:
//                         new BorderSide(color: HomePage.colorHintAndUnderline)),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: HomePage.colorHintAndUnderline),
//                     ),
//                     labelStyle: new TextStyle(color: HomePage.colorHintAndUnderline),
//                     hintText: "تأكيد كلمة السر الجديدة",
//                     labelText: "تأكيد كلمة السر الجديدة",
//                   ),
//                   validator: (value) {
//                     if (value != newPasswordCtrl.text) {
//
//                       return "كلمة السر غير متطابقة";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.width/20),
//                 InkWell(onTap: (){
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ForgetPassword()),
//                   );
//                 },child: Text("نسيت كلمة السر")),
//                 SizedBox(height: MediaQuery.of(context).size.width/20),
//
//                 //تأكيد
//                 ButtonTheme(
//                   shape: new RoundedRectangleBorder(
//                       borderRadius: new BorderRadius.circular(10.0)),
//                   minWidth: 500.0,
//                   height: MediaQuery.of(context).size.width/7,
//                   child: RaisedButton(
//                     child: Text(
//                         "تأكيد",
//                         style:TextStyle(fontSize: MediaQuery.of(context).size.width/20,color: Colors.white)
//
//                     ),
//                     color: HomePage.colorGreen,
//                     onPressed: () {
//                       if(enable){
//                         SendDataToServer(context);
//                       }else{
//                           displayToastMessage("الرجاء الانتظار يتم الان تعديل كلمة السر");
//                       }
//                     },
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.width/20,),
//
//               ])),
//         ]),
//       ),
//     );
//   }
//   Future SendDataToServer(BuildContext context) async {
//         setState(() {
//           enable=false;
//         });
//       var response = await http.post("${HomePage.URL}user_api/change_password",body: {
//         "key": "1234567890",
//         "token_id": "${HomePage.token}",
//         "current_password": "${currentPasswordCtrl.text}",
//         "new_password": "${newPasswordCtrl.text}",
//       });
//
//       var datauser = json.decode(response.body);
//      setState(() {
//        enable=true;
//      });
//       if(datauser['status']){
//         displayToastMessage(datauser['message'].toString());
//       }else{
//         displayToastMessage(datauser['message'].toString());
//       }
//   }
//
//   void displayToastMessage(var toastMessage) {
//     Fluttertoast.showToast(
//         msg: toastMessage.toString(),
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIos: 1,
//         backgroundColor: HomePage.colorGreen,
//         textColor: Colors.white,
//         fontSize: 16.0
//     );
//     // _goToHome();
//   }
// }
