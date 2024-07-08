import 'package:meta/meta.dart';

@immutable
abstract class CheckPinMessage {}

class CheckPinSuccess implements CheckPinMessage {
  const CheckPinSuccess();
}

class CheckPinSalah implements CheckPinMessage {
  final Object error;
  final String message;

  const CheckPinSalah(this.message, this.error);

  @override
  String toString() => 'CheckPin{message=$message, error=$error}';
}
class CheckPinSalah10Menit implements CheckPinMessage {
  final Object error;
  final String message;

  const CheckPinSalah10Menit(this.message, this.error);

  @override
  String toString() => 'CheckPin{message=$message, error=$error}';
}

class CheckPinError implements CheckPinMessage {
  final Object error;
  final String message;

  const CheckPinError(this.message, this.error);

  @override
  String toString() => 'CheckPin{message=$message, error=$error}';
}

class InvalidInformationMessage implements CheckPinMessage {
  const InvalidInformationMessage();
}

abstract class HomeLenderMessage {}

abstract class LogoutLenderMessage implements HomeLenderMessage {}

class LogoutLenderSuccessMessage implements LogoutLenderMessage {
  const LogoutLenderSuccessMessage();
}

class LogoutLenderErrorMessage implements LogoutLenderMessage {
  final String message;
  final Object error;

  const LogoutLenderErrorMessage(this.message, this.error);

  @override
  String toString() => 'LogoutLenderErrorMessage{message: $message, error: $error}';
}
