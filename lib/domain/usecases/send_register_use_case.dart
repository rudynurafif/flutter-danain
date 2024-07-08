import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class SendRegisterUseCase {
  final UserRepository _userRepoSitory;

  const SendRegisterUseCase(this._userRepoSitory);

  UnitResultSingle call({
    required String phone,
    required String name,
     String? referral,
    required String email,
    required String password,
  }) =>
      _userRepoSitory.sendRegisterLender(
     phone: phone, name: name, referal: referral, email: email, password: password,
      );
}
