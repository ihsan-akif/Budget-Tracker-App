import 'dart:async';

import 'package:budget_tracker/Consultant.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(ConsultantDetail());

class ConsultantDetail extends StatefulWidget {
  final User user;
  final Consultant consultant;

  const ConsultantDetail({Key key, this.user, this.consultant})
      : super(key: key);

  @override
  _ConsultantDetailState createState() => _ConsultantDetailState();
}

class _ConsultantDetailState extends State<ConsultantDetail> {
  String server = "http://shabab-it.com/budget_tracker";
  String cartQuantity = "0";
  int quantity = 1;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  double screenHeight, screenWidth;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _stateLocation;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  String phoneNum, website;

  @override
  void initState() {
    super.initState();
    _loadCartQuantity();
    latitude = double.parse(widget.consultant.latitude);
    longitude = double.parse(widget.consultant.longitude);
    phoneNum = widget.consultant.contact;
    website = widget.consultant.website;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                color: Colors.red,
                height: screenHeight / 2.8,
                width: screenWidth / 2.8,
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: server +
                      "/catalogue_images/${widget.consultant.prodid}.jpg",
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: Table(
                  border: TableBorder.all(),
                  defaultColumnWidth: FlexColumnWidth(1.0),
                  columnWidths: {
                    0: FlexColumnWidth(3.5),
                    1: FlexColumnWidth(6.5),
                  },
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 35,
                        child: Text(
                          "Price",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 35,
                        child: Text(
                          "RM " + widget.consultant.price,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ))
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 35,
                        child: Text(
                          "Quantity",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 35,
                        child: Text(
                          widget.consultant.quantity + " tickets left",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ))
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 35,
                        child: Text(
                          "Website",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 35,
                        child: GestureDetector(
                          onTap: () => launch("http:$website"),
                          child: Text(
                            widget.consultant.website,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ))
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 50,
                        child: Text(
                          "Address",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 50,
                        child: GestureDetector(
                          onTap: () => {_loadMapDialog()},
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              widget.consultant.address,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ))
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 35,
                        child: Text(
                          "Contact",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Container(
                        color: secondaryColor,
                        alignment: Alignment.center,
                        height: 35,
                        child: GestureDetector(
                          onTap: () {
                            if (widget.consultant.contact != "No") {
                              launch("tel:$phoneNum"); //make call
                            } else {
                              Toast.show("Phone Number Not Available", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            }
                          },
                          child: Text(
                            widget.consultant.contact,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ))
                    ])
                  ],
                ),
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minWidth: screenWidth / 2.5,
                  height: 40,
                  child: Text(
                    'Add ticket to Cart',
                  ),
                  color: secondaryColor,
                  textColor: Colors.black,
                  elevation: 5,
                  onPressed: (){
                    //Navigator.of(context).pop(false);
                    _addToCartDialog();
                  }
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minWidth: screenWidth / 2.5,
                  height: 40,
                  child: Text('Back'),
                  color: secondaryColor,
                  textColor: Colors.black,
                  elevation: 5,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addToCartDialog() {
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
                "Add " + widget.consultant.name + " ticket to Cart?",
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
                                            widget.consultant.quantity) -
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
                      _addtoCart();
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

  void _addtoCart() {
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
      int cquantity = int.parse(widget.consultant.quantity);
      print(cquantity);
      print(widget.consultant.prodid);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs = server + "/php/insert_consultanttocart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": widget.consultant.prodid,
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

  _loadMapDialog() {
    _controller = Completer();
    _stateLocation =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 14.4746);

    markers.add(Marker(
        markerId: markerId1,
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: widget.consultant.name)));

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Text(widget.consultant.name),
              titlePadding: EdgeInsets.all(5),
              actions: <Widget>[
                Text(widget.consultant.address),
                Container(
                  height: screenHeight / 2 ?? 600,
                  width: screenWidth ?? 360,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _stateLocation,
                    markers: markers.toSet(),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    height: 30,
                    color: Colors.blueGrey,
                    child: Text("Close"),
                    elevation: 10,
                    onPressed: () =>
                        {markers.clear(), Navigator.of(context).pop(false)})
              ],
            );
          });
        });
  }
}
