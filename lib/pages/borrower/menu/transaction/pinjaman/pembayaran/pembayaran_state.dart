import 'package:meta/meta.dart';



@immutable
abstract class PembayaranMessage {}

class PembayaranSuccess implements PembayaranMessage {
  const PembayaranSuccess();
}

class PembayaranError implements PembayaranMessage {
  final Object error;
  final String message;

  const PembayaranError(this.message, this.error);

  @override
  String toString() => 'SimulasiPinjamanError{message=$message, error=$error}';
}

class InvalidInformationMessage implements PembayaranMessage {
  const InvalidInformationMessage();
}


