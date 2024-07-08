import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class ModaLBottom extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Widget? action;
  const ModaLBottom({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Added this line
        children: [
          SvgPicture.asset(image),
          const SizedBox(height: 24),
          Headline2(text: title),
          const SizedBox(height: 8),
          Subtitle2(
            text: subtitle,
            align: TextAlign.center,
            color: HexColor('#777777'),
          ),
          action != null ? const SizedBox(height: 24) : Container(),
          action!
        ],
      ),
    );
  }
}

class ModaLBottomTemplate extends StatelessWidget {
  final double padding;
  final Widget child;
  final bool isUseMark;
  const ModaLBottomTemplate({
    super.key,
    this.padding = 16,
    required this.child,
    this.isUseMark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUseMark)
            Center(
              child: Container(
                width: 42,
                height: 4,
                margin: EdgeInsets.only(top: padding == 0 ? 24 : 0),
                decoration: BoxDecoration(
                  color: HexColor('#DDDDDD'),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          child
        ],
      ),
    );
  }
}

class ModalBottomTemplate2 extends StatelessWidget {
  final double padding;
  final Widget child;
  final bool isUseMark;
  const ModalBottomTemplate2({
    super.key,
    this.padding = 24,
    required this.child,
    this.isUseMark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUseMark)
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: HexColor('#DDDDDD'),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          child
        ],
      ),
    );
  }
}
