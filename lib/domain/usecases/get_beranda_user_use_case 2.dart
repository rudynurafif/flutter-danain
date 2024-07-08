import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class GetBerandaUserUseCase {
  final UserRepository _userRepository;

  const GetBerandaUserUseCase(this._userRepository);


  UnitResultSingle call() =>
      _userRepository.getBerandaAndUser();
}
