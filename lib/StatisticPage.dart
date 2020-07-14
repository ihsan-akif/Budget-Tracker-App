import 'package:budget_tracker/User.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(StatisticPage());

class StatisticPage extends StatefulWidget {
  final User user;
  const StatisticPage({Key key, this.user}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  String server = "http://shabab-it.com/budget_tracker";
  double totalExpense = 0.0;
  double totalIncome = 0.0;
  double balance = 0.0;
  List userData;
  List<charts.Series<Data, String>> _seriesPieData;
  String titleCenter = "Loading\nPlease Wait...";
  double totalFood,
      totalTransportation,
      totalUtilities,
      totalClothing,
      totalHealthcare,
      totalInsurance,
      totalHItems,
      totalDebt,
      totalEntertainment,
      totalOther = 0.0;

  @override
  void initState() {
    super.initState();
    loadData();
    _seriesPieData = List<charts.Series<Data, String>>();
    print("TotalFood: $totalFood");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            color: backgroundColor,
          ),
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
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Total Expense"),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: charts.PieChart(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 3),
                            behaviors: [
                              new charts.DatumLegend(
                                  outsideJustification:
                                      charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxRows: 4,
                                  cellPadding: new EdgeInsets.only(
                                      right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                    fontSize: 11,
                                  ))
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.inside)
                                ]),
                          ))
                        ],
                      ),
                    ),
                  ),
                )
        ],
      )),
    );
  }

  void loadData() async {
    String urlLoadData = server + "/php/load_data.php";
    await http.post(urlLoadData, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "Data Empty") {
        print(res.body);
        titleCenter = "No Data Found";
        setState(() {
          userData = null;
        });
      } else {
        setState(() {
          print(res.body);
          var extractdata = json.decode(res.body);
          userData = extractdata["data"];

          totalFood = 0.0;
          totalTransportation = 0.0;
          totalUtilities = 0.0;
          totalClothing = 0.0;
          totalHealthcare = 0.0;
          totalInsurance = 0.0;
          totalHItems = 0.0;
          totalDebt = 0.0;
          totalEntertainment = 0.0;
          totalOther = 0.0;
          setState(() {
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Food") {
                  totalFood += double.parse(userData[i]['total']);
                }
              }
            }
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Transportation") {
                  totalTransportation += double.parse(userData[i]['total']);
                }
              }
            }
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Utilities") {
                  totalUtilities += double.parse(userData[i]['total']);
                }
              }
            }
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Clothing") {
                  totalClothing += double.parse(userData[i]['total']);
                }
              }
            }
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Healthcare") {
                  totalHealthcare += double.parse(userData[i]['total']);
                }
              }
            }
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Insurance") {
                  totalInsurance += double.parse(userData[i]['total']);
                }
              }
            }
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Household Items") {
                  totalHItems += double.parse(userData[i]['total']);
                }
              }
            }

            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Debt") {
                  totalDebt += double.parse(userData[i]['total']);
                }
              }
            }

            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Entertainment") {
                  totalEntertainment += double.parse(userData[i]['total']);
                }
              }
            }
            for (int i = 0; i < userData.length; i++) {
              if (userData[i]['type'] == "Expense") {
                if (userData[i]['category'] == "Other") {
                  totalOther += double.parse(userData[i]['total']);
                }
              }
            }
            print(totalFood);
          });
          var pieData = [
            new Data('Food', totalFood, Colors.blue),
            new Data('Transportation', totalTransportation, Colors.red),
            new Data('Utilities', totalUtilities, Colors.pink),
            new Data('Clothing', totalClothing, Colors.purple),
            new Data('Healthcare', totalHealthcare, Colors.yellow),
            new Data('Insurance', totalInsurance, Colors.brown),
            new Data('Household Items', totalHItems, Colors.cyan),
            new Data('Debt', totalDebt, Colors.green),
            new Data('Entertainment', totalEntertainment, Colors.blueGrey),
            new Data('Other', totalOther, Colors.orange),
          ];

          _seriesPieData.add(
            charts.Series(
              data: pieData,
              domainFn: (Data data, _) => data.category,
              measureFn: (Data data, _) => data.total,
              colorFn: (Data data, _) =>
                  charts.ColorUtil.fromDartColor(data.colorval),
              id: 'Expense',
              labelAccessorFn: (Data row, _) => '${row.total}',
            ),
          );
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}

class Data {
  String category;
  double total;
  Color colorval;

  Data(this.category, this.total, this.colorval);
}
