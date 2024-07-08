import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_bloc.dart';
import 'package:flutter_danain/widgets/form/otp_form.dart';
import 'package:flutter_danain/widgets/loading/loading_payung.dart';

class StepOtpLupaPin extends StatefulWidget {
  final LupaPinBloc lpBloc;
  const StepOtpLupaPin({
    super.key,
    required this.lpBloc,
  });

  @override
  State<StepOtpLupaPin> createState() => _StepOtpLupaPinState();
}

class _StepOtpLupaPinState extends State<StepOtpLupaPin> {
  @override
  void initState() {
    super.initState();
    widget.lpBloc.getOtp();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.lpBloc;
    return StreamBuilder<bool>(
      stream: bloc.isValidStream,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        if (isValid == true) {
          return StreamBuilder<bool>(
            stream: bloc.isLoadingStream,
            builder: (context, snapshot) {
              final isLoading = snapshot.data ?? false;
              return StreamBuilder<String>(
                stream: bloc.noTelpStream,
                builder: (context, snapshot) {
                  final noTelp = snapshot.data ?? 'Nomor telepon anda';
                  return StreamBuilder<String?>(
                    stream: bloc.otpError,
                    builder: (context, snapshot) {
                      final error = snapshot.data;
                      return OtpWidget(
                        appbarTitle: 'Lupa Pin',
                        noTelp: noTelp,
                        digit: 6,
                        onChangeOtp: (String? val) {
                          bloc.errorOtpChange(null);
                        },
                        onCompleteOtp: (String val) {
                          bloc.otpChange(val);
                        },
                        postClick: () {
                          bloc.isLoadingChange(true);
                          bloc.validateOtp();
                        },
                        resend: () => bloc.resendGetOtp(),
                        backAction: () {
                          Navigator.pop(context);
                        },
                        isLoadingButton: isLoading,
                        errorText: error,
                      );
                    },
                  );
                },
              );
            },
          );
        }
        return const LoadingDanain();
      },
    );
  }
}
