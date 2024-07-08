import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class SendEmailRegisterUseCase {
  final UserRepository _userRepoSitory;

  const SendEmailRegisterUseCase(this._userRepoSitory);

  UnitResultSingle call() =>
      _userRepoSitory.sendEmailRegisterLender();
}
