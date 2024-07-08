import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/ubah_pin/ubah_pin_state.dart';
import 'package:flutter_danain/utils/validators.dart';

class UbahPinBloc {
  final pinController = BehaviorSubject<String>();
  Stream<String> get pinStream => pinController.stream;

  final newPinController = BehaviorSubject<String>();
  Stream<String> get newPinStream => newPinController.stream;

  final isPinController = BehaviorSubject<int>();
  Stream<int> get isPinStream => isPinController.stream;

  Stream<bool> get buttonKataSandi => Rx.combineLatest2(
        pinStream,
        newPinStream,
        (String a, String b) {
          return a.length > 3 &&
              Validator.isValidLowerCase(b) &&
              Validator.isValidUpperCase(b);
        },
      );

  final message = BehaviorSubject<UbahPinState?>();
  Stream<UbahPinState?> get messageStream => message.stream;

  void passwordChange(String value) {
    final controller = newPinController.sink;

    final List<String> errors = [];

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

  void postChangePin() async {
    try {
      final old = pinController.valueOrNull;
      final newPass = newPinController.valueOrNull;
      if (old != null && newPass != null) {
      } else {
        message.sink.add(
          const UbahPinStateError('Pastikan anda mengisi semua form', []),
        );
      }
    } catch (e) {
      message.sink.add(UbahPinStateError(e.toString(), e));
    }
  }

  void dispose() {
    pinController.close();
    newPinController.close();
  }
}
