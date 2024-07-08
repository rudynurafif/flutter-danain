import 'dart:io';

import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class ReqOtpRegisterUseCase {
  final UserRepository _userRepoSitory;

  const ReqOtpRegisterUseCase(this._userRepoSitory);

  UnitResultSingle call({
    required String phone,
  }) =>
      _userRepoSitory.reqOtpRegisterLender(
        phone: phone,
      );
}
