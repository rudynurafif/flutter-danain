import 'dart:io';

import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/usecases/info_product_use_case.dart';
import 'package:flutter_danain/domain/usecases/post_hubungan_keluarga.dart';

import '../models/pendanaan.dart';

abstract class UserRepository {
  Stream<Result<AuthenticationState>> get authenticationState$;

  Single<Result<AuthenticationState>> get authenticationState;

  UnitResultSingle login({
    required String email,
    required String password,
  });
  UnitResultSingle refreshToken();

  UnitResultSingle registerUser({
    required String name,
    required String email,
    required String password,
  });

  UnitResultSingle logout();

  UnitResultSingle changePassword({
    required String password,
    required String newPassword,
  });

  UnitResultSingle resetPassword({
    required String email,
  });

  UnitResultSingle reqOtpChangeHp({
    required String new_hp,
    required String kode_verifikasi,
    required File fileImage,
  });

  UnitResultSingle reqOtpRegisterLender({
    required String phone,
  });

  UnitResultSingle sendOtpRegisterLender({
    required String otp,
  });

  UnitResultSingle sendRegisterLender({
    required String phone,
    required String name,
    String? referal,
    required String email,
    required String password,
  });

  UnitResultSingle validasiOtpChangeHp({
    required String hp,
    required String otp,
  });

  UnitResultSingle validasiOtpChangeEmail({
    required String otp,
    required String hp,
  });

  UnitResultSingle changeEmailRequest({
    required String new_email,
    required String kode_verifikasi,
    required String type,
    required File fileimage,
  });

  UnitResultSingle forgotPasswordFirst({
    required String email,
  });

  UnitResultSingle makeNewPassword({
    required String kodeVerifikasi,
    required String password,
  });

  UnitResultSingle sendResetPasswordEmail(String email);
  UnitResultSingle getBeranda();
  UnitResultSingle getBerandaAndUser();

  UnitResultSingle sendPinRegisterLender({required String pin});

  UnitResultSingle sendEmailRegisterLender();

  UnitResultSingle ubahPinLender({
    required String currentPin,
    required String newPin,
    required String confirmPin,
  });

  UnitResultSingle checkPinLender({
    required String pin,
  });

  UnitResultSingle sendOtpForgotPinLender();
  UnitResultSingle resendOtpForgotPinLender();
  UnitResultSingle validasiOtpForgotPin({
    required String kode,
  });
  UnitResultSingle resetForgotPin({
    required String pin,
    required String key,
  });

  UnitResultSingle verificationLender({
    required Map<String, dynamic> payload,
  });

  UnitResultSingle reqOtpRegisterBorrower(
      {required String phone, String? kodeVerif});

  UnitResultSingle sendOtpRegisterBorrower({
    required String name,
    required String phone,
    required String email,
    required String otp,
    String? kodeVerif,
  });

  UnitResultSingle regisRdlLender({
    required Map<String, dynamic> payload,
  });


  UnitResultSingle registerBorrower({
    required Map<String, dynamic> payload,
  });

  Future<Either<String, GeneralResponse>> getHubunganKeluarga();

  Future<Either<String, GeneralResponse>> postHubunganKeluarga({
    required DataKeluargaPayload payload,
  });

  Future<Either<String, GeneralResponse>> getProduk({
    required GetProdukParams params,
  });
  Future<Either<String, GeneralResponse>> getInfoBank({
    required int idBank,
    required String noRek,
  });
  Future<Either<String, GeneralResponse>> postDataPendukung({
    required Map<String, dynamic> data,
  });

  //get data user
  Future<Either<String, GeneralResponse>> getDataUser({
    required String urlParam,
  });

  //for all integration
  Future<Either<String, GeneralResponse>> getRequest({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  });
  Future<Either<String, GeneralResponse>> postRequest({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  });
  Future<Either<String, GeneralResponse>> postRequestV2({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
  });
  Future<Either<String, GeneralResponse>> getRequestV2({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
  });
  Future<Either<String, GeneralResponse>> postFormData({
    required String url,
    required Map<String, String> body,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  });
  Future<Either<String, dynamic>> getDokumen({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  });
  Future<Either<String, dynamic>> postDokumen({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
  });
}
