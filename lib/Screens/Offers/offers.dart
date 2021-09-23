import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/OffersModel.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:shormeh/Screens/Offers/OfferDetails.dart';


class Offers extends StatefulWidget {
  Offers({Key key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  List<OffersModel> allOffers= new List<OffersModel>();

  bool isIndicatorActive=false;



  String token="";

  int translationLanguage=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();
  }

  Future getDataFromSharedPrfs()async{
    final prefs = await SharedPreferences.getInstance();
    final _translateLanguage = prefs.getInt('translateLanguage');

    final _cardToken= prefs.getString("cardToken");
    final _token= prefs.getString("token");
    setState((){
      token=_token;
      translationLanguage=_translateLanguage;
    });

    print("$token");
    getAllOffers();
  }

  onBackPressed(BuildContext context) async{
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //     HomePage(index:0)), (Route<dynamic> route) => false);
  }
  Future getAllOffers() async {
    var response =
    await http.get("${HomePage.URL}customer/notifications?limit=10",headers: {
      "Authorization": "Bearer $token",
    });

    var data = json.decode(response.body);
    print("$data");

    setState(() {
      for(int i=0;i<data['data'].length;i++){

        //allSubCats.add(new ProductsModel(dataAllSubCats[i]['id'],dataAllSubCats[i]['category']['image'],dataAllSubCats[i]['name'],dataAllSubCats[i]['category']['translations'][0]['name'],dataAllSubCats[i]['category']['translations'][1]['name']));
        allOffers.add(new OffersModel(
          data['data'][i]['id'],
          data['data'][i]['title'],
          data['data'][i]['description'],
          data['data'][i]['image']
        ));
      }
      //فى اللحظة دية كل الصيدليات بكل الاقسام اتحملت
      isIndicatorActive=false;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#40976c'),
        title: Text(translate('lan.offers')),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed:()=>onBackPressed(context),
        ),
      ),
      body: Container(
        child:isIndicatorActive?Center(child: CircularProgressIndicator(),):
        ListView.builder(
            shrinkWrap : true,
            physics: ScrollPhysics(),
            itemCount: allOffers.length,
            padding: EdgeInsets.fromLTRB(0.0,MediaQuery.of(context).size.width/50,0.0,MediaQuery.of(context).size.width/50),

            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OfferDetails(
                        id: allOffers[index].id,
                        description: allOffers[index].description,
                        image: allOffers[index].image,
                    )),
                  );
                },
                child:Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width/30,
                        MediaQuery.of(context).size.width/50,
                        MediaQuery.of(context).size.width/30,
                        MediaQuery.of(context).size.width/50,
                      ),

                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: HomePage.colorGreen, spreadRadius: 0.0),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image(
                          width: MediaQuery.of(context).size.width ,
                          height: MediaQuery.of(context).size.height / 4.5,
                          image:NetworkImage("${allOffers[index].image}"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width/30,
                        MediaQuery.of(context).size.width/50,
                        MediaQuery.of(context).size.width/30,
                        MediaQuery.of(context).size.width/50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(

                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width/1.1,
                                child: Text("${allOffers[index].title}",
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width/1.1,
                                child: Text("${allOffers[index].description}",
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/30,overflow: TextOverflow.ellipsis,),
                                  maxLines: 1,
                                ),
                              ),


                              Row(
                                children: [
                                  Container(
                                    width:translationLanguage==1? MediaQuery.of(context).size.width/1.3:0.0,
                                  ),
                                  Container(
                                    child: Text(translate('lan.more')+'...',
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width/25,
                                          color: HomePage.colorYellow),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              );
            }),
      ),
    );
  }

  void displayToastMessage(var toastMessage) {
    Fluttertoast.showToast(
        msg: toastMessage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
