import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository _userRepository;

  const LoginUseCase(this._userRepository);

  UnitResultSingle call({
    required String email,
    required String password,
  }) =>
      _userRepository.login(email: email, password: password);
}
