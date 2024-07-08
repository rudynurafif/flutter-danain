import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ChangePasswordUseCase {
  final UserRepository _userRepository;

  const ChangePasswordUseCase(this._userRepository);

  UnitResultSingle call({
    required String password,
    required String newPassword,
  }) =>
      _userRepository.changePassword(
        password: password,
        newPassword: newPassword,
      );
}
