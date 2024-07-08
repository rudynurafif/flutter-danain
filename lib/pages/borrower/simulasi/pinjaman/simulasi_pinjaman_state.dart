import 'package:meta/meta.dart';

class CredentialSimulasiPinjaman {
  final int gram;
  final int karat;
  final int? jangkaWaktu;
  final int? nilaiPinjaman;

  const CredentialSimulasiPinjaman(
      {required this.gram, required this.karat,  this.jangkaWaktu,  this.nilaiPinjaman});
}

@immutable
abstract class SimulasiPinjamanMessage {}

class SimulasiPinjamanSuccess implements SimulasiPinjamanMessage {
  const SimulasiPinjamanSuccess();
}

class SimulasiPinjamanError implements SimulasiPinjamanMessage {
  final Object error;
  final String message;

  const SimulasiPinjamanError(this.message, this.error);

  @override
  String toString() => 'SimulasiPinjamanError{message=$message, error=$error}';
}

class InvalidInformationMessage implements SimulasiPinjamanMessage {
  const InvalidInformationMessage();
}


