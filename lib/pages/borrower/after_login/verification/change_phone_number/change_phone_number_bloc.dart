import 'package:flutter_danain/domain/models/app_error.dart';

class ChangePhoneBloc {
  final newPhoneController = BehaviorSubject<String>();
  final buttonController = BehaviorSubject<bool>.seeded(false);

  Stream<String> get newPhoneStream => newPhoneController.stream;
  Stream<bool> get buttonStream => buttonController.stream;

  void changePhone(String value) {
    if (value.length < 12) {
      newPhoneController.sink.addError('Nomor HP harus lebih dari 11 digit');
      buttonController.sink.add(false);
    } else {
      newPhoneController.sink.add(value);
      buttonController.sink.add(true);
    }
  }

  void dispose() {
    newPhoneController.close();
  }
}
