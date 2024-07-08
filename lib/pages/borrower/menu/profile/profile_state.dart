import 'package:meta/meta.dart';

@immutable
abstract class ProfileMessage {}

abstract class LogoutMessage implements ProfileMessage {

}
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