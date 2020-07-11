import 'dart:convert';
import 'package:budget_tracker/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(ConsultancyServicePage());

class ConsultancyServicePage extends StatefulWidget {
  final User user;
  const ConsultancyServicePage({Key key, this.user}) : super(key: key);

  @override
  _ConsultancyServicePageState createState() => _ConsultancyServicePageState();
}

class _ConsultancyServicePageState extends State<ConsultancyServicePage> {
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  String titleCenter = "Loading\nPlease Wait...";
  String server = "http://shabab-it.com/budget_tracker";
  String cartQuantity = "0";
  int quantity = 1;
  List consultantData;
  double screenHeight, screenWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadConsultant();
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
                consultantData == null
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
                            itemCount: consultantData.length,
                            itemBuilder: (context, index) {
                              if (consultantData[index]['type'].toString() ==
                                  "Consultant") {
                                return Container(
                                    child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () =>
                                                    _onImageDisplay(index),
                                                child: Container(
                                                  height: screenHeight / 5.9,
                                                  width: screenWidth / 3.5,
                                                  child: ClipOval(
                                                      child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl: server +
                                                        "/catalogue_images/${consultantData[index]['prodid']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  consultantData[index]['name'],
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(
                                                "State:" +
                                                    consultantData[index]
                                                        ['state'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "RM " +
                                                    consultantData[index]
                                                        ['price'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Ticket available: " +
                                                    consultantData[index]
                                                        ['quantity'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                minWidth: 100,
                                                height: 30,
                                                child: Text(
                                                  'Add to Cart',
                                                ),
                                                color: primaryColor,
                                                textColor: Colors.black,
                                                elevation: 10,
                                                onPressed: () =>
                                                    _addToCartDialog(index),
                                              ),
                                            ],
                                          ),
                                        )));
                              }return Container();
                            }))
              ],
            )
          ],
        )),
      ),
    );
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

  void _loadConsultant() async {
    String urlLoadJobs = server + "/php/load_catalogue.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "Catalogue Empty") {
        cartQuantity = "0";
        titleCenter = "No product found";
        setState(() {
          consultantData = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          consultantData = extractdata["catalogue"];
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
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.white,
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
                          //border: Border.all(color: Colors.black),
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(server +
                                  "/catalogue_images/${consultantData[index]['prodid']}.jpg")))),
                ],
              ),
            ));
      },
    );
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
                "Add " + consultantData[index]['name'] + " ticket to Cart?",
                style: TextStyle(
                    //color: Colors.white,
                    ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select the quantity of the ticket",
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
                                
                                if (quantity <
                                    (int.parse(
                                            consultantData[index]['quantity']) -
                                        2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
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
      int cquantity = int.parse(consultantData[index]["quantity"]);
      print(cquantity);
      print(consultantData[index]["prodid"]);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs = server + "/php/insert_consultanttocart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": consultantData[index]["prodid"],
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
        Toast.show("Out of ticket", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
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
}
