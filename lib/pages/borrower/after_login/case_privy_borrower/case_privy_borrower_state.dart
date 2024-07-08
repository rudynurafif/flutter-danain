import 'package:meta/meta.dart';

@immutable
abstract class PrivyCaseBorrowerMessage {}

class PrivyCaseBorrowerSuccess implements PrivyCaseBorrowerMessage {
  const PrivyCaseBorrowerSuccess();
}

class PrivyCaseError implements PrivyCaseBorrowerMessage {
  final Object error;
  final String message;

  const PrivyCaseError(this.message, this.error);

  @override
  String toString() => 'PrivyCaseError{message=$message, error=$error}';
}

class InvalidInformationMessage implements PrivyCaseBorrowerMessage {
  const InvalidInformationMessage();
}