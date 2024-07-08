import 'dart:async';

import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/login_use_case.dart';
import 'package:flutter_danain/pages/lender/login/login.dart';
import 'package:flutter_danain/utils/utils.dart';

/// BLoC that handles validating form and login
class LoginLenderBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<String, void> emailChanged;
  final Function1<String, void> passwordChanged;
  final Function0<void> submitLogin;

  /// Streams
  final Stream<String?> emailError$;
  final Stream<String?> passwordError$;
  final Stream<LoginLenderMessage> message$;
  final Stream<bool> isLoading$;
  final Stream<String> validation$;
  final Stream<bool> button;

  LoginLenderBloc._({
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
  factory LoginLenderBloc(final LoginUseCase login) {
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
          return Validator.isValidEmail(telp) && pw.length >= 8;
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
      emailController.stream.map(Validator.isValidEmail),
      passwordController.stream.map(Validator.isValidPassword),
      isLoadingController.stream,
      (bool isValidEmail, bool isValidPassword, bool isLoading) =>
          isValidEmail && isValidPassword && !isLoading,
    ).shareValueSeeded(false);

    final credential$ = Rx.combineLatest2(
      emailController.stream,
      passwordController.stream,
      (String email, String password) =>
          CredentialLender(email: email, password: password),
    );

    final submit$ = submitLoginController.stream
        .withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid)
        .share();

    final emailError$ = emailController.stream
        .map((email) {
          if (Validator.isValidEmail(email)) return null;
          if (email == '') return 'Masukan email terdaftar';
          return 'Email tidak valid';
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
          .withLatestFrom(credential$, (_, CredentialLender c) => c)
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
          .map((_) => const InvalidInformationLenderMessage())
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

    return LoginLenderBloc._(
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

  static LoginLenderMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (value) {
        return const LoginLenderSuccessMessage();
      },
      ifLeft: (appError) => appError.isCancellation
          ? null
          : LoginLenderErrorMessage(appError.message!, appError.error!),
    );
  }
}
