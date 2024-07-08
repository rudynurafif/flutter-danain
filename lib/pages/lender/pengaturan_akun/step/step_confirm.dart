import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin_bloc.dart';
import 'package:flutter_danain/widgets/form/pin.dart';

class StepConfirmPin extends StatefulWidget {
  final UbahPinLenderBloc pinBloc;
  const StepConfirmPin({super.key, required this.pinBloc});

  @override
  State<StepConfirmPin> createState() => _StepConfirmPinState();
}

class _StepConfirmPinState extends State<StepConfirmPin> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.pinBloc;
    return StreamBuilder<String?>(
        stream: bloc.errorPin,
        builder: (context, snapshot) {
          return PinWidget(
            titleAppbar: 'Ubah Pin',
            title: 'Masukkan kembali PIN',
            subtitle:
                'Konfirmasi PIN yang telah Anda buat untuk otorisasi penggunaan akun maupun transaksi',
            actionBack: () {
              bloc.stepChange(2);
            },
            onChangePin: (String val) {
              bloc.confirmPinChange(val);
              bloc.errorPinChange(null);
            },
            onCompletePin: (String val) {
              bloc.isLoadingChange(true);
              bloc.confirmPinChange(val);
              bloc.postPin();
            },
            errorPin: snapshot.data,
          );
        });
  }
}
