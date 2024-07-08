import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';

class StatusBuilder extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;
  const StatusBuilder({
    super.key,
    required this.title,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: bgColor,
      ),
      alignment: Alignment.center,
      child: Subtitle3(
        text: title,
        color: textColor,
      ),
    );
  }
}
