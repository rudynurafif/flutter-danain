import 'package:meta/meta.dart';



@immutable
abstract class DetailVaMessage {}

class DetailVaSuccess implements DetailVaMessage {
  final Map<String,dynamic> data;
  const DetailVaSuccess(this.data);
}

class DetailVaError implements DetailVaMessage {
  final Object error;
  final String message;

  const DetailVaError(this.message, this.error);

  @override
  String toString() => 'SimulasiPinjamanError{message=$message, error=$error}';
}

class InvalidInformationMessage implements DetailVaMessage {
  const InvalidInformationMessage();
}


