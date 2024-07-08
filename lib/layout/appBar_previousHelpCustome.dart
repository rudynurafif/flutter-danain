import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';

PreferredSizeWidget previousHelpCustomeWidget(
  BuildContext context,
  VoidCallback action,
) {
  print(context);
  if (context != null && context.widget != null) {
    // YourWidgetType is a valid widget and context is not null or empty
    // You can perform actions here
    print(' contect kosong ');
  } else {
    // Context is not valid or empty
    // Handle the case where context is not what you expected

    print(' contect ada ');
  }
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 2),
            spreadRadius: 1,
          )
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: const Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        shadowColor: Colors.grey,
        leading: context != null && context.widget != null
            ? IconButton(
                onPressed: action,
                icon: SvgPicture.asset('assets/images/icons/back.svg'),
              )
            : null,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, HelpTemporary.routeName);
              },
              child: const Text(
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
      ),
    ),
  );
}

PreferredSizeWidget previousUseHelpWidget(
  BuildContext context,
  VoidCallback action,
  bool isHelp,
) {
  print(context);
  if (context != null && context.widget != null) {
    // YourWidgetType is a valid widget and context is not null or empty
    // You can perform actions here
    print(' contect kosong ');
  } else {
    // Context is not valid or empty
    // Handle the case where context is not what you expected

    print(' contect ada ');
  }
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 2),
            spreadRadius: 1,
          )
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: const Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        shadowColor: Colors.grey,
        leading: context != null && context.widget != null
            ? IconButton(
                onPressed: action,
                icon: SvgPicture.asset('assets/images/icons/back.svg'),
              )
            : null,
        actions: [
          if (isHelp == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, HelpTemporary.routeName);
                },
                child: const Text(
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
      ),
    ),
  );
}

PreferredSizeWidget previousWithActionCustomWidget(
  BuildContext context,
  String title,
  String contentAction,
  VoidCallback action,
) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 2),
            spreadRadius: 1,
          )
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: const Color(0xFFFFFFFF),
        shadowColor: Colors.grey,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/images/icons/back.svg'),
        ),
        title: Headline2500(text: title),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
            child: InkWell(
              onTap: action,
              child: Subtitle2(
                text: contentAction,
                color: const Color(0xff288C50),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
