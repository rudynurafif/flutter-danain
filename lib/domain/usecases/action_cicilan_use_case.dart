import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class ActionCicilanUseCase {
  final TransaksiRepository transaksiRepository;
  const ActionCicilanUseCase(this.transaksiRepository);
  UnitResultSingle call({
    required String va,
    required num total,
    required int status,
  }) =>
      transaksiRepository.actionCicilan(
        va: va,
        total: total,
        status: status,
      );
}
