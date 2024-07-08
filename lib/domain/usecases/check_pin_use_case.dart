import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class CheckPinUseCase {
  final UserRepository _userRepository;
  const CheckPinUseCase(this._userRepository);
  UnitResultSingle call({
    required String pin,
  }) =>
      _userRepository.checkPinLender(
        pin: pin,
      );
}
