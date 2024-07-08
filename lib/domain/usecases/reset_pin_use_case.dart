import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ResetPinUseCase {
  final UserRepository _userRepository;

  const ResetPinUseCase(this._userRepository);

  UnitResultSingle call({
    required String pin,
    required String key,
  }) =>
      _userRepository.resetForgotPin(
        pin: pin,
        key: key,
      );
}
