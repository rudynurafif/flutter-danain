import 'package:meta/meta.dart';

@immutable
abstract class UpdateBankState {}

class UpdateBankSuccess implements UpdateBankState {
  const UpdateBankSuccess();
}

class UpdateBankError implements UpdateBankState {
  final String message;
  final Object error;

  const UpdateBankError(this.message, this.error);

  @override
  String toString() => 'UpdateBankError{message=$message, error=$error}';
}

class InvalidInformationMessageBank implements UpdateBankState {
  const InvalidInformationMessageBank();
}
