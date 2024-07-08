import 'package:flutter/material.dart';

@immutable
abstract class RegisterLenderMessage {}

class RegisterLenderSuccessMessage implements RegisterLenderMessage {
  const RegisterLenderSuccessMessage();
}

class RegisterLenderErrorMessage implements RegisterLenderMessage {
  final Object error;
  final String message;

  const RegisterLenderErrorMessage(this.message, this.error);

  @override
  String toString() => 'RegisterLenderErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements RegisterLenderMessage {
  const InvalidInformationMessage();
}