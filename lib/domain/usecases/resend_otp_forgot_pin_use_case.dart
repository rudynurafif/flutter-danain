import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ResendOtpForgotPinUseCase {
  final UserRepository _userRepository;

  const ResendOtpForgotPinUseCase(this._userRepository);

  UnitResultSingle call() => _userRepository.resendOtpForgotPinLender();
}
