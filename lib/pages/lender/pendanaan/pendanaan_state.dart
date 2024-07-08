import 'package:meta/meta.dart';

@immutable
abstract class PendanaanMessage {}

class PendanaanSuccess implements PendanaanMessage {
  const PendanaanSuccess();
}

class PendanaanError implements PendanaanMessage {
  final Object error;
  final String message;

  const PendanaanError(this.message, this.error);

  @override
  String toString() => 'SimulasiPinjamanError{message=$message, error=$error}';
}

class PendanaanErrorSaldo implements PendanaanMessage {
  const PendanaanErrorSaldo();
}

class InvalidInformationMessage implements PendanaanMessage {
  const InvalidInformationMessage();
}
