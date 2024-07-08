import 'package:meta/meta.dart';

@immutable
abstract class UbahPinState {}

class UbahPinStateSuccess implements UbahPinState {
  const UbahPinStateSuccess();
}

class UbahPinStateErrorValidation implements UbahPinState {
  final Object error;
  final String message;

  const UbahPinStateErrorValidation(this.message, this.error);

  @override
  String toString() => 'ChangePasswordStateError{message=$message, error=$error}';
}
class UbahPinStateError implements UbahPinState {
  final Object error;
  final String message;

  const UbahPinStateError(this.message, this.error);

  @override
  String toString() => 'ChangePasswordStateError{message=$message, error=$error}';
}

class InvalidInformationMessage implements UbahPinState {
  const InvalidInformationMessage();
}