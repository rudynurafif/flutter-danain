import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class GetHubunganKeluargaUseCase {
  final UserRepository _userRepository;

  const GetHubunganKeluargaUseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call() async {
    return _userRepository.getHubunganKeluarga();
  }
}
