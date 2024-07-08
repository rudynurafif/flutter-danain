import 'package:meta/meta.dart';

@immutable
abstract class ChangePasswordState {}

class ChangePasswordStateSuccess implements ChangePasswordState {
  const ChangePasswordStateSuccess();
}

class ChangePasswordStateErrorValidation implements ChangePasswordState {
  final Object error;
  final String message;

  const ChangePasswordStateErrorValidation(this.message, this.error);

  @override
  String toString() => 'ChangePasswordStateError{message=$message, error=$error}';
}
class ChangePasswordStateError implements ChangePasswordState {
  final Object error;
  final String message;

  const ChangePasswordStateError(this.message, this.error);

  @override
  String toString() => 'ChangePasswordStateError{message=$message, error=$error}';
}

class InvalidInformationMessage implements ChangePasswordState {
  const InvalidInformationMessage();
}