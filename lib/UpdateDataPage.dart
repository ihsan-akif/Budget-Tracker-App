import 'package:budget_tracker/Data.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(UpdateDataPage());

class UpdateDataPage extends StatefulWidget {
  final User user;
  final Data data;
  const UpdateDataPage({Key key, this.user, this.data}) : super(key: key);

  @override
  _UpdateDataPageState createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  double screenHeight, screenWidth;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  File _image;
  String server = "http://shabab-it.com/budget_tracker";
  String pathAsset = 'assets/images/PhoneCamera.png';
  TextEditingController totalEditingController = new TextEditingController();
  TextEditingController categoryEditingController = new TextEditingController();
  TextEditingController descEditingController = new TextEditingController();
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  bool _takepicture = true;
  bool _takepicturelocal = false;
  String selectedCategory;
  List<String> expenseCategory = [
    "Food",
    "Transportation",
    "Utilities",
    "Clothing",
    "Healthcare",
    "Insurance",
    "Household Items",
    "Personal",
    "Debt",
    "Retirement",
    "Education",
    "Gifts/Donations",
    "Entertainment",
    "Other",
  ];
  List<String> incomeCategory = [
    "Salary",
    "Tips",
    "Bonus",
    "Vacation Pay",
    "Commission",
    "Interest/Dividend",
    "Rental",
    "Profit",
    "Other",
  ];
  List userData;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double balance = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalEditingController.text = widget.data.total;
    categoryEditingController.text = widget.data.category;
    descEditingController.text = widget.data.description;
    selectedCategory = widget.data.category;
    print(widget.data.type);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   title: Text('Update Your Data'),
      // ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
                onTap: _choose,
                child: Column(
                  children: [
                    Visibility(
                      visible: _takepicture,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl:
                              server + "/receipt_images/${widget.data.id}.jpg",
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _takepicturelocal,
                        child: Container(
                          height: screenHeight / 3,
                          width: screenWidth / 1.5,
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                              image: _image == null
                                  ? AssetImage('assets/images/PhoneCamera.png')
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ],
                )),
            SizedBox(height: 6),
            Container(
                width: screenWidth / 1.2,
                //height: screenHeight / 2,
                child: Card(
                    elevation: 6,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Table(
                                defaultColumnWidth: FlexColumnWidth(1.0),
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Total Income (RM)",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            controller: totalEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus0);
                                            },
                                            decoration: new InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),

                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),

                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  typeTable(widget.data.type),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Description",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            controller: descEditingController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus0,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus1);
                                            },
                                            decoration: new InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),

                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),

                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                ]),
                            SizedBox(height: 20),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minWidth: screenWidth / 1.5,
                              height: 40,
                              child: Text('Update ' + widget.data.type),
                              color: secondaryColor,
                              textColor: Colors.black,
                              elevation: 5,
                              onPressed: () => updateDataDialog(),
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minWidth: screenWidth / 1.5,
                              height: 40,
                              child: Text('Cancel'),
                              color: secondaryColor,
                              textColor: Colors.black,
                              elevation: 5,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        )))),
          ],
        )),
      ),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        _takepicture = false;
        _takepicturelocal = true;
      });
    }
  }

  updateDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update " + widget.data.type + " ?",
          ),
          content: new Text(
            "Are you sure?",
          ),
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
                updateData();
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

  updateData() {
    loadData();
    if (widget.data.type == "Income") {
      if (totalEditingController.text.length < 1) {
        Toast.show("Please enter the total of income", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (double.parse(totalEditingController.text) <= 0) {
        Toast.show("Please enter more than 0!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (descEditingController.text.length < 1) {
        Toast.show("Please enter the income description", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (double.parse(totalEditingController.text) <= totalExpense) {
        Toast.show("Income is less than expense!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }

    if (widget.data.type == "Expense") {
      if (totalEditingController.text.length < 1) {
        Toast.show("Please enter the total of expense", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (double.parse(totalEditingController.text) <= 0) {
        Toast.show("Please enter more than 0!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (descEditingController.text.length < 1) {
        Toast.show("Please enter the expense description", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if ((totalExpense + double.parse(totalEditingController.text)) >
          totalIncome) {
        Toast.show("Expense is more than income!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (totalExpense > totalIncome) {
        Toast.show("Total Expense is more than total income!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }

    double total = double.parse(totalEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating " + widget.data.type + "...");
    pr.show();
    String base64Image;

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());
      http.post(server + "/php/update_data.php", body: {
        "id": widget.data.id,
        "total": total.toStringAsFixed(2),
        "category": selectedCategory,
        "desc": descEditingController.text,
        "encoded_string": base64Image,
      }).then((res) {
        print(res.body);
        pr.hide();
        if (res.body == "success") {
          Toast.show("Update success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    } else {
      http.post(server + "/php/update_data.php", body: {
        "id": widget.data.id,
        "total": total.toStringAsFixed(2),
        "category": selectedCategory,
        "desc": descEditingController.text,
      }).then((res) {
        print(res.body);
        pr.hide();
        if (res.body == "success") {
          Toast.show("Update success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    }
  }

  typeTable(String type) {
    if (type == "Expense") {
      return TableRow(children: [
        TableCell(
          child: Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text("Category",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
        ),
        TableCell(
          child: Container(
            margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
            height: 40,
            child: Container(
              height: 40,
              child: DropdownButton(
                //sorting dropdownoption
                hint: Text(
                  'Type',
                ), // Not necessary for Option 1
                value: selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    print(selectedCategory);
                  });
                },
                items: expenseCategory.map((selectedType) {
                  return DropdownMenuItem(
                    child: new Text(
                      selectedType,
                    ),
                    value: selectedType,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ]);
    } else {
      return TableRow(children: [
        TableCell(
          child: Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text("Category",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
        ),
        TableCell(
          child: Container(
            margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
            height: 40,
            child: Container(
              height: 40,
              child: DropdownButton(
                //sorting dropdownoption
                hint: Text(
                  'Type',
                ), // Not necessary for Option 1
                value: selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    print(selectedCategory);
                  });
                },
                items: incomeCategory.map((selectedType) {
                  return DropdownMenuItem(
                    child: new Text(
                      selectedType,
                    ),
                    value: selectedType,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ]);
    }
  }

  void loadData() async {
    String urlLoadData = server + "/php/load_data.php";
    await http.post(urlLoadData, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      var extractdata = json.decode(res.body);
      userData = extractdata["data"];
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
      });

      balance = totalIncome - totalExpense;
      print("Total Income: $totalIncome");
      print("Total Expense: $totalExpense");
      print("Balance: $balance");
    }).catchError((err) {
      print(err);
    });
  }
}
