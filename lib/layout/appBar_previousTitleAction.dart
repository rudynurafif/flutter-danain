import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

PreferredSizeWidget prevTitleWithAction(
  BuildContext context,
  String title,
  List<Widget> listAction,
  PreferredSizeWidget? bottom,
) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      surfaceTintColor: const Color(0xFFFFFFFF),
      automaticallyImplyLeading: false,
      shadowColor: Colors.grey,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset('assets/images/icons/back.svg'),
      ),
      actions: listAction,
      bottom: bottom,
    ),
  );
}
