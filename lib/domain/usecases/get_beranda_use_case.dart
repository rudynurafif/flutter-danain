import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class GetBerandaUseCase {
  final UserRepository _userRepository;

  const GetBerandaUseCase(this._userRepository);

  UnitResultSingle call() =>
      _userRepository.getBeranda();
}
