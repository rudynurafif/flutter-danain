import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../shimmer/shimmer_widget.dart';

final rxPrefs = RxSharedPreferences(
  SharedPreferences.getInstance(),
  kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
);
Widget tabContent(
  BuildContext context,
  String icon,
  String content,
  bool borderBot,
  int status,
) {
  print('status login $status $content');
  return FutureBuilder<int?>(
    future: rxPrefs.getInt('user_status'),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        int? userStatus = snapshot.data;
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: borderBot
                  ? const BorderSide(color: Color(0xffEEEEEE), width: 1)
                  : const BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  icon,
                  width: 16,
                  height: 16,
                  fit: BoxFit.scaleDown,
                  color: userStatus == 2
                      ? HexColor(borrowerColor)
                      : HexColor(lenderColor),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Headline5(text: content),
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Color(0xffAAAAAA),
                  size: 24,
                ),
              ),
            ],
          ),
        );
      } else {
        return const LinearProgressIndicator();
      }
    },
  );
}

class TabContentBorrower extends StatelessWidget {
  final String icon;
  final String title;
  final bool isBottom;
  final VoidCallback onTap;
  const TabContentBorrower({
    super.key,
    required this.icon,
    required this.title,
    this.isBottom = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: isBottom
                ? const BorderSide(color: Color(0xffEEEEEE), width: 1)
                : const BorderSide(width: 0, color: Colors.transparent),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  HexColor(borrowerColor),
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  icon,
                  width: 16,
                  height: 16,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Headline5(text: title),
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Color(0xffAAAAAA),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget tabContentBorrower(
  BuildContext context,
  String icon,
  String content,
  bool borderBot,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      border: Border(
        bottom: borderBot
            ? const BorderSide(color: Color(0xffEEEEEE), width: 1)
            : const BorderSide(width: 0, color: Colors.transparent),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              HexColor(borrowerColor),
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset(
              icon,
              width: 16,
              height: 16,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Headline5(text: content),
          ),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.keyboard_arrow_right,
            color: Color(0xffAAAAAA),
            size: 24,
          ),
        ),
      ],
    ),
  );
}

Widget tabContentLender(
  BuildContext context,
  String icon,
  String content,
  bool borderBot,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      border: Border(
        bottom: borderBot
            ? const BorderSide(color: Color(0xffEEEEEE), width: 1)
            : const BorderSide(width: 0, color: Colors.transparent),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              HexColor(lenderColor),
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset(
              icon,
              width: 16,
              height: 16,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Headline5(text: content),
          ),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.keyboard_arrow_right,
            color: Color(0xffAAAAAA),
            size: 24,
          ),
        ),
      ],
    ),
  );
}

Widget tabContentLoading(
  BuildContext context,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Color(0xffEEEEEE), width: 1),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const ShimmerCircle(height: 32, width: 32),
        const SizedBox(width: 16),
        ShimmerLong(
          height: 14,
          width: MediaQuery.of(context).size.width / 2.5,
        ),
      ],
    ),
  );
}
