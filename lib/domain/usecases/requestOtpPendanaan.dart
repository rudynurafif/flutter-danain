import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class ReqOtpPendanaanUseCase {
  final TransaksiRepository _transaksiRepository;
  const ReqOtpPendanaanUseCase(this._transaksiRepository);

  UnitResultSingle call({
    required String nosbg,
  }) =>
      _transaksiRepository.requestOtpPendanaan(
        nosbg: nosbg
      );
}
