import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/simulasi_cnd_use_case.dart';

abstract class TransaksiRepository {
  //borrower
  UnitResultSingle postValidasiOtpPinjaman({
    required int idproduk,
    required int idjaminan,
    required String otp,
    required int idRekening,
    required String tujuanPinjaman,
  });

  UnitResultSingle postKonfirmasiSurveyCND({
    required int idTaskPengajuan,
    required int idPengajuan,
  });

  UnitResultSingle cicilEmasReq(
      {required int idProduk,
      required List<dynamic> dataProduk,
      String? kodeCheckout});

  UnitResultSingle cicilEmasVal({
    required Map<String, dynamic> data,
  });

  UnitResultSingle actionCicilan({
    required String va,
    required num total,
    required int status,
  });

  UnitResultSingle getPayment({
    required int idAgreement,
  });

  //lender
  UnitResultSingle tarikDana({
    required int nominal,
    required String pin,
  });

  UnitResultSingle requestOtpPendanaan({
    required String nosbg,
  });

  UnitResultSingle validateOtpPendanaan({
    required String noSbg,
    required String otp,
  });

  UnitResultSingle simulasiMaxi({
    required int nilaiPinjaman,
    required int jumlahHari,
  });
  UnitResultSingle calculateCicilan({
    required Map<String, dynamic> payload,
  });

  //v3 integrasi
  Future<Either<String, GeneralResponse>> simulasiCnD(
    SimulasiParams payload,
  );

  Future<Either<String, GeneralResponse>> getMaster(
    String endpoint,
    Map<String, dynamic> params,
  );
  Future<Either<String, GeneralResponse>> getMasterV1(
    String endpoint,
    Map<String, dynamic> params,
  );
  Future<Either<String, GeneralResponse>> getRiwayatTransaksiv3(
    String endpoint,
    Map<String, dynamic> params,
    String token,
  );
  Future<Either<String, GeneralResponse>> uploadFileManager(
    Map<String, dynamic> params,
    String file,
  );
  Future<Either<String, GeneralResponse>> postPengajuanCnd(
    Map<String, dynamic> payload,
  );
  Future<Either<String, GeneralResponse>> postKonfirmasiPinjaman(
    Map<String, dynamic> payload,
  );
  Future<Either<String, GeneralResponse>>
      postKonfirmasiPenyerahanKonfirmasPinjamanCND(
    Map<String, dynamic> payload,
  );
}
