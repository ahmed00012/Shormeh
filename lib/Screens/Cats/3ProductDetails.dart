import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/Addon.dart';
import 'package:shormeh/Models/Options.dart';
import 'package:shormeh/Models/ProductDetailsModel.dart';
import 'package:shormeh/Models/Slider.dart';
import 'package:shormeh/Screens/Card/Card1MyProductDetials.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';
import 'package:shormeh/Screens/user/login.dart';

class ProductDetails extends StatefulWidget {
  int productID;
  String productTotal;

  ProductDetails({
    Key key,
    this.productID,
    this.productTotal,
  }) ;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductDetailsModel productDetailsModel =
      new ProductDetailsModel(0, "", "", "", "", "", "");
  bool isIndicatorActive = true;
  List<SliderModel> allSliderImagesProduct = new List<SliderModel>();
  List<AddonModel> allAddons = new List<AddonModel>();
  List<OptionsModel> allOptions = new List<OptionsModel>();
  TextEditingController tECNotes = new TextEditingController();
  List<String> images= [];
  String lan = '';

  int portinsNum = 1;

  String cardToken = "";

  bool isLogin;
  int vendorID;
  int translationLanguage = 0;
  double totalAddOns = 0.0;
  double totalOptions=0.0;
  double total=0.0;
  String token='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSharedPrfs();

  }

  Future getDataFromSharedPrfs() async {
    final prefs = await SharedPreferences.getInstance();
    final _translateLanguage = prefs.getInt('translateLanguage');
    final _cardToken = prefs.getString("cardToken");
    final _vendorID = prefs.getInt("vendorID");
    final _isLogin = prefs.getBool("isLogin");
    final _token= prefs.getString("token");
    print(_token);
    setState(() {
      token=_token;
      vendorID = _vendorID;
      _translateLanguage == 0 ? lan = 'en' : lan = 'ar';
      translationLanguage = _translateLanguage;
    });
    if (_cardToken != null) {
      setState(() {
        cardToken = _cardToken;
      });
      getProductDetails();
    } else {
      getProductDetails();
    }

    if (_isLogin == null) {
      setState(() {
        isLogin = false;
      });
    } else {
      setState(() {
        isLogin = _isLogin;
      });
    }


    print(widget.productID);
  }


  Future getProductDetails() async {
    var response = await http.get(
        "${HomePage.URL}products/${widget.productID}/details",
        headers: {"Content-Language": lan});

    var dataProductDetails = json.decode(response.body);
    log(dataProductDetails.toString());

    setState(() {
      //allSubCats.add(new ProductsModel(dataAllSubCats[i]['id'],dataAllSubCats[i]['category']['image'],dataAllSubCats[i]['name'],dataAllSubCats[i]['category']['translations'][0]['name'],dataAllSubCats[i]['category']['translations'][1]['name']));
      productDetailsModel = ProductDetailsModel(
          dataProductDetails['id'],
          dataProductDetails['image_one'],
          dataProductDetails['name'],
          dataProductDetails['translations'][0]['name'],
          dataProductDetails['translations'][1]['name'],
          dataProductDetails['description'],
          dataProductDetails['price'],
      );

      //Addons
      for (int i = 0; i < dataProductDetails['addon'].length; i++) {
        allAddons.add(new AddonModel(
            dataProductDetails['addon'][i]["id"],
            dataProductDetails['addon'][i]["name_ar"],
            dataProductDetails['addon'][i]["name_en"],
            dataProductDetails['addon'][i]["price"]));
      }
      //Options
      for (int i = 0; i < dataProductDetails['options'].length; i++) {
        allOptions.add(new OptionsModel(
            dataProductDetails['options'][i]["id"],
            dataProductDetails['options'][i]["text"],
            dataProductDetails['options'][i]["text_ar"],
            dataProductDetails['options'][i]["price"]));
      }
      totalOptions = double.parse(dataProductDetails['price']);
      //Slider
      images.add(dataProductDetails['image_one']);
      if(dataProductDetails['image_two']!=null)
        images.add(dataProductDetails['image_two']);
      if(dataProductDetails['image_three']!=null)
        images.add(dataProductDetails['image_three']);

      isIndicatorActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          translate('lan.appName'),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor:  HexColor('#40976c'),
        leading: GestureDetector(
          onTap: () {
          Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        elevation: 5.0,
      ),
      body: Directionality(
        textDirection:   translationLanguage == 1?TextDirection.rtl:TextDirection.ltr,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  //Slider
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    child:images.length==1?Image.network(images[0]):CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 1000),
                        height: MediaQuery.of(context).size.height,
                        viewportFraction: 1.0,
                      ),
                      items:images.map((e) {
                        return InkWell(
                          child:  Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                e,
                                fit: BoxFit.fill,
                                loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.black12,
                                  );
                                },
                              )),
                        );
                      }).toList(),

                    ),



                  ) ,

                  //Body
                  Container(
                    margin:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 50),
                    alignment: Alignment.center,
                    child: Text(
                      translationLanguage == 0
                          ? "${productDetailsModel.nameEn}"
                          : "${productDetailsModel.nameAr}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 25),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 100),
                    child: Text(
                      "${productDetailsModel.description}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 25),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                       widget.productTotal==null? portinsNum==1?((totalOptions+totalAddOns)*portinsNum).toString():
                       "$total":widget.productTotal,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 20,
                            color: HexColor('#40976c')),
                      ),
                      Text(
                        ' '+translate('lan.rs'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 20,
                            color: HexColor('#40976c')),
                      ),
                    ],
                  ),

                  //Options
                  allOptions.length>0? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          translate('lan.customYourOptions'),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 25,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5,),
                        Text('['+translate('lan.chooseOne')+']',
                          style: TextStyle(color: HexColor('#40976c') ),)


                      ],
                    ),
                  ):Container(),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: allOptions.length,
                      padding: EdgeInsets.fromLTRB(
                          0.0,
                          MediaQuery.of(context).size.width / 50,
                          0.0,
                          MediaQuery.of(context).size.width / 50),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {

                            setState(() {
                           // total =    total + double.parse(allOptions[index].price);
                              if (allOptions[index].isSelected == false) {
                                allOptions[index].isSelected = true;
                                totalOptions =  double.parse(allOptions[index].price);
                                total=((totalOptions+totalAddOns)*portinsNum);
                                for (int i = 0; i < allOptions.length; i++) {
                                  if (i != index) {
                                    allOptions[i].isSelected = false;

                                  }
                                }
                              } else if (allOptions[index].isSelected == true) {
                                for (int i = 0; i < allOptions.length; i++) {
                                  allOptions[i].isSelected = false;

                                }
                              }
                            });

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  color: Color(0xfff7f7f7),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xfff7f7f7),
                                        spreadRadius: 0.0),
                                  ],
                                ),
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width / 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                          child: Text(
                                        translationLanguage == 0
                                            ? "${allOptions[index].text}"
                                            : "${allOptions[index].text_ar}",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25),
                                      )),
                                    ),
                                    Text(
                                      "${allOptions[index].price}"+' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              MediaQuery.of(context).size.width /
                                                  30,
                                          color: HexColor('#40976c')),
                                    ),
                                    Text(
                                      translate('lan.rs'),
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(context).size.width /
                                                  30,
                                          fontWeight: FontWeight.bold,
                                          color: HexColor('#40976c')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                                      child: SvgPicture.asset(
                                        'assets/images/comment.svg',
                                        height: 20,
                                        width: 20,
                                        color: allOptions[index].isSelected
                                            ? Colors.green[600]
                                            : Colors.black12,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      }),

                  //Addons
                  allAddons.length>0? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          translate('lan.customYourOrder'),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 25,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5,),
                        Text('['+translate('lan.optional')+']',
                          style: TextStyle(color: HexColor('#40976c') ),)


                      ],
                    ),
                  ):Container(),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: allAddons.length,
                      padding: EdgeInsets.fromLTRB(
                          0.0,
                          MediaQuery.of(context).size.width / 50,
                          0.0,
                          MediaQuery.of(context).size.width / 50),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(

                          onTap: () {
                            print(allAddons[index].price.toString()+'hhhhh');

                            setState(() {
                              // total =    total + double.parse(allOptions[index].price);
                              if (allAddons[index].isSelected == false) {
                                allAddons[index].isSelected = true;
                                totalAddOns =    totalAddOns  + double.parse(allAddons[index].price);
                                total=((totalOptions+totalAddOns)*portinsNum);
                              } else {
                                allAddons[index].isSelected = false;
                                totalAddOns  =    totalAddOns  - double.parse(allAddons[index].price);
                                total=((totalOptions+totalAddOns)*portinsNum);
                              }
                            });
                            print(total.toString()+'jjjjjjj');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  color: Color(0xfff7f7f7),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xfff7f7f7),
                                        spreadRadius: 0.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          translationLanguage == 0
                                          ? "${allAddons[index].nameEn}"
                                          : "${allAddons[index].nameAr}",
                                          style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              24),
                                        ),
                                      ),
                                      Text(
                                        "${allAddons[index].price}"+' ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                MediaQuery.of(context).size.width /
                                                    30,
                                            color: HexColor('#40976c')),
                                      ),
                                      Text(
                                        translate('lan.rs'),
                                        style: TextStyle(
                                            fontSize:
                                                MediaQuery.of(context).size.width /
                                                    30,
                                            fontWeight: FontWeight.bold,
                                            color: HexColor('#40976c')),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                        child: SvgPicture.asset(
                                          'assets/images/comment.svg',
                                          height: 20,
                                          width: 20,
                                          color: allAddons[index].isSelected
                                              ? HexColor('#40976c')
                                              : Colors.black12,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        );
                      }),

                  const SizedBox(
                    height: 10,
                  ),
                  //Notes
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 30,
                      0,
                      MediaQuery.of(context).size.width / 30,
                      0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          translate('lan.notes')+' ',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('[' + translate('lan.optional') + ']',
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width / 30,
                                color: HomePage.colorGrey)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(20),
                          border: Border.all(color: HexColor('#DDDDDD'))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration.collapsed(
                              hintText: translate('lan.leftYourNotes'),
                              hintStyle: TextStyle(color: Colors.black),
                            )),
                      ),
                    ),
                  ),

                  //Portions

                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translate('lan.numOfOrders'),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (portinsNum > 1)
                            setState(() {
                              portinsNum--;
                              total = (totalAddOns + totalOptions)*portinsNum;
                            });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: HexColor('#40976C'),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '-',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: HexColor('#40976C'),
                            )),
                        child: Center(
                          child: Text(
                            portinsNum.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            portinsNum++;
                            total = (totalAddOns + totalOptions)*portinsNum;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: HexColor('#40976C'),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  //Submit
                  InkWell(
                    onTap: () => showCupertinoModalBottomSheet(
                        expand: false,
                        context: context,
                        backgroundColor: Colors.white.withOpacity(0.7),
                        builder: (context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            FocusScope.of(context).unfocus();
                            return Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        MediaQuery.of(context).size.width / 25),
                                    topRight: Radius.circular(
                                        MediaQuery.of(context).size.width / 25),
                                  ),
                                ),
                                child: Column(
                                  //mainAxisSize: MainAxisSize.min,
                                  //mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    //ايقونة النزول
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Container(
                                            child: CircleAvatar(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(
                                                  Icons.expand_more,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      10,
                                                  color: HomePage.colorGreen,
                                                ),
                                              ),
                                              backgroundColor: Colors.transparent,
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width /
                                                35),
                                        child: Container(
                                          margin: new EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15),
                                          child: ButtonTheme(
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            minWidth: 500.0,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            child: RaisedButton(
                                              child: Text(
                                                  translate(
                                                      'lan.etmamElshraa'),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          20,
                                                      color: Colors.white)),
                                              color: HomePage.colorGreen,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                SendDataToServer(context);
                                              },
                                            ),
                                          ),
                                        ))
                                  ],
                                ));
                          });
                        }),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: HomePage.colorGreen),
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 15),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                child: Text(
                              translate('lan.addToCard'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 24),
                            )),
                            // Expanded(child: Container()),
                            // Container(
                            //     child: Text("${AppLocalizations.of(context).rs} ",style: TextStyle(color:HomePage.colorYellow,fontSize: MediaQuery.of(context).size.width/25,fontWeight: FontWeight.bold),)),
                          ],
                        )),
                  ),
                  const SizedBox(height: 30,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  Future SendDataToServer(BuildContext context) async {
    var listOptions = [];
    for (int i = 0; i < allOptions.length; i++) {

      if (allOptions[i].isSelected) {
        listOptions.add(allOptions[i].id);
      }
    }

    if (allOptions.length > 0) {
      if (listOptions.length == 0) {
        displayToastMessage(translate('lan.pleaseChooseSize'));
        return;
      }
    }

    var listAddons = [];
    for (int i = 0; i < allAddons.length; i++) {
      if (allAddons[i].isSelected) {
        listAddons.add(allAddons[i].id);
        print(allAddons[i].nameEn);
      }
    }

    var response;

    print(token);
    print(vendorID);
    print(productDetailsModel.id);
    print(portinsNum);
    print(listOptions);
    print(listAddons);
    print(cardToken.length);

    if (cardToken == "" || cardToken == null) {

      response = await http.post("${HomePage.URL}cart/add_product", body: {
        "vendor_id": "$vendorID",
        "product_id": "${productDetailsModel.id}",
        "quantity": "$portinsNum",
        "options": "$listOptions",
        "addons": "$listAddons",
        "note": "${tECNotes.text}",
      });
      print('sdkufgdslkuf');
      var dataOrder = json.decode(response.body);
      displayToastMessage("${dataOrder['message']}");

      if ("${dataOrder['success']}" == "1") {
        print("LLLLLLLLLLLLLLLLL ${dataOrder['cart']['token']}");
        saveDataInSharedPref(context, dataOrder['cart']['token']);
      }
    }
    else {
      print('llllllllllpppppppppppppppp');
      response = await http.post("${HomePage.URL}cart/add_product", body: {
        "vendor_id": "$vendorID",
        "product_id": "${productDetailsModel.id}",
        "quantity": "$portinsNum",
        "cart_token": cardToken,
        "options": "$listOptions",
        "addons": "$listAddons",
        "note": "${tECNotes.text}",

      });
      var dataOrder = json.decode(response.body);

      print("Card Token => $cardToken");

      if ("${dataOrder['success']}" == "1") {
        goToMyCard();
      }
    }
  }
  // Future SendDataToServer(BuildContext context) async {
  //   var listOptions = [];
  //   for(int i=0;i<allOptions.length;i++){
  //     if(allOptions[i].isSelected){
  //       listOptions.add(allOptions[i].id);
  //     }
  //   }
  //
  //   if(allOptions.length>0){
  //     if(listOptions.length==0){
  //       displayToastMessage(translate('lan.pleaseChooseSize'));
  //       return;
  //     }
  //   }
  //
  //   var listAddons = [];
  //   for(int i=0;i<allAddons.length;i++){
  //     if(allAddons[i].isSelected){
  //       listAddons.add(allAddons[i].id);
  //     }
  //   }
  //
  //   var response;
  //   if(cardToken==""||cardToken==null){
  //     response = await http.post("${HomePage.URL}cart/add_product",body: {
  //       "vendor_id": "$vendorID",
  //       "product_id": "${productDetailsModel.id}",
  //       "quantity": "$portinsNum",
  //       "options": "$listOptions",
  //       "addons": "$listAddons",
  //       "note": "${tECNotes.text}",
  //     });
  //
  //     var dataOrder = json.decode(response.body);
  //     displayToastMessage("${dataOrder['message']}");
  //
  //     if("${dataOrder['success']}"=="1"){
  //       print("LLLLLLLLLLLLLLLLL ${dataOrder['cart']['token']}");
  //       saveDataInSharedPref(context,dataOrder['cart']['token']);
  //
  //     }
  //   }else{
  //
  //     response = await http.post("${HomePage.URL}cart/add_product",body: {
  //       "vendor_id": "$vendorID",
  //       "product_id": "${productDetailsModel.id}",
  //       "quantity": "$portinsNum",
  //       "cart_token": cardToken,
  //       "options": "$listOptions",
  //       "addons": "$listAddons",
  //       "note": "${tECNotes.text}",
  //     });
  //     var dataOrder = json.decode(response.body);
  //
  //     print("Card Token => $cardToken");
  //
  //     if("${dataOrder['success']}"=="1"){
  //       goToMyCard();
  //     }
  //   }
  //
  //
  //
  //
  // }

  void saveDataInSharedPref(BuildContext context, cardTokenP) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('cardToken', cardTokenP);
    setState(() {
      cardToken = cardTokenP;
    });
    goToMyCard();
  }

  goToMyCard() {
    if (isLogin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Card1()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  goToHome(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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
