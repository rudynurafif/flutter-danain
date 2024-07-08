import 'package:flutter_danain/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/form/keybord.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_page.dart';

class PinWidget extends StatefulWidget {
  final VoidCallback actionBack;
  final String titleAppbar;
  final String title;
  final String subtitle;
  final Function1<String, void> onChangePin;
  final Function1<String, void> onCompletePin;
  final String? errorPin;
  const PinWidget({
    super.key,
    required this.title,
    required this.titleAppbar,
    required this.subtitle,
    required this.actionBack,
    required this.onChangePin,
    required this.onCompletePin,
    this.errorPin,
  });

  @override
  State<PinWidget> createState() => _PinWidgetState();
}

class _PinWidgetState extends State<PinWidget> {
  TextEditingController pinController = TextEditingController();
  String errorText = '';
  final defaultPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: TextStyle(
      fontSize: 16,
      color: HexColor(lenderColor),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: HexColor(lenderColor),
      ),
    ),
  );
  final errorPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.red,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: Colors.red,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final error = widget.errorPin;
    return Scaffold(
      appBar: previousTitleCustom(
        context,
        widget.titleAppbar,
        widget.actionBack,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                SvgPicture.asset('assets/lender/register/shield_pin.svg'),
                const SizedBox(height: 32),
                Headline2(
                  text: widget.title,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Subtitle2(
                  text: widget.subtitle,
                  color: HexColor('#777777'),
                  align: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Pinput(
                      obscureText: true,
                      controller: pinController,
                      length: 6,
                      autofocus: true,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: widget.onCompletePin,
                      onChanged: widget.onChangePin,
                      useNativeKeyboard: false,
                      textInputAction: TextInputAction.none,
                      keyboardType: TextInputType.none,
                      defaultPinTheme: error != null ? errorPinTheme : defaultPinTheme,
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Subtitle2(
                          text: error,
                          color: Colors.red,
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
          PinKeyboard(
            onKeyPressed: (key) {
              print(pinController.text);
              if (pinController.text.length < 6 && key != 'backspace') {
                pinController.text += key;
              }
              if (key == 'backspace') {
                print('back bang');
                pinController.text = pinController.text.substring(0, pinController.text.length - 1);
              }
            },
          ),
        ],
      ),
    );
  }
}

class PinWithForgot extends StatefulWidget {
  final VoidCallback actionBack;
  final String titleAppbar;
  final Function1<String, void> onChangePin;
  final Function1<String, void> onCompletePin;
  final String? errorPin;
  final bool isNavigate;
  const PinWithForgot({
    super.key,
    required this.titleAppbar,
    required this.actionBack,
    required this.onChangePin,
    required this.onCompletePin,
    required this.isNavigate,
    this.errorPin,
  });

  @override
  State<PinWithForgot> createState() => _PinWithForgotState();
}

class _PinWithForgotState extends State<PinWithForgot> {
  TextEditingController pinController = TextEditingController();
  String errorText = '';
  final defaultPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: TextStyle(
      fontSize: 16,
      color: HexColor(lenderColor),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: HexColor(lenderColor),
      ),
    ),
  );
  final errorPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.red,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: Colors.red,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final error = widget.errorPin;
    return Scaffold(
      appBar: previousTitleCustom(
        context,
        widget.titleAppbar,
        widget.actionBack,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              SvgPicture.asset('assets/lender/register/shield_pin.svg'),
              const SizedBox(height: 32),
              const Headline2(
                text: 'Masukan PIN',
                align: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Pinput(
                    obscureText: true,
                    controller: pinController,
                    length: 6,
                    autofocus: true,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: widget.onCompletePin,
                    onChanged: widget.onChangePin,
                    useNativeKeyboard: false,
                    textInputAction: TextInputAction.none,
                    keyboardType: TextInputType.none,
                    defaultPinTheme: error != null ? errorPinTheme : defaultPinTheme,
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Subtitle2(
                        text: error,
                        color: Colors.red,
                      ),
                    )
                ],
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, LupaPinPage.routeName);
                },
                child: Headline2(
                  text: 'Lupa PIN?',
                  color: HexColor(lenderColor),
                  align: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PinKeyboard(
            onKeyPressed: (key) {
              print(pinController.text);
              if (pinController.text.length < 6 && key != 'backspace') {
                pinController.text += key;
              }
              if (key == 'backspace') {
                print('back bang');
                pinController.text = pinController.text.substring(0, pinController.text.length - 1);
              }
            },
          ),
        ],
      ),
    );
  }
}

