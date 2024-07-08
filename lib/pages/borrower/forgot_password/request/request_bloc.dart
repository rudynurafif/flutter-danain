import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/forgot_password_use_case_1.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/forgot_password_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';

class ForgotPasswordEmailBloc extends DisposeCallbackBaseBloc {
  //control
  final Function1<String, void> emailControl;
  final Function1<int, void> stepControl;
  final Function0<void> submit;

  //stream
  final Stream<String> emailStream;
  final Stream<bool> isValidEmailStream;
  final Stream<int> stepStream;
  final Stream<ForgotPasswordMessage?> messageStream;

  ForgotPasswordEmailBloc._({
    required this.stepControl,
    required this.stepStream,
    required this.emailControl,
    required this.emailStream,
    required this.isValidEmailStream,
    required this.submit,
    required this.messageStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory ForgotPasswordEmailBloc(final ForgotPasswordUseCase reqKode) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final emailController = BehaviorSubject<String>();
    final submitController = PublishSubject<void>();
    final isValidEmail = Rx.combineLatest<String, bool>(
      [emailController.stream],
      (List<String> emails) {
        final email = emails.first;
        return Validator.isValidEmail(email);
      },
    ).shareValueSeeded(false);

    final submit$ = submitController.stream
        .withLatestFrom(isValidEmail, (_, bool isValid) => isValid)
        .share();
    final message = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(emailController, (_, String email) => email)
          .exhaustMap(
            (email) => reqKode(
              email: email,
            ),
          )
          .map(_responseToMessage)
    ]);

    return ForgotPasswordEmailBloc._(
      stepControl: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      emailControl: (String val) => emailController.add(val),
      emailStream: emailController.stream,
      isValidEmailStream: isValidEmail,
      submit: () => submitController.add(null),
      messageStream: message,
      dispose: () {
        emailController.close();
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
