import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class UpdateEmailUseCase1 {
  final UserRepository _userRepository;
  const UpdateEmailUseCase1(this._userRepository);

  UnitResultSingle call({
    required String otp,
    required String hp,
  }) =>
      _userRepository.validasiOtpChangeEmail(
        otp: otp,
        hp: hp,
      );
}
