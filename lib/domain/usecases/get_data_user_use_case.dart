import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class GetDataUser {
  final UserRepository _userRepository;

  const GetDataUser(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required String urlParam,
  }) async {
    return _userRepository.getDataUser(urlParam: urlParam);
  }
}