class PinWithForgotNoClose extends StatefulWidget {
  final Function1<String, void> onChangePin;
  final Function1<String, void> onCompletePin;
  final String? errorPin;
  final bool isNavigate;
  final VoidCallback? actionNavigate;
  const PinWithForgotNoClose({
    super.key,
    required this.onChangePin,
    required this.onCompletePin,
    required this.isNavigate,
    this.errorPin,
    this.actionNavigate,
  });

  @override
  State<PinWithForgotNoClose> createState() => _PinWithForgotNoCloseState();
}

class _PinWithForgotNoCloseState extends State<PinWithForgotNoClose> {
  TextEditingController pinController = TextEditingController();
  String errorText = '';
  final defaultPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: TextStyle(
      fontSize: 16,
      color: HexColor(lenderColor),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: HexColor(lenderColor),
      ),
    ),
  );
  final errorPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.red,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: Colors.red,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final error = widget.errorPin;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                SvgPicture.asset('assets/lender/register/shield_pin.svg'),
                const SizedBox(height: 32),
                const Headline2(
                  text: 'Masukan PIN',
                  align: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Pinput(
                      obscureText: true,
                      controller: pinController,
                      length: 6,
                      autofocus: true,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: widget.onCompletePin,
                      onChanged: widget.onChangePin,
                      useNativeKeyboard: false,
                      textInputAction: TextInputAction.none,
                      keyboardType: TextInputType.none,
                      defaultPinTheme: error != null ? errorPinTheme : defaultPinTheme,
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Subtitle2(
                          text: error,
                          color: Colors.red,
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, LupaPinPage.routeName);
                  },
                  child: Headline2(
                    text: 'Lupa PIN?',
                    color: HexColor(lenderColor),
                    align: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          PinKeyboard(
            onKeyPressed: (key) {
              print(pinController.text);
              if (pinController.text.length < 6 && key != 'backspace') {
                pinController.text += key;
              }
              if (key == 'backspace') {
                print('back bang');
                pinController.text = pinController.text.substring(0, pinController.text.length - 1);
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: widget.isNavigate == false
          ? const SizedBox.shrink()
          : SizedBox(
              height: 45,
              child: Button1(
                btntext: 'Pindah ke Akun Lain',
                action: widget.actionNavigate ??
                    () {
                      print('plist bang ini');
                    },
              ),
            ),
    );
  }
}

class PinWithForgotNoClose2 extends StatefulWidget {
  final Function1<String, void> onChangePin;
  final Function1<String, void> onCompletePin;
  final String? errorPin;
  final bool isNavigate;
  final VoidCallback? actionNavigate;

  const PinWithForgotNoClose2({
    super.key,
    required this.onChangePin,
    required this.onCompletePin,
    required this.isNavigate,
    this.errorPin,
    this.actionNavigate,
  });

  @override
  State<PinWithForgotNoClose2> createState() => _PinWithForgotNoClose2State();
}

class _PinWithForgotNoClose2State extends State<PinWithForgotNoClose2> {
  TextEditingController pinController = TextEditingController();
  final defaultPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: TextStyle(
      fontSize: 16,
      color: HexColor(lenderColor),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: HexColor(lenderColor),
      ),
    ),
  );
  final errorPinTheme = PinTheme(
    width: 30,
    height: 30,
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.red,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        width: 0.5,
        color: Colors.red,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final error = widget.errorPin;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                SvgPicture.asset('assets/lender/register/shield_pin.svg'),
                const SizedBox(height: 32),
                const Headline2(
                  text: 'Masukan PIN',
                  align: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Pinput(
                      obscureText: true,
                      controller: pinController,
                      length: 6,
                      autofocus: true,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: widget.onCompletePin,
                      onChanged: widget.onChangePin,
                      useNativeKeyboard: false,
                      textInputAction: TextInputAction.none,
                      keyboardType: TextInputType.none,
                      defaultPinTheme: error != null ? errorPinTheme : defaultPinTheme,
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Subtitle2(
                          text: error,
                          color: Colors.red,
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, LupaPinPage.routeName);
                  },
                  child: Headline2(
                    text: 'Lupa PIN?',
                    color: HexColor(lenderColor),
                    align: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          PinKeyboard(
            onKeyPressed: (key) {
              if (key != 'backspace') {
                if (pinController.text.length < 6) {
                  pinController.text += key;
                }
              } else {
                if (pinController.text.isNotEmpty) {
                  pinController.text =
                      pinController.text.substring(0, pinController.text.length - 1);
                }
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: widget.isNavigate == false
          ? const SizedBox.shrink()
          : SizedBox(
              height: 45,
              child: ButtonNoCircular(
                btntext: 'Pindah ke Akun Lain',
                action: widget.actionNavigate ??
                    () {
                      print('plist bang ini');
                    },
              ),
            ),
    );
  }
}
