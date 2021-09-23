import 'dart:convert';
import 'dart:developer';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh/Models/ProductsModel.dart';
import 'package:shormeh/Screens/Cats/1Categories.dart';
import 'package:shormeh/Screens/Cats/3ProductDetails.dart';
import 'package:shormeh/Screens/Home/HomePage.dart';



class Products extends StatefulWidget {
  int catID;
int vendorID;

  Products({
    Key key,
    this.catID,
    this.vendorID
  }) : super(key: key);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {



final scrollController = ScrollController();

  bool isIndicatorActive=true;

  List<ProductsModel> allSubCats= new List<ProductsModel>();

  bool isHome=true;
final PagingController<int, ProductsModel> _pagingController =
PagingController(firstPageKey: 0);




int translationLanguage;

  String subCatName="";
  String lan = '';

  int currentPage= 1;
// bool isLoadingVertical = false;
int increment =1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getAllSubCats();
    getDataFromSharedPref();
    _pagingController.addPageRequestListener((pageKey) {
      getAllSubCats(pageKey) ;
    });


  }
  Future<void> getDataFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();

    final _vendorID = prefs.getInt('vendorID');
    final _translateLanguage = prefs.getInt('translateLanguage');


    setState(() {
      translationLanguage=_translateLanguage;
      _translateLanguage==0?lan='en':lan='ar';
    });
    print(lan);

  }

