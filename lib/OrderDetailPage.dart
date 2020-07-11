import 'dart:convert';

import 'package:budget_tracker/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'order.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({Key key, this.order}) : super(key: key);
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List _orderdetails;
  String titlecenter = "Loading order details...";
  double screenHeight, screenWidth;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  String server = "http://shabab-it.com/budget_tracker";

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: secondaryColor,
      ),
      body: Stack(children: <Widget>[
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
            _orderdetails == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    titlecenter,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ))))
                : Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.8,
                        children: List.generate(_orderdetails.length, (index) {
                          if (_orderdetails[index]['type'].toString() ==
                              "Ebook") {
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
                                            onTap: () => _onImageDisplay(index),
                                            child: Container(
                                              height: screenHeight / 5.9,
                                              width: screenWidth / 3.5,
                                              child: ClipOval(
                                                  child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: server +
                                                    "/catalogue_images/${_orderdetails[index]['prodid']}.jpg",
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(_orderdetails[index]['name'],
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                            "Product ID: " +
                                                _orderdetails[index]['prodid'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "RM " +
                                                _orderdetails[index]['price'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Ebook purchased: " +
                                                _orderdetails[index]
                                                    ['cquantity'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Item Type: " +
                                                _orderdetails[index]
                                                    ['type'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )));
                          } 
                          else {
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
                                            onTap: () => _onImageDisplay(index),
                                            child: Container(
                                              height: screenHeight / 5.9,
                                              width: screenWidth / 3.5,
                                              child: ClipOval(
                                                  child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: server +
                                                    "/catalogue_images/${_orderdetails[index]['prodid']}.jpg",
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(_orderdetails[index]['name'],
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                            "Product ID: " +
                                                _orderdetails[index]['prodid'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "RM " +
                                                _orderdetails[index]['price'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Ticket purchased: " +
                                                _orderdetails[index]
                                                    ['cquantity'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Item Type: " +
                                                _orderdetails[index]
                                                    ['type'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )));
                          }
                        })))
          ],
        )
      ]),
    );
  }

  _loadOrderDetails() async {
    String urlLoadJobs = server + "/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.order.orderid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
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
                                  "/catalogue_images/${_orderdetails[index]['prodid']}.jpg")))),
                ],
              ),
            ));
      },
    );
  }
}
