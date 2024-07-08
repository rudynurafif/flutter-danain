import 'package:meta/meta.dart';

@immutable
abstract class OtpMessageState {}

class OtpMessageSuccess implements OtpMessageState {
  const OtpMessageSuccess();
}

class OtpMessageError implements OtpMessageState {
  final Object error;
  final String message;

  const OtpMessageError(this.message, this.error);

  @override
  String toString() => 'OtpMessageError{message=$message, error=$error}';
}

class InvalidInformationMessage implements OtpMessageState {
  const InvalidInformationMessage();
}