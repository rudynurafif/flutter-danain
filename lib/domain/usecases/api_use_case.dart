import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';

class GetRequestUseCase {
  final UserRepository _userRepository;

  const GetRequestUseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required String url,
    Map<String, dynamic> queryParam = const {},
    Map<String, String> moreHeader = const {},
    bool isUseToken = true,
    serviceBackend service = serviceBackend.auth,
  }) async {
    return _userRepository.getRequest(
      url: url,
      queryParam: queryParam,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      service: service,
    );
  }
}

class PostRequestUseCase {
  final UserRepository _userRepository;

  const PostRequestUseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String> moreHeader = const {},
    bool isUseToken = true,
    serviceBackend service = serviceBackend.auth,
  }) async {
    return _userRepository.postRequest(
      url: url,
      body: body,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      service: service,
    );
  }
}

class PostRequestV2UseCase {
  final UserRepository _userRepository;

  const PostRequestV2UseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String> moreHeader = const {},
    bool isUseToken = true,
  }) async {
    return _userRepository.postRequestV2(
      url: url,
      body: body,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
    );
  }
}

class GetRequestV2UseCase {
  final UserRepository _userRepository;

  const GetRequestV2UseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required String url,
    required Map<String, dynamic> queryParam,
    Map<String, String> moreHeader = const {},
    bool isUseToken = true,
  }) async {
    return _userRepository.getRequestV2(
      url: url,
      queryParam: queryParam,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
    );
  }
}

class PostFormDataUseCase {
  final UserRepository _userRepository;

  const PostFormDataUseCase(this._userRepository);

  Future<Either<String, GeneralResponse>> call({
    required String url,
    required Map<String, String> body,
    Map<String, dynamic> queryParam = const {},
    Map<String, String> moreHeader = const {},
    bool isUseToken = true,
    serviceBackend service = serviceBackend.auth,
  }) async {
    return _userRepository.postFormData(
      url: url,
      body: body,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      service: service,
      queryParam: queryParam,
    );
  }
}

class GetDokumenUseCase {
  final UserRepository _userRepository;

  const GetDokumenUseCase(this._userRepository);

  Future<Either<String, dynamic>> call({
    required String url,
    Map<String, dynamic> queryParam = const {},
    Map<String, String> moreHeader = const {},
    bool isUseToken = true,
    serviceBackend service = serviceBackend.dokumen,
  }) async {
    return _userRepository.getDokumen(
      url: url,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      service: service,
      queryParam: queryParam,
    );
  }
}

class PostRequestDocumentUseCase {
  final UserRepository _userRepository;

  const PostRequestDocumentUseCase(this._userRepository);

  Future<Either<String, dynamic>> call({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String> moreHeader = const {},
    bool isUseToken = true,
    serviceBackend service = serviceBackend.dokumen,
  }) async {
    return _userRepository.postDokumen(
      url: url,
      body: body,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      service: service,
    );
  }
}
