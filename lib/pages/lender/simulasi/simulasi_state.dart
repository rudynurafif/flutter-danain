import 'package:meta/meta.dart';

@immutable
abstract class SimulasiMessage {}

class SimulasiSuccess implements SimulasiMessage {
  const SimulasiSuccess();
}

class SimulasiError implements SimulasiMessage {
  final Object error;
  final String message;

  const SimulasiError(this.message, this.error);

  @override
  String toString() => 'SimulasiPinjamanError{message=$message, error=$error}';
}

class SimulasiErrorSaldo implements SimulasiMessage {
  const SimulasiErrorSaldo();
}

class InvalidInformationMessage implements SimulasiMessage {
  const InvalidInformationMessage();
}
