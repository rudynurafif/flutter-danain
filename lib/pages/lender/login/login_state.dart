import 'package:meta/meta.dart';

///
/// LoginLender message
///

class CredentialLender {
  final String email;
  final String password;

  const CredentialLender({required this.email, required this.password});
}

@immutable
abstract class LoginLenderMessage {}

class LoginLenderSuccessMessage implements LoginLenderMessage {
  const LoginLenderSuccessMessage();
}

class LoginLenderErrorMessage implements LoginLenderMessage {
  final Object error;
  final String message;

  const LoginLenderErrorMessage(this.message, this.error);

  @override
  String toString() => 'LoginLenderErrorMessage{message=$message, error=$error}';
}

class InvalidInformationLenderMessage implements LoginLenderMessage {
  const InvalidInformationLenderMessage();
}
