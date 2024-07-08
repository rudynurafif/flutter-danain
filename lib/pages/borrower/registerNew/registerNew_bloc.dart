import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/usecases/req_otp_register_borrower_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_otp_register_borrower_use_case.dart';
import 'package:flutter_danain/pages/borrower/registerNew/registerNew_state.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';

import '../../../data/remote/api_service.dart';
import '../../../domain/models/app_error.dart';
import '../../../utils/utils.dart';
import 'package:http/http.dart' as http;

import '../../../utils/validators.dart';

class RegisterNewBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;
  //control
  final Function1<int, void> stepControl;
  final Function1<String, void> nameControl;
  final Function1<String, void> emailControl;
  final Function1<String, void> phoneControl;
  final Function1<String?, void> kodeControl;
  final Function1<bool, void> checkControl;
  final Function0<void> reqOtp;

  //control step 2
  final Function1<String, void> otpControl;
  final Function1<bool, void> otpControlError;
  final Function0<void> sendOtp;

  //stream
  final Stream<int> stepStream;
  final Stream<String?> nameError$;
  final Stream<String?> emailError$;
  final Stream<String?> phoneError$;
  final Stream<String?> kodeError$;
  final Stream<bool> checkStream;
  final Stream<bool> buttonStep1Stream;

  //stream step 2
  final Stream<bool?> otpError;
  final Stream<RegisterNewMessage?> messageSendOtp;

  //value needed
  final BehaviorSubject<String> nameValue;
  final BehaviorSubject<String> emailValue;
  // final BehaviorSubject<String> emailUbahValue;

  final BehaviorSubject<String> phoneValue;
  final BehaviorSubject<String?> kodeValue;

  //message
  final Stream<RegisterNewMessage?> messageReqOtp;

  RegisterNewBloc._({
    required this.stepControl,
    required this.stepStream,
    required this.nameControl,
    required this.nameError$,
    required this.emailControl,
    required this.emailError$,
    required this.phoneControl,
    required this.phoneError$,
    required this.kodeControl,
    required this.kodeError$,
    required this.nameValue,
    required this.emailValue,
    required this.buttonStep1Stream,
    required this.phoneValue,
    required this.kodeValue,
    required this.checkControl,
    required this.checkStream,
    required this.apiService,
    required this.reqOtp,
    required this.messageReqOtp,
    required this.otpError,
    required this.otpControl,
    required this.otpControlError,
    required this.sendOtp,
    required this.messageSendOtp,
    required Function0<void> dispose,
  }) : super(dispose);

  factory RegisterNewBloc(
      ReqOtpRegisterBorrowerUseCase reqOtpRegisterBorrowerUseCase,
      SendOtpRegisterBorrowerUseCase sendOtpRegisterBorrowerUseCase) {
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    //step 1
    final stepController = BehaviorSubject<int>.seeded(1);
    final nameController = BehaviorSubject<String>();
    final emailController = BehaviorSubject<String>();
    final emailUbahController = BehaviorSubject<String>();
    final phoneController = BehaviorSubject<String>();
    final kodeController = BehaviorSubject<String?>.seeded(null);
    final checkController = BehaviorSubject<bool>.seeded(false);

    final nameError$ = BehaviorSubject<String?>();
    final emailError$ = BehaviorSubject<String?>();
    final phoneError$ = BehaviorSubject<String?>();
    final kodeError$ = BehaviorSubject<String?>();

    //step 2
    final reqOtpController = PublishSubject<void>();
    final sendOtpController = PublishSubject<void>();
    final otpController = BehaviorSubject<String>();
    final otpStatus = BehaviorSubject<bool>.seeded(true);
    final otpError = BehaviorSubject<bool?>();

    emailController.stream
        .asyncMap((email) async {
          if (Validator.isValidEmail(email)) {
            final response =
                await apiService.validateEmailAndPhone(email, null, '');
            final data = jsonDecode(response.body);
            final status = data['status'];
            final message = data['message'];

            print('check response $message');
            if (data['data']['email']['status_email'] == false)
              return "Email sudah terdaftar";
            if (status == 400) return message;
            return null;
          } else {
            return 'Email tidak valid';
          }
        })
        .distinct()
        .listen((error) {
          emailError$.add(error);
        });

    phoneError$.addStream(
      phoneController.stream.asyncMap((phone) async {
        if (Validator.isValidPhoneNumber(phone)) {
          final response =
              await apiService.validateEmailAndPhone(null, phone, '');
          final data = jsonDecode(response.body);
          final status = data['status'];
          final message = data['message'].toString();

          print('check response $message');

          if (status == 400) {
            return message;
          } else {
            if (data['data']['hp']['satus_hp'] == false)
              return "Nomor sudah terdaftar";
            return null;
          }
        } else {
          return 'Nomor Handphone minimal 10 karakter';
        }
      }).distinct(),
    );

    kodeError$.addStream(
      kodeController.stream.asyncMap((kode) async {
        final response = await apiService.validateBuatAkun(kode, 'ajakteman');
        final data = jsonDecode(response.body);
        final status = data['status'];
        final message = data['message'].toString();

        print('check response $kode');
        if (kode == null) {
          return null;
        } else {
          if (status == 400) {
            return message;
          } else {
            return null;
          }
        }
      }).distinct(),
    );

    //Credential
    final credential = Rx.combineLatest5(
      nameController.stream,
      emailController.stream,
      phoneController.stream,
      emailError$.stream,
      checkController.stream,
      (String? names, String? emails, String? phones, String? emailErrors,
              bool checks) =>
          CredentialReqOtp(name: names!, email: emails!, phone: phones!),
    );

    final buttonStep1 = Rx.combineLatest5(
      nameController.stream,
      emailController.stream,
      phoneController.stream,
      emailError$.stream,
      checkController.stream,
      (String? name, String? email, String? phone, String? emailError,
          bool check) {
        return name != null &&
            Validator.isValidUserName(name) &&
            emailError == null &&
            email != null &&
            Validator.isValidEmail(email) &&
            phone != null &&
            Validator.isValidPhoneNumber(phone) &&
            check == true;
      },
    ).shareValueSeeded(false);

    final submit$ = reqOtpController.stream
        .withLatestFrom(buttonStep1, (_, bool isValid) => isValid)
        .share();

    final messageReqOtp = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential, (_, CredentialReqOtp cred) => cred)
          .exhaustMap((credential) => reqOtpRegisterBorrowerUseCase(
              phone: credential.phone, kodeVerif: kodeController.value))
          .map(_responseToMessage)
    ]);

    final buttonStepVerifikasi = Rx.combineLatest2(
      phoneController.stream,
      otpController.stream,
      (String? phone, String? otp) {
        return otp != null &&
            phone != null &&
            Validator.isValidPhoneNumber(phone);
      },
    ).shareValueSeeded(false);

    final credentialSend = Rx.combineLatest2(
      otpController.stream,
      phoneController.stream,
      (String? otps, String? phones) =>
          CredentialSenOtp(otp: otps!, phone: phones!),
    );

    final submitSendOtp$ = sendOtpController.stream
        .withLatestFrom(buttonStepVerifikasi, (_, bool isValid) => isValid)
        .share();

    final messageSendOtp = Rx.merge([
      submitSendOtp$
          .where((isValid) => isValid)
          .withLatestFrom(credentialSend, (_, CredentialSenOtp cred) => cred)
          .exhaustMap((credentialSend) => sendOtpRegisterBorrowerUseCase(
                  name: nameController.value,
                  phone: phoneController.value,
                  email: emailController.value,
                  otp: otpController.value,
                  kodeVerif: kodeController.valueOrNull)
              .map(_responseToMessageOtp))
    ]);

    return RegisterNewBloc._(
      apiService: apiService,
      stepControl: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      nameControl: (String val) => nameController.add(val),
      nameError$: nameError$.stream,
      emailControl: (String val) => emailController.add(val),
      emailError$: emailError$.stream,
      phoneControl: (String val) => phoneController.add(val),
      phoneError$: phoneError$.stream,
      kodeControl: (String? val) => kodeController.add(val),
      kodeError$: kodeError$.stream,
      buttonStep1Stream: buttonStep1,
      nameValue: nameController,
      emailValue: emailController,
      phoneValue: phoneController,
      kodeValue: kodeController,
      checkControl: (bool val) => checkController.add(val),
      checkStream: checkController.stream,
      reqOtp: () => reqOtpController.add(null),
      messageReqOtp: messageReqOtp,
      otpError: otpError.stream,
      otpControl: (String val) => otpController.add(val),
      otpControlError: (bool val) => otpError.add(val),
      sendOtp: () => sendOtpController.add(null),
      messageSendOtp: messageSendOtp,
      dispose: () {
        stepController.close();
        nameController.close();
        emailController.close();
        phoneController.close();
        checkController.close();
        otpController.close();
        otpStatus.close();
      },
    );
  }
  static RegisterNewMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (response) => const RegisterNewSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : RegisterNewErrorMessage(appError.message!, appError.error!),
    );
  }

  static RegisterNewMessage? _responseToMessageOtp(UnitResult result) {
    return result.fold(
      ifRight: (response) {
        print('otp response $response');
      },
      ifLeft: (appError) => appError.isCancellation
          ? null
          : RegisterNewErrorMessage(appError.message!, appError.error!),
    );
  }
}

class CredentialReqOtp {
  final String name;
  final String email;
  final String phone;

  const CredentialReqOtp({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class CredentialSenOtp {
  final String otp;
  final String phone;

  const CredentialSenOtp({
    required this.otp,
    required this.phone,
  });
}

class CredentialSendPassword {
  final String hp;
  final String confirmPassword;
  final String email;
  final String nama;
  final String? referal;

  const CredentialSendPassword({
    required this.hp,
    required this.confirmPassword,
    required this.email,
    required this.nama,
    this.referal,
  });
}
