import 'package:flutter/material.dart';

@immutable
abstract class KonfirmasiPinjamanMessage {}

class KonfirmasiPinjamanSuccessMessage implements KonfirmasiPinjamanMessage {
  const KonfirmasiPinjamanSuccessMessage();
}

class KonfirmasiPinjamanErrorMessage implements KonfirmasiPinjamanMessage {
  final Object error;
  final String message;

  const KonfirmasiPinjamanErrorMessage(this.message, this.error);

  @override
  String toString() =>
      'KonfirmasiinjamanErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements KonfirmasiPinjamanMessage {
  const InvalidInformationMessage();
}
