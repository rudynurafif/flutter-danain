import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_detail_pendanaan/new_detail_pendanaan_state.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../domain/models/app_error.dart';
import '../../../../utils/type_defs.dart';

class NewDetailPendanaanBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getNewDetailPendanaan;
  final Function0<void> getDocumentP3;
  final Function1<bool, void> detailControl;
  final Function1<int, void> stepControl;
  final Function1<String, void> otpControl;
  final Function1<String?, void> errorOtpChange;
  final Function1<bool, void> isLoadingChange;

  final Stream<Map<String, dynamic>> detailPendanaan;
  final Stream<bool> isDetailStream;
  final Stream<int> stepStream;
  final Stream<bool> isLoadingButton;
  final Stream<bool> isAgreePP;
  final Stream<String?> errorOtp;
  final BehaviorSubject<String> noTelpUser;
  final Stream<String?> documentStream;

  // beranda
  final Function0<void> getDataHome;
  final Stream<Map<String, dynamic>?> dataHome;
  final Stream<Map<String, dynamic>?> summaryData;

  // message
  final Function1<int, void> checkSaldoFunction;
  final Function1<bool, void> agreementPP;
  final Function0<void> reqOtpSubmit;
  final Function1<String, void> validateOtpSubmit;
  final Stream<PendanaanMessage?> messageCheckSaldo;
  final Stream<bool> isPostDone;
  // final Stream<PendanaanMessage?> messageValidateOtp;

  NewDetailPendanaanBloc._({
    required this.getNewDetailPendanaan,
    required this.getDocumentP3,
    required this.detailControl,
    required this.stepControl,
    required this.isLoadingChange,
    required this.detailPendanaan,
    required this.isDetailStream,
    required this.stepStream,
    required this.isLoadingButton,
    required this.getDataHome,
    required this.dataHome,
    required this.summaryData,
    required this.checkSaldoFunction,
    required this.reqOtpSubmit,
    required this.messageCheckSaldo,
    required this.agreementPP,
    required this.isAgreePP,
    required this.validateOtpSubmit,
    required this.isPostDone,
    // required this.messageValidateOtp,
    required this.errorOtp,
    required this.errorOtpChange,
    required this.otpControl,
    required this.noTelpUser,
    required this.documentStream,
    required Function0<void> dispose,
  }) : super(dispose);

  static Future<int> fetchIdPengajuan(GetRequestUseCase getRequest, int id) async {
    try {
      final response = await getRequest.call(
        url: 'api/beedanainpendanaan/v1/pendanaan/list-pendanaan',
        service: serviceBackend.authLender,
        queryParam: {'idAgreement': id},
      );
      return response.fold(
        ifLeft: (String value) {
          throw Exception('Failed to load idPengajuan');
        },
        ifRight: (GeneralResponse response) {
          return response.data['detail']['idPengajuan'];
        },
      );
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  factory NewDetailPendanaanBloc(
    int id,
    GetRequestUseCase getRequest,
    PostRequestUseCase postRequest,
    PostRequestDocumentUseCase postReqDocument,
    GetAuthStateStreamUseCase getAuthState,
  ) {
    final detailPendanaan = BehaviorSubject<Map<String, dynamic>>();
    final isDetailController = BehaviorSubject<bool>.seeded(false);
    final isAgreePP = BehaviorSubject<bool>.seeded(false);
    final noTelpUserController = BehaviorSubject<String>();
    final stepController = BehaviorSubject<int>.seeded(1);
    final messageError = BehaviorSubject<String?>();
    final messageCheckSaldo = BehaviorSubject<PendanaanMessage>();
    final isPostDone = BehaviorSubject<bool>.seeded(false);

    final homeController = BehaviorSubject<Map<String, dynamic>?>();
    final summaryData = BehaviorSubject<Map<String, dynamic>?>();

    Future<void> getBerandaFunction() async {
      final auth = getAuthState();
      try {
        final event = await auth.first;
        final data = event.orNull()!.userAndToken;
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(data!.beranda);
        homeController.add(decodedToken['beranda']);
      } catch (e) {
        homeController.addError(e.toString());
      }
    }

    // step document
    final documentController = BehaviorSubject<String?>();

    // step otp
    final isLoadingButton = BehaviorSubject<bool>.seeded(false);
    final otpController = BehaviorSubject<String>();
    final otpErrorController = BehaviorSubject<String?>();

    void getNewDetailPendanaan() async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanainpendanaan/v1/pendanaan/list-pendanaan',
          service: serviceBackend.authLender,
          queryParam: {'idAgreement': id},
        );
        response.fold(
          ifLeft: (String value) {
            print('Api Response: $value');
          },
          ifRight: (GeneralResponse response) {
            detailPendanaan.add(response.data);
          },
        );
      } catch (e) {
        print('Exception: $e');
      }
    }

    Future<void> getSummary() async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/summary',
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (value) {
            messageError.add(value);
          },
          ifRight: (value) {
            summaryData.add(value.data);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    void checkSaldo(int valuePinjam) async {
      final summary = summaryData.valueOrNull ?? {};
      final saldo = summary['saldoTersedia'];
      if (saldo < valuePinjam) {
        messageCheckSaldo.add(const PendanaanError('Saldo Tidak Cukup', []));
        print('masuk');
      } else {
        messageCheckSaldo.add(const PendanaanSuccess());
      }
    }

    void agreementPP(bool isAgree) async {
      isAgreePP.add(isAgree);
    }

    void getDocumentP3() async {
      final idPengajuan = await fetchIdPengajuan(getRequest, id);
      try {
        final response = await postReqDocument.call(
          url: 'api/beedanaingenerate/v1/dokumen/PP',
          body: {
            'idPengajuan': idPengajuan,
            'cetak': 'PPP',
            'bucket': 'bpkb-lender',
            'view': 'view',
            'borrower_lender': 'lender'
          },
          service: serviceBackend.dokumen,
        );
        response.fold(
          ifLeft: (error) {
            print('error ngab $error');
          },
          ifRight: (dynamic response) {
            documentController.add(response);
          },
        );
      } catch (e) {
        print('Exception: $e');
      }
    }

    // step request otp
    Future<void> requestOtp() async {
      try {
        final idPengajuan = await fetchIdPengajuan(getRequest, id);
        final response = await getRequest.call(
          url: 'api/beedanainpendanaan/v1/pendanaan/requestotp',
          queryParam: {
            'types': 'resend',
            'idPengajuan': idPengajuan,
          },
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (value) {
            messageError.add(value);
          },
          ifRight: (GeneralResponse response) {
            print('response req otp : ${response.data}');
            // if (response.data['code'] == 201) {
            noTelpUserController.add(response.data['notelp']);
            stepController.add(2);
            // }
          },
        );
      } catch (e) {}
    }

    // step validasi otp
    Future<void> validateOtp(String otp) async {
      try {
        final idPengajuan = await fetchIdPengajuan(getRequest, id);
        final response = await getRequest.call(
          url: 'api/beedanainpendanaan/v1/pendanaan/validasiotp',
          queryParam: {
            'otp': otp,
            'idpengajuan': idPengajuan,
          },
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (String error) {
            print('error otp: $error');
            otpErrorController.add('Kode OTP yang dimasukkan tidak sesuai');
            isLoadingButton.add(false);
          },
          ifRight: (response) {
            print(response);
            isLoadingButton.add(false);
            isPostDone.add(true);
          },
        );
      } catch (e) {
        print(e);
      }
    }

    return NewDetailPendanaanBloc._(
      getNewDetailPendanaan: getNewDetailPendanaan,
      getDataHome: () async {
        homeController.add(null);
        await getBerandaFunction();
        await getSummary();
      },
      detailControl: (bool val) => isDetailController.add(val),
      stepControl: (int val) {
        stepController.add(val);
        otpErrorController.add(null);
      },
      detailPendanaan: detailPendanaan.stream,
      isDetailStream: isDetailController.stream,
      stepStream: stepController.stream,
      isLoadingButton: isLoadingButton.stream,
      isLoadingChange: (bool val) => isLoadingButton.add(val),
      checkSaldoFunction: checkSaldo,
      messageCheckSaldo: messageCheckSaldo,
      noTelpUser: noTelpUserController,
      agreementPP: agreementPP,
      isAgreePP: isAgreePP.stream,
      reqOtpSubmit: requestOtp,
      validateOtpSubmit: validateOtp,
      isPostDone: isPostDone.stream,
      // messageValidateOtp: messageValidateOtp,
      errorOtp: otpErrorController.stream,
      errorOtpChange: (String? val) => otpErrorController.add(val),
      otpControl: (String val) => otpController.add(val),
      dispose: () => detailPendanaan.close(),
      summaryData: summaryData.stream,
      dataHome: homeController.stream,
      documentStream: documentController.stream,
      getDocumentP3: getDocumentP3,
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
  final String noPP;
  const CredentialValidatePendanaan({
    required this.otp,
    required this.noPP,
  });
}
