
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class UpdateHpValidasiUseCase {
  final UserRepository _userRepoSitory;

  const UpdateHpValidasiUseCase(this._userRepoSitory);

  UnitResultSingle call({
    required String new_hp,
    required String otp,
  }) =>
      _userRepoSitory.validasiOtpChangeHp(
        hp: new_hp,
        otp: otp,
      );
}
