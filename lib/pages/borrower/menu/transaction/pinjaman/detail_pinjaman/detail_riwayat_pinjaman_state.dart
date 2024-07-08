import 'package:meta/meta.dart';



@immutable
abstract class DetailRiwayatPinjamanMessage {}

class DetailRiwayatPinjamanSuccess implements DetailRiwayatPinjamanMessage {
  const DetailRiwayatPinjamanSuccess();
}

class DetailRiwayatPinjamanError implements DetailRiwayatPinjamanMessage {
  final Object error;
  final String message;

  const DetailRiwayatPinjamanError(this.message, this.error);

  @override
  String toString() => 'SimulasiPinjamanError{message=$message, error=$error}';
}

class InvalidInformationMessage implements DetailRiwayatPinjamanMessage {
  const InvalidInformationMessage();
}


