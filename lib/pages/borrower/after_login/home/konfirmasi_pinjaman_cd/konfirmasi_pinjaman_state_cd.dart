import 'package:flutter/material.dart';

@immutable
abstract class KonfirmasiPincamanCdMessage {}

class KonfirmasiPincamanCdSuccessMessage
    implements KonfirmasiPincamanCdMessage {
  const KonfirmasiPincamanCdSuccessMessage();
}

class KonfirmasiPincamanCdErrorMessage implements KonfirmasiPincamanCdMessage {
  final Object error;
  final String message;

  const KonfirmasiPincamanCdErrorMessage(this.message, this.error);

  @override
  String toString() =>
      'PenawaranPinjamanErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements KonfirmasiPincamanCdMessage {
  const InvalidInformationMessage();
}
