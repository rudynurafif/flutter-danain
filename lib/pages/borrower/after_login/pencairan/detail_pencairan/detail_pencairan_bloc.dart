import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class DetailPencairanBloc extends DisposeCallbackBaseBloc {
  final Function2<int, int, void> getPinjamanControl;
  final Stream<Map<String, dynamic>> dataPinjamanStream;

  DetailPencairanBloc._({
    required this.getPinjamanControl,
    required this.dataPinjamanStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory DetailPencairanBloc(
    final GetAuthStateStreamUseCase getAuthState,
  ) {
    final dataPinjamanController = BehaviorSubject<Map<String, dynamic>>();
    final authState = getAuthState();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    void getPinjaman(int idjaminan, int idproduk) async {
      final event = await authState.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        final response = await apiService.getDetailPinjaman(
          token,
          idjaminan,
          idproduk,
        );
        dataPinjamanController.add(response);
      } catch (e) {
        dataPinjamanController.addError('Maaf Sepertinya terjadi Kesalahan');
      }
    }

    return DetailPencairanBloc._(
      getPinjamanControl: getPinjaman,
      dataPinjamanStream: dataPinjamanController.stream,
      dispose: () {},
    );
  }
}
