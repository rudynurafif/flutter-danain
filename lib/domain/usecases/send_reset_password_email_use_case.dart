import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class SendResetPasswordEmailUseCase {
  final UserRepository _userRepository;

  const SendResetPasswordEmailUseCase(this._userRepository);

  UnitResultSingle call(String email) =>
      _userRepository.sendResetPasswordEmail(email);
}
