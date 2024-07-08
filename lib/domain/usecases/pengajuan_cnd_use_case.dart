import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class PengajuanCndUseCase {
  final TransaksiRepository _transaksiRepository;
  const PengajuanCndUseCase(this._transaksiRepository);

  Future<Either<String, GeneralResponse>> call({
    required Map<String, dynamic> payload,
  }) =>
      _transaksiRepository.postPengajuanCnd(
        payload,
      );
}
