import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/Points.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';

class MyPoints extends StatefulWidget {
  // QuraanSura({Key key}) : super(key: key);

  @override
  _MyPointsState createState() => _MyPointsState();
}

class _MyPointsState extends State<MyPoints> {
  bool isIndicatorActive = true;

  onBackPressed(BuildContext context) async {
    Navigator.pop(context);
  }

  List<PointsModel> allPoints = new List<PointsModel>();

  String token = "";
  int totalUsed = 0;
  int total = 0;
  int remain = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();
  }

  Future getDataFromSharedPrfs() async {
    final prefs = await SharedPreferences.getInstance();
    final _cardToken = prefs.getString("cardToken");
    final _token = prefs.getString("token");
    setState(() {
      token = _token;
    });

    print("$token");
    getMyPoints();
  }

  Future getMyPoints() async {
    var response = await http.get("${HomePage.URL}customer/points", headers: {
      "Authorization": "Bearer $token",
    });

    var data = json.decode(response.body);
    //print("$data");
    log("${data['points']}");
    if (data["success"] == "1") {
      setState(() {
        for (int i = 0; i < data['points'].length; i++) {
          allPoints.add(new PointsModel(
              data['points'][i]['id'],
              data['total_points'],
              data['points_to_cash'],
              data['points'][i]['points'],
              data['points'][i]['converted']));
          totalUsed = totalUsed + data['points'][i]['converted'];
          total = data['total_points'];
          remain = total - totalUsed;
        }
        //فى اللحظة دية كل الصيدليات بكل الاقسام اتحملت
        isIndicatorActive = false;
      });
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (c) => HomePage(
                    isHomeScreen: true,
                  )),
        );
      },
      child: Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            backgroundColor: HexColor('#40976c'),
            elevation: 0,
            title: Text(translate('lan.myPoints'),style: TextStyle(fontFamily: 'Tajawal'),),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (c) => HomePage(
                            isHomeScreen: true,
                          )),
                );
              },
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 200,
                  decoration: new BoxDecoration(
                    color: Color(0xfff7f7f7),
                    borderRadius: new BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: Color(0xff40976C)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              translate('lan.totalEarned') + ' : ',
                              style: TextStyle(
                                  color: Color(0xff40976C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Tajawal'),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                total.toString(),
                                style: TextStyle(
                                    color: Color(0xff40976C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Tajawal'),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              translate('lan.totalUsed') + ' : ',
                              style: TextStyle(
                                  color: Color(0xff40976C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Tajawal'),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                totalUsed.toString(),
                                style: TextStyle(
                                    color: Color(0xff40976C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Tajawal'),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              translate('lan.remaining') + ' : ',
                              style: TextStyle(
                                  color: Color(0xff40976C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Tajawal'),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                remain.toString(),
                                style: TextStyle(
                                    color: Color(0xff40976C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Tajawal'),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: new BoxDecoration(
                              color: HexColor('#40976c'),
                              borderRadius: new BorderRadius.all(
                                Radius.circular(80),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                translate('lan.usePoints'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Tajawal'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: allPoints.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 50,
                          MediaQuery.of(context).size.width / 50,
                          MediaQuery.of(context).size.width / 50,
                          MediaQuery.of(context).size.width / 50),
                      child: Container(
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Color(0xfff7f7f7),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xfff7f7f7), spreadRadius: 0.0),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    child: Text(
                                      translate('lan.orderNo') +
                                          "  ${allPoints[index].id}",
                                      style: TextStyle(
                                          color: Color(0xff748b9d),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30,
                                          fontFamily: 'Tajawal'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    child: Text(
                                      translate('lan.pointsEarned') +
                                          "   ${allPoints[index].points}",
                                      style: TextStyle(
                                          color: Color(0xff748b9d),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30,
                                          fontFamily: 'Tajawal'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    child: Text(
                                      translate('lan.pointsUsed') +
                                          "  ${allPoints[index].converted}",
                                      style: TextStyle(
                                          color: Color(0xff748b9d),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30,
                                          fontFamily: 'Tajawal'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 7,
                              height: MediaQuery.of(context).size.width / 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff40976C),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${allPoints[0].points}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                27,
                                        fontFamily: 'Tajawal'),
                                  ),
                                  Text(
                                    translate('lan.point'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                27,
                                        fontFamily: 'Tajawal'),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ));
                },
              ),
              Container(
                height: 70,
              )
            ],
          )),
    );
  }

  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
