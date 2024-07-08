import 'dart:io';

import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class UpdateEmailUseCase2 {
  final UserRepository _userRepository;
  const UpdateEmailUseCase2(this._userRepository);

  UnitResultSingle call({
    required String new_email,
    required String kode,
    required String type,
    required File fileimage,
  }) =>
      _userRepository.changeEmailRequest(
        new_email: new_email,
        kode_verifikasi: kode,
        type: type,
        fileimage: fileimage
      );
}
