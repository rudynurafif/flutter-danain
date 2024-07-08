import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/action_cicilan_use_case.dart';
import 'package:flutter_danain/domain/usecases/cicil_emas_req_use_case.dart';
import 'package:flutter_danain/domain/usecases/cicil_emas_val_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_payment_use_case.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class CicilanDetailBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepChange;
  final Function1<int, void> getDataDetail;
  final Function1<Map<String, dynamic>, void> setResult;
  final Function0<void> getMasterPembayaran;
  final Function1<bool, void> isLoadingButtonChange;
  final Function0<void> getPayment;

  final Stream<int> stepStream$;
  final Stream<int> isLoadingStream$;
  final Stream<Map<String, dynamic>> dataStream;
  final Stream<bool> isLoadingButton$;

  final Stream<Map<String, dynamic>> resultPembayaran;
  final Stream<Map<String, dynamic>> masterPembayaran$;

  //pending
  final Function0<void> batalkanTransaksi;
  final Function1<String, void> otpChange;
  final Function0<void> reqOtp;
  final Function0<void> validateOtp;
  final Stream<String> noHpStream$;
  final Stream<bool> isLoading$;
  final Stream<String> otpStream;

  //message
  final Stream<DetailCicilanMessage?> messageBatalkan;
  final Stream<DetailCicilanMessage?> messageOtpReq;
  final Stream<DetailCicilanMessage?> messageOtpValidate;
  final Stream<DetailCicilanMessage?> messagePaymentData;

  CicilanDetailBloc._({
    required this.stepChange,
    required this.stepStream$,
    required this.getDataDetail,
    required this.dataStream,
    required this.isLoadingStream$,
    required this.batalkanTransaksi,
    required this.messageBatalkan,
    required this.noHpStream$,
    required this.isLoading$,
    required this.otpChange,
    required this.otpStream,
    required this.messageOtpReq,
    required this.messageOtpValidate,
    required this.reqOtp,
    required this.resultPembayaran,
    required this.setResult,
    required this.validateOtp,
    required this.getMasterPembayaran,
    required this.masterPembayaran$,
    required this.isLoadingButton$,
    required this.isLoadingButtonChange,
    required this.messagePaymentData,
    required this.getPayment,
    required Function0<void> dispose,
  }) : super(dispose);

  factory CicilanDetailBloc(
      GetAuthStateStreamUseCase getAuthState,
      ActionCicilanUseCase postAction,
      CicilEmasReqUseCase cicilEmasReq,
      CicilEmasValUseCase validateCicilEmas,
      GetPaymentUseCase getPaymentCicilan) {
    //get token
    final authState = getAuthState();
    Future<String> getToken() async {
      final event = await authState.first;

      final token = event.orNull()!.userAndToken!.token.toString();
      return token;
    }

    final stepController = BehaviorSubject<int>.seeded(1);
    final isLoadingController = BehaviorSubject<int>.seeded(1);
    final dataController = BehaviorSubject<Map<String, dynamic>>();
    final resultPembayaranController = BehaviorSubject<Map<String, dynamic>>();
    final masterPembayaran = BehaviorSubject<Map<String, dynamic>>();
    final isLoadingButton = BehaviorSubject<bool>();

    //pending
    final noHpController = BehaviorSubject<String>();
    final idBorrower = BehaviorSubject<int>();
    final isLoading = BehaviorSubject<bool>();
    final otpController = BehaviorSubject<String>();
    final reqOtpButton = PublishSubject<void>();
    final valOtp = PublishSubject<void>();
    final batalkan = PublishSubject<void>();
    final getPaymentButton = PublishSubject<void>();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    void getDataDetail(int idJaminan) async {
      final token = await getToken();
      final event = await authState.first;
      noHpController.add(event.orNull()!.userAndToken!.user.tlpmobile);
      idBorrower.add(event.orNull()!.userAndToken!.user.idborrower);
      try {
        final response = await apiService.getTransaksiCicilEmas(
          token,
          1,
          'idJaminan=$idJaminan',
        );
        dataController.add(response);
        isLoadingController.add(2);
      } catch (e) {
        isLoadingController.add(3);
      }
    }

    //batalkan
    final batalkanClick = batalkan.stream.share();
    final batalkanCredential =
        Rx.combineLatest2(dataController.stream, stepController.stream,
            (Map<String, dynamic>? batalkan, int val) {
      if (batalkan != null &&
          batalkan['pembayaranPending'] != null &&
          batalkan['pembayaranPending']['VA'] != null &&
          batalkan['pembayaranPending']['totalPembayaran'] != null) {
        return CredentialAction(
          va: batalkan['pembayaranPending']['VA'],
          total: batalkan['pembayaranPending']['totalPembayaran'],
          status: 9,
        );
      } else {
        print("Error: batalkan or its properties are null.");
        // Handle the error or take appropriate action
        // You might want to return a default CredentialAction or throw an exception.
        return CredentialAction(va: "default VA", total: 0, status: 0);
      }
    });

    final batalkanMessage = Rx.merge([
      batalkanClick
          .withLatestFrom(
              batalkanCredential, (_, CredentialAction cred) => cred)
          .exhaustMap(
            (value) => postAction(
              status: value.status,
              total: value.total,
              va: value.va,
            ),
          )
          .map(_responseMessage)
    ]);

    //request otp
    final reqOtpClick = reqOtpButton.stream.share();
    final credentialReqOtp = Rx.combineLatest2(
      dataController.stream,
      stepController.stream,
      (
        Map<String, dynamic> dataProduk,
        int step,
      ) {
        return CredReq(
          idProduk: dataProduk['idProduk'],
          dataProduk: dataProduk['detailEmas'],
          kodeCheckout: dataProduk['idTransaksi'],
        );
      },
    );
    final messageReqOtp = Rx.merge(
      [
        reqOtpClick
            .withLatestFrom(credentialReqOtp, (_, CredReq cred) => cred)
            .exhaustMap(
              (value) => cicilEmasReq(
                idProduk: value.idProduk,
                dataProduk: value.dataProduk,
                kodeCheckout: value.kodeCheckout,
              ),
            )
            .map(_responseMessage)
      ],
    );

    //validate otp
    final valOtpClick = valOtp.stream.share();
    final credValidate = Rx.combineLatest3(
      dataController.stream,
      otpController.stream,
      idBorrower.stream,
      (
        Map<String, dynamic> data,
        String otp,
        int id,
      ) {
        final result = {
          'idborrower': id,
          'no_perjanjian': data['idTransaksi'],
          'kodeCheckout': data['idTransaksi'],
          'totalPembayaran': data['pembayaranPending']['totalPembayaran'] ?? 0,
          'otp': otp,
        };
        return CredVal(data: result);
      },
    );
    final messageValOtp = Rx.merge(
      [
        valOtpClick
            .withLatestFrom(credValidate, (_, CredVal cred) => cred)
            .exhaustMap((value) => validateCicilEmas(data: value.data))
            .map(_responseMessage)
      ],
    );

    //get payment
    final getPaymentClick = getPaymentButton.stream.share();
    final messagePayment = Rx.merge([
      getPaymentClick
          .withLatestFrom(
              dataController.stream, (_, Map<String, dynamic> cred) => cred)
          .exhaustMap(
            (value) => getPaymentCicilan(idAgreement: value['idAgreement']),
          )
          .map(_responseMessage)
    ]);

    void getMasterBank() async {
      final response = await apiService.getMasterCaraBayar('BNI');
      final Map<String, dynamic> result = {};
      for (var entry in response) {
        final jenisPembayaran = entry['JenisPembayaran'];
        final keterangan = entry['Keterangan'];

        if (!result.containsKey(jenisPembayaran)) {
          result[jenisPembayaran] = [];
        }

        result[jenisPembayaran].add(keterangan);
      }
      masterPembayaran.add(result);
    }

    return CicilanDetailBloc._(
      stepChange: (int val) => stepController.add(val),
      stepStream$: stepController.stream,
      getDataDetail: getDataDetail,
      dataStream: dataController.stream,
      isLoadingStream$: isLoadingController.stream,
      batalkanTransaksi: () => batalkan.add(null),
      messageBatalkan: batalkanMessage,
      noHpStream$: noHpController.stream,
      isLoading$: isLoading.stream,
      otpChange: (String val) => otpController.add(val),
      reqOtp: () => reqOtpButton.add(null),
      otpStream: otpController.stream,
      messageOtpReq: messageReqOtp,
      messageOtpValidate: messageValOtp,
      isLoadingButton$: isLoadingButton.stream,
      isLoadingButtonChange: (bool val) => isLoadingButton.add(val),
      validateOtp: () => valOtp.add(null),
      setResult: (Map<String, dynamic> val) =>
          resultPembayaranController.add(val),
      resultPembayaran: resultPembayaranController.stream,
      getMasterPembayaran: getMasterBank,
      masterPembayaran$: masterPembayaran.stream,
      getPayment: () => getPaymentButton.add(null),
      messagePaymentData: messagePayment,
      dispose: () {
        stepController.close();
        dataController.close();
        isLoadingController.close();
      },
    );
  }
  static DetailCicilanMessage? _responseMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const DetailCicilanSuccess(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : DetailCicilanError(appError.message!, appError.error!),
    );
  }
}

class CredentialAction {
  final String va;
  final num total;
  final int status;

  const CredentialAction({
    required this.va,
    required this.total,
    required this.status,
  });
}

class CredReq {
  final int idProduk;
  final String kodeCheckout;
  final List<dynamic> dataProduk;

  const CredReq({
    required this.idProduk,
    required this.kodeCheckout,
    required this.dataProduk,
  });
}

class CredVal {
  final Map<String, dynamic> data;
  const CredVal({
    required this.data,
  });
}
