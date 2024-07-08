import 'package:rxdart/rxdart.dart';
import 'package:flutter_danain/utils/validators.dart';

class ForgotPasswordBloc {
  int currentStep = 0;
  final stepController = BehaviorSubject<int>();

  //step 1
  final emailController = BehaviorSubject<String>();
  final buttonStep1Controller = BehaviorSubject<bool>();

  Stream<int> get currentStepStream => stepController.stream;
  Stream<String> get emailStream => emailController.stream;
  Stream<bool> get buttonStep1Stream => buttonStep1Controller.stream;

  void nextStep() {
    if (currentStep < 1) {
      currentStep++;
      stepController.sink.add(currentStep);
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      currentStep--;
      stepController.sink.add(currentStep);
    }
  }

  void dispose() {
    stepController.close();
    emailController.close();
    buttonStep1Controller.close();
  }

  void emailChange(String email) {
    if (email.isEmpty) {
      emailController.sink.addError('Email Wajib diisi');
      buttonStep1Controller.sink.add(false);
    } else if (!Validator.isValidEmail(email)) {
      emailController.sink.addError('Email tidak Valid');
      buttonStep1Controller.sink.add(false);
    } else {
      emailController.sink.add(email);
      buttonStep1Controller.sink.add(true);
    }
  }
}


