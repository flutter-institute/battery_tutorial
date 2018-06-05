import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Battery Display',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new BatteryLevelPage(),
    );
  }
}

class BatteryLevelPage extends StatefulWidget {
  @override
  _BatteryLevelPageState createState() => new _BatteryLevelPageState();
}

class _BatteryLevelPageState extends State<BatteryLevelPage> {
  int _level = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Battery Level"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Your current battery level is'),
          ],
        ),
      ),
    );
  }
}
