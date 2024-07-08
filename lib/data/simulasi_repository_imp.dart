import 'package:flutter_danain/data/exception/local_data_source_exception.dart';
import 'package:flutter_danain/data/exception/remote_data_source_exception.dart';
import 'package:flutter_danain/data/local/entities/user_and_token_entity.dart';
import 'package:flutter_danain/data/local/entities/user_entity.dart';
import 'package:flutter_danain/data/local/local_data_source.dart';
import 'package:flutter_danain/data/remote/remote_data_source.dart';
import 'package:flutter_danain/domain/models/app_error.dart';

import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';

import '../domain/repositories/simulasi_repository.dart';
import 'remote/response/user_response.dart';

part 'remote/mappers/simulasi_mappers.dart';

class SimulasiRepositoryImpl implements SimulasiRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  SimulasiRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  ) {}

  @override
  UnitResultSingle simulasiPinjaman(
      {required int gram,
      required int karat,
      int? jangkaWaktu,
      int? nilaiPinjaman}) {
    print(
        "============================= masuk repository imp simulasi ============================");
    return _remoteDataSource
        .simulasiPinjaman(
          gram,
          karat,
          jangkaWaktu!,
          nilaiPinjaman!,
        )
        .toEitherSingle(_Mappers.errorToAppError)
        .asUnit();
  }
}
