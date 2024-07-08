import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class CicilEmasReqUseCase {
  final TransaksiRepository transaksiRepository;
  const CicilEmasReqUseCase(this.transaksiRepository);
  UnitResultSingle call({
    required int idProduk,
    required List<dynamic> dataProduk,
    String? kodeCheckout,
  }) =>
      transaksiRepository.cicilEmasReq(
        idProduk: idProduk,
        dataProduk: dataProduk,
        kodeCheckout: kodeCheckout
      );
}
