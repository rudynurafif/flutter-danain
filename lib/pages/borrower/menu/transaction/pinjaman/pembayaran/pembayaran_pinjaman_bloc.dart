import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class PembayaranPinjamanBloc extends DisposeCallbackBaseBloc {
  // function
  final Function0<void> getMasterPembayaran;
  final Function1<Map<String, dynamic>, void> detailPinjamanChange;

  //stream
  final Stream<Map<String, dynamic>> dataPinjamanStream;
  final Stream<Map<String, dynamic>> masterBankStream;

  PembayaranPinjamanBloc._({
    required this.getMasterPembayaran,
    required this.detailPinjamanChange,
    required this.dataPinjamanStream,
    required this.masterBankStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory PembayaranPinjamanBloc(
      GetAuthStateStreamUseCase getAuthStateStreamUseCase) {
    final masterPembayaranController = BehaviorSubject<Map<String, dynamic>>();
    final detailVaController = BehaviorSubject<Map<String, dynamic>>();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

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
      masterPembayaranController.add(result);
    }

    void dispose() {
      masterPembayaranController.close();
      detailVaController.close();
    }

    return PembayaranPinjamanBloc._(
      getMasterPembayaran: getMasterBank,
      detailPinjamanChange: (Map<String, dynamic> val) =>
          detailVaController.add(val),
      dataPinjamanStream: detailVaController.stream,
      masterBankStream: masterPembayaranController.stream,
      dispose: dispose,
    );
  }
}
