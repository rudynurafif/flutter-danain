import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/space_h.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:hexcolor/hexcolor.dart';

class TextFormFile extends StatelessWidget {
  final String label;
  final bool isCheck;
  final VoidCallback onTap;
  const TextFormFile({
    super.key,
    required this.label,
    required this.isCheck,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFDDDDDD),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: HexColor('#8EB69B'),
                  size: 24,
                ),
                const SpacerH(value: 12),
                TextWidget(
                  text: label,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            IconCheckCircle(isChecked: isCheck),
          ],
        ),
      ),
    );
  }
}

class IconCheckCircle extends StatelessWidget {
  final bool isChecked;
  const IconCheckCircle({
    super.key,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    if (isChecked) {
      return Container(
        width: 18,
        height: 18,
        decoration: ShapeDecoration(
          color: HexColor('#28AF60'),
          shape: const OvalBorder(),
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 12,
          color: Colors.white,
        ),
      );
    }
    return Container(
      width: 18,
      height: 18,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: OvalBorder(
          side: BorderSide(width: 1, color: Color(0xFFAAAAAA)),
        ),
      ),
    );
  }
}
