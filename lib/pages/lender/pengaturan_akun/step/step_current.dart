import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin_bloc.dart';
import 'package:flutter_danain/widgets/form/pin.dart';

class StepCurrentPin extends StatefulWidget {
  final UbahPinLenderBloc pinBloc;
  const StepCurrentPin({super.key, required this.pinBloc});

  @override
  State<StepCurrentPin> createState() => _StepCurrentPinState();
}

class _StepCurrentPinState extends State<StepCurrentPin> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.pinBloc;
    return StreamBuilder<String?>(
      stream: bloc.errorCurrentPin,
      builder: (context, snapshot) {
        return PinWidget(
          title: 'Masukkan PIN saat ini',
          titleAppbar: 'Ubah Pin',
          subtitle:
              'PIN digunakan untuk otorisasi penggunaan akun maupun transaksi',
          actionBack: () {
            Navigator.pop(context);
          },
          onChangePin: (String val) {
            bloc.errorCurrentPinChange(null);
            bloc.currentPinChange(val);
          },
          onCompletePin: (String val) {
            bloc.currentPinChange(val);
            bloc.checkPin();
          },
          errorPin: snapshot.data,
        );
      },
    );
  }
}
