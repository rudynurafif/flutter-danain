import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';

class UploadFileUseCase {
  final TransaksiRepository _transaksiRepository;
  const UploadFileUseCase(this._transaksiRepository);

  Future<Either<String, GeneralResponse>> call({
    required Map<String, dynamic> params,
    required String file,
  }) =>
      _transaksiRepository.uploadFileManager(
        params,
        file,
      );
}
