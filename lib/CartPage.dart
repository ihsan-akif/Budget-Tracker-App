import 'dart:async';
import 'dart:convert';
import 'package:budget_tracker/EbookPage.dart';
import 'package:budget_tracker/MainPage.dart';
import 'package:budget_tracker/Payment.dart';
import 'package:budget_tracker/SplashPage.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

void main() => runApp(CartPage());

class CartPage extends StatefulWidget {
  final User user;

  const CartPage({Key key, this.user}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

@override
class _CartPageState extends State<CartPage> {
  String server = "http://shabab-it.com/budget_tracker";
  List cartData;
  double screenHeight, screenWidth;
  double _totalprice = 0.0;
  double amountpayable;
  String titleCenter = "Loading your cart";
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  bool _useCredit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            title: Text(
              'My Cart',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: secondaryColor,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(MdiIcons.deleteEmpty),
                onPressed: () {
                  deleteAll();
                },
              ),
            ]),
        body: Container(
            child: Column(
          children: <Widget>[
            cartData == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    titleCenter,
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))))
                : Expanded(
                    child: ListView.builder(
                        itemCount: cartData.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight / 8,
                                          width: screenWidth / 5,
                                          child: ClipRRect(
                                              child: CachedNetworkImage(
                                            fit: BoxFit.scaleDown,
                                            imageUrl: server +
                                                "/catalogue_images/${cartData[index]['prodid']}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                        ),
                                        Text(
                                          "RM " + cartData[index]['price'],
                                          style: TextStyle(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 10, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    Container(
                                        width: screenWidth / 1.45,
                                        //color: Colors.blue,
                                        child: Row(
                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    cartData[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: primaryColor),
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "Your Quantity: " +
                                                        cartData[index]
                                                            ['cquantity'],
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Type: " +
                                                        cartData[index]['type'],
                                                    style: TextStyle(
                                                        color: primaryColor),
                                                  ),
                                                  Text(
                                                      "Total RM " +
                                                          cartData[index]
                                                              ['yourprice'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: primaryColor)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          Container(
                                                              height: 20,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () => {
                                                                      _updateCart(
                                                                          index,
                                                                          "add")
                                                                    },
                                                                    child: Icon(
                                                                        MdiIcons
                                                                            .plus,
                                                                        color:
                                                                            secondaryColor),
                                                                  ),
                                                                  Text(
                                                                    cartData[
                                                                            index]
                                                                        [
                                                                        'cquantity'],
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          primaryColor,
                                                                    ),
                                                                  ),
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () => {
                                                                      _updateCart(
                                                                          index,
                                                                          "remove")
                                                                    },
                                                                    child: Icon(
                                                                        MdiIcons
                                                                            .minus,
                                                                        color:
                                                                            secondaryColor),
                                                                  ),
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () => {
                                                                      _deleteCart(
                                                                          index)
                                                                    },
                                                                    child: Icon(
                                                                        MdiIcons
                                                                            .delete,
                                                                        color:
                                                                            secondaryColor),
                                                                  ),
                                                                ],
                                                              )),
                                                          SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ])));
                        })),
            Container(
              //color: primaryColor,
                //height: screenHeight / 3,
                child: Card(
                  color: primaryColor,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text("Payment",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                      //color: Colors.red,
                      child: Table(
                          defaultColumnWidth: FlexColumnWidth(1.0),
                          columnWidths: {
                            0: FlexColumnWidth(7),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 20,
                                    child: Text("Total Item Price ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 20,
                                  child: Text(
                                      "RM" + _totalprice.toStringAsFixed(2) ??
                                          "0.0",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black)),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 20,
                                    child: Text(
                                        "Credit RM" + widget.user.credit,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 20,
                                  child: Checkbox(
                                    value: _useCredit,
                                    onChanged: (bool value) {
                                      _onUseCredit(value);
                                    },
                                  ),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 20,
                                    child: Text("Total Amount ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 20,
                                  child: Text(
                                      "RM" + amountpayable.toStringAsFixed(2) ??
                                          "0.0",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ),
                            ]),
                          ])),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 200,
                    height: 40,
                    child: Text('CHECKOUT'),
                    color: secondaryColor,
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: makePaymentDialog,
                  ),
                ],
              ),
            ))
          ],
        )));
  }

  void _loadCart() {
    _totalprice = 0.0;
    amountpayable = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadEbookCart = server + "/php/load_cart.php";
    http.post(urlLoadEbookCart, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "Cart Empty") {
        //Navigator.of(context).pop(false);
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(
                      user: widget.user,
                    )));
      }

      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          // _weight = double.parse(cartData[i]['weight']) *
          //         int.parse(cartData[i]['cquantity']) +
          //     _weight;
          _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
        }
        // _weight = _weight / 1000;
        amountpayable = _totalprice;

        // print(_weight);
        print(_totalprice);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: primaryColor,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: primaryColor,
                ),
              )),
        ],
      ),
    );
  }

  void makePaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Proceed with payment?',
        ),
        content: new Text(
          'Are you sure?',
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                makePayment();
              },
              child: Text(
                "Ok",
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
              )),
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    if (amountpayable < 0) {
      double newamount = amountpayable * -1;
      await _payusingcredit(newamount);
      _loadCart();
      return;
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid =
        widget.user.email + "-" + formatter.format(now) + randomAlphaNumeric(6);
    print(orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: _totalprice.toStringAsFixed(2),
                  orderid: orderid,
                )));
    _loadCart();
  }

  _updateCart(int index, String op) {
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      quantity++;
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs = server + "/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "prodid": cartData[index]['prodid'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                  "prodid": cartData[index]['prodid'],
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: primaryColor,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: primaryColor,
                ),
              )),
        ],
      ),
    );
  }

  void _onUseCredit(bool newValue) => setState(() {
        _useCredit = newValue;
        if (_useCredit) {
          _updatePayment();
        } else {
          _updatePayment();
        }
      });

  void _updatePayment() {
    _totalprice = 0.0;
    amountpayable = 0.0;
    setState(() {
      for (int i = 0; i < cartData.length; i++) {
        _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
      }
      if (_useCredit) {
        amountpayable = _totalprice - double.parse(widget.user.credit);
      } else {
        amountpayable = _totalprice;
      }
      print(_totalprice);
    });
  }

  Future<void> _payusingcredit(double newamount) async {
    //insert carthistory
    //remove cart content
    //update product quantity
    //update credit in user
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlPayment = server + "/php/payment_credit.php";
    await http.post(urlPayment, body: {
      "userid": widget.user.email,
      "amount": _totalprice.toStringAsFixed(2),
      "orderid": generateOrderid(),
      "newcr": newamount.toStringAsFixed(2)
    }).then((res) {
      print(res.body);
      pr.dismiss();
    }).catchError((err) {
      print(err);
    });
  }

  String generateOrderid() {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    return orderid;
  }
}
