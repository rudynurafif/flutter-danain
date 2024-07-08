import 'package:meta/meta.dart';

@immutable
abstract class CicilEmasMessage {}

class CicilEmasSuccess implements CicilEmasMessage {
  const CicilEmasSuccess();
}

class CicilEmasError implements CicilEmasMessage {
  final Object error;
  final String message;

  const CicilEmasError(this.message, this.error);

  @override
  String toString() => 'CicilEmasError{message=$message, error=$error}';
}

class InvalidInformationMessage implements CicilEmasMessage {
  const InvalidInformationMessage();
}