import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class GetInfoBankUseCase {
  final UserRepository _userRepository;

  const GetInfoBankUseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required int idBank,
    required String noRek,
  }) async {
    return _userRepository.getInfoBank(idBank: idBank, noRek: noRek);
  }
}
