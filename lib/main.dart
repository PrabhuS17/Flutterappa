import 'package:flutter/material.dart';
import 'home.dart';
import 'buy.dart';
import 'services.dart';
import 'dart:isolate';




void printHello() {
  final DateTime now = new DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

void main(){
  final int helloAlarmID = 0;
  runApp(new MyApp());
//  await AndroidAlarmManager.periodic(const Duration(seconds: 1), helloAlarmID, printHello);
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Standard/Stanbic Bank',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  ParentPageState createState() => new ParentPageState();
}

class ParentPageState extends State<MyHomePage> {


  BankService service = new BankService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Standard Bank'),
          ),
          body: TabBarView(
            children: [
              new HomeScreen(),
              Icon(Icons.payment),
              Icon(Icons.all_inclusive),
              new BuyScreenWidget(service: service),
              Icon(Icons.menu),
            ],
          ),
          bottomNavigationBar: new Container(
              color: Colors.white,
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.payment)),
                  Tab(icon: Icon(Icons.all_inclusive)),
                  Tab(icon: Icon(Icons.shopping_cart)),
                  Tab(icon: Icon(Icons.menu)),
                ],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black,
              )),
        ));
  }
}
