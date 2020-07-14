import 'dart:convert';

import 'package:budget_tracker/Ebook.dart';
import 'package:budget_tracker/MainPage.dart';
import 'package:budget_tracker/UpdateEbookPage.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

void main() => runApp(AdminPage());

class AdminPage extends StatefulWidget {
  final User user;
  const AdminPage({Key key, this.user}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  double screenHeight, screenWidth;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  String titleCenter = "Loading\nPlease Wait...";
  String server = "http://shabab-it.com/budget_tracker";
  List ebookData;
  var _tapPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEbook();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Admin Menu'),
              backgroundColor: secondaryColor,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainPage(
                                user: widget.user,
                              )));
                },
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(MdiIcons.bookshelf),
                    text: "E-Book Catalogue",
                  ),
                  Tab(
                    icon: Icon(MdiIcons.face),
                    text: "Consultancy Services",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
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
                                return InkWell(
                                  onTap: () => _showPopupMenu(index),
                                  onTapDown: _storePosition,
                                  child: Card(
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
                                                    imageUrl: server +
                                                        "/catalogue_images/${ebookData[index]['prodid']}.jpg",
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
                                                    fontSize: 14.0,
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
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                );
                              }
                              return Container();
                            },
                          )),
                  ],
                ),
                Column(children: <Widget>[
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
                                    "Consultant") {
                                  return InkWell(
                                    onTap: () => _showPopupMenu(index),
                                    onTapDown: _storePosition,
                                    child: Card(
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
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl: server +
                                                        "/catalogue_images/${ebookData[index]['prodid']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        ebookData[index]
                                                            ['name'],
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text(
                                                      "State:" +
                                                          ebookData[index]
                                                              ['state'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "RM " +
                                                          ebookData[index]
                                                              ['price'] +
                                                          " per ticket",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Ticket available: " +
                                                          ebookData[index]
                                                              ['quantity'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  );
                                }
                                return Container();
                              }))
                ])
              ],
            ),
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

  void _loadEbook() async {
    String urlLoadEbook = server + "/php/load_catalogue.php";
    await http.post(urlLoadEbook, body: {}).then((res) {
      if (res.body == "Catalogue Empty") {
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
                            image: NetworkImage(server +
                                "/catalogue_images/${ebookData[index]['prodid']}.jpg"))),
                  )
                ],
              ),
            ),
          );
        });
  }

  updateCatalogueType(int index) {
    if (ebookData[index]['type'].toString() == "Ebook") {
      return Text(
        "Update E-Book?",
        style: TextStyle(
          color: Colors.black,
        ),
      );
    } else {
      return Text(
        "Update Consultant?",
        style: TextStyle(
          color: Colors.black,
        ),
      );
    }
  }

  deleteCatalogueType(int index) {
    if (ebookData[index]['type'].toString() == "Ebook") {
      return Text(
        "Delete E-Book?",
        style: TextStyle(
          color: Colors.black,
        ),
      );
    } else {
      return Text(
        "Delete Consultant?",
        style: TextStyle(
          color: Colors.black,
        ),
      );
    }
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

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _updateCatalogueDialog(index)},
              child: updateCatalogueType(index)),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: null,
              // onTap: () =>
              //     {Navigator.of(context).pop(), _deleteProductDialog(index)},
              child: deleteCatalogueType(index)),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _updateCatalogueDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update " + ebookData[index]['name'] + " ?",
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
                _updateCatalogue(index);
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

  _updateCatalogue(int index) async {
    print(ebookData[index]['type']);

    if (ebookData[index]['type'].toString() == "Ebook") {
      Ebook ebook = new Ebook(
          prodid: ebookData[index]['prodid'],
          name: ebookData[index]['name'],
          price: ebookData[index]['price'],
          author: ebookData[index]['author'],
          publisher: ebookData[index]['publisher'],
          dateRelease: ebookData[index]['daterelease'],
          quantity: ebookData[index]['quantity']);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => UpdateEbookPage(
                    user: widget.user,
                    ebook: ebook,
                  )));
    }

    _loadEbook();
  }

  void _deleteEbookDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete " + ebookData[index]['name'] + " ?",
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
                _deleteEbook(index);
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

  void _deleteEbook(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting " + ebookData[index]['name'] + "...");
    pr.show();
    http.post(server + "/php/delete_catalogue.php", body: {
      "prodid": ebookData[index]['prodid'],
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadEbook();
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
}
