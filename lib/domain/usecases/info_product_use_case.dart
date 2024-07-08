import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class GetProdukUseCase {
  final UserRepository _userRepository;

  const GetProdukUseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required GetProdukParams params,
  }) async {
    return _userRepository.getProduk(params: params);
  }
}

class GetProdukParams {
  final int page;
  final int pageSize;
  const GetProdukParams({
    required this.page,
    this.pageSize = 10,
  });
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
    };
  }
}
