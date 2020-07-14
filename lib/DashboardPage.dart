import 'dart:async';
import 'dart:convert';
import 'package:budget_tracker/AddExpensePage.dart';
import 'package:budget_tracker/AddIncomePage.dart';
import 'package:budget_tracker/Data.dart';
import 'package:budget_tracker/UpdateDataPage.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

void main() => runApp(DashboardPage());

class DashboardPage extends StatefulWidget {
  final User user;
  const DashboardPage({Key key, this.user}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

@override
class _DashboardPageState extends State<DashboardPage> {
  List userData;
  double screenHeight, screenWidth;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  String titleCenter = "Loading\nPlease Wait...";
  String server = "http://shabab-it.com/budget_tracker";
  double totalExpense = 0.0;
  double totalIncome = 0.0;
  double balance = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //title: 'Material App',
        home: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomPadding: false,
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.add_event,
            backgroundColor: primaryColor,
            children: [
              SpeedDialChild(
                  child: Icon(MdiIcons.cashPlus),
                  label: "Add New Income",
                  backgroundColor: primaryColor,
                  onTap: addNewIncome),
              SpeedDialChild(
                  child: Icon(MdiIcons.cashMinus),
                  label: "Add New Expense",
                  backgroundColor: primaryColor, //_changeLocality()
                  onTap: addNewExpense),
            ],
          ),
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
                  SizedBox(
                    height: 10,
                  ),
                  // tableNull(balance.toString(), totalIncome.toString(),
                  //     totalExpense.toString()),

                  userData == null
                      ? Card(
                          elevation: 10,
                          child: Container(
                            height: screenHeight / 5.5,
                            width: screenWidth / 1.2,
                            margin: EdgeInsets.all(20),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Budgets",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Divider(color: Colors.black),
                                Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Table(
                                      //border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Column(children: [
                                            Icon(
                                              MdiIcons.cashPlus,
                                            ),
                                            Text('Income',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ]),
                                          Column(children: [
                                            Icon(
                                              MdiIcons.cashMinus,
                                            ),
                                            Text('Expense',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ))
                                          ]),
                                          Column(children: [
                                            Icon(
                                              MdiIcons.cashUsd,
                                            ),
                                            Text('Balance',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ))
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Text("RM 00.00",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text("RM 00.00",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                            "RM 00.00",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        )
                      : Card(
                          elevation: 10,
                          child: Container(
                            height: screenHeight / 5.5,
                            width: screenWidth / 1.2,
                            margin: EdgeInsets.all(20),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Budgets",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Divider(color: Colors.black),
                                Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Table(
                                      //border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Column(children: [
                                            Icon(
                                              MdiIcons.cashPlus,
                                            ),
                                            Text('Income',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ]),
                                          Column(children: [
                                            Icon(
                                              MdiIcons.cashMinus,
                                            ),
                                            Text('Expense',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ))
                                          ]),
                                          Column(children: [
                                            Icon(
                                              MdiIcons.cashUsd,
                                            ),
                                            Text('Balance',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ))
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Text(
                                              "RM " +
                                                  totalIncome
                                                      .toStringAsFixed(2),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                              "RM " +
                                                  totalExpense
                                                      .toStringAsFixed(2),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                            "RM " + balance.toStringAsFixed(2),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ),

                  // SizedBox(
                  //   height: 5,
                  // ),
                  userData == null
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
                              itemCount: userData.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  //height: screenHeight / 10,
                                  //width: screenWidth / 1.2,
                                  margin: EdgeInsets.fromLTRB(11, 0, 11, 5),
                                  child: GestureDetector(
                                    onTap: () => {showDetails(index)},
                                    child: Card(
                                        elevation: 10,
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // GestureDetector(),
                                            Container(
                                              child: dataType(index),
                                              margin: EdgeInsets.all(15),
                                            ),
                                            Container(
                                              width: screenWidth / 1.5,
                                              margin: EdgeInsets.all(15),
                                              child: Column(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    userData[index]['type'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        userData[index]
                                                            ['category'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 20,
                                                      // ),
                                                      Text(
                                                        "RM " +
                                                            userData[index]
                                                                ['total'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),

                                                  // Text(
                                                  //   userData[index]['description'],
                                                  //   style: TextStyle(color: Colors.black),
                                                  // ),
                                                  // Text(
                                                  //   userData[index]['date'],
                                                  //   style: TextStyle(color: Colors.black),
                                                  // ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              })),
                ],
              ),
            ],
          ),
        ),
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

  void loadData() async {
    String urlLoadData = server + "/php/load_data.php";
    await http.post(urlLoadData, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "Data Empty") {
        // cartQuantity = "0";
        titleCenter = "No Data Found";
        print(res.body);
        setState(() {
          userData = null;
        });
      } else {
        setState(() {
          print(res.body);
          var extractdata = json.decode(res.body);
          userData = extractdata["data"];
          // cartQuantity = widget.user.quantity;
          totalIncome = 0.0;
          totalExpense = 0.0;
          setState(() {
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Income") {
                totalIncome += double.parse(userData[i]['total']);
              }
            }

            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                totalExpense += double.parse(userData[i]['total']);
              }
            }

            balance = totalIncome - totalExpense;
            print("Total Income: $totalIncome");
            print("Total Expense: $totalExpense");
            print("Balance: $balance");
          });
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget dataType(index) {
    if (userData[index]['type'] == "Income") {
      return CircleAvatar(
        backgroundColor: blueishColor,
        child: Text(
          "I",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: secondaryColor,
        child: Text(
          "E",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      );
    }
  }

  Future<void> addNewExpense() async {
    if (widget.user.email == "guest@budgettracker.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (userData == null) {
      Toast.show("Please add income first!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddExpensePage(
                  user: widget.user,
                )));
    loadData();
  }

  Future<void> addNewIncome() async {
    if (widget.user.email == "guest@budgettracker.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddIncomePage(
                  user: widget.user,
                )));
    loadData();
  }

  showDetails(int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Center(
                child: new Text(
                  userData[index]['type'],
                  style: TextStyle(color: Colors.black),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _onImageDisplay(index),
                    child: Container(
                      height: screenHeight / 5.9,
                      width: screenWidth / 3.5,
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: server +
                              "/receipt_images/${userData[index]['id']}.jpg",
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Text('Receipt Image\nClick to view the image',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total Amount:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'RM ' + userData[index]['total'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Date:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        dateformat(userData[index]['date']),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Category:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        userData[index]['category'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Description:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          userData[index]['description'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: secondaryColor,
                          onPressed: () => {
                                Navigator.of(context).pop(),
                                _updateDetailDialog(index)
                              },
                          child: Text(
                            "Update " + userData[index]['type'],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: secondaryColor,
                          onPressed: () => {
                                Navigator.of(context).pop(),
                                _deleteDataDialog(index)
                              },
                          child: Text(
                            "Delete " + userData[index]['type'],
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
                            "Close",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )),
                    ],
                  )
                ],
              ),
            );
          });
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
                            image: NetworkImage(server +
                                "/receipt_images/${userData[index]['id']}.jpg"))),
                  )
                ],
              ),
            ),
          );
        });
  }

  _updateDetailDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update " + userData[index]['type'] + " ?",
          ),
          content: new Text("Are you sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _updateDetail(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _updateDetail(int index) async {
    print(userData[index]['category']);
    Data data = new Data(
      id: userData[index]['id'],
      total: userData[index]['total'],
      category: userData[index]['category'],
      description: userData[index]['description'],
      date: userData[index]['date'],
      type: userData[index]['type'],
    );
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UpdateDataPage(
                  user: widget.user,
                  data: data,
                )));
    loadData();
  }

  void _deleteDataDialog(int index) {
    // if (userData[index]['type'] == "Income") {
    //   if (double.parse(userData[index]['total']) > totalExpense) {
    //     Toast.show("Cannot delete this income!", context,
    //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //     return;
    //   }
    // }

    print(double.parse(userData[index]['total']));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete " + userData[index]['type'] + " ?",
          ),
          content: new Text("Are you sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteData(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteData(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting " + userData[index]['type'] + "...");
    pr.show();
    http.post(server + "/php/delete_data.php", body: {
      "id": userData[index]['id'],
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        loadData();
        //Navigator.of(context).pop();
        pr.hide();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }

  String dateformat(String dateTime) {
    String dayFormat = dateTime.substring(8, 10);
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
    return dayFormat + " " + month + " " + yearFormat;
  }
}
