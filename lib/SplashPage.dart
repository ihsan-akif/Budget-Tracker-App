import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:budget_tracker/LoginPage.dart';

void main() => runApp(MyApp());

Color primaryColor = Color.fromRGBO(255, 82, 48, 1);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Budget Tracker',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/SplashScreen.png'),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 50,
                  child: ProgressIndicator(),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Not wasting ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor)),
                          TextSpan(
                              text: "money",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor)),
                          TextSpan(
                              text: " is the best way to save ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor)),
                          TextSpan(
                              text: "money",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (BuildContext context) => LoginPage()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      child: CircularProgressIndicator(
        value: animation.value,
        valueColor:
            new AlwaysStoppedAnimation<Color>(primaryColor),
      ),
    ));
  }
}
