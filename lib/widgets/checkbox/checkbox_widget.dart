import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/space_h.dart';
import 'package:hexcolor/hexcolor.dart';

Widget checkBoxBorrower(bool isSelected, Widget content) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      checkOrNotBorrower(isSelected),
      const SizedBox(width: 10),
      Flexible(child: content),
    ],
  );
}

Widget checkOrNotBorrower(bool isSelected) {
  if (isSelected == true) {
    return Container(
      width: 16,
      height: 16,
      decoration: ShapeDecoration(
        color: HexColor('#288C50'),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: HexColor('#E9F6EB')),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 12,
      ),
    );
  } else {
    return Container(
      width: 16,
      height: 16,
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F3F3),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

Widget checkBoxLender(bool isSelected, Widget content) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      checkOrNotLender(isSelected),
      const SizedBox(width: 10),
      Flexible(child: content),
    ],
  );
}

class CheckBoxBorrower extends StatelessWidget {
  final bool isCheck;
  final Widget title;
  final VoidCallback onTap;
  const CheckBoxBorrower({
    super.key,
    required this.isCheck,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          checkOrNotBorrower(isCheck),
          const SpacerH(),
          Flexible(child: title),
        ],
      ),
    );
  }
}

Widget checkOrNotLender(bool isSelected) {
  if (isSelected == true) {
    return Container(
      width: 16,
      height: 16,
      decoration: ShapeDecoration(
        color: HexColor(lenderColor),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: HexColor('#E9F6EB')),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 12,
      ),
    );
  } else {
    return Container(
      width: 16,
      height: 16,
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F3F3),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
