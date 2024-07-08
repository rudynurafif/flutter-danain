import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class GetAuthStateStreamUseCase {
  final UserRepository _userRepository;

  const GetAuthStateStreamUseCase(this._userRepository);

  Stream<Result<AuthenticationState>> call() =>
      _userRepository.authenticationState$;
}
