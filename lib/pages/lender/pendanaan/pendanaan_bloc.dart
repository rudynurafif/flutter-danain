import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/requestOtpPendanaan.dart';
import 'package:flutter_danain/domain/usecases/validate_otp_pendanaan_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'pendanaan.dart';

class PendanaanBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepControl;
  final Function0<void> getProduct;
  final Function0<void> getDataPendanaan;
  final Function1<String, void> getDataPendanaanDetail;
  final Function1<String, void> otpControl;
  final Function1<Map<String, dynamic>?, void> detailPendanaanControl;
  final Function1<bool, void> detailControl;
  final Function1<String?, void> errorOtpChange;
  final Function1<bool, void> isLoadingChange;
  final Function0<void> getDataBeranda;

  final Stream<int> stepStream;
  final Stream<List<dynamic>> jenisProductStream;
  final Stream<Map<String, dynamic>> dataPendanaan;
  final Stream<Map<String, dynamic>> dataBeranda;
  final Stream<Map<String, dynamic>?> detailDataPendanaan;
  final Stream<dynamic> documentStream;
  final Stream<String> noTelpUser;
  final Stream<bool> isDetailStream;
  final Stream<String?> errorOtp;
  final Stream<bool> isLoadingButton;

  // saldo
  final Stream<Map<String, dynamic>?> summaryData;

  //message
  final Function1<int, void> checkSaldoFunction;
  final Function0<void> reqOtpSubmit;
  final Function0<void> validateOtpSubmit;
  final Stream<PendanaanMessage?> messageCheckSaldo;
  final Stream<PendanaanMessage?> messageReqOtp;
  final Stream<PendanaanMessage?> messageValidateOtp;

  //filter function
  final Function1<String, void> sortControl;
  final Function1<List<int>, void> jenisFilterControl;
  final Function1<String?, void> terendahControl;
  final Function1<String?, void> tertinggiControl;

  //filter stream
  final Stream<String> sortStream;
  final Stream<List<int>> jenisProdukSortStream;
  final BehaviorSubject<int?> terendahStream;
  final BehaviorSubject<int?> tertinggiStream;

  PendanaanBloc._({
    required this.stepControl,
    required this.getProduct,
    required this.stepStream,
    required this.jenisProductStream,
    required this.dataPendanaan,
    required this.sortControl,
    required this.jenisFilterControl,
    required this.terendahControl,
    required this.tertinggiControl,
    required this.getDataPendanaan,
    required this.sortStream,
    required this.jenisProdukSortStream,
    required this.terendahStream,
    required this.tertinggiStream,
    required this.detailDataPendanaan,
    required this.getDataPendanaanDetail,
    required this.documentStream,
    required this.messageReqOtp,
    required this.messageValidateOtp,
    required this.otpControl,
    required this.reqOtpSubmit,
    required this.validateOtpSubmit,
    required this.checkSaldoFunction,
    required this.messageCheckSaldo,
    required this.noTelpUser,
    required this.detailControl,
    required this.isDetailStream,
    required this.detailPendanaanControl,
    required this.errorOtp,
    required this.errorOtpChange,
    required this.summaryData,
    required this.isLoadingButton,
    required this.isLoadingChange,
    required this.getDataBeranda,
    required this.dataBeranda,
    required Function0<void> dispose,
  }) : super(dispose);

  factory PendanaanBloc(
    final GetAuthStateStreamUseCase getAuthState,
    final ReqOtpPendanaanUseCase reqOtp,
    final ValidasiOtpPendanaanUseCase validateOtp,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final jenisProductController = BehaviorSubject<List<dynamic>>();
    final dataPendanaanController = BehaviorSubject<Map<String, dynamic>>();
    final noTelpUserController = BehaviorSubject<String>();
    final isDetailController = BehaviorSubject<bool>.seeded(false);
    final dataBerandaController = BehaviorSubject<Map<String, dynamic>>();

    // saldo
    final summaryData = BehaviorSubject<Map<String, dynamic>?>();

    //step detail
    final detailPendanaanController = BehaviorSubject<Map<String, dynamic>?>();

    //step document
    final documentController = BehaviorSubject<dynamic>();
    final messageCheckSaldo = BehaviorSubject<PendanaanMessage?>();

    //step otp
    final otpController = BehaviorSubject<String>();
    final otpErrorController = BehaviorSubject<String?>();
    final isLoadingButton = BehaviorSubject<bool>.seeded(false);

    //submit
    final requestOtpSubmit = PublishSubject<void>();
    final validateOtpSubmit = PublishSubject<void>();

    //filter
    final sortController = BehaviorSubject<String>.seeded('0');
    final jenisFilterController = BehaviorSubject<List<int>>();
    final terendahController = BehaviorSubject<int?>();
    final tertinggiController = BehaviorSubject<int?>();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    final authState$ = getAuthState();

    String getJenisFilter(List<int> value) {
      if (value.isNotEmpty) {
        final queryString = value.map((id) => 'idProduk=$id').join('&');
        return '&$queryString';
      }
      return '';
    }

    String getParamsPendanaan() {
      final sort = sortController.valueOrNull ?? '0';
      final jenisFilter = jenisFilterController.valueOrNull ?? [];
      final String jenis = getJenisFilter(jenisFilter);
      final terendah = terendahController.valueOrNull ?? 0;
      final tertinggi = tertinggiController.valueOrNull ?? 0;
      final tertinggiVal = tertinggi <= 0 ? '' : '&max=${tertinggi.toString()}';
      final terendahVal = terendah <= 0 ? '' : '&min=${terendah.toString()}';

      return 'sort=$sort$terendahVal$tertinggiVal$jenis';
    }

    void getBeranda() async {
      final event = await authState$.first;
      final beranda = event.orNull()!.userAndToken!.beranda;

      final Map<String, dynamic> data = JwtDecoder.decode(beranda);
      print('beranda bang: $data');
      dataBerandaController.add(data['beranda']['status']);
    }

    void getProduct() async {
      final event = await authState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      final noTelp = event.orNull()!.userAndToken!.user.tlpmobile;
      try {
        noTelpUserController.add(noTelp);
        final response = await apiService.getProductPendaanan1(token);
        print('response product $response');
        jenisProductController.add(response);
        print('ini produk: ${jenisProductController.value}');
      } catch (e) {
        print('error: ${e.toString()}');
        jenisProductController.addError(e.toString());
      }
    }

    void getDataPendanaan() async {
      final event = await authState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      final params = getParamsPendanaan();
      try {
        final response = await apiService.getDataPendanaan(token, params);
        dataPendanaanController.add(response);
        print('ini list pendanaan: ${dataPendanaanController.value}');
      } catch (e) {
        dataPendanaanController.addError(e.toString());
      }
    }

    void getDocumentP3(int idJaminan) async {
      final event = await authState$.first;
      final id = event.orNull()!.userAndToken!.user.idborrower.toString();
      try {
        final response = await apiService.getDocumentPendanaanP3(id, idJaminan);
        documentController.add(response);
        print('ini document: ${documentController.value}');
      } catch (e) {
        documentController.addError(e.toString());
      }
    }

    void getDetailPendanaan(String noSbg) async {
      final event = await authState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        final response = await apiService.getDetailDataPendanaan(
          token,
          'nosbg=$noSbg',
        );
        detailPendanaanController.add(response);
        getDocumentP3(response['data_detail_status']['id_jaminan']);
        print('ini detail pendanaan: ${detailPendanaanController.value}');
        print('ini detail pendanaan coba check: ${response['estimasi_pendapatan']}');
      } catch (e) {
        detailPendanaanController.addError(e.toString());
      }
    }

    void terendahControl(String? val) {
      if (val == null) {
        terendahController.add(-1);
      } else {
        final String replace = val.replaceAll('Rp ', '').replaceAll('.', '');
        final value = int.tryParse(replace);
        if (value == 0) {
          terendahController.add(-1);
        } else {
          terendahController.add(value!);
        }
      }
    }

    void tertinggiControl(String? val) {
      if (val == null) {
        tertinggiController.add(-1);
      } else {
        final String replace = val.replaceAll('Rp ', '').replaceAll('.', '');
        final value = int.tryParse(replace);
        if (value == 0) {
          tertinggiController.add(-1);
        } else {
          tertinggiController.add(value!);
        }
      }
    }

    void checkSaldo(int valuePinjaman) async {
      print('masuk gan');
      final event = await authState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      final params = getParamsPendanaan();
      try {
        final response = await apiService.getDataPendanaan(token, params);
        dataPendanaanController.add(response);
        print('ini list pendanaan: ${dataPendanaanController.value}');
      } catch (e) {
        dataPendanaanController.addError(e.toString());
      }
      final dataPendanaan = dataPendanaanController.valueOrNull ?? {};
      final saldo = dataPendanaan['saldo_tersedia'] ?? 0;
      if (saldo < valuePinjaman) {
        messageCheckSaldo.add(const PendanaanError('Saldo Tidak Cukup', []));
        print('gak masuk gan');
      } else {
        messageCheckSaldo.add(const PendanaanSuccess());
        print('masuk gan');
      }
    }

    //step request otp
    final submitReqOtp = requestOtpSubmit.stream.share();
    final messageReqOtp = Rx.merge([
      submitReqOtp
          .withLatestFrom(detailPendanaanController, (_, Map<String, dynamic>? val) => val)
          .exhaustMap(
            (value) => reqOtp(nosbg: value!['no_sbg']),
          )
          .map(_responseToMessage)
    ]);

    //step validate otp
    final credentialValidate = Rx.combineLatest2(
      detailPendanaanController.stream,
      otpController.stream,
      (Map<String, dynamic>? data, String otp) => CredentialValidatePendanaan(
        otp: otp,
        nosbg: data!['no_sbg'],
      ),
    );

    final submitValidateOtp = validateOtpSubmit.stream.share();
    final messageValidateOtp = Rx.merge(
      [
        submitValidateOtp
            .withLatestFrom(credentialValidate, (_, CredentialValidatePendanaan cred) => cred)
            .exhaustMap(
              (value) => validateOtp(
                nosbg: value.nosbg,
                otp: value.otp,
              ),
            )
            .map(_responseToMessage)
      ],
    );

    return PendanaanBloc._(
      stepControl: (int val) {
        otpErrorController.add(null);
        stepController.add(val);
      },
      sortControl: (String val) => sortController.add(val),
      dataPendanaan: dataPendanaanController.stream,
      jenisFilterControl: (List<int> val) => jenisFilterController.add(val),
      terendahControl: terendahControl,
      tertinggiControl: tertinggiControl,
      stepStream: stepController.stream,
      getProduct: getProduct,
      jenisProdukSortStream: jenisFilterController.stream,
      getDataPendanaan: getDataPendanaan,
      jenisProductStream: jenisProductController.stream,
      sortStream: sortController.stream,
      terendahStream: terendahController,
      tertinggiStream: tertinggiController,
      detailDataPendanaan: detailPendanaanController.stream,
      detailPendanaanControl: (Map<String, dynamic>? val) => detailPendanaanController.add(val),
      getDataPendanaanDetail: getDetailPendanaan,
      documentStream: documentController.stream,
      reqOtpSubmit: () => requestOtpSubmit.add(null),
      messageReqOtp: messageReqOtp,
      otpControl: (String val) => otpController.add(val),
      validateOtpSubmit: () => validateOtpSubmit.add(null),
      messageValidateOtp: messageValidateOtp,
      checkSaldoFunction: checkSaldo,
      messageCheckSaldo: messageCheckSaldo,
      noTelpUser: noTelpUserController.stream,
      detailControl: (bool val) => isDetailController.add(val),
      isDetailStream: isDetailController.stream,
      errorOtp: otpErrorController.stream,
      errorOtpChange: (String? val) => otpErrorController.add(val),
      isLoadingButton: isLoadingButton.stream,
      isLoadingChange: (bool val) => isLoadingButton.add(val),
      dataBeranda: dataBerandaController.stream,
      getDataBeranda: getBeranda,
      dispose: () {
        stepController.close();
        jenisProductController.close();
      },
      summaryData: summaryData.stream,
    );
  }
  static PendanaanMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const PendanaanSuccess(),
      ifLeft: (appError) =>
          appError.isCancellation ? null : PendanaanError(appError.message!, appError.error!),
    );
  }
}

class CredentialValidatePendanaan {
  final String otp;
  final String nosbg;
  const CredentialValidatePendanaan({
    required this.otp,
    required this.nosbg,
  });
}
