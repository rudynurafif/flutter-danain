import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class ModalPopUp extends StatelessWidget {
  const ModalPopUp({
    required this.icon,
    required this.title,
    required this.message,
    this.bgColor,
    this.actions = const [],
    super.key,
  });

  final String icon;
  final String title;
  final String message;
  final Color? bgColor;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                icon,
                width: 40,
                height: 40,
              ),
              const SizedBox(height: 16),
              Headline3500(
                text: title,
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text: message,
                align: TextAlign.center,
                color: HexColor('#777777'),
              ),
              getAction(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget getAction(BuildContext context) {
    if (actions.length < 1) {
      return const SizedBox.shrink();
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: actions.map((e) => e).toList(),
        ),
      );
    }
  }
}

class ModalPopUpNoClose extends StatelessWidget {
  const ModalPopUpNoClose({
    required this.icon,
    required this.title,
    required this.message,
    this.dialogKey,
    this.bgColor,
    this.actions = const [],
    this.sizeIcon = 40,
    super.key,
  });
  final double sizeIcon;
  final String icon;
  final String title;
  final String message;
  final GlobalKey<State>? dialogKey;
  final Color? bgColor;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      key: dialogKey,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 14),
                child: SvgPicture.asset(
                  icon,
                  width: sizeIcon,
                  height: sizeIcon,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Headline3500(
                text: title,
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text: message,
                align: TextAlign.center,
                color: HexColor('#777777'),
              ),
              getAction()
            ],
          ),
        ),
      ),
    );
  }

  Widget getAction() {
    if (actions.length < 1) {
      return const SizedBox.shrink();
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: actions.map((e) => e).toList(),
        ),
      );
    }
  }
}

class ModalPopUpNoCloseNoButton extends StatelessWidget {
  const ModalPopUpNoCloseNoButton({
    required this.icon,
    required this.title,
    required this.message,
    this.dialogKey,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  final String icon;
  final String title;
  final String message;
  final GlobalKey<State>? dialogKey;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      key: dialogKey,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  Container(
                    padding: const EdgeInsets.only(top: 14),
                    child: SvgPicture.asset(
                      icon,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  Container()
                ],
              ),
              const SizedBox(height: 16),
              Headline3500(
                text: title,
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text: message,
                align: TextAlign.center,
                color: HexColor('#777777'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalPopUpNoClose2 extends StatelessWidget {
  const ModalPopUpNoClose2({
    required this.icon,
    required this.title,
    required this.message,
    this.dialogKey,
    this.bgColor,
    this.actions = const [],
    Key? key,
  }) : super(key: key);

  final String icon;
  final String title;
  final String message;
  final GlobalKey<State>? dialogKey;
  final Color? bgColor;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      key: dialogKey,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  Container(
                    padding: const EdgeInsets.only(top: 14),
                    child: SvgPicture.asset(
                      icon,
                    ),
                  ),
                  Container()
                ],
              ),
              const SizedBox(height: 16),
              Headline3500(
                text: title,
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text: message,
                align: TextAlign.center,
                color: HexColor('#777777'),
              ),
              getAction()
            ],
          ),
        ),
      ),
    );
  }

  Widget getAction() {
    if (actions.length < 1) {
      return const SizedBox.shrink();
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: actions.map((e) => e).toList(),
        ),
      );
    }
  }
}

class ModalDetailAngsuran extends StatelessWidget {
  final Widget content;

  const ModalDetailAngsuran({Key? key, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: content,
            )
          ],
        ),
      ),
    );
  }
}

class ModalPopUpCustomeContent extends StatelessWidget {
  const ModalPopUpCustomeContent({
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  Headline3500(
                    text: title,
                    align: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              content
            ],
          ),
        ),
      ),
    );
  }
}

class ModalPopUpCustomAction extends StatelessWidget {
  const ModalPopUpCustomAction({
    required this.icon,
    required this.title,
    required this.message,
    required this.callback,
    this.bgColor,
    this.actions = const [],
    Key? key,
  }) : super(key: key);

  final String icon;
  final String title;
  final String message;
  final Color? bgColor;
  final VoidCallback callback;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  Container(
                    padding: const EdgeInsets.only(top: 14),
                    child: SvgPicture.asset(icon),
                  ),
                  InkWell(
                    onTap: callback,
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Headline3500(
                text: title,
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text: message,
                align: TextAlign.center,
                color: HexColor('#777777'),
              ),
              getAction()
            ],
          ),
        ),
      ),
    );
  }

  Widget getAction() {
    if (actions.length < 1) {
      return const SizedBox.shrink();
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: actions.map((e) => e).toList(),
        ),
      );
    }
  }
}

class ModalCloseIcon extends StatelessWidget {
  final Widget child;

  const ModalCloseIcon({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
