import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin_bloc.dart';
import 'package:flutter_danain/widgets/form/pin.dart';

class StepNew extends StatefulWidget {
  final UbahPinLenderBloc pinBloc;
  const StepNew({super.key, required this.pinBloc});

  @override
  State<StepNew> createState() => _StepNewState();
}

class _StepNewState extends State<StepNew> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.pinBloc;
    return PinWidget(
      titleAppbar: 'Ubah Pin',
      title: 'Buat PIN Baru',
      subtitle:
          'Buat 6 digit PIN Anda untuk otorisasi penggunaan akun maupun transaksi',
      actionBack: () {
        bloc.stepChange(1);
      },
      onChangePin: bloc.newPinChange,
      onCompletePin: (String val) {
        bloc.newPinChange(val);
        bloc.stepChange(3);
      },
    );
  }
}
