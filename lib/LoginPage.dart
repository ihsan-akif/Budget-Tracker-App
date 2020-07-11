import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_tracker/RegisterPage.dart';
import 'package:budget_tracker/User.dart';
import 'package:budget_tracker/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double screenHeight;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  TextEditingController _emailEditingCtrl = new TextEditingController();
  TextEditingController _passwordEditingCtrl = new TextEditingController();
  bool rememberMe = false;
  String urlLogin = "http://shabab-it.com/budget_tracker/php/login_user.php";

  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    print('Screen Height: $screenHeight');

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Container(
//                width: double.infinity,
//                decoration: BoxDecoration(
//                    color: primaryColor,
//                    border: Border.all(color: primaryColor)),
//              ),
              Stack(
                children: <Widget>[
                  background(context),
                  upperHalf(context),
                  lowerHalf(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget background(BuildContext context) {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: 350.0,
        decoration: BoxDecoration(color: secondaryColor),
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 3,
      child: Center(
        child: Image.asset("assets/images/Logo.png", height: 200),
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 440,
      margin: EdgeInsets.only(top: screenHeight / 2.8),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Hello There!",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailEditingCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Enter Email",
                        fillColor: Colors.white,
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(color: primaryColor),
                        ),
                        prefixIcon: Icon(
                          Icons.mail,
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _passwordEditingCtrl,
                    decoration: InputDecoration(
                        labelText: "Enter Password",
                        fillColor: Colors.white,
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(color: primaryColor),
                        ),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                        )),
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                          value: rememberMe,
                          onChanged: (bool value) {
                            _onRememberMeChanged(value);
                          }),
                      Text(
                        "Remember Me",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        elevation: 5.0,
                        minWidth: 330.0,
                        height: 35,
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        onPressed: this._userLogin),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: _forgotPassword,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 14.0, color: primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    elevation: 10.0,
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        elevation: 5.0,
                        minWidth: 300.0,
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.face),
                            Text(
                              " SIGN IN AS GUEST",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        onPressed: _guestLogin),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: registerUser,
                        child: Text(
                          "Sign Up",
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
        ],
      ),
    );
  }

  void registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
  }

  void _userLogin() async {
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
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    pr.show();
    String _email = _emailEditingCtrl.text;
    String _password = _passwordEditingCtrl.text;

    http.post(urlLogin, body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      var string = res.body;
      print(res.body);
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            name: userdata[1],
            email: _email,
            password: _password,
            phoneNum: userdata[3],
            datereg: userdata[4],
            quantity: userdata[5],
            credit: userdata[6]);
        pr.hide();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(
                      user: _user,
                    )));
      } else {
        pr.hide();
        Toast.show("Login Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print('Error: $err');
      pr.hide();
    });
  }

  void _guestLogin() async {
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
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    pr.show();
    String _email = "guest@budgettracker.com";
    String _password = "GuestAccount1";

    http.post(urlLogin, body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      var string = res.body;
      print(res.body);
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            name: userdata[1],
            email: _email,
            password: _password,
            phoneNum: userdata[3],
            datereg: userdata[4],
            quantity: userdata[5],
            credit: userdata[6]);
        pr.hide();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(
                      user: _user,
                    )));
      } else {
        pr.hide();
        Toast.show("Login Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print('Error: $err');
      pr.hide();
    });
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Forgot Password?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: new Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Enter your email",
                ),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ))
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
            ),
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

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString("email")) ?? '';
    String password = (prefs.getString("pass")) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingCtrl.text = email;
        _passwordEditingCtrl.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingCtrl.text;
    String password = _passwordEditingCtrl.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString("email", email);
      await prefs.setString("pass", password);
      Toast.show("Email and Password saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString("email", "");
      await prefs.setString("pass", "");
      setState(() {
        _emailEditingCtrl.text = "";
        _passwordEditingCtrl.text = "";
        rememberMe = false;
      });
      Toast.show("Email and Password removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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
