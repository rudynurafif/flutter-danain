import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class AjakTemanBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepChange;
  final Function0<void> getAjakTemanData;

  final Stream<int> stepStream;
  final Stream<String> linkAjakTeman;
  final Stream<Map<String, dynamic>> ajakTemanStream;

  AjakTemanBloc._({
    required this.stepChange,
    required this.stepStream,
    required this.ajakTemanStream,
    required this.getAjakTemanData,
    required this.linkAjakTeman,
    required Function0<void> dispose,
  }) : super(dispose);

  factory AjakTemanBloc(
    GetAuthStateStreamUseCase getAuthState,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final ajakTemanController = BehaviorSubject<Map<String, dynamic>>();
    final linkController = BehaviorSubject<String>();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    final authState$ = getAuthState();
    void getAjakTemanData() async {
      final event = await authState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        final response = await apiService.getAjakTeman(token);
        print(response);
        final kode = response['kode_ajakteman'];
        linkController.add(
          'Gunakan Kode Referal ini Untuk Daftar di Apps Danain : $kode, atau klik untuk registrasi melalui apps : https://m.danain.co.id/appslink?ref=$kode',
        );
        ajakTemanController.add(response);
      } catch (e) {
        ajakTemanController.addError('Maaf sepertinya ada yang salah');
      }
    }

    return AjakTemanBloc._(
      stepChange: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      ajakTemanStream: ajakTemanController.stream,
      linkAjakTeman: linkController.stream,
      getAjakTemanData: getAjakTemanData,
      dispose: () {
        stepController.close();
        ajakTemanController.close();
      },
    );
  }
}
