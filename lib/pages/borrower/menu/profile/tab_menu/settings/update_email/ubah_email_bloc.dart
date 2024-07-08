import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/ubah_email_use_case_1.dart';
import 'package:flutter_danain/domain/usecases/ubah_email_use_case_2.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class UbahEmailBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;
  final Stream<Result<AuthenticationState>?> authState;

  //controller
  final Function1<int, void> stepControl;
  final Function1<String, void> reqOtp;
  final Function1<String, void> otpControl;
  final Function1<String, void> kodeVerifikasiControl;
  final Function1<File, void> fileControl;
  final Function1<String, void> newEmailControl;

  //submit trigger
  final Function0<void> submitOtp;
  final Function0<void> submitChangeEmail;

  //stream
  final Stream<int> stepStream;
  final Stream<File> fileStream;
  final Stream<String?> emailError;
  final Stream<bool> buttonChangeEmail;
  final Stream<String> newEmailStream;

  //stream message
  final Stream<UpdateEmailMessage?> messageValidateOtp;
  final Stream<UpdateEmailMessage?> messageChangeEmail;

  UbahEmailBloc._({
    required this.apiService,
    required this.authState,
    required this.stepControl,
    required this.reqOtp,
    required this.otpControl,
    required this.submitOtp,
    required this.submitChangeEmail,
    required this.kodeVerifikasiControl,
    required this.stepStream,
    required this.fileControl,
    required this.fileStream,
    required this.newEmailControl,
    required this.emailError,
    required this.buttonChangeEmail,
    required this.messageValidateOtp,
    required this.messageChangeEmail,
    required this.newEmailStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory UbahEmailBloc(
    final GetAuthStateStreamUseCase getAuthState,
    final UpdateEmailUseCase1 validasiOtpForEmail,
    final UpdateEmailUseCase2 changeEmailReq,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final otpController = BehaviorSubject<String>();
    final validateOtpClick = PublishSubject<void>();

    //change email
    final kodeController = BehaviorSubject<String>();
    final newEmailController = BehaviorSubject<String>();
    final fileController = BehaviorSubject<File>();
    final changeEmailClick = PublishSubject<void>();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    final authenticationState$ = getAuthState();
    final authState$ = authenticationState$;

    Future<String> hp() async {
      final event = await authenticationState$.first;
      return event.orNull()!.userAndToken!.user.tlpmobile;
    }

    final newEmailError$ = newEmailController.stream.map((newHp) {
      if (Validator.isValidEmail(newHp)) {
        return null;
      } else {
        return 'Email tidak valid';
      }
    });

    final credential = Rx.combineLatest2(
      otpController.stream,
      hp().asStream(),
      (String a, String b) => CredentialValidasiOtpEmail(otp: a, hp: b),
    );

    final submitOtp$ = validateOtpClick.stream.share();

    final messageValidateOtp = Rx.merge([
      submitOtp$
          .withLatestFrom(
            credential,
            (_, CredentialValidasiOtpEmail cred) => cred,
          )
          .exhaustMap(
            (value) => validasiOtpForEmail(
              hp: value.hp,
              otp: value.otp,
            ),
          )
          .map(_responseMessage)
    ]);

    void reqOtp(String type) async {
      final event = await authenticationState$.first;
      final response = await apiService.reqOtpUpdateEmail(
          event.orNull()!.userAndToken!.token,
          event.orNull()!.userAndToken!.user.tlpmobile,
          type);
      print(response);
      if (response == true && type == 'request') {
        stepController.sink.add(2);
      }
    }

    //update email
    final credentialUpdate = Rx.combineLatest3(
      newEmailController.stream,
      kodeController.stream,
      fileController.stream,
      (String a, String b, File c) => CredentialUpdateEmail(
          new_email: a, type: 'request', kode_verifikasi: b, fileimage: c),
    );

    final buttonChangeEmail = Rx.combineLatest3(
      newEmailController.stream,
      kodeController.stream,
      fileController.stream,
      (String? a, String? kode, File? c) {
        return a != null &&
            kode != null &&
            c != null &&
            Validator.isValidPhoneNumber(a);
      },
    ).shareValueSeeded(false);

    final submitChangeEmail$ = changeEmailClick.stream
        .withLatestFrom(buttonChangeEmail, (_, bool isValid) => isValid)
        .share();

    final messageChangeEmail$ = Rx.merge([
      submitChangeEmail$
          .where((isValid) => isValid)
          .withLatestFrom(
              credentialUpdate, (_, CredentialUpdateEmail cred) => cred)
          .exhaustMap(
            (val) => changeEmailReq(
                new_email: val.new_email,
                kode: val.kode_verifikasi,
                fileimage: val.fileimage,
                type: val.type),
          )
          .map(_responseMessage)
    ]);

    final disposeCallback = () {};

    return UbahEmailBloc._(
      apiService: apiService,
      authState: authState$,
      otpControl: (String otp) => otpController.add(otp),
      stepControl: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      reqOtp: reqOtp,
      kodeVerifikasiControl: (String val) => kodeController.sink.add(val),
      messageValidateOtp: messageValidateOtp,
      submitOtp: () => validateOtpClick.add(null),
      newEmailControl: (String val) => newEmailController.sink.add(val),
      fileControl: (File val) => fileController.sink.add(val),
      fileStream: fileController.stream,
      emailError: newEmailError$,
      newEmailStream: newEmailController.stream,
      buttonChangeEmail: buttonChangeEmail,
      submitChangeEmail: () => changeEmailClick.add(null),
      messageChangeEmail: messageChangeEmail$,
      dispose: disposeCallback,
    );
  }

  static UpdateEmailMessage? _responseMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const UpdateEmailSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : UpdateEmailErrorMessage(appError.message!, appError.error!),
    );
  }
}

class CredentialValidasiOtpEmail {
  final String otp;
  final String hp;

  const CredentialValidasiOtpEmail({
    required this.otp,
    required this.hp,
  });
}

class CredentialUpdateEmail {
  final String new_email;
  final String kode_verifikasi;
  final String type;
  final File fileimage;

  const CredentialUpdateEmail({
    required this.new_email,
    required this.kode_verifikasi,
    required this.type,
    required this.fileimage,
  });
}
