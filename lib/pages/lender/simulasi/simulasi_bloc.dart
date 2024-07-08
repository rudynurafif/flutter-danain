import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/simulasi_cicilan_use_case.dart';
import 'package:flutter_danain/domain/usecases/simulasi_maxi_use_case.dart';
import 'package:flutter_danain/pages/lender/simulasi/simulasi_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class SimulasiPendanaanBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> nominalChange;
  final Function0<void> getMaster;

  //maxi function
  final Function1<int, void> tenorPinjamanChange;
  final Function0<void> postMaxi;
  final Function1<Map<String, dynamic>, void> responseMaxiChange;

  //cicil emas function
  final Function1<ListProductResponse, void> produkTenorChange;
  final Function0<void> postCicilan;
  final Function1<Map<String, dynamic>, void> responseCicilanChange;

  //maxi stream
  final Stream<int> tenorPinjamanStream;
  final Stream<Map<String, dynamic>> maxiResponse;
  final Stream<SimulasiMessage?> messageMaxi;

  //cicil emas stream
  final Stream<List<ListProductResponse>> listProdukStream;
  final Stream<ListProductResponse> produkTenorStream;
  final Stream<Map<String, dynamic>> cicilanResponse;
  final Stream<SimulasiMessage?> messageCicilan;

  final Stream<bool> isLoading;
  final Function1<bool, void> isLoadingChange;

  SimulasiPendanaanBloc._({
    required this.nominalChange,
    required this.tenorPinjamanChange,
    required this.produkTenorChange,
    required this.tenorPinjamanStream,
    required this.produkTenorStream,
    required this.cicilanResponse,
    required this.maxiResponse,
    required this.listProdukStream,
    required this.getMaster,
    required this.messageMaxi,
    required this.postMaxi,
    required this.responseMaxiChange,
    required this.messageCicilan,
    required this.postCicilan,
    required this.responseCicilanChange,
    required this.isLoading,
    required this.isLoadingChange,
    required Function0<void> dispose,
  }) : super(dispose);

  factory SimulasiPendanaanBloc(
    SimulasiMaxiUseCase simulasiMaxi,
    SimulasiCicilanUseCase calculateCicilan,
  ) {
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    final maxiResponseController = BehaviorSubject<Map<String, dynamic>>();
    final cicilanResponseController = BehaviorSubject<Map<String, dynamic>>();
    final nominalController = BehaviorSubject<int>.seeded(1);
    final tenorPinjamanController = BehaviorSubject<int>.seeded(1);
    final maxiButtonController = PublishSubject<void>();

    //cicil emas
    final produkTenorList = BehaviorSubject<List<ListProductResponse>>();
    final produkTenorController = BehaviorSubject<ListProductResponse>();
    final cicilButtonController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);

    void getInitData() async {
      final List<ListProductResponse> dataProduk =
          await apiService.getListProduct(2);
      try {
        produkTenorList.add(dataProduk);
        print(dataProduk);
        final ListProductResponse productSelected = dataProduk
            .where(
              (element) => element.tenor == 6,
            )
            .first;
        produkTenorController.add(productSelected);
      } catch (e) {
        produkTenorList.addError('Maaf sepertinya terjadi kesalahan');
      }
    }

    final credentialMaxi = Rx.combineLatest2(
      nominalController.stream,
      tenorPinjamanController.stream,
      (int nominal, int tenor) => CredentialMaxi(
        nilaiPinjaman: nominal,
        jumlahHari: tenor,
      ),
    );
    final maxiClick = maxiButtonController.stream.share();
    final messageMaxi = Rx.merge([
      maxiClick
          .withLatestFrom(credentialMaxi, (_, CredentialMaxi cred) => cred)
          .exhaustMap(
            (value) => simulasiMaxi(
              jumlahHari: value.jumlahHari,
              nilaiPinjaman: value.nilaiPinjaman,
            ),
          )
          .map(_responseToMessage)
    ]);

    final credentialCicilan = Rx.combineLatest2(
        nominalController.stream, produkTenorController.stream, (
      int nominal,
      ListProductResponse produk,
    ) {
      final Map<String, dynamic> result = {
        'totalHargaEmas': nominal,
        'idProduk': produk.id,
        'tenor': produk.tenor,
      };
      return result;
    });
    final cicilanClick = cicilButtonController.stream.share();

    final messageCicilan = Rx.merge([
      cicilanClick
          .withLatestFrom(
              credentialCicilan, (_, Map<String, dynamic> cred) => cred)
          .exhaustMap(
            (value) => calculateCicilan(payload: value),
          )
          .map(_responseToMessage)
    ]);

    void dispose() {
      maxiResponseController.close();
      cicilanResponseController.close();
      nominalController.close();
      tenorPinjamanController.close();
      produkTenorController.close();
      produkTenorList.close();
    }

    return SimulasiPendanaanBloc._(
      nominalChange: (int val) {
        print(val);
        nominalController.add(val);
      },
      tenorPinjamanChange: (int val) => tenorPinjamanController.add(val),
      produkTenorChange: (ListProductResponse val) =>
          produkTenorController.add(val),
      tenorPinjamanStream: tenorPinjamanController.stream,
      produkTenorStream: produkTenorController.stream,
      cicilanResponse: cicilanResponseController.stream,
      maxiResponse: maxiResponseController.stream,
      listProdukStream: produkTenorList.stream,
      getMaster: getInitData,
      messageMaxi: messageMaxi,
      postMaxi: () => maxiButtonController.add(null),
      responseMaxiChange: (Map<String, dynamic> val) =>
          maxiResponseController.add(val),
      messageCicilan: messageCicilan,
      postCicilan: () => cicilButtonController.add(null),
      responseCicilanChange: (Map<String, dynamic> val) =>
          cicilanResponseController.add(val),
      isLoading: isLoadingController.stream,
      isLoadingChange: (bool val) => isLoadingController.add(val),
      dispose: dispose,
    );
  }
  static SimulasiMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (value) {
        print(value.toString());
        return const SimulasiSuccess();
      },
      ifLeft: (appError) => appError.isCancellation
          ? null
          : SimulasiError(appError.message!, appError.error!),
    );
  }
}

class CredentialMaxi {
  final int nilaiPinjaman;
  final int jumlahHari;
  const CredentialMaxi({
    required this.nilaiPinjaman,
    required this.jumlahHari,
  });
}
