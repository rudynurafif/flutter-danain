import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/post_konfirmasi_penyerahan_pinjaman.dart';
import 'package:flutter_danain/domain/usecases/post_konfirmasi_validasi_otp_use_case.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class KonfirmasiPinjamanBloc2 extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepControl;
  final Function1<int, void> idPengajuanControl;
  final Function1<int, void> idTakControl;
  final Function1<int, void> isPenyerahanBpkb;
  final Function1<int, void> getPinjamanControl;
  final Function0<void> getDocumentPerjanjian;
  final Function1<bool, void> checkPinjamanControl;
  final Function1<String, void> otpControl;
  final Function1<String, void> otpControlError;
  final Function0<void> konfirmasiPinjaman;
  final Function1<Map<String, dynamic>?, void> responseChange;
  final Stream<dynamic> documentPerjanjian;

  final Stream<int> stepStream;
  final Stream<String> noHpStream;
  final Stream<bool> checkPinjaman;
  final Stream<Map<String, dynamic>> dataPinjamanStream;
  final Stream<KonfirmasiPinjamanMessage?> messageReqOtp;
  final Stream<String?> otpError;
  final BehaviorSubject<Map<String, dynamic>?> response;
  final BehaviorSubject<Map<String, dynamic>?> responseKonfirmasi;
  final Stream<String?> konfirmasiError;

  final Stream<int> isPenyerahanBpkbStream;
  final Function0<void> postValidasiOtp;
  final Function0<void> postKonfirmasiPenyerahanKonfirmasPinjamanCND;

  KonfirmasiPinjamanBloc2._({
    required this.response,
    required this.responseKonfirmasi,
    required this.stepControl,
    required this.idPengajuanControl,
    required this.idTakControl,
    required this.stepStream,
    required this.getPinjamanControl,
    required this.getDocumentPerjanjian,
    required this.dataPinjamanStream,
    required this.checkPinjaman,
    required this.checkPinjamanControl,
    required this.isPenyerahanBpkb,
    required this.noHpStream,
    required this.otpControl,
    required this.otpControlError,
    required this.messageReqOtp,
    required this.konfirmasiPinjaman,
    required this.otpError,
    required this.documentPerjanjian,
    required this.postValidasiOtp,
    required this.postKonfirmasiPenyerahanKonfirmasPinjamanCND,
    required this.isPenyerahanBpkbStream,
    required this.responseChange,
    required Function0<void> dispose,
    required this.konfirmasiError,
  }) : super(dispose);

  factory KonfirmasiPinjamanBloc2(
      final GetAuthStateStreamUseCase getAuthState,
      final PostKonfirmasiValidasiOtpUseCase postOtp,
      final GetRequestUseCase getRequest,
      final PostKonfirmasiPenyerahanPinjamanUseCase
          postKonfirmasiPenyerahanPinjaman,
      final PostRequestDocumentUseCase postReqDocument) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final idPengajuanControl = BehaviorSubject<int>.seeded(0);
    final idTakControl = BehaviorSubject<int>.seeded(0);
    final isPenyerahanBpkbControl = BehaviorSubject<int>.seeded(0);
    final dataPinjamanController = BehaviorSubject<Map<String, dynamic>>();
    final checkPinjaman = BehaviorSubject<bool>.seeded(false);
    final otpController = BehaviorSubject<String>();
    final otpError = BehaviorSubject<String?>();
    final KonfirmasiErrorController = BehaviorSubject<String?>();
    final noHpController = BehaviorSubject<String>();
    final messageReqOtp = BehaviorSubject<KonfirmasiPinjamanMessage?>();
    final responseController = BehaviorSubject<Map<String, dynamic>?>();
    final responseKonfirmasiController =
        BehaviorSubject<Map<String, dynamic>?>();
    final documentPerjanjianController = BehaviorSubject<dynamic>();
    final authState = getAuthState();
    final isLoading = BehaviorSubject<bool>.seeded(true);
    final errorMessage = BehaviorSubject<String?>();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    void getDocumentPerjanjian() async {
      print("object MASUK");
      try {
        final response = await postReqDocument.call(
          url: 'api/beedanaingenerate/v1/dokumen/PP',
          body: {
            'idPengajuan': idPengajuanControl.value,
            'cetak': 'PP',
            'bucket': 'bpkb-borrower',
            'view': 'view',
            'borrower_lender': 'borrower'
          },
          service: serviceBackend.dokumen,
        );
        response.fold(
          ifLeft: (error) {
            print('error ngab $error');
          },
          ifRight: (dynamic response) {
            print('berhasil ngab $response');
            documentPerjanjianController.add(response);
          },
        );
      } catch (e) {
        print('GAGAL ngab ${e}');
      }
    }

    Future<void> getPinjaman(int idPengajuan) async {
      final event = await authState.first;
      final noTelp = event.orNull()!.userAndToken!.user.tlpmobile.toString();
      noHpController.add(noTelp);
      try {
        final response = await getRequest.call(
          url: 'api/beeborrowertransaksi/v1/cnd/konfirmasi/cnd',
          queryParam: {
            'idPengajuan': idPengajuan,
          },
        );
        response.fold(
          ifLeft: (error) {
            print('error bang $error');
          },
          ifRight: (value) {
            dataPinjamanController.add(value.data);
          },
        );
      } catch (e) {
        dataPinjamanController.addError(
          'Maaf Sepertinya terjadi Kesalahan ${e.toString()}',
        );
      }
    }

    void konfirmasiPinjaman() async {
      // ...

      final event = await authState.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      final pinjaman = dataPinjamanController.valueOrNull ?? {};

      // Making a network request using apiService
      print("detail konfirmasi pinjaman $pinjaman");
      final response = await apiService.reqOtpKonfirmasiPinjaman(
        token,
        pinjaman['idPengajuan'],
      );

      // Parsing the response body
      final body = jsonDecode(response.body);
      print("check response body ${response.statusCode}");
      // Handling the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Adding a success message to messageReqOtp
        messageReqOtp.add(const KonfirmasiPinjamanSuccessMessage());
      } else {
        // Adding an error message to messageReqOtp
        messageReqOtp
            .add(KonfirmasiPinjamanErrorMessage(body['message'], body));
      }
    }

    final auth = getAuthState();

    Future<void> postValidasiOtp() async {
      isLoading.add(true);
      final event = await auth.first;
      final user = event.orNull()!.userAndToken!.user;
      final payload = {
        'idproduk': Constants.get.idProdukCashDrive,
        'idjaminan': dataPinjamanController.value['idPengajuan'],
        'otp': otpController.value,
        'idrekening': dataPinjamanController.value['dataRekening']['idBank'],
        'tujuan_pinjaman': 'Konsumtif',
        'idTaskPengajuan': dataPinjamanController.value['idTaskPengajuan']
      };
      final response = await postOtp.call(payload: payload);
      response.fold(
        ifLeft: (value) {
          errorMessage.add(value);
          otpError.add(value);
          stepController.add(2);
        },
        ifRight: (value) {
          responseController.add(value.data);
          stepController.add(4);
        },
      );
      isLoading.add(false);
    }

    Future<void> postKonfirmasiPenyerahanKonfirmasPinjamanCND() async {
      isLoading.add(true);
      final event = await auth.first;
      final user = event.orNull()!.userAndToken!.user;
      final payload = {
        'idPengajuan': dataPinjamanController.value['idPengajuan'],
        'idTaskPengajuan': dataPinjamanController.value['idTaskPengajuan'],
        'isPenyerahanBpkb': isPenyerahanBpkbControl.value,
      };
      final response =
          await postKonfirmasiPenyerahanPinjaman.call(payload: payload);
      response.fold(
        ifLeft: (value) {
          errorMessage.add(value);
          stepController.add(4);
        },
        ifRight: (value) {
          if (isPenyerahanBpkbControl.value == 2) {
            responseKonfirmasiController.add(value.data);
            stepController.add(5);
          } else {
            responseKonfirmasiController.add(value.data);
            KonfirmasiErrorController.add("Berhasil");
            stepController.add(4);
          }
        },
      );
      isLoading.add(false);
    }

    return KonfirmasiPinjamanBloc2._(
        stepControl: (int val) => stepController.add(val),
        checkPinjamanControl: (bool val) => checkPinjaman.add(val),
        checkPinjaman: checkPinjaman.stream,
        stepStream: stepController.stream,
        response: responseController,
        responseKonfirmasi: responseKonfirmasiController,
        otpControl: (String val) => otpController.add(val),
        otpError: otpError.stream,
        otpControlError: (String val) => otpError.add(val),
        getPinjamanControl: getPinjaman,
        getDocumentPerjanjian: getDocumentPerjanjian,
        dataPinjamanStream: dataPinjamanController.stream,
        noHpStream: noHpController.stream,
        konfirmasiPinjaman: konfirmasiPinjaman,
        messageReqOtp: messageReqOtp.stream,
        documentPerjanjian: documentPerjanjianController,
        dispose: () {
          stepController.close();
        },
        idPengajuanControl: (int val) => idPengajuanControl.add(val),
        idTakControl: (int val) => idTakControl.add(val),
        isPenyerahanBpkbStream: isPenyerahanBpkbControl.stream,
        isPenyerahanBpkb: (int val) => isPenyerahanBpkbControl.add(val),
        postValidasiOtp: postValidasiOtp,
        postKonfirmasiPenyerahanKonfirmasPinjamanCND:
            postKonfirmasiPenyerahanKonfirmasPinjamanCND,
        konfirmasiError: KonfirmasiErrorController.stream,
        responseChange: (Map<String, dynamic>? response) =>
            responseController.add(response));
  }

  static KonfirmasiPinjamanMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const KonfirmasiPinjamanSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : KonfirmasiPinjamanErrorMessage(appError.message!, appError.error!),
    );
  }
}
