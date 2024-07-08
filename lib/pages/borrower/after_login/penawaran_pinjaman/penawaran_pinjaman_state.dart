import 'package:flutter/material.dart';

@immutable
abstract class PenawaranPinjamanMessage {}

class PenawaranPinjamanSuccessMessage implements PenawaranPinjamanMessage {
  const PenawaranPinjamanSuccessMessage();
}

class PenawaranPinjamanErrorMessage implements PenawaranPinjamanMessage {
  final Object error;
  final String message;

  const PenawaranPinjamanErrorMessage(this.message, this.error);

  @override
  String toString() => 'PenawaranPinjamanErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements PenawaranPinjamanMessage {
  const InvalidInformationMessage();
}
