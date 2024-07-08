import 'package:flutter/material.dart';

@immutable
abstract class RegisterNewMessage {}

class RegisterNewSuccessMessage implements RegisterNewMessage {
  const RegisterNewSuccessMessage();
}

class RegisterNewErrorMessage implements RegisterNewMessage {
  final Object error;
  final String message;

  const RegisterNewErrorMessage(this.message, this.error);

  @override
  String toString() => 'RegisterLenderErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements RegisterNewMessage {
  const InvalidInformationMessage();
}