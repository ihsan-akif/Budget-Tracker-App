import 'dart:async';
import 'dart:convert';
import 'package:budget_tracker/CartPage.dart';
import 'package:budget_tracker/PaymentHistoryPage.dart';
import 'package:budget_tracker/SplashPage.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(EbookPage());

class EbookPage extends StatefulWidget {
  final User user;
  const EbookPage({Key key, this.user}) : super(key: key);

  @override
  _EbookPageState createState() => _EbookPageState();
}

@override
class _EbookPageState extends State<EbookPage> {
  List ebookData;
  double screenHeight, screenWidth;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  String titleCenter = "Loading\nPlease Wait...";
  String server = "http://shabab-it.com/budget_tracker";
  String cartQuantity = "0";
  int quantity = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEbook();
    _loadCartQuantity();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: backgroundColor,
              resizeToAvoidBottomPadding: false,
              body: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/Logo.png'))),
                  ),
                  Container(
                    color: Color.fromRGBO(255, 255, 255, 0.19),
                  ),
                  Column(
                    children: <Widget>[
                      ebookData == null
                          ? Flexible(
                              child: Container(
                                  child: Center(
                                      child: Text(
                              titleCenter,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))))
                          : Expanded(
                              child: ListView.builder(
                              itemCount: ebookData.length,
                              itemBuilder: (context, index) {
                                if (ebookData[index]['type'].toString() ==
                                    "Ebook") {
                                  return Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () =>
                                                  _onImageDisplay(index),
                                              child: Container(
                                                height: screenHeight / 5.9,
                                                width: screenWidth / 3.5,
                                                child: ClipRRect(
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        "http://shabab-it.com/budget_tracker/catalogue_images/${ebookData[index]['prodid']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  ebookData[index]['name'],
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "RM " +
                                                      ebookData[index]['price'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "ISBN: " +
                                                      ebookData[index]
                                                          ['prodid'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Author: " +
                                                      ebookData[index]
                                                          ['author'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Publisher: " +
                                                      ebookData[index]
                                                          ['publisher'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Date Release: " +
                                                      dateformat(ebookData[
                                                                  index]
                                                              ['daterelease']
                                                          .toString()),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 60),
                                                  child: MaterialButton(
                                                    color: secondaryColor,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .horizontal()),
                                                    minWidth: 100,
                                                    height: 30,
                                                    child: Text('Add to Cart'),
                                                    elevation: 10,
                                                    onPressed: () =>
                                                        _addToCartDialog(index),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                }return Container();
                              },
                            ))
                    ],
                  ),
                ],
              ),
              // floatingActionButton: FloatingActionButton.extended(
              //   backgroundColor: secondaryColor,
              //   onPressed: () async {
              //     if (widget.user.quantity == "0") {
              //       Toast.show("Cart empty", context,
              //           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              //       return;
              //     }
              //     await Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (BuildContext context) => EbookCartPage(
              //                   user: widget.user,
              //                 )));
              //     _loadEbook();
              //     _loadCartQuantity();
              //   },
              //   icon: Icon(
              //     MdiIcons.cart,
              //     color: Colors.black,
              //   ),
              //   label: Text(
              //     cartQuantity,
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
            )));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text("Exit an app?"),
                  content: new Text("Are you sure you want to exit"),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text("Exit"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("Cancel"),
                    )
                  ],
                )) ??
        false;
  }

  void _loadEbook() async {
    String urlLoadEbook =
        "http://shabab-it.com/budget_tracker/php/load_catalogue.php";
    await http.post(urlLoadEbook, body: {}).then((res) {
      if (res.body == "Catalogue Empty") {
        cartQuantity = "0";
        titleCenter = "No E-Book Found";
        print(res.body);
        setState(() {
          ebookData = null;
        });
      } else {
        setState(() {
          print(res.body);
          var extractdata = json.decode(res.body);
          ebookData = extractdata["catalogue"];
          cartQuantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _onImageDisplay(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: primaryColor,
              height: screenHeight / 2.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: screenWidth / 1.5,
                    width: screenWidth / 1.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: NetworkImage(
                                "http://shabab-it.com/budget_tracker/catalogue_images/${ebookData[index]['prodid']}.jpg"))),
                  )
                ],
              ),
            ),
          );
        });
  }

  String dateformat(String dateTime) {
    String yearFormat = dateTime.substring(0, 4);
    String monthFormat = dateTime.substring(5, 7);
    String month;

    switch (monthFormat) {
      case "01":
        month = "January";
        break;
      case "02":
        month = "February";
        break;
      case "03":
        month = "March";
        break;
      case "04":
        month = "April";
        break;
      case "05":
        month = "May";
        break;
      case "06":
        month = "Jun";
        break;
      case "07":
        month = "July";
        break;
      case "08":
        month = "August";
        break;
      case "09":
        month = "September";
        break;
      case "10":
        month = "October";
        break;
      case "11":
        month = "November";
        break;
      case "12":
        month = "December";
        break;
    }
    return month + " " + yearFormat;
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  _addToCartDialog(int index) {
    if (widget.user.email == "guest@budgettracker.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    // if (widget.user.email == "admin@grocery.com") {
    //   Toast.show("Admin Mode!!!", context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //   return;
    // }
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Add " + ebookData[index]['name'] + " to Cart?",
                style: TextStyle(
                    //color: Colors.white,
                    ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select the quantity of the E-Book",
                    style: TextStyle(
                        //color: Colors.white,
                        ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                                //color: Colors.white,
                                ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                quantity++;
                                // if (quantity <
                                //     (int.parse(ebookData[index]['quantity']) -
                                //         2)) {
                                //   quantity++;
                                // } else {
                                //   Toast.show("Quantity not available", context,
                                //       duration: Toast.LENGTH_LONG,
                                //       gravity: Toast.BOTTOM);
                                // }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: secondaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: secondaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )),
              ],
            );
          });
        });
  }

  void _addtoCart(int index) {
    if (widget.user.email == "guest@budgettracker.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    // if (widget.user.email == "admin@grocery.com") {
    //   Toast.show("Admin mode", context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //   return;
    // }
    try {
      int cquantity = int.parse(ebookData[index]["quantity"]);
      print(cquantity);
      print(ebookData[index]["prodid"]);
      print(widget.user.email);
      if (cquantity > 0) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Add to cart...");
      pr.show();
      String urlLoadJobs = server + "/php/insert_ebooktocart.php";
      http.post(urlLoadJobs, body: {
        "email": widget.user.email,
        "proisbn": ebookData[index]["prodid"],
        "quantity": quantity.toString(),
      }).then((res) {
        print(res.body);
        if (res.body == "failed") {
          Toast.show("Failed add to cart", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          pr.hide();
          return;
        } else {
          List respond = res.body.split(",");
          setState(() {
            cartQuantity = respond[1];
            widget.user.quantity = cartQuantity;
          });
          Toast.show("Success add to cart", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
        pr.hide();
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
