import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class RefreshTokenUseCase {
  final UserRepository _repo;
  const RefreshTokenUseCase(this._repo);

  UnitResultSingle call() => _repo.refreshToken();
}
