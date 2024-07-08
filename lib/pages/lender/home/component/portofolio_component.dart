import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterComponent extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const FilterComponent({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 7,
        ),
        decoration: ShapeDecoration(
          color: const Color(0xFFFCFEFD),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFD3EEDE)),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/lender/pendanaan/filter.svg',
            ),
            const SizedBox(width: 8),
            Subtitle2(text: title)
          ],
        ),
      ),
    );
  }
}

class FilterComponentNoBorder extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const FilterComponentNoBorder({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 7,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/lender/pendanaan/filter.svg',
            ),
            const SizedBox(width: 8),
            Subtitle2(text: title)
          ],
        ),
      ),
    );
  }
}
