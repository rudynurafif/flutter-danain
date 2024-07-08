import 'package:meta/meta.dart';

@immutable
abstract class HomeMessage {}

abstract class LogoutMessage implements HomeMessage {}

abstract class FdcMessage implements HomeMessage {}

abstract class UpdateAvatarMessage implements HomeMessage {}

///
///
///
class LogoutSuccessMessage implements LogoutMessage {
  const LogoutSuccessMessage();
}

class LogoutErrorMessage implements LogoutMessage {
  final String message;
  final Object error;

  const LogoutErrorMessage(this.message, this.error);

  @override
  String toString() => 'LogoutErrorMessage{message: $message, error: $error}';
}

class FdcSuccessMessage implements FdcMessage {
  const FdcSuccessMessage();
}

class FdcErrorMessage implements FdcMessage {
  final String message;
  final Object error;

  const FdcErrorMessage(this.message, this.error);

  @override
  String toString() => 'FdcErrorMessage{message: $message, error: $error}';
}

///
///
///

