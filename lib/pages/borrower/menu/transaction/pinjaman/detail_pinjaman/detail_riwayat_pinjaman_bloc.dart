import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:disposebag/disposebag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_va_pinjaman_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import '../../../../../../data/remote/api_service.dart';
import 'detail_riwayat_pinjaman_state.dart';

class DetailRiwayatPinjamanBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;
  // Input Functions (now nullable)
  final Function0<void> detailPinjamanChange;
  final Function1<int, void> idAggrementChange;
  final Function0<void> getVa;

  // Output stream
  final Stream<dynamic> messageDetailPinjamanStream$;
  final Stream<bool> isLoading;
  final Stream<DetailVaMessage> messageVa;

  DetailRiwayatPinjamanBloc._({
    required this.detailPinjamanChange,
    required this.idAggrementChange,
    required this.messageDetailPinjamanStream$,
    required this.apiService,
    required this.isLoading,
    required this.getVa,
    required this.messageVa,
    required Function0<void> dispose,
  }) : super(dispose);

  factory DetailRiwayatPinjamanBloc(
      GetAuthStateStreamUseCase getAuthStateStreamUseCase) {
    final idAgreementController = PublishSubject<int>();
    final detailPinjamansController = PublishSubject<void>();
    final isLoading = BehaviorSubject<bool>.seeded(false);
    final vaController = BehaviorSubject<DetailVaMessage>();

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

    void getVa() async {
      isLoading.add(true);
      final event = await authenticationState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        final response = await apiService.postPembayaranPortofolios(
          token,
          idAgreement ?? 0,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body)['data'];
          print('data va bang ${response.body}');
          if (data['dataVa'] == null || data['VA'] == null) {
            vaController.add(
              DetailVaError(
                'Ups, terjadi kesalahan silakan coba beberapa saat lagi',
                data,
              ),
            );
          } else {
            vaController.add(DetailVaSuccess(data));
          }
        } else {
          final data = jsonDecode(response.body);
          print('data va error bang $data');
          vaController.add(DetailVaError(
            'Ups, terjadi kesalahan: ${data['message']}',
            data,
          ));
        }
      } catch (e) {
        vaController.add(DetailVaError(
          'Ups, terjadi kesalahan: ${e.toString()}',
          e,
        ));
      }
      isLoading.add(false);
    }

    final DetailPinjamanSMessage$ = detailPinjamansController
        .debug(identifier: 'detaiPinjaman [1]', log: debugPrint)
        .switchMap((_) {
      return Stream.fromIterable([null]).asyncExpand((_) async* {
        await for (final event in authenticationState$) {
          try {
            final response = await apiService.getDetailPortofolios(
                event.orNull()!.userAndToken!.token, idAgreement ?? 0);

            final responseBody = jsonDecode(response);
            final sendingData = responseBody['data'];
            yield sendingData;
          } catch (e) {
            yield e.toString();
          }
        }
      });
    }).asBroadcastStream();

    final messageDetailPinjamanStream$ = Rx.merge([DetailPinjamanSMessage$])
        .whereType<DetailRiwayatPinjamanMessage>()
        .publish();

    return DetailRiwayatPinjamanBloc._(
      dispose: DisposeBag([messageDetailPinjamanStream$.connect()]).dispose,
      apiService: apiService,
      idAggrementChange: idAgreementController.add,
      messageDetailPinjamanStream$: DetailPinjamanSMessage$,
      detailPinjamanChange: () => detailPinjamansController.add(null),
      getVa: getVa,
      isLoading: isLoading.stream,
      messageVa: vaController.stream,
    );
  }

  static DetailRiwayatPinjamanMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const DetailRiwayatPinjamanSuccess(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : DetailRiwayatPinjamanError(appError.message!, appError.error!),
    );
  }
}
