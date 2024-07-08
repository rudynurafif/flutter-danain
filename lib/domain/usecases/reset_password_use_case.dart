import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ResetPasswordUseCase {
  final UserRepository _userRepository;

  const ResetPasswordUseCase(this._userRepository);

  UnitResultSingle call({
    required String email,
  }) =>
      _userRepository.resetPassword(
        email: email,
      );
}
