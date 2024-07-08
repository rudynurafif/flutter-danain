import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ForgotPasswordUseCase {
  final UserRepository _userRepository;
  const ForgotPasswordUseCase(this._userRepository);

  UnitResultSingle call({
    required String email,
  }) =>
      _userRepository.forgotPasswordFirst(
        email: email,
      );
}
