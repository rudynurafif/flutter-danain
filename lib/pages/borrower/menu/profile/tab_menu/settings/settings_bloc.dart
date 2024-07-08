import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';

class SettingsBloc extends DisposeCallbackBaseBloc {
  final Stream<Result<AuthenticationState>?> authState$;

  SettingsBloc._({
    required this.authState$,
    required Function0<void> dispose,
  }) : super(dispose);

  factory SettingsBloc(GetAuthStateStreamUseCase getAuthState) {
    final authState = getAuthState();

    return SettingsBloc._(
      authState$: authState,
      dispose: () {},
    );
  }
}
