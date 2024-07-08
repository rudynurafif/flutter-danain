import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class GangguanKoneksiScreen extends StatefulWidget {
  static const routeName = '/gangguan_konekasi_screen';
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<GangguanKoneksiScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 17);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PreferencePage()));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset("assets/images/logo/logo_splash.png"),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              'Your App Name',
              style: TextStyle(fontSize: 50.0, color: Colors.white),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            SizedBox(
              height: 20,
            ),
            SleekCircularSlider(
              min: 0,
              max: 100,
              initialValue: 100,
              appearance: CircularSliderAppearance(
                infoProperties: InfoProperties(
                    mainLabelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 25,
                    )
                ),
                customColors: CustomSliderColors(
                    dotColor: Colors.white,
                    progressBarColor: Colors.black,
                    shadowColor: Colors.white,
                    trackColor: Colors.white),
                spinnerDuration: 10,
                animDurationMultiplier: 10,
                animationEnabled: true,
                startAngle: 0.0,
                angleRange: 360,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Initializing app...',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}