import'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Screens/Card/Card1MyProductDetials.dart';
import 'package:shormeh/Screens/Cats/1Categories.dart';
import 'package:shormeh/Screens/Locations.dart';
import 'package:shormeh/Screens/Offers/offers.dart';
import 'package:shormeh/Screens/SideBar/More.dart';
import 'package:shormeh/Screens/SideBar/MyPoints.dart';
import 'package:shormeh/Screens/user/login.dart';


    class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
      bool isLogin = false;
      bool menu = false;

      bool offers = false;

      bool home = true;

      bool profile = false;

      bool more = false;
     int _bottomNavIndex= 2;

      final List<Widget> pages = [
        Locations(),
        MyPoints(),
        HomeScreen(),
        Card1(),
        More(),
      ];

      final iconList = <IconData>[
        Icons.location_searching,
        Icons.local_offer,
        Icons.shopping_basket,
        Icons.menu,
      ];

      getDataFromSharedPref()async{
        final prefs = await SharedPreferences.getInstance();
        final _isLogin = prefs.getBool('isLogin');
        if(_isLogin==null){
          await prefs.setBool('isLogin',false);
        }else{
          setState(() {
            isLogin=_isLogin;
          });
        }
      }


      @override
  void initState() {
  getDataFromSharedPref();
    super.initState();
  }

      @override
      Widget build(BuildContext context) {


        return Column(
          children: [
            pages[_bottomNavIndex],
            Align(
              alignment: Alignment.bottomCenter,
              child: CurvedNavigationBar(
                index: 2,
                backgroundColor: Colors.transparent,



                items: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        iconList[0],
                        size: 30,
                        color: !menu ? Colors.black26 : Colors.white,
                      ),
                      !menu
                          ? Text(
                        translate('lan.home'),
                        style:
                        TextStyle(color: Colors.black26, fontSize: 12),
                      )
                          : Container()
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        iconList[1],
                        size: 30,
                        color: !offers ? Colors.black26 : Colors.white,
                      ),
                      !offers
                          ? Text(
                        translate('lan.myPoints'),
                        style:
                        TextStyle(color: Colors.black26, fontSize: 12),
                      )
                          : Container()
                    ],
                  ),
                  Icon(
                    Icons.home,
                    size: 35,
                    color: !home ? Colors.black26 : Colors.white,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        iconList[2],
                        size: 30,
                        color: !profile ? Colors.black26 : Colors.white,
                      ),
                      !profile
                          ? Text(
                        translate('lan.orders'),
                        style:
                        TextStyle(color: Colors.black26, fontSize: 12),
                      )
                          : Container()
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        iconList[3],
                        size: 30,
                        color: !more ? Colors.black26 : Colors.white,
                      ),
                      !more
                          ? Text(
                        translate('lan.more'),
                        style:
                        TextStyle(color: Colors.black26, fontSize: 12),
                      )
                          : Container()
                    ],
                  ),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      setState(() {
                        menu = true;
                        offers = false;
                        home = false;
                        profile = false;
                        more = false;
                        _bottomNavIndex = 0;
                      });
                      break;

                    case 1:
                      setState(() {
                        menu = false;
                        offers = true;
                        home = false;
                        profile = false;
                        more = false;
                      });
                      if(!isLogin)
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()));
                      else
                        setState(() {
                          _bottomNavIndex = 1;
                        });
                      break;
                    case 2:
                      setState(() {
                        menu = false;
                        offers = false;
                        home = true;
                        profile = false;
                        more = false;
                        _bottomNavIndex = 2;
                      });
                      break;
                    case 3:
                      setState(() {
                        menu = false;
                        offers = false;
                        home = false;
                        profile = true;
                        more = false;
                      });
                      if(!isLogin) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()));
                      }

                      else
                        setState(() {
                          _bottomNavIndex = 3;
                        });
                      break;
                    case 4:
                      setState(() {
                        menu = false;
                        offers = false;
                        home = false;
                        profile = false;
                        more = true;
                        _bottomNavIndex = 4;
                      });
                      break;
                  }
                },
                buttonBackgroundColor: HexColor('#707070'),
              ),
            )
          ],
        );
      }
}
