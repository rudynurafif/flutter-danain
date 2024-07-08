import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_danain/component/auxpage/preference_component.dart';
import 'package:flutter_danain/layout/appBar_LeftLogo.dart';
import 'package:flutter_danain/layout/footer_Lisence.dart';

class PreferencePage extends StatelessWidget{
  static const routeName = '/preference_page';
  const PreferencePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: leftLogoWidget(context),
      //set drawer from app_drawer.dart
      //set like this where ever you want
      body: StartPage(),
      bottomNavigationBar: footerLisence(context),

    );
  }
}