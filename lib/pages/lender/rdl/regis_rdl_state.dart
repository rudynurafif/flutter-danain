import 'package:flutter/material.dart';

@immutable
abstract class RegisRdlMessage {}

class RegisRdlSuccessMessage implements RegisRdlMessage {
  const RegisRdlSuccessMessage();
}

class RegisRdlErrorMessage implements RegisRdlMessage {
  final Object error;
  final String message;

  const RegisRdlErrorMessage(this.message, this.error);

  @override
  String toString() => 'RegisterLenderErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements RegisRdlMessage {
  const InvalidInformationMessage();
}