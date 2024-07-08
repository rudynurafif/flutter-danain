import 'package:meta/meta.dart';

@immutable
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
