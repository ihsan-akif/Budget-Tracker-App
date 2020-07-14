import 'dart:async';
import 'package:budget_tracker/SplashPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/User.dart';

class CreditPage extends StatefulWidget {
  final User user;
  final String val;
  CreditPage({this.user, this.val});

  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BUY CREDIT'),
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'http://shabab-it.com/budget_tracker/php/buy_credit.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phoneNum +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&csc=' +
                        widget.user.credit,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }

  
}
