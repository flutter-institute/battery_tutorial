import 'package:flutter/material.dart';
import 'package:battery/battery.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Display',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BatteryLevelPage(),
    );
  }
}

class BatteryLevelPage extends StatefulWidget {
  @override
  _BatteryLevelPageState createState() => _BatteryLevelPageState();
}

class _BatteryLevelPageState extends State<BatteryLevelPage> {
  final Battery _battery = Battery();

  BatteryState _batteryState;
  int _batteryLevel;

  @override
  void initState() {
    super.initState();

    _battery.batteryLevel.then((level) {
      this.setState(() {
        _batteryLevel = level;
      });
    });

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      _battery.batteryLevel.then((level) {
        this.setState(() {
          _batteryLevel = level;
          _batteryState = state;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Battery Level"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 25.0,
              width: 100.0,
              child: CustomPaint(
                painter: _BatteryLevelPainter(_batteryLevel, _batteryState),
                child: _batteryState == BatteryState.charging ? Icon(Icons.flash_on) : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BatteryLevelPainter extends CustomPainter {
  final int _batteryLevel;
  final BatteryState _batteryState;

  _BatteryLevelPainter(this._batteryLevel, this._batteryState);

  @override
  void paint(Canvas canvas, Size size) {
    Paint getPaint({Color color = Colors.black, PaintingStyle style = PaintingStyle.stroke}) {
      return Paint()
        ..color = color
        ..strokeWidth = 1.0
        ..style = style;
    }

    final double batteryRight = size.width - 4.0;

    final RRect batteryOutline = RRect.fromLTRBR(0.0, 0.0, batteryRight, size.height, Radius.circular(3.0));

    // Battery body
    canvas.drawRRect(
      batteryOutline,
      getPaint(),
    );

    // Battery nub
    canvas.drawRect(
      Rect.fromLTWH(batteryRight, (size.height / 2.0) - 5.0, 4.0, 10.0),
      getPaint(style: PaintingStyle.fill),
    );

    // Fill rect
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, batteryRight * _batteryLevel / 100.0, size.height));

    Color indicatorColor;
    if (_batteryLevel < 15) {
      indicatorColor = Colors.red;
    } else if (_batteryLevel < 30) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = Colors.green;
    }

    canvas.drawRRect(
      RRect.fromLTRBR(0.5, 0.5, batteryRight - 0.5, size.height - 0.5, Radius.circular(3.0)),
      getPaint(style: PaintingStyle.fill, color: indicatorColor)
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _BatteryLevelPainter old = oldDelegate as _BatteryLevelPainter;
    return old._batteryLevel != _batteryLevel || old._batteryState != _batteryState;
  }
}
