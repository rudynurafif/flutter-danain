import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';

class ContentMenu extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool icon;
  final VoidCallback? navigate;
  ContentMenu({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.navigate,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigate ?? () {},
      child: Row(
        children: [
          SvgPicture.asset(image, width: 52, height: 52),
          SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headline5(text: title, align: TextAlign.start),
                SizedBox(height: 4),
                Subtitle2(
                  text: subtitle,
                  align: TextAlign.start,
                  color: Color(0xff777777),
                )
              ],
            ),
          ),
          icon
              ? Icon(
                  Icons.keyboard_arrow_right,
                  color: Color(0xff27AE60),
                  size: 20,
                )
              : Container()
        ],
      ),
    );
  }
}
