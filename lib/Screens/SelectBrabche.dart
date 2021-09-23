import 'dart:async';
import 'dart:convert';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:android_intent/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/LocationsModel.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:shormeh/Screens/Locations.dart';



class SelectBranche extends StatefulWidget {
  int lan ;
  double lat;
  double long;
  SelectBranche({this.lan, this.lat,this.long});
  @override
  _SelectBrancheState createState() => _SelectBrancheState();
}

class _SelectBrancheState extends State<SelectBranche> with TickerProviderStateMixin {

  String dropdownValue = 'Select Language';
  List<String> allBranches= [];

  List<String> allSliderCities =[];

  bool isIndicatorActive=true;

  // Position currentLocation;
  bool circularIndicatorActive = true;
  bool noMarketsOnMap=false;
  List<LocationModel> allLocationsGPS = new List<LocationModel>();

  // bool enableClick=true;

  int translateLanguage=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.lat.toString()+widget.long.toString());
    getAllSliderCities();
    getBranches();
    setState(() {
      allBranches.add("فرع الهفوف Hafouf");
      allBranches.add("فرع المبرز Mubraaz");
      allBranches.add("فرع دمام Damam");
      allBranches.add("فرع الخبر");
    });


    getDataFromSharedPref();

  }



  Future<void> getDataFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final _translateLanguage = prefs.getInt('translateLanguage');
    if(_translateLanguage==null&& widget.lan == null){
      setState(() {
        prefs.setInt('translateLanguage',0);
        widget.lan=0;
      });
    }else{
      setState(() {
        translateLanguage=_translateLanguage;
        widget.lan = _translateLanguage;
      });
    }


  }


  Future getAllSliderCities() async {
    var response =
    await http.get("${HomePage.URL}settings/app");

    var dataAllSilderCities = json.decode(response.body);

    setState(() {
      allSliderCities = [
        dataAllSilderCities['cities_slider'][0]['img_url'],
        dataAllSilderCities['cities_slider'][1]['img_url'],
        dataAllSilderCities['cities_slider'][2]['img_url'],
      ];
    });



  }


  // getLocationStatus()async{
  //
  //   var status = await Geolocator.isLocationServiceEnabled();
  //   if(status){
  //     setState(() {
  //       // هفعل السيركل عشان الفيو وهى هتطفى تانى من تحت وهقول ان فى صيدليات بعد ماكان الموقع مش متفعل
  //       getUserLocation();
  //     });
  //   }else{
  //     setState(() {
  //       _showDialog(context);
  //     });
  //   }
  // }
  //
  //
  // void _showDialog(BuildContext context) {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("الموقع",style: TextStyle(color: HomePage.colorGreen),),
  //         content: new Text("لكى تتمكن من مشاهدة المطاعم بالقرب منك الرجاء تفعيل الموقع"),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new FlatButton(
  //               child: new Text("تفعيل",style: TextStyle(color: HomePage.colorGreen),),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 setActiveLocation();
  //                 setState(() {
  //                   noMarketsOnMap=true;
  //                   circularIndicatorActive=false;
  //                 });
  //               }
  //           ),
  //           new FlatButton(
  //             child: new Text("الغاء",style: TextStyle(color: HomePage.colorGreen),),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  //
  // setActiveLocation()async{
  //   var platform = Theme.of(context).platform;
  //
  //   if(platform == TargetPlatform.iOS){
  //     AppSettings.openAppSettings();
  //   }else{
  //     final AndroidIntent intent = new AndroidIntent(
  //       action: 'android.settings.LOCATION_SOURCE_SETTINGS',
  //     );
  //     await intent.launch();
  //   }
  // }
  //
  // getUserLocation() async {
  //   currentLocation = await locateUser();
  //   getBranches();
  // }
  //
  // Future<Position> locateUser() async {
  //   return Geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // }

  getBranches() async {

    final response = await http.get(
        "${HomePage.URL}vendors?lat=${widget.lat}&long=${widget.long}");

    var data = json.decode(response.body);
    print(data);

    setState(() {
      allLocationsGPS.clear();
      allLocationsGPS= new List<LocationModel>();
      print("${allLocationsGPS.length}");
      for (int i = 0; i < data.length; i++) {
        allLocationsGPS.add(new LocationModel(
          data[i]['vendor']['id'],
          "${data[i]['vendor']['id']}",
          "${data[i]['vendor']['id']}",
          "${data[i]['vendor']['id']}",
          "${data[i]['vendor']['lat']}",
          "${data[i]['vendor']['id']}",
          data[i]['vendor']['vendor_id'],
          "${data[i]['name_ar']}",
          "${data[i]['name_en']}",
        ));
      }

        circularIndicatorActive = false;
        noMarketsOnMap = true;
      });
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          //Slider
          CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1.0,

            ),

            items: allSliderCities.map((banner) {
              return Builder(builder: (BuildContext context) {
                return InkWell(
                  onTap: (){
                    //sliderBannerClick(allBanners,currentIndex);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        banner,
                        fit: BoxFit.fill,
                      )),
                );
              },
              );
            }).toList(),
          ),

          //DropDownlist
          Directionality(
            textDirection:   translateLanguage == 1?TextDirection.rtl:TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5,0,5,100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  //Languages
                  GestureDetector(
                    onTap: (){
                      showDialogeLanguage(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.8,color:  HexColor('#40976c')),

                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                        ),
                        margin:  EdgeInsets.all(MediaQuery.of(context).size.width/50),
                        padding:  EdgeInsets.all(MediaQuery.of(context).size.width/50),

                        child: Row(
                          children: [
                            Container(
                              //margin:EdgeInsets.all(double2),
                                child: Text(
    translate('lan.language'),
                                  // "${AppLocalizations.of(context).language}",
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/23),)),
                            Expanded(child: Container()),
                            Container(
                                child:Icon(Icons.keyboard_arrow_down,size: MediaQuery.of(context).size.width/15,)
                            )
                          ],
                        )
                    ),
                  ),

                  //Cities/Branches/Location
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onTap: (){

                              showDialogeBranches(context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.8,color:  HexColor('#40976c')),

                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.transparent,

                              ),
                              margin:  EdgeInsets.all(MediaQuery.of(context).size.width/50),
                              padding:  EdgeInsets.all(MediaQuery.of(context).size.width/50),

                              child: Row(
                                children: [
                                  Container(
                                      //margin:EdgeInsets.all(double2),
                                      child: Text(translate('lan.branches'),
                                        // "${AppLocalizations.of(context).branches}",
                                        style: TextStyle(fontSize: MediaQuery.of(context).size.width/23),)),
                                  Expanded(child: Container()),
                                  Container(
                                    child:Icon(Icons.keyboard_arrow_down,size: MediaQuery.of(context).size.width/15,)
                                  )
                                ],
                              )
                          ),
                        ),
                      ),
                      Expanded(child: InkWell(
                        onTap: () {
                          goToMyLocations();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Image.asset("assets/images/location.png",
                          width: MediaQuery.of(context).size.width/10,
                          height: MediaQuery.of(context).size.width/10,
                          ),
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  void showDialogeBranches(BuildContext context){
    showDialog(
        context: context,

        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, StateSetter setState) {
                return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width/1.1,
              height: MediaQuery.of(context).size.height/1.1,
              decoration: ShapeDecoration(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),)),
              child: Container(
                color: Colors.transparent,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allLocationsGPS.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  index==0?
                    Column(children: [
                      //DropDown Dialoge
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.8),
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white
                            ),
                            margin:  EdgeInsets.all(MediaQuery.of(context).size.width/40),
                            padding:  EdgeInsets.all(MediaQuery.of(context).size.width/30),

                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                Container(
                                  //margin:EdgeInsets.all(double2),
                                    child: Text(translate('lan.branches'),style: TextStyle(fontSize: MediaQuery.of(context).size.width/23),)),
                                Expanded(child: Container()),
                                Container(
                                    child:Icon(Icons.clear,size: MediaQuery.of(context).size.width/12,)
                                )
                              ],
                            )
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          //Navigator.pop(context);
                          goToHome(allLocationsGPS[index].vendor_id);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.8),
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white

                            ),
                            margin:  EdgeInsets.all(MediaQuery.of(context).size.width/40),
                            padding:  EdgeInsets.all(MediaQuery.of(context).size.width/30),

                            child: Container(
                                alignment: Alignment.center,
                                //margin:EdgeInsets.all(double2),
                                child: Text(
                                  widget.lan==0?"${allLocationsGPS[index].nameEn}":"${allLocationsGPS[index].nameAr}"
                                  ,style: TextStyle(fontSize: MediaQuery.of(context).size.width/23),))
                        ),
                      ),
                    ],):
                    GestureDetector(
                      onTap:(){
                        goToHome(allLocationsGPS[index].vendor_id);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.8),
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white

                          ),
                          margin:  EdgeInsets.all(MediaQuery.of(context).size.width/40),
                          padding:  EdgeInsets.all(MediaQuery.of(context).size.width/30),

                          child: Container(
                              alignment: Alignment.center,
                              //margin:EdgeInsets.all(double2),
                              child: Text(
                                widget.lan==0?"${allLocationsGPS[index].nameEn}":"${allLocationsGPS[index].nameAr}"
                                ,style: TextStyle(fontSize: MediaQuery.of(context).size.width/23),))
                      ),
                    );
                  },
                ),
              ),
            ),
          );});
        }
    );


  }
  void showDialogeLanguage(BuildContext context){
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width/1.1,
              height: MediaQuery.of(context).size.height/1.1,
              decoration: ShapeDecoration(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),)),
              child: Container(
                child: Column(children: [
                  GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.8),
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white
                        ),
                        margin:  EdgeInsets.all(MediaQuery.of(context).size.width/40),
                        padding:  EdgeInsets.all(MediaQuery.of(context).size.width/30),

                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Container(
                              //margin:EdgeInsets.all(double2),
                                child: Text(
                                  translate('lan.language'),
                                  // "${AppLocalizations.of(context).language}",
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/23),)),
                            Expanded(child: Container()),
                            Container(
                                child:Icon(Icons.clear,size: MediaQuery.of(context).size.width/12,)
                            )
                          ],
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      setState(() {
                        widget.lan = 1;
                        translateLanguage = 1;
                      });
                      Navigator.pop(context);

                      changeLaguageAndGoToMyApp(1,context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.8),
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white

                        ),
                        margin:  EdgeInsets.all(MediaQuery.of(context).size.width/40),
                        padding:  EdgeInsets.all(MediaQuery.of(context).size.width/30),

                        child: Container(
                            alignment: Alignment.center,
                            //margin:EdgeInsets.all(double2),
                            child: Text( translate('lan.translateAr'),style: TextStyle(fontSize: MediaQuery.of(context).size.width/23),))
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      setState(() {
                        translateLanguage = 0;
                        widget.lan= 0;
                      });
                     Navigator.pop(context);
                      changeLaguageAndGoToMyApp(0,context);

                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.8),
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white

                        ),
                        margin:  EdgeInsets.all(MediaQuery.of(context).size.width/40),
                        padding:  EdgeInsets.all(MediaQuery.of(context).size.width/30),

                        child: Container(
                            alignment: Alignment.center,
                            //margin:EdgeInsets.all(double2),
                            child: Text(
                            translate('lan.translateEn'),style: TextStyle(fontSize: MediaQuery.of(context).size.width/23),))
                    ),
                  ),
                ],)
              ),
            ),
          ),
        );
      },
      // transitionBuilder: (_, anim, __, child) {
      //   return SlideTransition(
      //     position: Tween(begin: Offset(0, 0), end: Offset(0, 0)).animate(anim),
      //     child: child,
      //   );
      // },
    );

  }

  void goToHome(int id)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('vendorID', id);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void goToMyLocations()async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Locations()),
    );
  }

  void changeLaguageAndGoToMyApp(int translateLanguage, BuildContext context1,)async {
    LocalizationDelegate x=  LocalizedApp.of(context).delegate;
    final prefs = await SharedPreferences.getInstance();

    print("TTT $translateLanguage");


      if(widget.lan==0) {
        setState(() {
          x.changeLocale(Locale("en"));
          prefs.setInt('translateLanguage', 0);
        });

      }
      else {
       setState(() {
         x.changeLocale(Locale('ar',));
         prefs.setInt('translateLanguage', 1);
       });
      }




  }

}


/*

Center(
                  child: Text("Find Food You Love",style: TextStyle(fontSize: MediaQuery.of(context).size.width/20),),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/50,),
                Center(
                  child: Text("Discover the best foods from over 1000 restaurant and fast delivery to your doorstep",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,),textAlign: TextAlign.center,),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/50,),
 */


//Slider
/*
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/20),
              child: ImageAutoSlider(
                assetImages: [
                  AssetImage('assets/images/delivery.png'),
                  AssetImage('assets/images/broccoliOne.png'),
                  AssetImage('assets/images/broccoliTwo.png')
                ],
                imageHeight: MediaQuery.of(context).size.height/2.6,
                boxFit: BoxFit.fitHeight,
                slideMilliseconds: 700,
                durationSecond: 3,
              ),
            ),

 */