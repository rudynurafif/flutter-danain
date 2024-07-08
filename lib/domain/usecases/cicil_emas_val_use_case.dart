import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class CicilEmasValUseCase {
  final TransaksiRepository transaksiRepository;
  const CicilEmasValUseCase(this.transaksiRepository);
  UnitResultSingle call({
    required Map<String, dynamic> data,
  }) =>
      transaksiRepository.cicilEmasVal(
        data: data,
      );
}
