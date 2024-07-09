import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class RegisterBorrowerUseCase {
  final UserRepository _userRepository;

  const RegisterBorrowerUseCase(this._userRepository);

  UnitResultSingle call({required Map<String, dynamic> payload}) {
    return _userRepository.registerBorrower(
      payload: payload,
    );
  }
}
