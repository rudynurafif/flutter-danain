import 'package:flutter_danain/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/tarik_dana/tarik_dana.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';

class Step2TarikDana extends StatefulWidget {
  final TarikDanaBloc tdBloc;
  const Step2TarikDana({super.key, required this.tdBloc});

  @override
  State<Step2TarikDana> createState() => _Step2TarikDanaState();
}

class _Step2TarikDanaState extends State<Step2TarikDana> {
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
    final bloc = widget.tdBloc;
    return WillPopScope(
      child: StreamBuilder<String?>(
        stream: bloc.errorPin,
        builder: (context, snapshot) {
          return PinWithForgot(
            titleAppbar: '',
            actionBack: () {
              bloc.stepControl(1);
            },
            onChangePin: bloc.pinControl,
            onCompletePin: (String val) {
              bloc.stepControl(3);
              bloc.pinControl(val);
              bloc.checkPin(val);
            },
            isNavigate: false,
            errorPin: snapshot.data,
          );
        },
      ),
      onWillPop: () async {
        bloc.stepControl(1);
        return false;
      },
    );
  }
}
