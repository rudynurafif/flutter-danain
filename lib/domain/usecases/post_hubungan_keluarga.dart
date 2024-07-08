import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class PostHubunganKeluargaUseCase {
  final UserRepository _userRepository;

  const PostHubunganKeluargaUseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required DataKeluargaPayload payload,
  }) async {
    return _userRepository.postHubunganKeluarga(payload: payload);
  }
}

class DataKeluargaPayload {
  final int idHubunganKeluarga;
  final String namaLengkap;
  final String noHp;
  final String noKtp;
  const DataKeluargaPayload({
    required this.idHubunganKeluarga,
    required this.namaLengkap,
    required this.noHp,
    required this.noKtp,
  });

  Map<String, dynamic> toJson() {
    return {
      'idHubunganKeluarga': idHubunganKeluarga,
      'namaLengkap': namaLengkap,
      'noHp': noHp,
      'noKtp': noKtp,
    };
  }
}
