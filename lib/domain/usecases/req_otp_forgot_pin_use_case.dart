import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ReqOtpForgotPinUseCase {
  final UserRepository _userRepository;

  const ReqOtpForgotPinUseCase(this._userRepository);

  UnitResultSingle call() => _userRepository.sendOtpForgotPinLender();
}
