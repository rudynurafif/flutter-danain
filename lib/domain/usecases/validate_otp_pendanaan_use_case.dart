import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class ValidasiOtpPendanaanUseCase {
  final TransaksiRepository _transaksiRepository;
  const ValidasiOtpPendanaanUseCase(this._transaksiRepository);

  UnitResultSingle call({
    required String nosbg,
    required String otp,
  }) =>
      _transaksiRepository.validateOtpPendanaan(
        noSbg: nosbg,
        otp: otp,
      );
}
