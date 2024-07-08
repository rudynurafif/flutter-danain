import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ValOtpForgotPinUseCase {
  final UserRepository _userRepository;

  const ValOtpForgotPinUseCase(this._userRepository);

  UnitResultSingle call({
    required String kode,
  }) =>
      _userRepository.validasiOtpForgotPin(
        kode: kode,
      );
}
