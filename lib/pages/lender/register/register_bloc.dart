import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/req_otp_register_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_email_register_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_otp_register_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_pin_register_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_register_use_case.dart';
import 'package:flutter_danain/pages/lender/register/register_lender_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import '../../../data/remote/api_service.dart';

class RegisterLenderBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;
  //control
  final Function1<int, void> stepControl;
  final Function1<String, void> nameControl;
  final Function1<String, void> emailControl;
  final Function1<String, void> emailControlNull;
  final Function1<String, void> phoneControl;
  final Function1<String?, void> kodeControl;
  final Function1<bool, void> checkControl;
  final Function1<String, void> otpControl;
  final Function1<String, void> passwordControl;
  final Function1<String, void> confirmPasswordControl;
  final Function1<String, void> pinControl;
  final Function1<String, void> confirmPinControl;
  final Function1<bool, void> otpControlError;
  final Function1<String, void> confirmPinErrorControl;
  final Function1<String, void> errorEmailControl;
  final Function1<String, void> emailUbahControl;
  //proses otp
  final Function0<void> reqOtp;
  final Function0<void> sendOtp;

  //proses password
  final Function0<void> sendRegister;

  //proses pin
  final Function0<void> sendPin;

  //proses sending email
  final Function0<void> sendEmail;

  //stream
  final Stream<int> stepStream;
  final Stream<String?> nameError$;
  final Stream<String?> emailError$;
  final Stream<String?> phoneError$;
  final Stream<String?> kodeError$;
  final Stream<bool> checkStream;
  final Stream<bool> buttonStep1Stream;
  final Stream<bool> otpStatusStream;
  final Stream<List<int>> passwordErrorStream;
  final Stream<bool> passwordButton;
  final Stream<String?> confirmPinError;
  final Stream<bool> isComplete;
  final Stream<String?> validateBuatAkunStream;
  final Stream<bool?> otpError;
  final Stream<bool> haveAgreeStream;

  //Stream Message
  final Stream<RegisterLenderMessage?> messageReqOtp;
  final Stream<RegisterLenderMessage?> messageSendOtp;
  final Stream<RegisterLenderMessage?> messageSendRegister;
  final Stream<RegisterLenderMessage?> messageSendPinRegister;
  final Stream<RegisterLenderMessage?> messageSendEmail;

  //value needed
  final BehaviorSubject<String> nameValue;
  final BehaviorSubject<String> emailValue;
  final BehaviorSubject<String> emailUbahValue;

  final BehaviorSubject<String> phoneValue;
  final BehaviorSubject<String?> kodeValue;

  RegisterLenderBloc._({
    required this.apiService,
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
    required this.emailUbahValue,
    required this.buttonStep1Stream,
    required this.phoneValue,
    required this.kodeValue,
    required this.checkControl,
    required this.checkStream,
    required this.otpControl,
    required this.otpStatusStream,
    required this.passwordControl,
    required this.confirmPasswordControl,
    required this.passwordErrorStream,
    required this.passwordButton,
    required this.pinControl,
    required this.confirmPinControl,
    required this.confirmPinError,
    required this.isComplete,
    required this.validateBuatAkunStream,
    required this.reqOtp,
    required this.sendOtp,
    required this.messageReqOtp,
    required this.messageSendOtp,
    required this.otpControlError,
    required this.otpError,
    required this.sendRegister,
    required this.messageSendRegister,
    required this.sendPin,
    required this.messageSendPinRegister,
    required this.sendEmail,
    required this.messageSendEmail,
    required this.confirmPinErrorControl,
    required this.errorEmailControl,
    required this.emailControlNull,
    required this.emailUbahControl,
    required this.haveAgreeStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory RegisterLenderBloc(
    final ReqOtpRegisterUseCase reqOtp,
    final SendOtpRegisterUseCase sendOtp,
    final SendRegisterUseCase sendRegister,
    final SendPinRegisterUseCase sendPin,
    final SendEmailRegisterUseCase sendEmail,
  ) {
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
    final haveAgreeController = BehaviorSubject<bool>.seeded(false);

    //step 2
    final reqOtpController = PublishSubject<void>();
    final sendOtpController = PublishSubject<void>();
    final otpController = BehaviorSubject<String>();
    final otpStatus = BehaviorSubject<bool>.seeded(true);
    final otpError = BehaviorSubject<bool?>();

    //step 3
    final passwordController = BehaviorSubject<String>();
    final confirmPasswordController = BehaviorSubject<String>();
    final passwordError = BehaviorSubject<List<int>>();
    final sendRegisterController = PublishSubject<void>();

    //step 5
    final pinController = BehaviorSubject<String>();
    final sendPinController = BehaviorSubject<void>();

    //step 6
    final confirmPinController = BehaviorSubject<String>();
    final confirmPinError = BehaviorSubject<String?>.seeded(null);
    final isComplete = BehaviorSubject<bool>.seeded(false);
    final sendEmailController = BehaviorSubject<void>();

    final validateBuatAkunStream = BehaviorSubject<String?>();

    void validatePin(String val) {
      if (val.length == 6) {
        if (val == pinController.value) {
          confirmPinController.add(val);
          confirmPinError.add(null);
          isComplete.add(true);
        } else {
          confirmPinError.add('Konfirmasi PIN tidak sesuai');
        }
      } else {
        confirmPinController.add(val);
        confirmPinError.add(null);
      }
    }

    passwordError.addStream(
      passwordController.map(
        (value) {
          final List<int> errors = [];
          if (!Validator.isValidLowerCase(value)) {
            errors.add(1);
          }
          if (!Validator.isValidUpperCase(value)) {
            errors.add(2);
          }
          if (!Validator.isValidPasswordNumber(value)) {
            errors.add(3);
          }
          if (!Validator.isValidLengthPassWord(value)) {
            errors.add(4);
          }
          return errors;
        },
      ),
    );

    nameError$.addStream(
      nameController.stream.map((name) {
        if (Validator.isValidUserName(name)) return null;
        return 'Nama minimal 3 karakter';
      }).distinct(),
    );

    emailController.stream
        .asyncMap((email) async {
          if (Validator.isValidEmail(email)) {
            final response = await apiService.validateBuatAkun(email, 'email');
            final data = jsonDecode(response.body);
            final status = data['status'];
            final message = data['message'];

            print('check response $message');
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

    emailUbahController.stream
        .asyncMap((email) async {
          if (Validator.isValidEmail(email)) {
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
          final response = await apiService.validateBuatAkun(phone, 'hp');
          final data = jsonDecode(response.body);
          final status = data['status'];
          final message = data['message'].toString();

          print('check response $message');

          if (status == 400) {
            return message;
          } else {
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
    emailError$.listen((value) {
      print('email error listen $value');
    });
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

    final credentialSend = Rx.combineLatest2(
      otpController.stream,
      phoneController.stream,
      (String? otps, String? phones) =>
          CredentialSenOtp(otp: otps!, phone: phones!),
    );

    final credentialSendPin = Rx.combineLatest2(
      pinController.stream,
      confirmPinController.stream,
      (String? pin, String? confirmPin) =>
          CredentialSendPin(pin: pin!, confirmPin: confirmPin!),
    );

    final credentialPassword = Rx.combineLatest5(
        phoneController.stream,
        confirmPasswordController.stream,
        emailController.stream,
        nameController.stream,
        kodeController.stream,
        (String? phones, String? confirmPassoword, String? email, String? name,
                String? kode) =>
            CredentialSendPassword(
                confirmPassword: confirmPassoword!,
                hp: phones!,
                email: email!,
                nama: name!,
                referal: kode));

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

    buttonStep1.listen((event) {
      print('button step 1 $event');
    });

    final buttonStepVerifikasi = Rx.combineLatest2(
      phoneController.stream,
      otpController.stream,
      (String? phone, String? otp) {
        return otp != null &&
            phone != null &&
            Validator.isValidPhoneNumber(phone);
      },
    ).shareValueSeeded(false);

    final buttonPassword = Rx.combineLatest2(
      passwordController.stream,
      confirmPasswordController.stream,
      (String? a, String? b) {
        return a != null &&
            b != null &&
            Validator.isValidPasswordRegis(a) &&
            Validator.isValidPasswordRegis(b) &&
            a == b;
      },
    ).shareValueSeeded(false);

    final buttonPin = Rx.combineLatest2(
      pinController.stream,
      confirmPinController.stream,
      (String? pin, String? comfirmPin) {
        return pin != null && comfirmPin != null;
      },
    ).shareValueSeeded(true);

    pinController.listen((value) {
      print('pinController $value');
    });

    final submit$ = reqOtpController.stream
        .withLatestFrom(buttonStep1, (_, bool isValid) => isValid)
        .share();

    final messageReqOtp = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential, (_, CredentialReqOtp cred) => cred)
          .exhaustMap((credential) => reqOtp(phone: credential.phone))
          .map(_responseToMessage)
    ]);

    final submitSendOtp$ = sendOtpController.stream
        .withLatestFrom(buttonStepVerifikasi, (_, bool isValid) => isValid)
        .share();

    final messageSendOtp = Rx.merge([
      submitSendOtp$
          .where((isValid) => isValid)
          .withLatestFrom(credentialSend, (_, CredentialSenOtp cred) => cred)
          .exhaustMap((credentialSend) => sendOtp(otp: credentialSend.otp))
          .map(_responseToMessage)
    ]);

    final submitSendRegister$ = sendRegisterController.stream
        .withLatestFrom(buttonPassword, (_, bool isValid) => isValid)
        .share();

    final messageSendRegister = Rx.merge([
      submitSendRegister$
          .where((isValid) => isValid)
          .withLatestFrom(
              credentialPassword, (_, CredentialSendPassword cred) => cred)
          .exhaustMap((credentialPassword) => sendRegister(
              phone: credentialPassword.hp,
              name: credentialPassword.nama,
              referral: credentialPassword.referal,
              email: credentialPassword.email,
              password: credentialPassword.confirmPassword))
          .map(_responseToMessage)
    ]);

    final submitSendPinRegister$ = sendPinController.stream
        .withLatestFrom(buttonPin, (_, bool isValid) => isValid)
        .share();

    submitSendPinRegister$.listen((event) {
      print('value pin $event');
    });

    final messageSendPin = Rx.merge([
      submitSendPinRegister$
          .where((isValid) => isValid)
          .withLatestFrom(
              credentialSendPin, (_, CredentialSendPin cred) => cred)
          .exhaustMap(
              (credentialSendPin) => sendPin(pin: credentialSendPin.confirmPin))
          .map(_responseToMessage)
    ]);

    final submitSendEmail$ = sendEmailController.stream.share();

    final messageSendEmail = Rx.merge([
      submitSendEmail$.exhaustMap((_) => sendEmail()).map(_responseToMessage)
    ]);

    return RegisterLenderBloc._(
      apiService: apiService,
      stepControl: (int val) {
        stepController.add(val);
        otpError.add(null);
      },
      stepStream: stepController.stream,
      nameControl: (String val) => nameController.add(val),
      nameError$: nameError$.stream,
      emailControl: (String val) => emailController.add(val),
      emailUbahControl: (String val) => emailUbahController.add(val),
      emailControlNull: (String val) => emailController.add(''),
      emailError$: emailError$.stream,
      phoneControl: (String val) => phoneController.add(val),
      phoneError$: phoneError$.stream,
      kodeControl: (String? val) => kodeController.add(val),
      kodeError$: kodeError$.stream,
      pinControl: (String val) => pinController.add(val),
      buttonStep1Stream: buttonStep1,
      nameValue: nameController,
      emailValue: emailController,
      emailUbahValue: emailUbahController,
      phoneValue: phoneController,
      kodeValue: kodeController,
      checkControl: (bool val) {
        haveAgreeController.add(true);
        checkController.add(val);
      },
      checkStream: checkController.stream,
      otpControl: (String val) => otpController.add(val),
      otpStatusStream: otpStatus.stream,
      passwordControl: (String val) => passwordController.add(val),
      confirmPinControl: validatePin,
      confirmPinError: confirmPinError.stream,
      validateBuatAkunStream: validateBuatAkunStream.stream,
      confirmPasswordControl: (String val) =>
          confirmPasswordController.add(val),
      passwordErrorStream: passwordError.stream,
      passwordButton: buttonPassword,
      isComplete: isComplete.stream,
      reqOtp: () => reqOtpController.add(null),
      sendOtp: () => sendOtpController.add(null),
      messageReqOtp: messageReqOtp,
      messageSendOtp: messageSendOtp,
      otpError: otpError.stream,
      otpControlError: (bool val) => otpError.add(val),
      sendRegister: () => sendRegisterController.add(null),
      messageSendRegister: messageSendRegister,
      sendPin: () => sendPinController.add(null),
      messageSendPinRegister: messageSendPin,
      sendEmail: () => sendEmailController.add(null),
      messageSendEmail: messageSendEmail,
      confirmPinErrorControl: (String val) => confirmPinError.add(null),
      errorEmailControl: (String val) => emailError$.add(null),
      haveAgreeStream: haveAgreeController.stream,
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
  static RegisterLenderMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const RegisterLenderSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : RegisterLenderErrorMessage(appError.message!, appError.error!),
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

class CredentialSendPin {
  final String pin;
  final String confirmPin;

  const CredentialSendPin({required this.pin, required this.confirmPin});
}
