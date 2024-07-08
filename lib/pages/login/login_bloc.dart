import 'dart:async';

import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/login_use_case.dart';
import 'package:flutter_danain/pages/login/login.dart';
import 'package:flutter_danain/utils/utils.dart';

/// BLoC that handles validating form and login
class LoginBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<String, void> emailChanged;
  final Function1<String, void> passwordChanged;
  final Function0<void> submitLogin;

  /// Streams
  final Stream<String?> emailError$;
  final Stream<String?> passwordError$;
  final Stream<LoginMessage> message$;
  final Stream<bool> isLoading$;
  final Stream<String> validation$;
  final Stream<bool> button;

  LoginBloc._({
    required Function0<void> dispose,
    required this.emailChanged,
    required this.passwordChanged,
    required this.submitLogin,
    required this.validation$,
    required this.emailError$,
    required this.passwordError$,
    required this.message$,
    required this.isLoading$,
    required this.button,
  }) : super(dispose);
  factory LoginBloc(final LoginUseCase login) {
    /// Controllers
    final emailController = BehaviorSubject<String>();
    final passwordController = BehaviorSubject<String>();
    final submitLoginController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final buttonController = BehaviorSubject<bool>.seeded(false);
    buttonController.addStream(
      Rx.combineLatest2(
        emailController.stream,
        passwordController.stream,
        (telp, pw) {
          return Validator.isValidPhoneNumber(telp) && pw.length >= 8;
        },
      ).shareValueSeeded(false),
    );
    final controllers = [
      emailController,
      passwordController,
      submitLoginController,
      isLoadingController,
      buttonController,
    ];

    ///
    /// Streams
    ///

    final isValidSubmit$ = Rx.combineLatest3(
      emailController.stream.map(Validator.isValidPhoneNumber),
      passwordController.stream.map(Validator.isValidPassword),
      isLoadingController.stream,
      (bool isValidEmail, bool isValidPassword, bool isLoading) =>
          isValidEmail && isValidPassword && !isLoading,
    ).shareValueSeeded(false);

    final credential$ = Rx.combineLatest2(
      emailController.stream,
      passwordController.stream,
      (String email, String password) =>
          Credential(email: email, password: password),
    );

    final submit$ = submitLoginController.stream
        .withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid)
        .share();

    final emailError$ = emailController.stream
        .map((email) {
          print('value email $email');
          if (Validator.isValidPhoneNumber(email)) return null;
          if (email == '') return 'Masukan nomor hp';
          return 'Nomor hp tidak valid';
        })
        .distinct()
        .share();

    final passwordError$ = passwordController.stream
        .map((password) {
          if (Validator.isValidPassword(password)) return null;
          if (password == '') return 'Masukkan password';
          return 'Kata sandi minimal 8 karakter';
        })
        .distinct()
        .share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential$, (_, Credential c) => c)
          .exhaustMap(
            (credential) => login(
              email: credential.email,
              password: credential.password,
            )
                .doOn(
                  listen: () => isLoadingController.add(true),
                  cancel: () => isLoadingController.add(false),
                )
                .map(_responseToMessage),
          ),
      submit$
          .where((isValid) => !isValid)
          .map((_) => const InvalidInformationMessage())
    ]).whereNotNull().share();

    final combinedStream = Rx.combineLatest2(emailError$, passwordError$,
        (intValue, doubleValue) => '$intValue, $doubleValue');

    final subscriptions = <String, Stream>{
      'emailError': emailError$,
      'passwordError': passwordError$,
      'isValidSubmit': isValidSubmit$,
      'message': message$,
      'isLoading': isLoadingController,
    }.debug();

    return LoginBloc._(
      dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
      emailChanged: trim.pipe(emailController.add),
      validation$: combinedStream,
      passwordChanged: passwordController.add,
      submitLogin: () => submitLoginController.add(null),
      emailError$: emailError$,
      passwordError$: passwordError$,
      message$: message$,
      isLoading$: isLoadingController,
      button: buttonController.stream,
    );
  }

  static LoginMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (value) {
        return const LoginSuccessMessage();
      },
      ifLeft: (appError) => appError.isCancellation
          ? null
          : LoginErrorMessage(appError.message!, appError.error!),
    );
  }
}