@override
void dispose() {
  _pagingController.dispose();
  super.dispose();
}





  Future getAllSubCats(int pageKey) async {



Uri url = Uri.parse("${HomePage.URL}vendors/${widget.vendorID}/${widget.catID}/products?page=$currentPage");

    var response =
    await http.get(url,
        headers: {
      "Content-Language":lan
    });
    ;
     var dataAllSubCats = json.decode(response.body);


final isLastPage = dataAllSubCats['products']['data'].length < 5;


      for(int i=0 ;i<dataAllSubCats['products']['data'].length;i++){
  allSubCats.add(new ProductsModel(
    dataAllSubCats['products']['data'][(i + increment).toString()]['id'],
    dataAllSubCats['products']['data'][(i + increment).toString()]['image_one'],
    dataAllSubCats['products']['data'][(i + increment).toString()]['name'],
    dataAllSubCats['products']['data'][(i + increment)
        .toString()]['translations'][0]['name'],
    dataAllSubCats['products']['data'][(i + increment)
        .toString()]['translations'][1]['name'],
    dataAllSubCats['products']['data'][(i + increment).toString()]['price'],

  ));

      }

if (isLastPage) {
  _pagingController.appendLastPage(allSubCats.sublist(increment-1));
} else {
  final nextPageKey = pageKey + dataAllSubCats['products']['data'].length ;
  _pagingController.appendPage(allSubCats, nextPageKey);
}

    setState(() {
      currentPage++;
      increment=increment+5;
      // isLoadingVertical = false;

    });





  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
        translate('lan.appName'),),
        backgroundColor:  HexColor('#40976c'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return HomePage(isHomeScreen: true,);
                },
              ),
                  (_) => false,
            );
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        elevation: 5.0,
      ),
      body:PagedListView<int, ProductsModel>(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<ProductsModel>(
            firstPageProgressIndicatorBuilder:(_)=>Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/4.5,

                  margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width/30,
                    MediaQuery.of(context).size.width/50,
                    MediaQuery.of(context).size.width/30,
                    MediaQuery.of(context).size.width/50,
                  ),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                child:    ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child:Image.asset(
                    'assets/images/2705-image-loading.gif',
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),


                  // Image.network(
                  //   "${allSubCats[index].image}",
                  //   fit: BoxFit.fill,
                  //   width: double.infinity,
                  //   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                  //     if (loadingProgress == null) return child;
                  //     return Container(
                  //       color: Colors.black12,
                  //     );
                  //   },
                  //
                  // ),

                ),
              ),
                Container(
                  height: MediaQuery.of(context).size.height/4.5,

                  margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width/30,
                    MediaQuery.of(context).size.width/50,
                    MediaQuery.of(context).size.width/30,
                    MediaQuery.of(context).size.width/50,
                  ),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child:    ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child:Image.asset(
                      'assets/images/2705-image-loading.gif',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),


                    // Image.network(
                    //   "${allSubCats[index].image}",
                    //   fit: BoxFit.fill,
                    //   width: double.infinity,
                    //   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                    //     if (loadingProgress == null) return child;
                    //     return Container(
                    //       color: Colors.black12,
                    //     );
                    //   },
                    //
                    // ),

                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height/4.5,

                  margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width/30,
                    MediaQuery.of(context).size.width/50,
                    MediaQuery.of(context).size.width/30,
                    MediaQuery.of(context).size.width/50,
                  ),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child:    ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child:Image.asset(
                      'assets/images/2705-image-loading.gif',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),


                    // Image.network(
                    //   "${allSubCats[index].image}",
                    //   fit: BoxFit.fill,
                    //   width: double.infinity,
                    //   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                    //     if (loadingProgress == null) return child;
                    //     return Container(
                    //       color: Colors.black12,
                    //     );
                    //   },
                    //
                    // ),

                  ),
                ),

              ],
            ),
            newPageProgressIndicatorBuilder: (_)=> Center(child: CircularProgressIndicator(color:HexColor('#40976c'),)),
            itemBuilder: (context, item, index) {
              return  GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetails(productID: allSubCats[index].id)),
                  );
                },
                child:Container(
                    height: MediaQuery.of(context).size.height/4.5,

                    margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width/30,
                      MediaQuery.of(context).size.width/50,
                      MediaQuery.of(context).size.width/30,
                      MediaQuery.of(context).size.width/50,
                    ),
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child:Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child:FadeInImage.assetNetwork(
                            placeholder: 'assets/images/2705-image-loading.gif',
                            image: "${allSubCats[index].image}",
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ),


                          // Image.network(
                          //   "${allSubCats[index].image}",
                          //   fit: BoxFit.fill,
                          //   width: double.infinity,
                          //   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                          //     if (loadingProgress == null) return child;
                          //     return Container(
                          //       color: Colors.black12,
                          //     );
                          //   },
                          //
                          // ),

                        ),
                        Align(

                          child: Container(
                            width: size.width,
                            height: size.height/9,

                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                bottomLeft:
                                const Radius.circular(10.0),
                                bottomRight:
                                const Radius.circular(10.0),
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

                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                        Container (
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width/3),
                          child: Row(
                            children: [



                              SizedBox(width: MediaQuery.of(context).size.width/20,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.8,
                                child: Text(translationLanguage==0?"${allSubCats[index].nameEn}":"${allSubCats[index].nameAr}",
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,color: Colors.white,fontWeight: FontWeight.bold)),
                              ),
                              Expanded(child: Container()),
                              Row(
                                children: [
                                  Text("${allSubCats[index].price}",
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width/25,
                                        color: HomePage.colorYellow),),
                                  Text(translate('lan.rs'),
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,
                                        fontWeight: FontWeight.bold,color: HomePage.colorYellow),),
                                ],
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/20,),

                            ],
                          ),
                        )
                      ],
                    )
                ),

              );


            }
        ),


      )



      // LazyLoadScrollView(
      //   isLoading: isLoadingVertical,
      //   onEndOfPage: () => getAllSubCats(),
      //   child: Container(
      //     height: MediaQuery.of(context).size.height,
      //     child: Column(
      //       children: [
      //         Expanded(
      //           child: ListView(
      //             shrinkWrap: true,
      //             children: [
      //               ListView.builder(
      //                   shrinkWrap : true,
      //                   physics:NeverScrollableScrollPhysics(),
      //                   itemCount: allSubCats.length,
      //                   padding: EdgeInsets.fromLTRB(0.0,MediaQuery.of(context).size.width/50,0.0,MediaQuery.of(context).size.width/50),
      //                   itemBuilder: (BuildContext context, int index) {
      //                     return GestureDetector(
      //                       onTap: () {
      //                         Navigator.push(
      //                           context,
      //                           MaterialPageRoute(builder: (context) => ProductDetails(productID: allSubCats[index].id)),
      //                         );
      //                       },
      //                       child:Container(
      //                           height: MediaQuery.of(context).size.height/4.5,
      //
      //                           margin: EdgeInsets.fromLTRB(
      //                             MediaQuery.of(context).size.width/30,
      //                             MediaQuery.of(context).size.width/50,
      //                             MediaQuery.of(context).size.width/30,
      //                             MediaQuery.of(context).size.width/50,
      //                           ),
      //                           decoration:  BoxDecoration(
      //                             borderRadius: BorderRadius.all(
      //                               Radius.circular(10.0),
      //                             ),
      //                           ),
      //                           child:Stack(
      //                             children: [
      //                               ClipRRect(
      //                                 borderRadius: BorderRadius.circular(10.0),
      //                                 child: Image.network(
      //                                     "${allSubCats[index].image}",
      //                                     fit: BoxFit.fill,
      //                                     width: double.infinity,
      //                                     loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
      //                                       if (loadingProgress == null) return child;
      //                                       return Container(
      //                                         color: Colors.black12,
      //                                       );
      //                                     },
      //
      //                                 ),
      //
      //                               ),
      //                               Align(
      //
      //                                 child: Container(
      //                                   width: size.width,
      //                                   height: size.height/9,
      //
      //                                   decoration: BoxDecoration(
      //                                     borderRadius: new BorderRadius.only(
      //                                       bottomLeft:
      //                                       const Radius.circular(10.0),
      //                                       bottomRight:
      //                                       const Radius.circular(10.0),
      //                                     ),
      //                                     gradient: LinearGradient(
      //                                       colors: [
      //                                         Colors.black.withOpacity(0.02),
      //                                         Colors.black.withOpacity(0.5),
      //                                         Colors.black.withOpacity(0.7),
      //                                       ],
      //                                       begin: Alignment.topCenter,
      //                                       end: Alignment.bottomCenter,
      //                                     ),
      //                                   ),
      //
      //                                 ),
      //                                 alignment: Alignment.bottomCenter,
      //                               ),
      //                               Container (
      //                                 margin: EdgeInsets.only(top: MediaQuery.of(context).size.width/3),
      //                                 child: Row(
      //                                   children: [
      //
      //
      //
      //                                     SizedBox(width: MediaQuery.of(context).size.width/20,),
      //                                     Container(
      //                                       width: MediaQuery.of(context).size.width/1.8,
      //                                       child: Text(translationLanguage==0?"${allSubCats[index].nameEn}":"${allSubCats[index].nameAr}",
      //                                           style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,color: Colors.white,fontWeight: FontWeight.bold)),
      //                                     ),
      //                                     Expanded(child: Container()),
      //                                     Row(
      //                                       children: [
      //                                         Text("${allSubCats[index].price}",
      //                                           style: TextStyle(fontWeight: FontWeight.bold,
      //                                               fontSize: MediaQuery.of(context).size.width/25,
      //                                               color: HomePage.colorYellow),),
      //                                         Text(translate('lan.rs'),
      //                                           style: TextStyle(fontSize: MediaQuery.of(context).size.width/25,
      //                                               fontWeight: FontWeight.bold,color: HomePage.colorYellow),),
      //                                       ],
      //                                     ),
      //                                     SizedBox(width: MediaQuery.of(context).size.width/20,),
      //
      //                                   ],
      //                                 ),
      //                               )
      //                             ],
      //                           )
      //                       ),
      //
      //                     );
      //                   }),
      //             const SizedBox(height: 60,)
      //             ],
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
