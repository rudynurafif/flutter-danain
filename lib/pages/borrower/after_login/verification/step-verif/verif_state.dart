// class VerificationState {
//   final String name;
//   final String noKtp;
//   final String tempatLahir;
//   final DateTime tglLahir;
//   final String gender;
//   final int statusKawin;
//   final int pendTerakhir;
//   final int agama;
//   final String? npwp;
//   final String? namaPasangan;
//   final String ibuKandung;
//   final int statusRumah;
//   final int lamaTinggal;

//   const VerificationState({
//     required this.name,
//     required this.noKtp,
//     required this.tempatLahir,
//     required this.tglLahir,
//     required this.gender,
//     required this.statusKawin,
//     required this.pendTerakhir,
//     required this.agama,
//     this.npwp,
//     this.namaPasangan,
//     required this.ibuKandung,
//     required this.statusRumah,
//     required this.lamaTinggal
//   });
// }

import 'package:meta/meta.dart';

@immutable
abstract class VerificationMessage {}

class VerificationSuccess implements VerificationMessage {
  const VerificationSuccess();
}

class VerificationError implements VerificationMessage {
  final Object error;
  final String message;

  const VerificationError(this.message, this.error);

  @override
  String toString() => 'VerificationError{message=$message, error=$error}';
}

class InvalidInformationMessage implements VerificationMessage {
  const InvalidInformationMessage();
}
