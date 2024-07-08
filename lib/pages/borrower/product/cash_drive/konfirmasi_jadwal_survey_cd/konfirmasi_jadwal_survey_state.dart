import 'package:flutter/material.dart';

@immutable
abstract class KonfirmasiJadwalSurveyMessage {}

class KonfirmasiJadwalSurveySuccessMessage
    implements KonfirmasiJadwalSurveyMessage {
  const KonfirmasiJadwalSurveySuccessMessage();
}

class KonfirmasiJadwalSurveyErrorMessage
    implements KonfirmasiJadwalSurveyMessage {
  final Object error;
  final String message;

  const KonfirmasiJadwalSurveyErrorMessage(this.message, this.error);

  @override
  String toString() =>
      'KonfirmasiJadwalSurveyErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements KonfirmasiJadwalSurveyMessage {
  const InvalidInformationMessage();
}
