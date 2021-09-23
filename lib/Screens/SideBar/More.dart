import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:shormeh/Screens/Offers/offers.dart';
import 'package:shormeh/Screens/SideBar/AboutUs.dart';
import 'package:shormeh/Screens/SideBar/Comment.dart';
import 'package:shormeh/Screens/SideBar/MyOdrers.dart';
import 'package:shormeh/Screens/SideBar/MyPoints.dart';
import 'package:shormeh/Screens/SideBar/Translation.dart';
import 'package:shormeh/Screens/user/login.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../SelectBrabche.dart';

class More extends StatefulWidget {
  More({Key key}) : super(key: key);

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  bool isLogin = false;

  String tel = "";
  onBackPressed(BuildContext context) async {
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //     HomePage(index:0)), (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPref();
  }

  getDataFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final _isLogin = prefs.getBool('isLogin');
    if (_isLogin == null) {
      await prefs.setBool('isLogin', false);
    } else {
      setState(() {
        isLogin = _isLogin;
      });
    }

    getAboutUs();
  }

  Future getAboutUs() async {
    var response = await http.get("${HomePage.URL}settings/website");

    var data = json.decode(response.body);
    setState(() {
      tel = data["mobile"];
    });
    //  }
  }

  @override
  Widget build(BuildContext context) {
    double double1 = MediaQuery.of(context).size.width / 20;
    double double2 = MediaQuery.of(context).size.width / 25;
    double double3 = MediaQuery.of(context).size.height / 12;
    double double4 = MediaQuery.of(context).size.width / 22;

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: HexColor('#40976c'),
        title: Text(
          translate('lan.myAccount'),
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(isHomeScreen: true,)));
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 22,
            0.0, MediaQuery.of(context).size.width / 22, 0.0),
        child: ListView(
          children: [
            //Profile
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => QuranSettings()));
              },
              child: Container(
                height: double3,
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/user.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.profile'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //My Orders
            InkWell(
              onTap: () {
                if (isLogin) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyOrders()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                }
              },
              child: Container(
                height: double3,
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/orders.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.myOrders'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //My Points
            InkWell(
              onTap: () {
                if (isLogin) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPoints()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                }
              },
              child: Container(
                height: double3,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/points.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.myPoints'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //اللغة
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Translate()));
              },
              child: Container(
                height: double3,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/newspaper.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.language'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //News
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Offers()));
              },
              child: Container(
                height: double3,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/newspaper.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.offers'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //Excellent Request
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => ExcelentRequest()));
              },
              child: Container(
                height: double3,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/request.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.excelentRequest'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //About Us
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs()));
              },
              child: Container(
                height: double3,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/info.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.aboutUs'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //Contact Us
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Comment()));
              },
              child: Container(
                height: double3,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/contact.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.contactUs'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //Mobile
            InkWell(
              onTap: () {
                launch("tel://$tel");
              },
              child: Container(
                height: double3,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/mobile.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.mobile'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            //Log Out
            InkWell(
              onTap: () {
                saveDataInSharedPref(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => QuranSettings()));
              },
              child: Container(
                height: double3,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/logout.png",
                      width: double1,
                      height: double1,
                    ),
                    SizedBox(
                      width: double2,
                    ),
                    Text(
                      translate('lan.logout'),
                      style: TextStyle(
                          fontSize: double2,
                          color: Colors.black,
                          fontFamily: 'Tajawal'),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: double1,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 75,
            ),
          ],
        ),
      ),
    );
  }

  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void saveDataInSharedPref(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("cardToken", "");
    await prefs.setBool('isLogin', false);
    await prefs.setString('name', "");
    await prefs.setString('phone', "");
    await prefs.setString('email', "");
    await prefs.setString('token', "");

    goToHome(context);
  }

  goToHome(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => Login(fromMyAccount: false,)),
//    );
  }
}
