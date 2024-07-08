import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/make_new_password_use_case.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/forgot_password_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';

class MakeNewPasswordBloc extends DisposeCallbackBaseBloc {
  final Function1<String, void> passwordControl;
  final Function1<String, void> confirmControl;
  final Function1<String, void> kodeControl;
  final Function0<void> submit;

  final Stream<List<int>> passwordError;
  final Stream<bool> isValidButton;
  final Stream<ForgotPasswordMessage?> message;
  MakeNewPasswordBloc._({
    required this.passwordControl,
    required this.confirmControl,
    required this.passwordError,
    required this.isValidButton,
    required this.kodeControl,
    required this.submit,
    required this.message,
    required Function0<void> dispose,
  }) : super(dispose);

  factory MakeNewPasswordBloc(final MakeNewPasswordUseCase reqNewPassword) {
    final passwordController = BehaviorSubject<String>();
    final confirmController = BehaviorSubject<String>();
    final kodeController = BehaviorSubject<String>.seeded('0');
    final passwordError = BehaviorSubject<List<int>>();
    final submitController = PublishSubject<void>();

    passwordError.addStream(
      passwordController.map(
        (value) {
          List<int> errors = [];
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

    final credential = Rx.combineLatest2(
      kodeController.stream,
      passwordController.stream,
      (String kode, String password) => CredentialMakePassword(
        kode: kode,
        password: password,
      ),
    );

    final buttonPassword = Rx.combineLatest2(
      passwordController.stream,
      confirmController.stream,
      (String? a, String? b) {
        return a != null &&
            b != null &&
            Validator.isValidPasswordRegis(a) &&
            Validator.isValidPasswordRegis(b) &&
            a == b;
      },
    ).shareValueSeeded(false);

    final submit$ = submitController.stream
        .withLatestFrom(buttonPassword, (_, bool isValid) => isValid)
        .share();

    final message = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential, (_, CredentialMakePassword cred) => cred)
          .exhaustMap((credential) => reqNewPassword(
                kodeVerifikasi: credential.kode,
                password: credential.password,
              ))
          .map(_responseToMessage)
    ]);
    return MakeNewPasswordBloc._(
      passwordControl: (String val) => passwordController.add(val),
      confirmControl: (String val) => confirmController.add(val),
      passwordError: passwordError.stream,
      isValidButton: buttonPassword,
      submit: () => submitController.add(null),
      message: message,
      kodeControl: (String val) => kodeController.add(val),
      dispose: () {
        passwordController.close();
        confirmController.close();
        submitController.close();
        kodeController.close();
      },
    );
  }
  static ForgotPasswordMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const ForgotPasswordSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : ForgotPasswordErrorMessage(appError.message!, appError.error!),
    );
  }
}

class CredentialMakePassword {
  final String kode;
  final String password;
  const CredentialMakePassword({
    required this.kode,
    required this.password,
  });
}
