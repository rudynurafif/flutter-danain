import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class SimulasiCicilanUseCase {
  final TransaksiRepository _transaksiRepository;
  const SimulasiCicilanUseCase(this._transaksiRepository);

  UnitResultSingle call({
    required Map<String, dynamic> payload,
  }) =>
      _transaksiRepository.calculateCicilan(
        payload: payload,
      );
}
