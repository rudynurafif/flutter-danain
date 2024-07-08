import 'package:meta/meta.dart';

@immutable
abstract class PrivyCaseMessage {}

class PrivyCaseSuccess implements PrivyCaseMessage {
  const PrivyCaseSuccess();
}

class PrivyCaseError implements PrivyCaseMessage {
  final Object error;
  final String message;

  const PrivyCaseError(this.message, this.error);

  @override
  String toString() => 'PrivyCaseError{message=$message, error=$error}';
}

class InvalidInformationMessage implements PrivyCaseMessage {
  const InvalidInformationMessage();
}