import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';
import 'package:flutter_danain/utils/constants.dart';

class SimulasiCndUseCase {
  final TransaksiRepository _transaksiRepository;
  const SimulasiCndUseCase(this._transaksiRepository);

  Future<Either<String, GeneralResponse>> call({
    required SimulasiParams payload,
  }) =>
      _transaksiRepository.simulasiCnD(payload);
}

class SimulasiParams {
  final int nilaiPinjaman;
  final int tenor;
  final int idProduk;
  final int idJenisKendaraan;
  final String tahun;
  final int idProvinsi;
  final int idModel;

  const SimulasiParams({
    required this.nilaiPinjaman,
    required this.tenor,
    this.idProduk = 2,
    required this.idJenisKendaraan,
    required this.tahun,
    required this.idProvinsi,
    required this.idModel,
  });
  Map<String, dynamic> toJson() {
    return {
      'nilaiPinjaman': nilaiPinjaman,
      'tenor': tenor,
      'idProduk': idProduk,
      'idJenisKendaraan': idJenisKendaraan,
      'tahun': tahun,
      'idProvinsi': idProvinsi,
      'idModel': idModel,
    };
  }
}
