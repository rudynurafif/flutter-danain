import 'package:flutter_danain/data/exception/local_data_source_exception.dart';
import 'package:flutter_danain/data/exception/remote_data_source_exception.dart';
import 'package:flutter_danain/data/local/entities/user_and_token_entity.dart';
import 'package:flutter_danain/data/local/entities/user_entity.dart';
import 'package:flutter_danain/data/local/local_data_source.dart';
import 'package:flutter_danain/data/remote/remote_data_source.dart';
import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/data/remote/response/user_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';

import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';
import 'package:flutter_danain/domain/usecases/simulasi_cnd_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';

part 'remote/mappers/transaksi_mappers.dart';

class TransaksiRepositoryImpl implements TransaksiRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  TransaksiRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  ) {}

  Single<Result<UserAndTokenEntity?>> get _userAndToken =>
      _localDataSource.userAndToken.toEitherSingle(_Mappers.errorToAppError);
  @override
  UnitResultSingle tarikDana({
    required int nominal,
    required String pin,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Require login!',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .tarikDana(userAndToken.token, nominal, pin)
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle postValidasiOtpPinjaman({
    required int idproduk,
    required int idjaminan,
    required String otp,
    required int idRekening,
    required String tujuanPinjaman,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Require login!',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .postValidasiOtpPinjaman(
            userAndToken.token,
            idproduk,
            idjaminan,
            otp,
            idRekening,
            tujuanPinjaman,
          )
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle postKonfirmasiSurveyCND({
    required int idTaskPengajuan,
    required int idPengajuan,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Require login!',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .postKonfirmasiSurveyCND(
            userAndToken.token,
            idTaskPengajuan,
            idPengajuan,
          )
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle cicilEmasReq(
      {required int idProduk,
      required List<dynamic> dataProduk,
      String? kodeCheckout}) {
    return _userAndToken.flatMapEitherSingle(
      (value) {
        if (value == null) {
          return Single.value(
            AppError(
              message: 'Require login!',
              error: 'Email or token is null',
              stackTrace: StackTrace.current,
            ).left(),
          );
        }
        return _remoteDataSource
            .cicilEmasReq(value.token, idProduk, dataProduk, kodeCheckout)
            .toEitherSingle(_Mappers.errorToAppError)
            .asUnit();
      },
    );
  }

  @override
  UnitResultSingle cicilEmasVal({
    required Map<String, dynamic> data,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Require login!',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .cicilEmasVal(userAndToken.token, data)
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle getPayment({
    required int idAgreement,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Require login!',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .getPayment(userAndToken.token, idAgreement)
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle actionCicilan({
    required String va,
    required num total,
    required int status,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Require login!',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .actionCicilan(userAndToken.token, va, total, status)
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle requestOtpPendanaan({
    required String nosbg,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Require login!',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .requestOtpPendanaan(
            userAndToken.token,
            nosbg,
          )
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle validateOtpPendanaan({
    required String noSbg,
    required String otp,
  }) {
    return _userAndToken.flatMapEitherSingle((userAndToken) {
      if (userAndToken == null) {
        return Single.value(
          AppError(
            message: 'Require login!',
            error: 'Email or token is null',
            stackTrace: StackTrace.current,
          ).left(),
        );
      }

      return _remoteDataSource
          .validateOtpPendanaan(
            userAndToken.token,
            noSbg,
            otp,
          )
          .toEitherSingle(_Mappers.errorToAppError)
          .asUnit();
    });
  }

  @override
  UnitResultSingle simulasiMaxi({
    required int nilaiPinjaman,
    required int jumlahHari,
  }) {
    return _remoteDataSource
        .simulasiMaxi(nilaiPinjaman, jumlahHari)
        .toEitherSingle(_Mappers.errorToAppError)
        .asUnit();
  }

  @override
  UnitResultSingle calculateCicilan({
    required Map<String, dynamic> payload,
  }) {
    return _remoteDataSource
        .calculateCicilan(payload)
        .toEitherSingle(_Mappers.errorToAppError)
        .asUnit();
  }

  // ini v3 integrasi
  @override
  Future<Either<String, GeneralResponse>> simulasiCnD(SimulasiParams payload) {
    return _remoteDataSource.simulasiCnD(payload);
  }

  @override
  Future<Either<String, GeneralResponse>> getMaster(
    String endpoint,
    Map<String, dynamic> params,
  ) {
    return _remoteDataSource.getMasterData(endpoint, params);
  }

  @override
  Future<Either<String, GeneralResponse>> getMasterV1(
    String endpoint,
    Map<String, dynamic> params,
  ) {
    return _remoteDataSource.getMasterV1(endpoint, params);
  }

  @override
  Future<Either<String, GeneralResponse>> getRiwayatTransaksiv3(
    String endpoint,
    Map<String, dynamic> params,
    String token,
  ) {
    return _remoteDataSource.getRiwayatTransaksiv3(endpoint, params, token);
  }

  @override
  Future<Either<String, GeneralResponse>> uploadFileManager(
    Map<String, dynamic> params,
    String file,
  ) {
    return _remoteDataSource.uploadFileManager(params, file);
  }

  @override
  Future<Either<String, GeneralResponse>> postPengajuanCnd(
    Map<String, dynamic> payload,
  ) async {
    if (await _userAndToken.isEmpty) {
      return const Left('Token tidak ada bang');
    }
    final user = await _userAndToken.first;
    return _remoteDataSource.postPengajuanCnd(user.orNull()!.token, payload);
  }

  @override
  Future<Either<String, GeneralResponse>> postKonfirmasiPinjaman(
    Map<String, dynamic> payload,
  ) async {
    if (await _userAndToken.isEmpty) {
      return const Left('Token tidak ada bang');
    }
    final user = await _userAndToken.first;
    return _remoteDataSource.postKonfirmasiPinjaman(
        user.orNull()!.token, payload);
  }

  @override
  Future<Either<String, GeneralResponse>>
      postKonfirmasiPenyerahanKonfirmasPinjamanCND(
    Map<String, dynamic> payload,
  ) async {
    if (await _userAndToken.isEmpty) {
      return const Left('Token tidak ada bang');
    }
    final user = await _userAndToken.first;
    return _remoteDataSource.postKonfirmasiPenyerahanKonfirmasPinjamanCND(
        user.orNull()!.token, payload);
  }
}
