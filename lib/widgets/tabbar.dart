import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';




class AppTabBar extends StatelessWidget {
  String title;
  AppTabBar({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width:MediaQuery.of(context).size.width,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title,
    style: TextStyle(color: Colors.white,
                   fontWeight: FontWeight.bold,fontSize: 20),),
            centerTitle: true,
            backgroundColor:HexColor('#40976C'),
            shape: ContinuousRectangleBorder(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(60.0),
                bottomLeft: Radius.circular(60.0),

              ),),

            bottom: TabBar(
              indicatorColor: Colors.transparent,
              isScrollable: false,
              tabs: [
                Tab(icon: Icon(Icons.location_on_outlined,)),
                Tab(icon: SvgPicture.asset('assets/images/truck.svg',color: Colors.white,)),
                Tab(icon: Icon(Icons.list)),
                Tab(icon: Icon(Icons.credit_card)),


              ],

            ),

          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
