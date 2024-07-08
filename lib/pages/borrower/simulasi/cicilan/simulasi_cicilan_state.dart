import 'package:meta/meta.dart';

class CredentialSimulasiCicilan {
  final List<Map<String, dynamic>> detailEmas;
  final int totalHargaEmas;
  final int idProduk;
  final int tenor;

  const CredentialSimulasiCicilan({
    required this.detailEmas,
    required this.totalHargaEmas,
    required this.idProduk,
    required this.tenor,
  });
}

@immutable
abstract class SimulasiCicilanMessage {}

class SimulasiCicilanSuccess implements SimulasiCicilanMessage {
  const SimulasiCicilanSuccess();
}

class SimulasiCicilanError implements SimulasiCicilanMessage {
  final Object error;
  final String message;

  const SimulasiCicilanError(this.message, this.error);

  @override
  String toString() => 'SimulasiCicilanError{message=$message, error=$error}';
}

class InvalidInformationMessage implements SimulasiCicilanMessage {
  const InvalidInformationMessage();
}
