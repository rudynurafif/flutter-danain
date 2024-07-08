import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class RegisRdlLenderUseCase {
  final UserRepository userRepo;
  const RegisRdlLenderUseCase(this.userRepo);

  UnitResultSingle call({
    required Map<String, dynamic> payload,
  }) =>
      userRepo.regisRdlLender(
        payload: payload,
      );
}
