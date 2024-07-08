import 'package:flutter/material.dart';

@immutable
abstract class ForgotPasswordMessage {}

class ForgotPasswordSuccessMessage implements ForgotPasswordMessage {
  const ForgotPasswordSuccessMessage();
}

class ForgotPasswordErrorMessage implements ForgotPasswordMessage {
  final Object error;
  final String message;

  const ForgotPasswordErrorMessage(this.message, this.error);

  @override
  String toString() => 'ForgotPasswordErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements ForgotPasswordMessage {
  const InvalidInformationMessage();
}