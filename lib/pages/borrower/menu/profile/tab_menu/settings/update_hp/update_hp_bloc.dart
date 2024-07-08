import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/ubah_hp_use_case.dart';
import 'package:flutter_danain/domain/usecases/ubah_hp_validasi_user_case.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/update_hp_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class UpdateHpBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;
  final Stream<Result<AuthenticationState>> authState;

  final Function1<int, void> stepControl;
  final Function1<String, void> newHpControl;
  final Function1<String, void> kodeControl;
  final Function1<File, void> fileControl;
  final Function1<String, void> otpControl;
  final Function0<void> submitOtp;

  final Stream<int> stepStream;
  final Stream<File> fileStream;
  final Stream<String?> newHpError;
  final Stream<bool> buttonReqOtp;
  final Stream<UpdateHpMessage?> messageReqOtp;
  final Stream<UpdateHpMessage?> messageValidasiOtp;

  UpdateHpBloc._({
    required this.apiService,
    required this.authState,
    required this.newHpControl,
    required this.fileControl,
    required this.stepControl,
    required this.submitOtp,
    required this.otpControl,
    required this.stepStream,
    required this.kodeControl,
    required this.fileStream,
    required this.newHpError,
    required this.buttonReqOtp,
    required this.messageReqOtp,
    required this.messageValidasiOtp,
    required Function0<void> dispose,
  }) : super(dispose);

  factory UpdateHpBloc(
    final GetAuthStateStreamUseCase getAuthState,
    final UpdateHpUseCase reqOtp,
    final UpdateHpValidasiUseCase valOtp,
  ) {
    final stepController = BehaviorSubject<int>();
    final newHpController = BehaviorSubject<String>();
    final kodeController = BehaviorSubject<String>.seeded('ok');
    final submitOtpController = PublishSubject<void>();
    final otpController = BehaviorSubject<String>();
    final validateOtpController = BehaviorSubject<String>();

    final fileController = BehaviorSubject<File>();
    final credential = Rx.combineLatest3(
      newHpController.stream,
      kodeController.stream,
      fileController.stream,
      (String a, String b, File c) =>
          CredentialReqOtp(new_hp: a, kode_verifikasi: b, fileimage: c),
    );
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    final authenticationState$ = getAuthState();
    final authState$ = authenticationState$;

    final newHpError$ = newHpController.stream.map((newHp) {
      if (Validator.isValidPhoneNumber(newHp)) {
        return null;
      } else {
        return 'Nomor handphone minimal 10 karakter';
      }
    });

    //request otp
    final buttonReqOtp = Rx.combineLatest2(
      newHpController,
      fileController,
      (String? a, File? c) {
        return a != null && c != null && Validator.isValidPhoneNumber(a);
      },
    ).shareValueSeeded(false);

    final submit$ = submitOtpController.stream
        .withLatestFrom(buttonReqOtp, (_, bool isValid) => isValid)
        .share();

    final messageReqOtp = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential, (_, CredentialReqOtp cred) => cred)
          .exhaustMap((credential) => reqOtp(
              fileImage: credential.fileimage,
              new_hp: credential.new_hp,
              kode_verifikasi: credential.kode_verifikasi))
          .map(_responseToMessage)
    ]);

    //validate otp

    final otpValid = Rx.combineLatest2(
        otpController.stream, newHpController.stream, (String? a, String? b) {
      return a != null && b != null;
    });
    final credentialValOtp = Rx.combineLatest2(
      newHpController.stream,
      otpController.stream,
      (String a, String b) {
        return CredentialValidateOtp(
            hp: a, otp: b); // Return the CredentialValidateOtp object
      },
    );

    final validateOtpClick = validateOtpController.stream
        .withLatestFrom(otpValid, (_, bool isValid) => isValid)
        .share();

    final messageValidateOtp = Rx.merge([
      validateOtpClick
          .where((isValid) => isValid)
          .withLatestFrom(
            credentialValOtp,
            (_, CredentialValidateOtp cred2) => cred2,
          )
          .exhaustMap((value) => valOtp(new_hp: value.hp, otp: value.otp))
          .map(_responseToMessage),
    ]);

    return UpdateHpBloc._(
      apiService: apiService,
      authState: authState$,
      newHpControl: (String val) => newHpController.sink.add(val),
      fileControl: (File val) => fileController.sink.add(val),
      stepControl: (int val) => stepController.sink.add(val),
      kodeControl: (String val) => kodeController.sink.add(val),
      otpControl: (String val) => otpController.sink.add(val),
      stepStream: stepController.stream,
      fileStream: fileController.stream,
      submitOtp: () => submitOtpController.add(null),
      buttonReqOtp: buttonReqOtp,
      newHpError: newHpError$,
      messageReqOtp: messageReqOtp,
      messageValidasiOtp: messageValidateOtp,
      dispose: () {
        stepController.close();
      },
    );
  }
  static UpdateHpMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const UpdateHpSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : UpdateHpErrorMessage(appError.message!, appError.error!),
    );
  }
}

class CredentialReqOtp {
  final String new_hp;
  final String kode_verifikasi;
  final File fileimage;

  const CredentialReqOtp({
    required this.new_hp,
    required this.kode_verifikasi,
    required this.fileimage,
  });
}

class CredentialValidateOtp {
  final String hp;
  final String otp;

  const CredentialValidateOtp({
    required this.hp,
    required this.otp,
  });
}
