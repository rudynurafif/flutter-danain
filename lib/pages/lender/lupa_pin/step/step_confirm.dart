import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_bloc.dart';
import 'package:flutter_danain/widgets/form/pin.dart';

class StepConfirm extends StatefulWidget {
  final LupaPinBloc lpBloc;
  const StepConfirm({
    super.key,
    required this.lpBloc,
  });

  @override
  State<StepConfirm> createState() => _StepConfirmState();
}

class _StepConfirmState extends State<StepConfirm> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.lpBloc;
    return StreamBuilder<String?>(
      stream: bloc.errorConfirm,
      builder: (context, snapshot) {
        return PinWidget(
          actionBack: () => bloc.stepChange(2),
          onChangePin: (String val) {
            bloc.confirmPinChange(val);
            bloc.errorConfirmControl(null);
          },
          onCompletePin: (String val) {
            bloc.confirmPinChange(val);
            bloc.checkPin();
          },
          titleAppbar: 'Lupa PIN',
          title: 'Masukkan kembali PIN',
          subtitle:
              'Konfirmasi PIN yang telah kamu buat untuk otorisasi penggunaan akun maupun transaksi',
          errorPin: snapshot.data,
        );
      },
    );
  }
}
