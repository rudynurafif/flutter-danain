import 'package:meta/meta.dart';

@immutable
abstract class DetailCicilanMessage {}

class DetailCicilanSuccess implements DetailCicilanMessage {
  const DetailCicilanSuccess();
}

class DetailCicilanError implements DetailCicilanMessage {
  final Object error;
  final String message;

  const DetailCicilanError(this.message, this.error);

  @override
  String toString() => 'SimulasiPinjamanError{message=$message, error=$error}';
}

class DetailCicilanErrorSaldo implements DetailCicilanMessage {
  const DetailCicilanErrorSaldo();
}

class InvalidInformationMessage implements DetailCicilanMessage {
  const InvalidInformationMessage();
}
