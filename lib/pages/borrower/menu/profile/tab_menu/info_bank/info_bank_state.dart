import 'package:meta/meta.dart';

@immutable
abstract class InfoBankState {}

class InfoBankSuccess implements InfoBankState {
  final Map<String, dynamic> data;
  const InfoBankSuccess(this.data);
}

class InfoBankErrorName implements InfoBankState {
  final Map<String, dynamic> data;
  const InfoBankErrorName(this.data);
}

class InfoBankError implements InfoBankState {
  final String message;
  final Object error;

  const InfoBankError(this.message, this.error);

  @override
  String toString() => 'InfoBankError{message=$message, error=$error}';
}

class InvalidInformationMessage implements InfoBankState {
  const InvalidInformationMessage();
}
