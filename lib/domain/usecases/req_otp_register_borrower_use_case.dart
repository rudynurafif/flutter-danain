
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ReqOtpRegisterBorrowerUseCase {
  final UserRepository _userRepoSitory;

  const ReqOtpRegisterBorrowerUseCase(this._userRepoSitory);

  UnitResultSingle call({
    required String phone,
    String? kodeVerif
  }) =>
      _userRepoSitory.reqOtpRegisterBorrower(
        phone: phone,
        kodeVerif:kodeVerif,
      );
}
