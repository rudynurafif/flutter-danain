import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class PostDataPendukungUseCase {
  final UserRepository _userRepository;

  const PostDataPendukungUseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required Map<String, dynamic> data,
  }) async {
    return _userRepository.postDataPendukung(data: data);
  }
}
