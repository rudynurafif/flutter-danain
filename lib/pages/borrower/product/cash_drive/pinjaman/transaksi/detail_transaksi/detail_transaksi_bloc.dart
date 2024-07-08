import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/api_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_riwayat_transaksi_v3.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class DetailTransaksiBlocV3 extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepChange;
  final Function1<int, void> idAgreementChange;
  final Function1<int, void> getRiwayatTransaksi;
  final Function0<void> getMasterBank;
  final Function0<void> getDocumentPerjanjian;
  final Function1<Map<String, dynamic>, void> resultChange;

  final Stream<Map<String, dynamic>> caraBayarStream;
  final Stream<Map<String, dynamic>> resultValidate;
  final Stream<int> stepStream$;
  final Stream<dynamic> documentPerjanjian;
  final Stream<String?> errorMessage;

  final BehaviorSubject<Map<String, dynamic>?> response;

  DetailTransaksiBlocV3._({
    required this.getRiwayatTransaksi,
    required this.response,
    required this.stepChange,
    required this.stepStream$,
    required this.idAgreementChange,
    required this.getMasterBank,
    required this.caraBayarStream,
    required Function0<void> dispose,
    required this.resultChange,
    required this.resultValidate,
    required this.getDocumentPerjanjian,
    required this.documentPerjanjian,
    required this.errorMessage,
  }) : super(dispose);

  factory DetailTransaksiBlocV3(
      GetRiwayatTransaksiUseCase getRiwayatTransaksiUseCase,
      GetAuthStateStreamUseCase getAuthStateStreamUseCase,
      final PostRequestDocumentUseCase postReqDocument) {
    final stepController = BehaviorSubject<int>.seeded(1);
    //get token
    final errorMessage = BehaviorSubject<String?>();
    final responseController = BehaviorSubject<Map<String, dynamic>?>();
    final authenticationState$ = getAuthStateStreamUseCase();
    final idAgreementController = BehaviorSubject<int?>();
    final caraBayarController = BehaviorSubject<Map<String, dynamic>>();
    final documentPerjanjianController = BehaviorSubject<dynamic>();

    Future<void> getRiwayatTransaksi(int idAgreement) async {
      try {
        final event = await authenticationState$.first;
        final response = await getRiwayatTransaksiUseCase.call(
          endpoint: '/api/beeborrowertransaksi/v1/cnd/riwayattransaksiborrower',
          params: {
            'page': 1,
            'pageSize': 10,
            'id': idAgreement,
          },
          token: event.orNull()!.userAndToken!.token.toString(),
        );
        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            print('masuk right bang ${value.data}');
            responseController.add(value.data);
            documentPerjanjianController.add(value.data['fileP2']);
          },
        );
      } catch (e) {
        print('masuk error bang bang ${e.toString()}');
        errorMessage.add(e.toString());
      }
    }

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    final resultValidate = BehaviorSubject<Map<String, dynamic>>();

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
      caraBayarController.add(result);
    }

    void getDocumentPerjanjian() async {
      print("check id pengajuan ${responseController.value!['fileP2']} ");
      documentPerjanjianController.add(responseController.value!['fileP2']);
      try {
        final response = await postReqDocument.call(
          url: 'api/beedanaingenerate/v1/dokumen/PP',
          body: {
            'idPengajuan': responseController.value?['idPengajuan'],
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
            // documentPerjanjianController
            //     .add(responseController.value!['fileP2']);
          },
        );
      } catch (e) {
        print('masuk error bang bang ${e.toString()}');
        errorMessage.add(e.toString());
      }
    }

    final authState$ = authenticationState$.castAsNullable().publishState(null);

    return DetailTransaksiBlocV3._(
        getRiwayatTransaksi: getRiwayatTransaksi,
        dispose: DisposeBag([
          authState$.connect(),
        ]).dispose,
        response: responseController,
        stepChange: (int val) => stepController.add(val),
        getMasterBank: getMasterBank,
        stepStream$: stepController.stream,
        idAgreementChange: (int val) => idAgreementController.add(val),
        caraBayarStream: caraBayarController.stream,
        resultChange: (Map<String, dynamic> val) => resultValidate.add(val),
        resultValidate: resultValidate.stream,
        getDocumentPerjanjian: getDocumentPerjanjian,
        documentPerjanjian: documentPerjanjianController,
        errorMessage: errorMessage.stream);
  }
}
