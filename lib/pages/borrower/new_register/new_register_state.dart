import 'package:meta/meta.dart';

@immutable
abstract class RegisterBorrowerMessage {}

class RegisterBorrowerSuccessMessage implements RegisterBorrowerMessage {
  const RegisterBorrowerSuccessMessage();
}

class RegisterBorrowerErrorMessage implements RegisterBorrowerMessage {
  final Object error;
  final String message;

  const RegisterBorrowerErrorMessage(this.message, this.error);

  @override
  String toString() =>
      'RegisterBorrowerErrorMessage{message=$message, error=$error}';
}

class InvalidInformationLenderMessage implements RegisterBorrowerMessage {
  const InvalidInformationLenderMessage();
}

@immutable
abstract class CekLokasiMessage {}

class CekLokasiSuccessMessage implements CekLokasiMessage {
  const CekLokasiSuccessMessage();
}

class CekLokasiErrorMessage implements CekLokasiMessage {
  final Object error;
  final String message;

  const CekLokasiErrorMessage(this.message, this.error);

  @override
  String toString() => 'CekLokasiErrorMessage{message=$message, error=$error}';
}

class CekLokasiTidakDitemukanMessage implements CekLokasiMessage {
  final String message;

  const CekLokasiTidakDitemukanMessage(this.message);

  @override
  String toString() => 'CekLokasiErrorMessage{message=$message}';
}

class CekLokasiDitolak implements CekLokasiMessage {
  final String message;

  const CekLokasiDitolak(this.message);

  @override
  String toString() => 'CekLokasiErrorMessage{message=$message}';
}

class InvalidInfoMessage implements CekLokasiMessage {
  const InvalidInfoMessage();
}
