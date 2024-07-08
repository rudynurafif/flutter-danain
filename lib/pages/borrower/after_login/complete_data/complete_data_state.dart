import 'package:meta/meta.dart';

@immutable
abstract class CompleteDataMessage {}

class CompleteDataSuccess implements CompleteDataMessage {
  const CompleteDataSuccess();
}

class CompleteDataError implements CompleteDataMessage {
  final Object error;
  final String message;

  const CompleteDataError(this.message, this.error);

  @override
  String toString() => 'CompleteDataError{message=$message, error=$error}';
}

class InvalidInformationMessage implements CompleteDataMessage {
  const InvalidInformationMessage();
}