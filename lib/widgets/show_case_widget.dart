import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView(
      {super.key,
      required this.globalKey,
      required this.title,
      required this.description,
      required this.child,
      this.shapeBorder = const CircleBorder()});

  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;
  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey, title: title, description: description,
      showArrow: true,
      titleTextStyle: TextStyle(
        color: HexColor('#333333'),
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ), // Custom font size for title
      descTextStyle: TextStyle(
        color: HexColor('#777777'),
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      child: child,
      disposeOnTap: true,
      onTargetClick: () {},
    );
  }
}
