import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_bloc.dart';
import 'package:flutter_danain/widgets/form/pin.dart';

class StepNewPin extends StatefulWidget {
  final LupaPinBloc lpBloc;
  const StepNewPin({
    super.key,
    required this.lpBloc,
  });

  @override
  State<StepNewPin> createState() => _StepNewPinState();
}

class _StepNewPinState extends State<StepNewPin> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.lpBloc;
    return PinWidget(
      actionBack: () => bloc.stepChange(1),
      onChangePin: (String val) {
        bloc.newPinChange(val);
      },
      onCompletePin: (String val) {
        bloc.newPinChange(val);
        bloc.stepChange(3);
      },
      titleAppbar: 'Lupa PIN',
      title: 'Buat PIN Baru',
      subtitle: 'Buat 6 digit PIN kamu untuk otorisasi penggunaan akun maupun transaksi',
    );
  }
}
