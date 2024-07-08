import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class UbahHpBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;
  final Stream<Result<AuthenticationState>?> authState;

  final Function1<int, void> stepControl;
  final Function1<int, void> sendEmail;

  final Stream<int> stepStream;

  UbahHpBloc._({
    required this.apiService,
    required this.authState,
    required this.sendEmail,
    required this.stepControl,
    required this.stepStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory UbahHpBloc(
    final GetAuthStateStreamUseCase getAuthState,
  ) {
    final stepController = PublishSubject<int>();
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    final authenticationState$ = getAuthState();
    final authState$ = authenticationState$;
    sendEmail(int nextStep) async {
      print('masuk bang');
      final event = await authenticationState$.first;

      final response = await apiService
          .reqEmailUpdateHp(event.orNull()!.userAndToken!.token);
      if (response == true) {
        stepController.sink.add(nextStep);
      }
    }

    final disposeCallback = () {};

    return UbahHpBloc._(
      apiService: apiService,
      sendEmail: sendEmail,
      authState: authState$,
      stepControl: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      dispose: disposeCallback,
    );
  }
}
