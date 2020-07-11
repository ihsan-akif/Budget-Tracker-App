import 'dart:convert';
import 'dart:io';
import 'package:budget_tracker/DashboardPage.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

void main() => runApp(AddExpensePage());

class AddExpensePage extends StatefulWidget {
  final User user;
  const AddExpensePage({Key key, this.user}) : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
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
  String selectedCategory;
  List<String> listCategory = [
    "Food",
    "Transportation",
    "Utilities",
    "Clothing",
    "Healthcare",
    "Insurance",
    "Household Items",
    "Debt",
    "Entertainment",
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
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Add New Expense'),
      // ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 6),
                GestureDetector(
                    onTap: () => {_choose()},
                    child: Container(
                      height: screenHeight / 3,
                      width: screenWidth / 1.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //         <--- border radius here
                            ),
                      ),
                    )),
                SizedBox(height: 5),
                Text("Click the above image to take picture of your receipt",
                    style: TextStyle(fontSize: 10.0)),
                SizedBox(height: 5),
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
                                              child: Text("Total Expense (RM)",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                controller:
                                                    totalEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus0);
                                                },
                                                decoration: new InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(5),
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),

                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Category",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 40,
                                            child: Container(
                                              height: 40,
                                              child: DropdownButton(
                                                //sorting dropdownoption
                                                hint: Text(
                                                  'Category',
                                                ), // Not necessary for Option 1
                                                value: selectedCategory,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedCategory = newValue;
                                                    print(selectedCategory);
                                                  });
                                                },
                                                items: listCategory
                                                    .map((selectedCategory) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                        selectedCategory,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    value: selectedCategory,
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
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
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                controller:
                                                    descEditingController,
                                                keyboardType:
                                                    TextInputType.text,
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
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  minWidth: screenWidth / 1.5,
                                  height: 40,
                                  child: Text('Add New Expense'),
                                  color: secondaryColor,
                                  textColor: Colors.black,
                                  elevation: 5,
                                  onPressed: _insertNewExpense,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
            ),
          ),
        ),
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
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.original,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio16x9
              ]
            : [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio5x3,
                //CropAspectRatioPreset.ratio5x4,
                //CropAspectRatioPreset.ratio7x5,
                //CropAspectRatioPreset.ratio16x9
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
      setState(() {});
    }
  }

  void _insertNewExpense() {
    loadData();
    if (_image == null) {
      Toast.show("Please take expense receipt", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Insert New Expense?",
          ),
          content: new Text(
            "Are you sure?",
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertExpense();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
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

  insertExpense() {
    double total = double.parse(totalEditingController.text);
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String id = "exp" +
        widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    print(id);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Inserting new expense...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post(server + "/php/insert_expense.php", body: {
      "id": id,
      "email": widget.user.email,
      "total": total.toStringAsFixed(2),
      "category": selectedCategory,
      "desc": descEditingController.text,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      pr.hide();
      loadData();
      if (res.body == "success") {
        Toast.show("Expense Added", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Failed to add", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
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
