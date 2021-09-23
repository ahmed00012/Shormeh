import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/Cats.dart';
import 'package:shormeh/Screens/Cats/2Products.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shormeh/Screens/SelectBrabche.dart';
import 'package:dio/dio.dart';

import '../Home/HomePage.dart';

class HomeScreen extends StatefulWidget {
  int vendorID;
  HomeScreen({this.vendorID});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool isIndicatorActive = true;

  List<Cats> allCats = new List<Cats>();
  List<String> allSliderHome = [];
  String language = '';
  DateTime currentBackPressTime;
  bool isIndicatorActive = true;

  //FCM
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  //FCM
  String vendorName = "";
  int vendorID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSliderHome();
    getDataFromSharedPref();
    print(widget.vendorID);
  }

  Future<void> getDataFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('branchSelected', true);

    final _vendorID = prefs.getInt('vendorID');
    int lan = prefs.getInt('translateLanguage');
    lan == 1 ? language = 'ar' : language = 'en';
    print(language);

    setState(() {
      widget.vendorID == null
          ? vendorID = _vendorID
          : vendorID = widget.vendorID;
      //HomePage.cardToken = _cardToken;
    });
    fcmNotification();
    getAllCats();
  }

  //FCM
  fcmNotification() {
    //FCM
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });
    //دية بتستقبل النوتيكفكشن وتعرضها
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                "",
                notification.title,
                notification.body,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'app_icon',
              ),
            ));
      }
    });

    //ديه بتفتح التطبيق وتقيم الخدمة
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'A new onMessageOpenedApp event was published Message ${message.notification.title} ');
      if (message.notification.title == "تقيم الخدمة") {
        Navigator.pushNamed(
          context,
          '/taqeem',
        );
      } else {
        Navigator.pushNamed(
          context,
          '/message',
        );
      }
    });

    FirebaseMessaging.instance.getToken().then((value) {
      print("FIREBASE TOKEN $value");
    });
  }

  Future getAllSliderHome() async {

    var response = await Dio().get("${HomePage.URL}sliders");
    setState(() {
      allSliderHome = [
        response.data[0]['image_one'],
        response.data[1]['image_one'],
        response.data[2]['image_one'],
      ];
      isIndicatorActive = false;
    });
  }

  Future getAllCats() async {
    // setState(() {
    //   isIndicatorActive = true;
    // });
    var response = await http.get("${HomePage.URL}vendors/$vendorID/categories",
        headers: {"Content-Language": language});

    var dataAllCats = json.decode(response.body);

    vendorName = dataAllCats['vendor']['name'];
    setState(() {
      vendorID = dataAllCats['vendor']['id'];
    });
    print(vendorID + 20000);

    for (int i = 0; i < dataAllCats['categories'].length; i++) {
      allCats.add(new Cats(
          dataAllCats['categories'][i]['id'],
          dataAllCats['categories'][i]['name'],
          dataAllCats['categories'][i]['image']));
      print("${allCats[i].id}");
    }
    // setState(() {
    //   //فى اللحظة دية كل الصيدليات بكل الاقسام اتحملت
    //   isIndicatorActive = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          vendorName,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Tajawal'),
        ),
        backgroundColor: HexColor('#40976c'),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectBranche()));
            },
            child: Image.asset(
              'assets/images/locationHome.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        elevation: 5.0,
      ),
      body:
          // isIndicatorActive
          //     ? Container(
          //   color: Colors.white,
          //   child: Center(
          //       child:Container(
          //         height: MediaQuery.of(context).size.height*0.4,
          //         width: MediaQuery.of(context).size.width*0.6,
          //         child: Lottie.asset('assets/images/lf20_8tcvbixe.json'),
          //       )
          //   ),
          // )
          //     :
          Container(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 10,
                ),
                //Slider
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      height: MediaQuery.of(context).size.height,
                      viewportFraction: 1.0,
                    ),
                    items: allSliderHome.map((banner) {
                      return Builder(
                        builder: (BuildContext context) {
                          return InkWell(
                              onTap: () {
                                //sliderBannerClick(allBanners,currentIndex);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: allSliderHome.isEmpty
                                        ? Container(
                                            color: Colors.black12,
                                          )
                                        :
                                    FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/2705-image-loading.gif',
                                      image: banner,
                                      fit: BoxFit.fill,
                                    ),
                                    // Image.network(
                                    //         banner,
                                    //         fit: BoxFit.fill,
                                    //         loadingBuilder:
                                    //             (BuildContext context,
                                    //                 Widget child,
                                    //                 ImageChunkEvent
                                    //                     loadingProgress) {
                                    //           if (loadingProgress == null)
                                    //             return child;
                                    //           return Container(
                                    //             color: Colors.black12,
                                    //           );
                                    //         },
                                    //       ),
                                  )));
                        },
                      );
                    }).toList(),
                  ),
                ),
                //Cats
                GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: allCats.length,
                    padding: EdgeInsets.fromLTRB(
                        0.0,
                        MediaQuery.of(context).size.width / 50,
                        0.0,
                        MediaQuery.of(context).size.width / 50),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      //childAspectRatio: MediaQuery.of(context).size.width /10,
                      mainAxisExtent: MediaQuery.of(context).size.width / 2.3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Products(
                                      catID: allCats[index].id,
                                      vendorID: vendorID,
                                    )),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: size.width * 0.5,
                            height: size.height * 0.2,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Stack(
                                  children: [

                                    FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/2705-image-loading.gif',
                                      image: allCats[index].image,
                                      fit: BoxFit.fill,
                                      width: size.width * 0.45,
                                    ),

                                    // Image(
                                    //   image: NetworkImage(
                                    //       '${allCats[index].image}'),
                                    //   fit: BoxFit.fill,
                                    //   width: size.width * 0.45,
                                    //   loadingBuilder: (BuildContext context,
                                    //       Widget child,
                                    //       ImageChunkEvent loadingProgress) {
                                    //     if (loadingProgress == null)
                                    //       return child;
                                    //     return Container(
                                    //       color: Colors.black12,
                                    //     );
                                    //   },
                                    // ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width: size.width * 0.45,
                                        height: size.height * 0.1,
                                        alignment: Alignment.bottomLeft,
                                        padding: EdgeInsets.only(
                                            left: 10, bottom: 12),
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.only(
                                            bottomLeft:
                                                const Radius.circular(15.0),
                                            bottomRight:
                                                const Radius.circular(15.0),
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.02),
                                              Colors.black.withOpacity(0.5),
                                              Colors.black.withOpacity(0.7),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Text(
                                          allCats[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Tajawal'),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 75,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
