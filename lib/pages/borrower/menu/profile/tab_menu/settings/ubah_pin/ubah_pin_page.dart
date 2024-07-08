
import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/ubah_pin/ubah_pin_bloc.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../../data/constants.dart';
import '../../../../../../../layout/appBar_previousTitleCustom.dart';

class UbahPinPage extends StatefulWidget {
  static const routeName = '/change_Pin_page';
  const UbahPinPage({super.key});

  @override
  State<UbahPinPage> createState() => _UbahPinPageState();
}

class _UbahPinPageState extends State<UbahPinPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final bloc = UbahPinBloc();
  TextEditingController pinController = TextEditingController();
  TextEditingController newPinController = TextEditingController();
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
    return StreamBuilder<int>(
        stream: bloc.isPinStream,
        builder: (context, snapshot) {
    return Scaffold(
      appBar: previousTitleCustom(context, 'Ubah Pin', () {
        Navigator.pop(context);
      }),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: masukanPin(),
      ),
    );
        }
        );
  }

  Widget masukanPin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/lender/register/shield_pin.svg'),
        const SizedBox(height: 32),
         Text(
          'Masukkan Pin saat ini',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: HexColor('#333333')),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'PIN digunakan untuk otorisasi penggunaan akun maupun transaksi',
          style: TextStyle(color: HexColor('#777777')),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Pinput(
              obscureText: true,
              controller: pinController,
              length: 6,
              separatorBuilder: (index) => const SizedBox(width: 8),
              useNativeKeyboard: true,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              // onCompleted: widget.onChangePin,
              autofocus: true,
              onChanged: (value) {
                bloc.pinController.sink.add(value);
              },
              textInputAction: TextInputAction.none,
              defaultPinTheme: defaultPinTheme,
            ),
          ],
        )
      ],
    );
  }

}
