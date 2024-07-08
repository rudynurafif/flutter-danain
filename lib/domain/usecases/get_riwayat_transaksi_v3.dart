import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class GetRiwayatTransaksiUseCase {
  final TransaksiRepository _transaksiRepository;
  const GetRiwayatTransaksiUseCase(this._transaksiRepository);

  Future<Either<String, GeneralResponse>> call({
    required String endpoint,
    required Map<String, dynamic> params,
    required String token,
  }) =>
      _transaksiRepository.getRiwayatTransaksiv3(endpoint, params, token);
}
