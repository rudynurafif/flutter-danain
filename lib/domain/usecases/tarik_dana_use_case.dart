import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class TarikDanaUseCase {
  final TransaksiRepository _transaksiRepository;
  const TarikDanaUseCase(this._transaksiRepository);

  UnitResultSingle call({
    required int nominal,
    required String pin,
  }) =>
      _transaksiRepository.tarikDana(
        nominal: nominal,
        pin: pin,
      );
}
