import 'package:flutter/material.dart';

@immutable
abstract class UpdateHpMessage {}

class UpdateHpSuccessMessage implements UpdateHpMessage {
  const UpdateHpSuccessMessage();
}

class UpdateHpErrorMessage implements UpdateHpMessage {
  final Object error;
  final String message;

  const UpdateHpErrorMessage(this.message, this.error);

  @override
  String toString() => 'UpdateHpErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements UpdateHpMessage {
  const InvalidInformationMessage();
}