import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class SendOtpRegisterBorrowerUseCase {
  final UserRepository _userRepoSitory;

  const SendOtpRegisterBorrowerUseCase(this._userRepoSitory);

  UnitResultSingle call({
    required String name,
    required String phone,
    required String email,
    required String otp,
    String? kodeVerif
  }) =>
      _userRepoSitory.sendOtpRegisterBorrower(
        name: name,
        phone: phone,
        email: email,
        otp: otp,
        kodeVerif:kodeVerif,
      );
}
