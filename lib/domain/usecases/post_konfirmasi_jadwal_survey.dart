import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class PostKonfirmasiJadwalSurveyUseCase {
  final TransaksiRepository _transaksiRepository;
  const PostKonfirmasiJadwalSurveyUseCase(this._transaksiRepository);

  UnitResultSingle call({
    required int idTaskPengajuan,
    required int idPengajuan,
  }) =>
      _transaksiRepository.postKonfirmasiSurveyCND(
        idTaskPengajuan: idTaskPengajuan,
        idPengajuan: idPengajuan,
      );
}
