import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class GetPaymentUseCase {
  final TransaksiRepository transaksiRepository;
  const GetPaymentUseCase(this.transaksiRepository);
  UnitResultSingle call({
    required int idAgreement,
  }) =>
      transaksiRepository.getPayment(
        idAgreement: idAgreement,
      );
}
