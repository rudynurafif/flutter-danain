import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';

import '../../../../widgets/form/keybord.dart';

class Step5RegisLender extends StatefulWidget {
  final RegisterLenderBloc regisBloc;
  const Step5RegisLender({super.key, required this.regisBloc});

  @override
  State<Step5RegisLender> createState() => _Step5RegisLenderState();
}

class _Step5RegisLenderState extends State<Step5RegisLender> {
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
  @override
  Widget build(BuildContext context) {
    final bloc = widget.regisBloc;
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        bloc.stepControl(4);
      }),
      body:
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      Container(
        height: 230,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/lender/register/shield_pin.svg'),
            const SizedBox(height: 32),
            const Headline2(
              text: 'Buat PIN Baru',
              align: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Subtitle2(
              text:
                  'Buat 6 digit PIN Anda untuk otorisasi penggunaan akun maupun transaksi',
              color: HexColor('#777777'),
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Pinput(
              obscureText: true,
              controller: pinController,
              length: 6,
              separatorBuilder: (index) => const SizedBox(width: 8),
              useNativeKeyboard: false,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                bloc.pinControl(pin);
                bloc.stepControl(6);
              },
              autofocus: true,
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              textInputAction: TextInputAction.none,
              defaultPinTheme: defaultPinTheme,
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
                  pinController.text = pinController.text
                      .substring(0, pinController.text.length - 1);
                }
              },
            ),
      ]
      )

    );
  }
}
