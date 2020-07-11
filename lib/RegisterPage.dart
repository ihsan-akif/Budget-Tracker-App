import 'package:flutter/material.dart';
import 'package:budget_tracker/LoginPage.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(RegisterPage());

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double screenHeight;
  bool _isChecked = false;
  String urlRegister =
      "http://shabab-it.com/budget_tracker/php/register_user.php";
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phoneNum = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: secondaryColor,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            background(context),
            upperHalf(context),
            lowerHalf(context),
          ],
        ),
      ),
    );
  }

  Widget background(BuildContext context) {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: 350.0,
        decoration: BoxDecoration(color: Color.fromRGBO(244, 244, 244, 1)),
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "WELCOME TO",
                style: TextStyle(
                  fontSize: 30,
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "REGISTRATION PAGE",
                style: TextStyle(
                  fontSize: 25,
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 3.6),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: new Form(key: _key, autovalidate: _validate, child: formUI()),
    );
  }

  Widget formUI() {
    return Column(children: <Widget>[
      Card(
        elevation: 15,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: "Enter Your Name",
                  icon: Icon(Icons.person),
                  fillColor: Colors.white,
                ),
                validator: validateName,
                onSaved: (String val) {
                  _name.text = val;
                },
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus0);
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Enter Your Email",
                  icon: Icon(Icons.mail),
                  fillColor: Colors.white,
                ),
                validator: validateEmail,
                onSaved: (String val) {
                  _email.text = val;
                },
                focusNode: focus0,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus1);
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _phoneNum,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Enter Your Phone Number",
                  icon: Icon(Icons.phone),
                  fillColor: Colors.white,
                ),
                validator: validatePhoneNum,
                onSaved: (String val) {
                  _phoneNum.text = val;
                },
                focusNode: focus1,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus2);
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: "Enter Your Password",
                  icon: Icon(Icons.lock),
                  fillColor: Colors.white,
                ),
                obscureText: true,
                validator: validatePassword,
                onSaved: (String val) {
                  _password.text = val;
                },
                focusNode: focus2,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus3);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool value) {
                      _onChange(value);
                    },
                  ),
                  GestureDetector(
                    onTap: _showEULA,
                    child: Text('I Agree to Terms and Conditions ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                elevation: 10.0,
                color: primaryColor,
                clipBehavior: Clip.antiAlias,
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    elevation: 5.0,
                    minWidth: 330.0,
                    height: 35,
                    child: Text(
                      "REGISTER",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    onPressed: _onRegister),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: _loginScreen,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 14.0,
                          color: primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ]);
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validatePhoneNum(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be in digit";
    } else if (value.length != 10 && value.length != 11) {
      return "Phone Number must be 10 - 11 digits";
    }
    return null;
  }

  String validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length != 8 && value.length < 8) {
      return "Password length must be 8 characters or more";
    } else if (!regExp.hasMatch(value)) {
      return "Password must be in combination of 1 lowercase, \n1 uppercase and 1 number";
    }
    return null;
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("End-User License Agreement of Budget Tracker"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and ShababIT This EULA agreement governs your acquisition and use of our Budget Tracker software (Software) directly from ShababIT or indirectly through a ShababIT authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the Budget Tracker software. It provides a license to use the Budget Tracker software and contains warranty information and liability disclaimers. If you register for a free trial of the Budget Tracker software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the Budget Tracker software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by ShababIT herewith regardless of whether other software is referred to or described herein. The terms also apply to any ShababIT updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Budget Tracker. ShababIT shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of ShababIT. ShababIT reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _loginScreen() {
    Navigator.of(context).pop();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void _onRegister() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Registration Confirmation",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: new Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Are you sure you wants to register a new account?")
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _checkedformat();
                }),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkedformat() {
    if (!_isChecked) {
      Toast.show("Please Accept Terms and Conditions", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_key.currentState.validate()) {
      //No any error in validation
      _key.currentState.save();
      String name = _name.text;
      String email = _email.text;
      String phoneNum = _phoneNum.text;
      String password = _password.text;
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
      pr.style(
          message: 'Please wait...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 19.0,
              fontWeight: FontWeight.w600));
      pr.show();
      http.post(urlRegister, body: {
        "name": name,
        "email": email,
        "password": password,
        "phoneNum": phoneNum,
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
          Toast.show("Registration Success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          pr.hide();
        } else {
          Toast.show("Registration Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          pr.hide();
        }
      }).catchError((err) {
        print(err);
      });
      pr.hide();
    } else {
      //validation error
      setState(() {
        _validate = true;
      });
    }
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2, 280, size.width, 390.0 - 200);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
