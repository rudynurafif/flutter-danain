import 'package:meta/meta.dart';

@immutable
abstract class TarikDanaMessage {}

class TarikDanaSuccessMessage implements TarikDanaMessage {
  const TarikDanaSuccessMessage();
}

class TarikDanaErrorMessage implements TarikDanaMessage {
  final Object error;
  final String message;

  const TarikDanaErrorMessage(this.message, this.error);

  @override
  String toString() => 'TarikDanaErrorMessage{message=$message, error=$error}';
}
class TarikDanaSalahPinMessage implements TarikDanaMessage {
  final Object error;
  final String message;

  const TarikDanaSalahPinMessage(this.message, this.error);

  @override
  String toString() => 'TarikDanaErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements TarikDanaMessage {
  const InvalidInformationMessage();
}
