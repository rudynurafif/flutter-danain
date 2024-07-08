import 'dart:io';

import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/data/remote/response/token_response.dart';
import 'package:flutter_danain/data/remote/response/user_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/info_product_use_case.dart';
import 'package:flutter_danain/domain/usecases/post_hubungan_keluarga.dart';
import 'package:flutter_danain/domain/usecases/simulasi_cnd_use_case.dart';

abstract class RemoteDataSource {
  Single<TokenResponse> loginUser(String email, String password);

  Single<TokenResponse> refreshToken(String refreshToken);

  Single<TokenResponse> registerUser(
    String name,
    String email,
    String password,
  );

  Single<TokenResponse> changePassword(
    String email,
    String password,
    String newPassword,
    String token,
  );

  Single<TokenResponse> resetPassword(String email);

  Single<UserResponse> getUserProfile(String token);
  Single<TokenResponse> getBerandaProfile(String token, String lastPage);
  Single<UserResponse> getUserProfileWithoutToken();
  Single<TokenResponse> getToken();
  Single<GeneralResponse> getBerandaProfileWithoutToken(String lastPage);
  Single<TokenResponse> reqOtpChangeHp(
      String new_hp, String kode_verifikasi, File fileImage, String token);
  Single<TokenResponse> validasiOtpChangeHp(
      String hp, String otp, String token);
  Single<TokenResponse> validasiOtpChangeEmail(
    String hp,
    String otp,
    String token,
  );

  Single<TokenResponse> forgotPasswordFirst(String email);
  Single<TokenResponse> makeNewPassword(String kodeVerifikasi, String password);

  Single<TokenResponse> changeEmailRequest(
    String new_email,
    String kode_verifikasi,
    String type,
    File fileimage,
    String token,
  );

  Single<TokenResponse> postValidasiOtpPinjaman(
    String token,
    int idproduk,
    int idjaminan,
    String otp,
    int idRekening,
    String tujuanPinjaman,
  );

  Single<TokenResponse> postKonfirmasiSurveyCND(
    String token,
    int idTaskPengajuan,
    int idPengajuan,
  );

  // Single<FdcResponse> getCheckFdc(String token);

  Single<TokenResponse> simulasiPinjaman(
    int gram,
    int karat,
    int jangkaWaktu,
    int nilaiPinjaman,
  );

  Single<TokenResponse> cicilEmasReq(
    String token,
    int idProduk,
    List<dynamic> dataProduk,
    String? kodeCheckout,
  );

  Single<TokenResponse> cicilEmasVal(
    String token,
    Map<String, dynamic> data,
  );

  Single<TokenResponse> actionCicilan(
    String token,
    String va,
    num total,
    int status,
  );

  Single<TokenResponse> getPayment(
    String token,
    int idAgreement,
  );

  //lender
  Single<TokenResponse> tarikDana(
    String token,
    int nominal,
    String pin,
  );

  Single<TokenResponse> requestOtpPendanaan(
    String token,
    String noSbg,
  );
  Single<TokenResponse> validateOtpPendanaan(
    String token,
    String noSbg,
    String otp,
  );
  Single<TokenResponse> reqOtpRegisterLender(
    String phone,
  );

  Single<TokenResponse> sendOtpRegisterLender(
    String otp,
  );

  Single<TokenResponse> reqOtpRegisterBorrower(
    String phone,
    String? kodeVerif,
  );

  Single<TokenResponse> sendRegisterLender(
      String phone, String name, String referal, String email, String password);

  Single<TokenResponse> sendPinRegisterLender(
    String pin,
    String token,
  );

  Single<TokenResponse> sendEmailRegisterLender(String token);

  Single<TokenResponse> ubahPinLender(
    String token,
    String currentPin,
    String newPin,
    String confirmPin,
  );

  Single<TokenResponse> checkPinLender(
    String token,
    String pin,
  );

  Single<TokenResponse> sendOtpForgotPinLender(String token);
  Single<TokenResponse> resendOtpForgotPinLender(String token);
  Single<TokenResponse> validasiOtpForgotPin(String token, String kode);
  Single<TokenResponse> resetForgotPin(
    String token,
    String pin,
    String key,
  );

  Single<TokenResponse> verificationLender(
    String token,
    Map<String, dynamic> payload,
  );

  Single<TokenResponse> regisRdlLender(
    String token,
    Map<String, dynamic> payload,
  );

  Single<TokenResponse> sendOtpRegisterBorrower(
    String name,
    String phone,
    String email,
    String otp,
    String? kodeVerif,
  );

  Single<TokenResponse> simulasiMaxi(
    int nilaiPinjaman,
    int jumlahHari,
  );
  Single<TokenResponse> calculateCicilan(
    Map<String, dynamic> payload,
  );

  //v3 integrasi
  Future<Either<String, GeneralResponse>> simulasiCnD(
    SimulasiParams params,
  );
  Future<Either<String, GeneralResponse>> getMasterData(
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
    String token,
    Map<String, dynamic> payload,
  );
  Future<Either<String, GeneralResponse>> postKonfirmasiPinjaman(
    String token,
    Map<String, dynamic> payload,
  );
  Future<Either<String, GeneralResponse>>
      postKonfirmasiPenyerahanKonfirmasPinjamanCND(
    String token,
    Map<String, dynamic> payload,
  );
  Future<Either<String, GeneralResponse>> getHubunganKeluarga(
    String token,
  );
  Future<Either<String, GeneralResponse>> postHubunganKeluarga(
    String token,
    DataKeluargaPayload payload,
  );

  Future<Either<String, GeneralResponse>> getProduk(GetProdukParams params);
  Future<Either<String, GeneralResponse>> getInfoBank({
    required int idBank,
    required String noRek,
    required String token,
  });
  Future<Either<String, GeneralResponse>> postDataPendukung({
    required Map<String, dynamic> data,
    required String token,
  });
  Future<Either<String, GeneralResponse>> getDataUser(
    String token,
    String urlParams,
  );

  //for all integration
  Future<Either<String, GeneralResponse>> getRequest({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String token,
  });
  Future<Either<String, GeneralResponse>> postRequest({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String token,
  });
  Future<Either<String, GeneralResponse>> postRequestV2({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required String token,
  });
  Future<Either<String, GeneralResponse>> getRequestV2({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required String token,
  });
  Future<Either<String, GeneralResponse>> postFormData({
    required String url,
    required Map<String, String> body,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String token,
  });

  Future<Either<String, dynamic>> getDokumen({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String token,
  });
  Future<Either<String, dynamic>> postRequestDokumen({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String token,
  });
}
