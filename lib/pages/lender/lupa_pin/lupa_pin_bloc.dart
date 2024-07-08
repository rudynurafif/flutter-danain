import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/req_otp_forgot_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/resend_otp_forgot_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/reset_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/val_otp_forgot_pin_use_case.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_state.dart';
import 'package:flutter_danain/utils/utils.dart';

class LupaPinBloc extends DisposeCallbackBaseBloc {
  Function1<int, void> stepChange;
  Function1<String, void> otpChange;
  Function1<String?, void> errorOtpChange;
  Function0<void> getDataUser;
  Function1<bool, void> isLoadingChange;
  Function1<String, void> newPinChange;
  Function1<String, void> confirmPinChange;
  Function1<bool, void> isValidChange;

  Stream<int> stepStream;
  Stream<String> otpStream;
  Stream<bool> isLoadingStream;
  Stream<bool> isValidStream;
  Stream<String> noTelpStream;
  Stream<String?> errorConfirm;
  Stream<String?> otpError;

  //trigger post or get
  Function0<void> getOtp;
  Function0<void> resendGetOtp;
  Function0<void> validateOtp;
  Function0<void> checkPin;
  Function1<String?, void> errorConfirmControl;
  Function1<String, void> keyChange;

  Stream<LupaPinMessage?> messageReqOtp;
  Stream<LupaPinMessage?> messageResendOtp;
  Stream<LupaPinMessage?> messageValidateOtp;
  Stream<LupaPinMessage?> messageCheckPin;

  LupaPinBloc._({
    required this.stepChange,
    required this.otpChange,
    required this.errorOtpChange,
    required this.getDataUser,
    required this.stepStream,
    required this.otpStream,
    required this.otpError,
    required this.noTelpStream,
    required this.isLoadingChange,
    required this.isLoadingStream,
    required this.getOtp,
    required this.messageReqOtp,
    required this.messageResendOtp,
    required this.resendGetOtp,
    required this.messageValidateOtp,
    required this.messageCheckPin,
    required this.validateOtp,
    required this.keyChange,
    required this.confirmPinChange,
    required this.newPinChange,
    required this.checkPin,
    required this.errorConfirm,
    required this.errorConfirmControl,
    required this.isValidChange,
    required this.isValidStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory LupaPinBloc(
    GetAuthStateStreamUseCase getAuthState,
    ReqOtpForgotPinUseCase reqOtp,
    ResendOtpForgotPinUseCase resendOtp,
    ValOtpForgotPinUseCase valOtp,
    ResetPinUseCase resetPin,
  ) {
    final authState = getAuthState();
    final stepController = BehaviorSubject<int>.seeded(1);
    final otpController = BehaviorSubject<String>();
    final noTelpController = BehaviorSubject<String>();
    final keyController = BehaviorSubject<String>();
    final otpErrorController = BehaviorSubject<String?>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final getOtpController = PublishSubject<void>();
    final resendOtpController = PublishSubject<void>();
    final validateOtpController = PublishSubject<void>();
    final newPinController = BehaviorSubject<String>();
    final confirmPinController = BehaviorSubject<String>();
    final confirmPinErrorController = BehaviorSubject<String?>();
    final resetPinController = BehaviorSubject<String?>();
    final isValidController = BehaviorSubject<bool>.seeded(false);

    void getDataUser() async {
      final event = await authState.first;
      final noTelp = event.orNull()!.userAndToken!.user.tlpmobile;
      noTelpController.add(noTelp);
    }

    final reqClick = getOtpController.stream.share();
    final messageReqOtp = Rx.merge(
        [reqClick.exhaustMap((_) => reqOtp()).map(_responseToMessage)]);
    final resendClick = resendOtpController.stream.share();
    final messageResendOtp = Rx.merge(
        [resendClick.exhaustMap((_) => resendOtp()).map(_responseToMessage)]);

    //validate
    final validateClick = validateOtpController.stream.share();
    final messageValidate = Rx.merge(
      [
        validateClick
            .withLatestFrom(otpController.stream, (_, String cred) => cred)
            .exhaustMap((value) => valOtp(kode: value))
            .map(_responseToMessage)
      ],
    );
    void dispose() {
      stepController.close();
      otpErrorController.close();
      otpController.close();
    }

    void checkPin() {
      final newPin = newPinController.valueOrNull;
      final confirmPin = confirmPinController.valueOrNull;
      if (newPin == confirmPin) {
        resetPinController.add(null);
      } else {
        confirmPinErrorController.add('Konfirmasi PIN tidak sesuai');
      }
    }

    final resetPinClick = resetPinController.stream.share();
    final credential = Rx.combineLatest2(
      newPinController.stream,
      keyController.stream,
      (String a, String b) => CredentialReset(pin: a, key: b),
    );

    final messageReset = Rx.merge([
      resetPinClick
          .withLatestFrom(credential, (_, CredentialReset cred) => cred)
          .exhaustMap(
            (value) => resetPin(
              key: value.key,
              pin: value.pin,
            ),
          )
          .map(_responseToMessage)
    ]);

    return LupaPinBloc._(
      stepChange: (int val) => stepController.add(val),
      otpChange: (String val) => otpController.add(val),
      errorOtpChange: (String? val) => otpErrorController.add(val),
      noTelpStream: noTelpController.stream,
      stepStream: stepController.stream,
      otpStream: otpController.stream,
      otpError: otpErrorController.stream,
      keyChange: (String val) => keyController.add(val),
      getDataUser: getDataUser,
      isLoadingChange: (bool val) => isLoadingController.add(val),
      isLoadingStream: isLoadingController.stream,
      messageReqOtp: messageReqOtp,
      getOtp: () => getOtpController.add(null),
      resendGetOtp: () => resendOtpController.add(null),
      messageResendOtp: messageResendOtp,
      validateOtp: () => validateOtpController.add(null),
      confirmPinChange: (String val) => confirmPinController.add(val),
      newPinChange: (String val) => newPinController.add(val),
      messageValidateOtp: messageValidate,
      errorConfirmControl: (String? val) => confirmPinErrorController.add(val),
      errorConfirm: confirmPinErrorController.stream,
      messageCheckPin: messageReset,
      isValidChange: (bool val) => isValidController.add(val),
      isValidStream: isValidController.stream,
      checkPin: checkPin,
      dispose: dispose,
    );
  }

  static LupaPinMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const LupaPinSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : LupaPinErrorMessage(appError.message!, appError.error!),
    );
  }
}

class CredentialReset {
  final String pin;
  final String key;

  const CredentialReset({
    required this.pin,
    required this.key,
  });
}
