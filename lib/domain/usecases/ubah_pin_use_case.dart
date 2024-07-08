import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class UbahPinLenderUseCase {
  final UserRepository _userRepository;
  const UbahPinLenderUseCase(this._userRepository);
  UnitResultSingle call({
    required String currentPin,
    required String newPin,
    required String confirmPin,
  }) =>
      _userRepository.ubahPinLender(
        currentPin: currentPin,
        newPin: newPin,
        confirmPin: confirmPin,
      );
}
