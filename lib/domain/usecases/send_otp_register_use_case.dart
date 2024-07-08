import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class SendOtpRegisterUseCase {
  final UserRepository _userRepoSitory;

  const SendOtpRegisterUseCase(this._userRepoSitory);

  UnitResultSingle call({
    required String otp,
  }) =>
      _userRepoSitory.sendOtpRegisterLender(
        otp: otp,
      );
}
