import 'package:flutter/material.dart';

@immutable
abstract class VerifikasiMessage {}

class VerifikasiSuccessMessage implements VerifikasiMessage {
  const VerifikasiSuccessMessage();
}

class VerifikasiErrorMessage implements VerifikasiMessage {
  final Object error;
  final String message;

  const VerifikasiErrorMessage(this.message, this.error);

  @override
  String toString() => 'RegisterLenderErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements VerifikasiMessage {
  const InvalidInformationMessage();
}