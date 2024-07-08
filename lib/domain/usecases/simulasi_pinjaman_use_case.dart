import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/simulasi_repository.dart';

class SimulasiPinjamanUseCase {
  final SimulasiRepository _simulasiRepository;

  const SimulasiPinjamanUseCase(this._simulasiRepository);

  UnitResultSingle call({
    required int gram,
    required int karat,
     int? jangkaWaktu,
     int? nilaiPinjaman,
  }) =>
      _simulasiRepository.simulasiPinjaman(
        gram: gram,
        karat: karat,
        jangkaWaktu: jangkaWaktu!,
        nilaiPinjaman: nilaiPinjaman!
      );
}
