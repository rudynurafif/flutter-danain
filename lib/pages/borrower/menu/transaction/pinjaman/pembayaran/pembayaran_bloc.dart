import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:disposebag/disposebag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran/pembayaran_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import '../../../../../../data/remote/api_service.dart';

class PembayaranBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;
  // Input Functions (now nullable)
  final Function0<void> detailPinjamanChange;
  final Function1<int, void> idAggrementChange;
  final Function0<void> getMasterPembayaran;

  // Output stream
  final Stream<dynamic> messageDetailPinjamanStream$;
  final Stream<String> vaStream$;
  final Stream<dynamic> pembayaranStream$;
  final Stream<Map<String, dynamic>> masterPembayaran$;
  final Stream<Map<String, dynamic>> detailPembayaram$;

  PembayaranBloc._({
    required this.detailPinjamanChange,
    required this.idAggrementChange,
    required this.messageDetailPinjamanStream$, // Corrected
    required this.apiService,
    required this.vaStream$,
    required this.pembayaranStream$,
    required this.masterPembayaran$,
    required this.getMasterPembayaran,
    required this.detailPembayaram$,
    required Function0<void> dispose,
  }) : super(dispose);

  factory PembayaranBloc(GetAuthStateStreamUseCase getAuthStateStreamUseCase) {
    final idAgreementController = PublishSubject<int>();
    final detailPinjamansController = PublishSubject<void>();
    final vaController = PublishSubject<String>();
    final pembayaranController = PublishSubject<dynamic>();
    final masterPembayaran = BehaviorSubject<Map<String, dynamic>>();
    final detailPembayaran = BehaviorSubject<Map<String, dynamic>>();

    final authenticationState$ = getAuthStateStreamUseCase();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    int? idAgreement; // Declare a variable to store the latest ID

// Listen to idAgreementController.stream
    idAgreementController.stream.listen((id) {
      // Update the latest ID when a new value is emitted
      idAgreement = id;
    });

    final DetailPinjamanSMessage$ = detailPinjamansController
        .debug(identifier: 'pembayaran [1]', log: debugPrint)
        .switchMap((_) {
      return Stream.fromIterable([null]).asyncExpand((_) async* {
        await for (final event in authenticationState$) {
          try {
            print('response vas');
            final response = await apiService.postPembayaranPortofolios(
                event.orNull()!.userAndToken!.token, idAgreement ?? 0);

            final responseBody = jsonDecode(response.body);

            final vaValue = responseBody['data']['VA'];
            final pembayaranValue = responseBody['data']['dataVa']['nominal'];
            print('dapat response ${pembayaranValue}');
            vaController.add(vaValue);
            pembayaranController.add(pembayaranValue);
            detailPembayaran.add(responseBody);
            // final sendingData =responseBody['data'];

            yield response;
          } catch (e) {
            yield e.toString();
          }
        }
      });
    }).asBroadcastStream();

    final messageDetailPinjamanStream$ = Rx.merge([DetailPinjamanSMessage$])
        .whereType<PembayaranMessage>()
        .publish();

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

    return PembayaranBloc._(
      dispose: DisposeBag([
        messageDetailPinjamanStream$.connect(),
      ]).dispose, // Corrected
      apiService: apiService,
      idAggrementChange: idAgreementController.add,
      messageDetailPinjamanStream$:
          DetailPinjamanSMessage$, // Provide the correct stream here
      detailPinjamanChange: () => detailPinjamansController.add(null),
      vaStream$: vaController.stream,
      pembayaranStream$: pembayaranController,
      getMasterPembayaran: getMasterBank,
      masterPembayaran$: masterPembayaran.stream,
      detailPembayaram$: detailPembayaran.stream,
    );
  }

  static PembayaranMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const PembayaranSuccess(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : PembayaranError(appError.message!, appError.error!),
    );
  }
}
