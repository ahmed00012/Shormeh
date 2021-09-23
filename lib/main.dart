import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shormeh/Screens/Card/Card6TaqeemElkhdma.dart';
import 'package:shormeh/Screens/Cats/1Categories.dart';
import 'package:shormeh/Screens/Home/getLocation.dart';

import 'package:shormeh/Screens/SelectBrabche.dart';

import 'Screens/Card/Card2MyAllProductsDetails.dart';
import 'Screens/Card/Card5OdrerStatus.dart';

import 'Screens/Home/HomePage.dart';
import 'Screens/Splash.dart';
import 'dart:ui' as ui;


void main() async{
  HttpOverrides.global = new MyHttpOverrides();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale:'en_US',
      supportedLocales: ['en_US', 'ar']);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  // runApp(Phoenix(child: MyApp()));
  runApp(LocalizedApp(delegate, MyApp()));
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _translateLanguage = 0;
  bool gotLocation;
  bool gotBranch ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // helper.onLocaleChanged = onLocaleChange;
    // _specificLocalizationDelegate =  SpecificLocalizationDelegate(new Locale("en"));
    _getDataFromSharedPref();

  }
  Future<void> _getDataFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();

    final _gotLocation = prefs.getBool('getLocation');
    final _branchSelected = prefs.getBool('branchSelected');

    setState(() {
      gotLocation = _gotLocation;
      gotBranch = _branchSelected;
    });
   _translateLanguage = prefs.getInt('translateLanguage');

    print(_translateLanguage);
    if (_translateLanguage!=null&&_translateLanguage==1) {
      await prefs.setInt('translateLanguage',1);
      print(_translateLanguage+5);
      // setState(() {
      //   helper.onLocaleChanged = onLocaleChange;
      //   _specificLocalizationDelegate =  SpecificLocalizationDelegate(new Locale("ar"));
      // });
    }

   else if (_translateLanguage==null||_translateLanguage==0) {
      await prefs.setInt('translateLanguage', 0);
      print("ENGLISH LANG");
      print(_translateLanguage);
      // setState(() {
      //   helper.onLocaleChanged = onLocaleChange;
      //   _specificLocalizationDelegate =  SpecificLocalizationDelegate(new Locale("en"));
      // });
    }
    else {
      print("ARABIC LANG");
      // setState(() {
      //   helper.onLocaleChanged = onLocaleChange;
      //   _specificLocalizationDelegate =  SpecificLocalizationDelegate(new Locale("ar"));
      // });
    }

  }


  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.black54,
        fontSize: 25.0
    );
  }



  Widget getHome(){
    if(gotLocation ==null)
      return GetLocation();

   else if(gotLocation!=null && gotBranch ==null)
      return SelectBranche();

   else if (gotBranch)
      return HomePage();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return
      FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LocalizationProvider(
           child: MaterialApp(
              debugShowCheckedModeBanner: false,
               theme: ThemeData(
                 primaryColor: HomePage.colorGreen,
                 accentColor: HomePage.colorGreen,
                 cursorColor: HomePage.colorGreen,
                 fontFamily: 'Tajawal',
                 //primarySwatch: HomePage.colorBlue,
               ),
              routes: <String , WidgetBuilder>{
                '/home': (BuildContext  context) => new HomePage(),
                '/orderMethod':(BuildContext c)=> new Card2(),
                '/message': (BuildContext  context) => new OrderStatus(),
                '/taqeem': (BuildContext  context) => new Card6TaqeemElkhdma(),
                '/selectBranche': (BuildContext  context) => new SelectBranche(),
                '/myApp': (BuildContext  context) => new MyApp(),


              },
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                // new FallbackCupertinoLocalisationsDelegate(),
                // //app-specific localization
                // _specificLocalizationDelegate
              ],
              supportedLocales: [Locale('en'),Locale('ar')],

              locale: ui.window.locale,
              home: Splash()));
        }
        else {
          // Loading is done, return the app:
          return LocalizationProvider(

          child: MaterialApp(
            title: 'شورمية',
            routes: <String , WidgetBuilder>{
              '/home': (BuildContext  context) => new HomePage(),
              '/orderMethod':(BuildContext c)=> new Card2(),
              '/message': (BuildContext  context) => new OrderStatus(),
              '/taqeem': (BuildContext  context) => new Card6TaqeemElkhdma(),
              '/selectBranche': (BuildContext  context) => new SelectBranche(),
              '/myApp': (BuildContext  context) => new MyApp(),
              '/categories': (BuildContext  context) => new HomeScreen(),


            },
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              // new FallbackCupertinoLocalisationsDelegate(),
              // //app-specific localization
              // _specificLocalizationDelegate
            ],
            supportedLocales: [Locale('en'),Locale('ar')],
            locale: ui.window.locale,

            // locale:  _specificLocalizationDelegate.overriddenLocale,
            //home: SubCats(),
            //home: SignUp(),
            //home: ProductDetails(),
            //home: HomePage(),
            home: getHome(),
            //home: Locations(),
            //home: TestPage(),
            //home: OrderStatus(),
            //home: Card6TaqeemElkhdma(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: HomePage.colorGreen,
              accentColor: HomePage.colorGreen,
              cursorColor: HomePage.colorGreen,
              fontFamily: 'Tajawal',
              //primarySwatch: HomePage.colorBlue,
            ),
          ));
        }
      },

    );
  }

}

