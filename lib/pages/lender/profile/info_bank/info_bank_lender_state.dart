import 'package:meta/meta.dart';

@immutable
abstract class InfoBankLenderState {}

class InfoBankLenderSuccess implements InfoBankLenderState {
  final Map<String, dynamic> data;
  const InfoBankLenderSuccess(this.data);
}

class InfoBankLenderErrorName implements InfoBankLenderState {
  final Map<String, dynamic> data;
  const InfoBankLenderErrorName(this.data);
}

class InfoBankLenderError implements InfoBankLenderState {
  final String message;
  final Object error;

  const InfoBankLenderError(this.message, this.error);

  @override
  String toString() => 'InfoBankError{message=$message, error=$error}';
}

class InvalidInformationMessage implements InfoBankLenderState {
  const InvalidInformationMessage();
}
