import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';

import '../../../../widgets/form/keybord.dart';

class Step6RegisLender extends StatefulWidget {
  final RegisterLenderBloc regisBloc;
  const Step6RegisLender({super.key, required this.regisBloc});

  @override
  State<Step6RegisLender> createState() => _Step6RegisLenderState();
}

class _Step6RegisLenderState extends State<Step6RegisLender> {
  TextEditingController pinController = TextEditingController();
  String errorText = '';
  @override
  void initState() {
widget.regisBloc.confirmPinErrorControl('');
    super.initState();
    // TODO: implement initState


  }

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
    final bloc = widget.regisBloc;
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        bloc.stepControl(5);
      }),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      Container(
        height: 300,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/lender/register/shield_pin.svg'),
            const SizedBox(height: 32),
            const Headline2(
              text: 'Masukkan kembali PIN',
              align: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Subtitle2(
              text:
                  'Konfirmasi PIN yang telah Anda buat untuk otorisasi penggunaan akun maupun transaksi',
              color: HexColor('#777777'),
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            StreamBuilder<String?>(
              stream: bloc.confirmPinError,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Pinput(
                      obscureText: true,
                      controller: pinController,
                      length: 6,
                      autofocus: true,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        bloc.confirmPinControl(pin);
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                        bloc.confirmPinControl(value);
                      },
                      useNativeKeyboard: false,
                      textInputAction: TextInputAction.none,
                      keyboardType: TextInputType.none,
                      defaultPinTheme:
                          snapshot.hasData ? errorPinTheme : defaultPinTheme,
                    ),
                    if (snapshot.hasData)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Subtitle2(
                          text: snapshot.data!,
                          color: Colors.red,
                        ),
                      )
                  ],
                );
              },
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
