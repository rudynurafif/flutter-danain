import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';

import '../pages/help_temp/help_temp.dart';


PreferredSizeWidget previousHelpWidget(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.white,
    leading: IconButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        )),
    actions: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, HelpTemporary.routeName);
          },
          child: Text(
            'Bantuan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff288C50),
            ),
          ),
        ),
      )
    ],
  );
}
