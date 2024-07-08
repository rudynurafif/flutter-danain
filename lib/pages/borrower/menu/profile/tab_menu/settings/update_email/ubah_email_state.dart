import 'package:flutter/material.dart';

@immutable
abstract class UpdateEmailMessage {}

class UpdateEmailSuccessMessage implements UpdateEmailMessage {
  const UpdateEmailSuccessMessage();
}

class UpdateEmailErrorMessage implements UpdateEmailMessage {
  final Object error;
  final String message;

  const UpdateEmailErrorMessage(this.message, this.error);

  @override
  String toString() => 'UpdateEmailErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements UpdateEmailMessage {
  const InvalidInformationMessage();
}