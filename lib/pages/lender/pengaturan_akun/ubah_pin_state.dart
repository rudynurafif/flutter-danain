import 'package:meta/meta.dart';

@immutable
abstract class UbahPinMessage {}

class UbahPinSuccess implements UbahPinMessage {
  const UbahPinSuccess();
}

class UbahPinError implements UbahPinMessage {
  final Object error;
  final String message;

  const UbahPinError(this.message, this.error);

  @override
  String toString() => 'UbahPin{message=$message, error=$error}';
}

class InvalidInformationMessage implements UbahPinMessage {
  const InvalidInformationMessage();
}
