import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class SimulasiMaxiUseCase {
  final TransaksiRepository _transaksiRepository;
  const SimulasiMaxiUseCase(this._transaksiRepository);

  UnitResultSingle call({
    required int nilaiPinjaman,
    required int jumlahHari,
  }) =>
      _transaksiRepository.simulasiMaxi(
        nilaiPinjaman: nilaiPinjaman,
      jumlahHari: jumlahHari,
      );
}
