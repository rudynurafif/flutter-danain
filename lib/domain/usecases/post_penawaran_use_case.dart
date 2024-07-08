import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class PenawaranPinjamanUseCase {
  final TransaksiRepository _transaksiRepository;
  const PenawaranPinjamanUseCase(this._transaksiRepository);

  UnitResultSingle call({
    required int idproduk,
    required int idjaminan,
    required String otp,
    required int idRekening,
    required String tujuanPinjaman,
  }) =>
      _transaksiRepository.postValidasiOtpPinjaman(
        idproduk: idproduk,
        idjaminan: idjaminan,
        otp: otp,
        idRekening: idRekening,
        tujuanPinjaman: tujuanPinjaman,
      );
}
