import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_riwayat_transaksi_v3.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../data/remote/response/general_response.dart';

class RiwayatTransaksiBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepChange;
  final Function({Map<String, dynamic> params}) getListRiwayat;
  final Function({Map<String, dynamic> params}) infiniteScroll;
  final Function0<void> terapkan;
  final Function0<void> reset;

  // beranda
  final Function0<void> getDataHome;
  final Stream<Map<String, dynamic>?> dataHome;
  final Stream<Map<String, dynamic>?> summaryData;

  //stream
  final Stream<Map<String, dynamic>> authState$;
  final Stream<int> stepStream;
  final Stream<Map<String, dynamic>> detailDataStream;
  final Stream<List<dynamic>?> listDataStream;

  //filter stream
  final Stream<List<String>> jenisTransaksiStream;
  final Stream<int> bulanStream;
  final Stream<int> periodeStream;
  final Stream<int> tahunStream;
  final Stream<bool> haveFilterStream;

  //filter function
  final Function1<int, void> bulanControl;
  final Function1<int, void> tahunControl;
  final Function1<List<String>, void> jenisTransaksiControl;
  final Function1<int, void> periodeControl;

  final BehaviorSubject<List<dynamic>?> response;

  RiwayatTransaksiBloc._({
    required this.stepChange,
    required this.getListRiwayat,
    required this.detailDataStream,
    required this.authState$,
    required this.getDataHome,
    required this.dataHome,
    required this.summaryData,
    required this.stepStream,
    required this.listDataStream,
    required this.infiniteScroll,
    required this.bulanControl,
    required this.jenisTransaksiControl,
    required this.bulanStream,
    required this.jenisTransaksiStream,
    required this.periodeControl,
    required this.periodeStream,
    required this.tahunControl,
    required this.tahunStream,
    required this.terapkan,
    required this.reset,
    required this.haveFilterStream,
    required Function0<void> dispose,
    required this.response,
  }) : super(dispose);

  factory RiwayatTransaksiBloc(
    GetAuthStateStreamUseCase getAuthState,
    GetRequestUseCase getRequest,
    GetRiwayatTransaksiUseCase getRiwayatTransaksiUseCase,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final detailData = BehaviorSubject<Map<String, dynamic>>();
    final berandaData = BehaviorSubject<Map<String, dynamic>>();
    final listDataController = BehaviorSubject<List<dynamic>?>();
    final authState$ = getAuthState();
    final homeController = BehaviorSubject<Map<String, dynamic>?>();
    final summaryData = BehaviorSubject<Map<String, dynamic>?>();
    final messageError = BehaviorSubject<String?>();

    //params
    final datenow = DateTime.now();
    // final prevMonth = DateTime(datenow.year, datenow.month - 1, datenow.day);
    // final prevString = DateFormat('MM').format(prevMonth);
    // final month = int.tryParse(prevString);
    final month = datenow.month;
    final jenisTransaksiController = BehaviorSubject<List<String>>.seeded([]);
    final periodeController = BehaviorSubject<int>.seeded(1);
    final bulanController = BehaviorSubject<int>.seeded(month);
    final tahunController = BehaviorSubject<int>.seeded(datenow.year);
    final paramsController = BehaviorSubject<String>.seeded('');
    final haveFilter = BehaviorSubject<bool>.seeded(false);
    final responseController = BehaviorSubject<List<dynamic>?>();
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    Future<void> getBerandaFunction() async {
      final auth = getAuthState();
      try {
        final event = await auth.first;
        final data = event.orNull()!.userAndToken;
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(
          data!.beranda,
        );
        homeController.add(decodedToken['beranda']);
      } catch (e) {
        homeController.addError(e.toString());
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

    Future<void> getData({
      Map<String, dynamic> params = const {},
    }) async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/riwayatTransaksiLender',
          service: serviceBackend.authLender,
          queryParam: params,
        );
        response.fold(
          ifLeft: (String error) {
            messageError.add(error);
          },
          ifRight: (GeneralResponse response) {
            listDataController.add(response.data['ResponseData']);
          },
        );
      } catch (e) {
        listDataController.addError('Maaf sepertinya terjadi kesalahan');
      }
    }

    void reset() {
      paramsController.add('');
      bulanController.add(month);
      tahunController.add(datenow.year);
      periodeController.add(1);
      jenisTransaksiController.add([]);
      getData();
    }

    void terapkan() {
      final periode = periodeController.valueOrNull ?? 4;
      var param = '';
      final bulan = bulanController.valueOrNull ?? 0;
      final tahun = tahunController.valueOrNull ?? 0;
      final jenis = jenisTransaksiController.valueOrNull ?? [];
      final periodeVal = '&priode=$periode';
      final bulanVal = '&bulan=$bulan';
      final tahunVal = '&tahun=$tahun';
      final jenisVal = getJenisControl(jenis);

      if (periode == 4) {
        param = '&priode=2&bulan=${month}&tahun=${datenow.year}$jenisVal';
      }

      if (periode == 2) {
        param = '$periodeVal$bulanVal$tahunVal$jenisVal';
      }
      if (periode == 3) {
        param = '$periodeVal$jenisVal';
      }
      if (periode == 1) {
        param = '$jenisVal';
      }
      haveFilter.add(true);
      paramsController.add(param);
      getData();
    }

    void infiniteScroll({
      Map<String, dynamic> params = const {},
    }) async {
      final listDataExisting = listDataController.valueOrNull ?? [];
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/riwayatTransaksiLender',
          service: serviceBackend.authLender,
          queryParam: params,
          isUseToken: true,
        );
        response.fold(
          ifLeft: (String error) {
            messageError.add(error);
          },
          ifRight: (GeneralResponse response) {
            listDataExisting.addAll(response.data['ResponseData'] ?? []);
            print('ini length list transaksi ${listDataExisting.length}');
            listDataController.add(listDataExisting);
          },
        );
      } catch (e) {
        listDataController.addError('Maaf sepertinya terjadi kesalahan');
        messageError.add(e.toString());
      }
    }

    void dispose() {
      detailData.close();
    }

    return RiwayatTransaksiBloc._(
      bulanControl: (int val) => bulanController.add(val),
      jenisTransaksiControl: (List<String> val) => jenisTransaksiController.add(val),
      getListRiwayat: getData,
      infiniteScroll: infiniteScroll,
      authState$: berandaData.stream,
      stepChange: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      detailDataStream: detailData.stream,
      listDataStream: listDataController.stream,
      bulanStream: bulanController.stream,
      jenisTransaksiStream: jenisTransaksiController.stream,
      periodeControl: (int val) => periodeController.add(val),
      periodeStream: periodeController.stream,
      tahunControl: (int val) => tahunController.add(val),
      tahunStream: tahunController.stream,
      haveFilterStream: haveFilter.stream,
      reset: reset,
      terapkan: terapkan,
      dispose: dispose,
      response: responseController,
      getDataHome: () async {
        homeController.add(null);
        await getBerandaFunction();
        await getSummary();
      },
      dataHome: homeController.stream,
      summaryData: summaryData.stream,
    );
  }
}

String getJenisControl(List<String> value) {
  if (value.isNotEmpty) {
    final queryString = value.map((id) => 'jenis_transaksi=$id').join('&');
    return '&$queryString';
  }
  return '';
}
