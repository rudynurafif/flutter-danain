import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/usecases/info_product_use_case.dart';
import 'package:flutter_danain/domain/usecases/post_hubungan_keluarga.dart';
import 'package:flutter_danain/data/exception/local_data_source_exception.dart';
import 'package:flutter_danain/data/exception/remote_data_source_exception.dart';
import 'package:flutter_danain/data/local/entities/user_and_token_entity.dart';
import 'package:flutter_danain/data/local/entities/user_entity.dart';
import 'package:flutter_danain/data/local/local_data_source.dart';
import 'package:flutter_danain/data/remote/remote_data_source.dart';
import 'package:flutter_danain/data/remote/response/user_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:tuple/tuple.dart';

part 'remote/mappers/auth_mappers.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  @override
  final Stream<Result<AuthenticationState>> authenticationState$;

  @override
  Single<Result<AuthenticationState>> get authenticationState =>
      _localDataSource.userAndToken
          .map(_Mappers.userAndTokenEntityToDomainAuthState)
          .toEitherSingle(_Mappers.errorToAppError);

  UserRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  ) : authenticationState$ = _localDataSource.userAndToken$
            .map(_Mappers.userAndTokenEntityToDomainAuthState)
            .toEitherStream(_Mappers.errorToAppError)
            .publishValue()
          ..listen((state) => debugPrint('[USER_REPOSITORY] state=$state'))
          ..connect() {
    _init().ignore();
  }

  @override
  UnitResultSingle login({
    required String email,
    required String password,
  }) {
    return _remoteDataSource
        .loginUser(email, password)
        .toEitherSingle(_Mappers.errorToAppError)
        .flatMapEitherSingle((result) {
          final token = result.token!;
          final refreshToken = result.refreshToken!;
          const String lastPage = "kosong";
          return _remoteDataSource
              .getBerandaProfile(token, lastPage)
              .toEitherSingle(_Mappers.errorToAppError)
              .flatMapEitherSingle((beranda) {
            final tokenBeranda = beranda.token!;
            final Map<String, dynamic> jsonDataProfile = {
              'username': 'Azzam sidqi',
              'email': 'azzam@gmail.com',
              'id_borrower': 1,
              'id_rekening': 1,
              'tlp_mobile': '085313212131',
              'ktp': 'dummy',
            };
            // return Single.value(
            //   Tuple4(
            //     UserResponse.fromJson(jsonDataProfile),
            //     token,
            //     refreshToken,
            //     tokenBeranda,
            //   ).right(),
            // );
            return _remoteDataSource
                .getUserProfile(token)
                .map(
                  (user) => Tuple4(
                    user,
                    token,
                    refreshToken,
                    tokenBeranda,
                  ),
                )
                .toEitherSingle(_Mappers.errorToAppError);
          });
        })
        .flatMapEitherSingle(
          (tuple) => _localDataSource
              .saveUserAndToken(
                _Mappers.userResponseToUserAndTokenEntity(
                  tuple.item1,
                  tuple.item2,
                  tuple.item3,
                  tuple.item4,
                ),
              )
              .toEitherSingle(_Mappers.errorToAppError),
        )
        .asUnit();
  }

  @override
  UnitResultSingle refreshToken() {
    return _userAndToken.flatMapEitherSingle((value) {
      if (value == null) {
        return Single.value(
          AppError(
            message: 'Silakan login ulang',
            error: 'Tidak ada autentikasi',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }
      return _remoteDataSource
          .refreshToken(value!.refreshToken)
          .toEitherSingle(_Mappers.errorToAppError)
          .flatMapEitherSingle((result) {
            final token = result.token!;
            final refreshToken = result.refreshToken!;
            const String lastPage = "kosong";
            return _remoteDataSource
                .getBerandaProfile(token, lastPage)
                .toEitherSingle(_Mappers.errorToAppError)
                .flatMapEitherSingle((beranda) {
              final tokenBeranda = beranda.token!;
              final Map<String, dynamic> jsonDataProfile = {
                'username': 'Azzam sidqi',
                'email': 'azzam@gmail.com',
                'id_borrower': 1,
                'id_rekening': 1,
                'tlp_mobile': '085313212131',
                'ktp': 'dummy',
              };
              // return Single.value(
              //   Tuple4(
              //     UserResponse.fromJson(jsonDataProfile),
              //     token,
              //     refreshToken,
              //     tokenBeranda,
              //   ).right(),
              // );
              return _remoteDataSource
                  .getUserProfile(token)
                  .map(
                    (user) => Tuple4(
                      user,
                      token,
                      refreshToken,
                      tokenBeranda.toString(),
                    ),
                  )
                  .toEitherSingle(_Mappers.errorToAppError);
            });
          })
          .flatMapEitherSingle(
            (tuple) => _localDataSource
                .saveUserAndToken(
                  _Mappers.userResponseToUserAndTokenEntity(
                    tuple.item1,
                    tuple.item2,
                    tuple.item3,
                    tuple.item4,
                  ),
                )
                .toEitherSingle(_Mappers.errorToAppError),
          )
          .asUnit();
    });
  }

  @override
  UnitResultSingle registerUser({
    required String name,
    required String email,
    required String password,
  }) =>
      _remoteDataSource
          .registerUser(name, email, password)
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();

  @override
  UnitResultSingle logout() => _localDataSource
      .removeUserAndToken()
      .toEitherSingle(_Mappers.errorToAppError)
      .asUnit();

  @override
  UnitResultSingle changePassword({
    required String password,
    required String newPassword,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Silakan login ulang',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .changePassword(
            userAndToken.user.email,
            password,
            newPassword,
            userAndToken.token,
          )
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle resetPassword({
    required String email,
  }) =>
      _remoteDataSource
          .resetPassword(
            email,
          )
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();

  @override
  UnitResultSingle sendResetPasswordEmail(String email) => _remoteDataSource
      .resetPassword(email)
      .toEitherSingle(_Mappers.errorToAppError)
      .asUnit();

  ///
  /// Helpers functions
  ///

  /// TODO: Replace with interceptor
  Single<Result<UserAndTokenEntity?>> get _userAndToken =>
      _localDataSource.userAndToken.toEitherSingle(_Mappers.errorToAppError);

  ///
  /// Check auth when starting app
  ///
  Future<void> _init() async {
    const tag = '[USER_REPOSITORY] { init }';

    try {
      final userAndToken = await _localDataSource.userAndToken.first;
      debugPrint('$tag userAndToken local=$userAndToken');

      if (userAndToken == null) {
        return;
      }

      final userProfile = await _remoteDataSource
          .getUserProfile(
            userAndToken.token,
          )
          .first;
      // final Map<String, dynamic> jsonDataProfile = {
      //   'username': 'Azzam sidqi',
      //   'email': 'azzam@gmail.com',
      //   'id_borrower': 1,
      //   'id_rekening': 1,
      //   'tlp_mobile': '085313212131',
      //   'ktp': 'dummy',
      // };
      print("coba coba testing");
      print(userAndToken.token);
      // debugPrint('$tag userProfile server=$userProfile');
      await _localDataSource
          .saveUserAndToken(
            _Mappers.userResponseToUserAndTokenEntity(
              // UserResponse.fromJson(jsonDataProfile),
              userProfile,
              userAndToken.token,
              userAndToken.refreshToken,
              userAndToken.beranda,
            ),
          )
          .first;
    } on RemoteDataSourceException catch (e) {
      debugPrint('$tag remote error=$e');
    } on LocalDataSourceException catch (e) {
      debugPrint('$tag local error=$e');
      await _localDataSource.removeUserAndToken().first;
    }
  }

  @override
  UnitResultSingle getBeranda() {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Silakan login ulang',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .getBerandaProfile(userAndToken!.token, 'kosong')
          .toEitherSingle(_Mappers.errorToAppError)
          .flatMapEitherSingle((beranda) {
            return _remoteDataSource
                .getUserProfile(userAndToken.token)
                .map((user) => Tuple4(
                      user,
                      userAndToken.token,
                      userAndToken.refreshToken,
                      beranda.token.toString(),
                    ))
                .toEitherSingle(_Mappers.errorToAppError);
          })
          .flatMapEitherSingle(
            (tuple) => _localDataSource
                .saveUserAndToken(
                  _Mappers.userResponseToUserAndTokenEntity(
                    tuple.item1,
                    tuple.item2,
                    tuple.item3,
                    tuple.item4,
                  ),
                )
                .toEitherSingle(_Mappers.errorToAppError),
          )
          .asUnit();
    });
  }

  @override
  UnitResultSingle reqOtpRegisterLender({required String phone}) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        return _remoteDataSource
            .reqOtpRegisterLender(phone)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle reqOtpRegisterBorrower(
      {required String phone, String? kodeVerif}) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        return _remoteDataSource
            .reqOtpRegisterBorrower(phone, kodeVerif)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle sendOtpRegisterLender({required String otp}) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        return _remoteDataSource
            .sendOtpRegisterLender(otp)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle sendOtpRegisterBorrower(
      {required String name,
      required String phone,
      required String email,
      required String otp,
      String? kodeVerif}) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        return _remoteDataSource
            .sendOtpRegisterBorrower(name, phone, email, otp, kodeVerif)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle reqOtpChangeHp({
    required String new_hp,
    required String kode_verifikasi,
    required File fileImage,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }
        return _remoteDataSource
            .reqOtpChangeHp(new_hp, kode_verifikasi, fileImage, value.token)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle validasiOtpChangeHp({
    required String hp,
    required String otp,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }
        return _remoteDataSource
            .validasiOtpChangeHp(hp, otp, value.token)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle validasiOtpChangeEmail({
    required String otp,
    required String hp,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .validasiOtpChangeEmail(hp, otp, value.token)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle changeEmailRequest({
    required String new_email,
    required String kode_verifikasi,
    required String type,
    required File fileimage,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .changeEmailRequest(
                new_email, kode_verifikasi, type, fileimage, value.token)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle forgotPasswordFirst({
    required String email,
  }) {
    return _remoteDataSource
        .forgotPasswordFirst(email)
        .toEitherSingle(_Mappers.errorToAppError)
        .asUnit();
  }

  @override
  UnitResultSingle makeNewPassword({
    required String kodeVerifikasi,
    required String password,
  }) {
    return _remoteDataSource
        .makeNewPassword(kodeVerifikasi, password)
        .toEitherSingle(_Mappers.errorToAppError)
        .asUnit();
  }

  @override
  UnitResultSingle getBerandaAndUser() {
    return _remoteDataSource
        .getBerandaProfileWithoutToken('Step3')
        .toEitherSingle(_Mappers.errorToAppError)
        .flatMapEitherSingle((beranda) {
          return _remoteDataSource
              .getUserProfileWithoutToken()
              .toEitherSingle(_Mappers.errorToAppError)
              .flatMapEitherSingle((user) {
            return _remoteDataSource
                .getToken()
                .map((token) => Tuple4(
                      user,
                      token.token.toString(),
                      token.refreshToken!,
                      beranda.toString(),
                    ))
                .toEitherSingle(_Mappers.errorToAppError);
          });
        })
        .flatMapEitherSingle(
          (tuple) => _localDataSource
              .saveUserAndToken(
                _Mappers.userResponseToUserAndTokenEntity(
                  tuple.item1,
                  tuple.item2,
                  tuple.item3,
                  tuple.item4,
                ),
              )
              .toEitherSingle(_Mappers.errorToAppError),
        )
        .asUnit();
  }

  @override
  UnitResultSingle sendRegisterLender(
      {required String phone,
      required String name,
      String? referal,
      required String email,
      required String password}) {
    return _remoteDataSource
        .sendRegisterLender(phone, name, referal ?? "", email, password)
        .toEitherSingle(_Mappers.errorToAppError)
        .flatMapEitherSingle((result) {
          final token = result.token!;
          const String lastPage = "kosong";
          return _remoteDataSource
              .getBerandaProfile(token, lastPage)
              .toEitherSingle(_Mappers.errorToAppError)
              .flatMapEitherSingle((beranda) {
            final tokenBeranda = beranda.token!;
            final Map<String, dynamic> jsonDataProfile = {
              'username': 'Azzam sidqi',
              'email': 'azzam@gmail.com',
              'id_borrower': 1,
              'id_rekening': 1,
              'tlp_mobile': '085313212131',
              'ktp': 'dummy',
            };
            // return Single.value(
            //   Tuple4(
            //     UserResponse.fromJson(jsonDataProfile),
            //     token,
            //     result.refreshToken.toString(),
            //     tokenBeranda,
            //   ).right(),
            // );
            return _remoteDataSource
                .getUserProfile(token)
                .map((user) => Tuple4(
                      user,
                      token,
                      result.refreshToken!,
                      tokenBeranda,
                    ))
                .toEitherSingle(_Mappers.errorToAppError);
          });
        })
        .flatMapEitherSingle(
          (tuple) => _localDataSource
              .saveUserAndToken(
                _Mappers.userResponseToUserAndTokenEntity(
                  tuple.item1,
                  tuple.item2,
                  tuple.item3,
                  tuple.item4,
                ),
              )
              .toEitherSingle(_Mappers.errorToAppError),
        )
        .asUnit();
  }

  @override
  UnitResultSingle sendPinRegisterLender({required String pin}) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _userAndToken.flatMapEitherSingle(
          (value) {
            return _remoteDataSource
                .sendPinRegisterLender(pin, value!.token)
                .toEitherSingle(_Mappers.errorToAppError)
                .asUnit();
          },
        );
      },
    );
  }

  @override
  UnitResultSingle sendEmailRegisterLender() {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          // return Single.value(
          //   AppError(
          //     message: 'Silakan login ulang',
          //     error: 'Email or token is null',
          //     stackTrace: StackTrace.current,
          //   ).left(),
          // );
        }

        return _userAndToken.flatMapEitherSingle(
          (value) {
            return _remoteDataSource
                .sendEmailRegisterLender(value!.token)
                .toEitherSingle(_Mappers.errorToAppError)
                .asUnit();
          },
        );
      },
    );
  }

  @override
  UnitResultSingle ubahPinLender({
    required String currentPin,
    required String newPin,
    required String confirmPin,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .ubahPinLender(value.token, currentPin, newPin, confirmPin)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle checkPinLender({
    required String pin,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .checkPinLender(value.token, pin)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle sendOtpForgotPinLender() {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .sendOtpForgotPinLender(value.token)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle resendOtpForgotPinLender() {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .resendOtpForgotPinLender(value.token)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle validasiOtpForgotPin({
    required String kode,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .validasiOtpForgotPin(value.token, kode)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle resetForgotPin({
    required String pin,
    required String key,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .resetForgotPin(value.token, pin, key)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle verificationLender({
    required Map<String, dynamic> payload,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .verificationLender(value.token, payload)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle regisRdlLender({
    required Map<String, dynamic> payload,
  }) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Silakan login ulang',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }

        return _remoteDataSource
            .regisRdlLender(value.token, payload)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  Future<Either<String, GeneralResponse>> getHubunganKeluarga() async {
    if (await _userAndToken.isEmpty) {
      return const Left('Token tidak ada bang');
    }
    final user = await _userAndToken.first;
    return _remoteDataSource.getHubunganKeluarga(user.orNull()!.token);
  }

  @override
  Future<Either<String, GeneralResponse>> postHubunganKeluarga(
      {required DataKeluargaPayload payload}) async {
    if (await _userAndToken.isEmpty) {
      return const Left('Token tidak ada bang');
    }
    final user = await _userAndToken.first;
    return _remoteDataSource.postHubunganKeluarga(
      user.orNull()!.token,
      payload,
    );
  }

  @override
  Future<Either<String, GeneralResponse>> getProduk({
    required GetProdukParams params,
  }) async {
    return _remoteDataSource.getProduk(params);
  }

  @override
  Future<Either<String, GeneralResponse>> getInfoBank({
    required int idBank,
    required String noRek,
  }) async {
    if (await _userAndToken.isEmpty) {
      return const Left('Token tidak ada bang');
    }
    final user = await _userAndToken.first;
    return _remoteDataSource.getInfoBank(
      idBank: idBank,
      noRek: noRek,
      token: user.orNull()!.token,
    );
  }

  @override
  Future<Either<String, GeneralResponse>> getDataUser({
    required String urlParam,
  }) async {
    if (await _userAndToken.isEmpty) {
      return const Left('Token tidak ada bang');
    }
    final user = await _userAndToken.first;
    return _remoteDataSource.getDataUser(
      user.orNull()!.token,
      urlParam,
    );
  }

  @override
  Future<Either<String, GeneralResponse>> postDataPendukung({
    required Map<String, dynamic> data,
  }) async {
    if (await _userAndToken.isEmpty) {
      return const Left('Token tidak ada bang');
    }
    final user = await _userAndToken.first;
    return _remoteDataSource.postDataPendukung(
      data: data,
      token: user.orNull()!.token,
    );
  }

  @override
  Future<Either<String, GeneralResponse>> getRequest({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  }) async {
    final user = await _userAndToken.first;
    return _remoteDataSource.getRequest(
      url: url,
      queryParam: queryParam,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      service: service,
      token: user.orNull()!.token.toString(),
    );
  }

  @override
  Future<Either<String, GeneralResponse>> postRequest({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  }) async {
    final user = await _userAndToken.first;
    return _remoteDataSource.postRequest(
      url: url,
      body: body,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      service: service,
      token: user.orNull()!.token.toString(),
    );
  }

  @override
  Future<Either<String, GeneralResponse>> postRequestV2({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
  }) async {
    final user = await _userAndToken.first;
    return _remoteDataSource.postRequestV2(
      url: url,
      body: body,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      token: user.orNull()!.token.toString(),
    );
  }
  @override
  Future<Either<String, GeneralResponse>> getRequestV2({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
  }) async {
    final user = await _userAndToken.first;
    return _remoteDataSource.getRequestV2(
      url: url,
      queryParam: queryParam,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      token: user.orNull()!.token.toString(),
    );
  }

  @override
  Future<Either<String, GeneralResponse>> postFormData({
    required String url,
    required Map<String, String> body,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  }) async {
    final user = await _userAndToken.first;
    return _remoteDataSource.postFormData(
      url: url,
      body: body,
      moreHeader: moreHeader,
      queryParam: queryParam,
      isUseToken: isUseToken,
      service: service,
      token: user.orNull()!.token.toString(),
    );
  }

  @override
  Future<Either<String, dynamic>> getDokumen({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  }) async {
    final user = await _userAndToken.first;
    return _remoteDataSource.getDokumen(
      url: url,
      moreHeader: moreHeader,
      queryParam: queryParam,
      isUseToken: isUseToken,
      service: service,
      token: user.orNull()!.token.toString(),
    );
  }

  @override
  Future<Either<String, dynamic>> postDokumen({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  }) async {
    final user = await _userAndToken.first;
    return _remoteDataSource.postRequestDokumen(
      url: url,
      body: body,
      moreHeader: moreHeader,
      isUseToken: isUseToken,
      service: service,
      token: user.orNull()!.token.toString(),
    );
  }
}
