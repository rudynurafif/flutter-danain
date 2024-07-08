import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/utils/validators.dart';

class NewPasswordBloc {
  final passwordController = BehaviorSubject<String>();
  final confirmPasswordController = BehaviorSubject<String>();

  Stream<String> get passwordStream => passwordController.stream;
  Stream<String> get confirmPasswordStream => confirmPasswordController.stream;
  Stream<bool> get passwordButtonStream => Rx.combineLatest2(
        passwordStream,
        confirmPasswordStream,
        (
          String password,
          String confirmPassword,
        ) {
          bool passwordValid = Validator.isValidPasswordRegis(password);
          bool confirmPasswordValid =
              Validator.isValidPasswordRegis(confirmPassword);
          bool samePass = password == confirmPassword;
          return passwordValid && confirmPasswordValid && samePass;
        },
      );

  void dispose() {
    passwordController.close();
    confirmPasswordController.close();
  }

  void passwordChange(String value) {
    final controller = passwordController.sink;

    List<String> errors = [];

    if (!Validator.isValidLowerCase(value)) {
      errors.add('1');
    }
    if (!Validator.isValidUpperCase(value)) {
      errors.add('2');
    }
    if (!Validator.isValidPasswordNumber(value)) {
      errors.add('3');
    }
    if (!Validator.isValidLengthPassWord(value)) {
      errors.add('4');
    }

    if (errors.isNotEmpty) {
      controller.addError(errors);
    } else {
      controller.add(value);
    }
  }

  void confirmChange(String value) {
    confirmPasswordController.sink.add(value);
  }
}
