import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final bool isLeading;
  final String? title;
  final Function()? leadingAction;
  final List<Widget>? actions;
  final Color? background;
  final PreferredSize? bottom;
  final double? elevation;

  const AppBarWidget({
    super.key,
    required this.context,
    required this.isLeading,
    this.title,
    this.leadingAction,
    this.actions,
    this.background,
    this.bottom,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: background ?? Colors.white,
      surfaceTintColor: Colors.white,
      elevation: elevation ?? 20,
      shadowColor: const Color.fromARGB(50, 0, 0, 0),
      title: TextWidget(
        text: title ?? '',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        align: TextAlign.center,
        color: Colors.black,
      ),
      leading: isLeading == true
          ? IconButton(
              icon: SvgPicture.asset('assets/images/icons/back.svg'),
              onPressed: leadingAction ??
                  () {
                    Navigator.pop(context);
                  },
            )
          : null,
      actions: actions,
      bottom: bottom ??
          const PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: SizedBox.shrink(),
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
