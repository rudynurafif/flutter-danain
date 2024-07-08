import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class MakeNewPasswordUseCase {
  final UserRepository _userRepository;
  const MakeNewPasswordUseCase(this._userRepository);

  UnitResultSingle call({
    required String kodeVerifikasi,
    required String password
  }) =>
      _userRepository.makeNewPassword(
        kodeVerifikasi: kodeVerifikasi,
        password: password
      );
}
