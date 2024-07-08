import 'dart:io';

import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class UpdateHpUseCase {
  final UserRepository _userRepoSitory;

  const UpdateHpUseCase(this._userRepoSitory);

  UnitResultSingle call({
    required String new_hp,
    required String kode_verifikasi,
    required File fileImage,
  }) =>
      _userRepoSitory.reqOtpChangeHp(
        new_hp: new_hp,
        kode_verifikasi: kode_verifikasi,
        fileImage: fileImage,
      );
}
