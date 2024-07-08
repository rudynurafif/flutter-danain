import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class VerifikasiLenderUseCase {
  final UserRepository userRepo;
  const VerifikasiLenderUseCase(this.userRepo);

  UnitResultSingle call({
    required Map<String, dynamic> payload,
  }) =>
      userRepo.verificationLender(
        payload: payload,
      );
}
