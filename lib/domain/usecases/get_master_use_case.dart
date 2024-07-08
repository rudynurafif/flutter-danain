import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class GetMasterDataUseCase {
  final TransaksiRepository _transaksiRepository;
  const GetMasterDataUseCase(this._transaksiRepository);

  Future<Either<String, GeneralResponse>> call({
    required String endpoint,
    required Map<String, dynamic> params,
  }) =>
      _transaksiRepository.getMaster(
        endpoint,
        params,
      );
}

class GetMasterV1UseCase {
  final TransaksiRepository _transaksiRepository;
  const GetMasterV1UseCase(this._transaksiRepository);

  Future<Either<String, GeneralResponse>> call({
    required String endpoint,
    required Map<String, dynamic> params,
  }) =>
      _transaksiRepository.getMasterV1(
        endpoint,
        params,
      );
}
