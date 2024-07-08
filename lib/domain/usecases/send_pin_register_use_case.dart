import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class SendPinRegisterUseCase {
  final UserRepository _userRepoSitory;

  const SendPinRegisterUseCase(this._userRepoSitory);

  UnitResultSingle call({
    required String pin,
  }) =>
      _userRepoSitory.sendPinRegisterLender(
        pin: pin,
      );
}
