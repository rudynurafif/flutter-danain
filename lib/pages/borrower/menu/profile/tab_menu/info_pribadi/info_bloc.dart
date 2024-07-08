import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class InfoBorrowerBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getUserToken;
  final Stream<UserAndToken?> userTokenStream;

  InfoBorrowerBloc._({
    required this.getUserToken,
    required this.userTokenStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory InfoBorrowerBloc(GetAuthStateStreamUseCase getAuthState) {
    final auth = getAuthState();
    final userTokenController = BehaviorSubject<UserAndToken?>();
    void getData() async {
      final event = await auth.first;
      final data = event.orNull()!.userAndToken;
      userTokenController.add(data);
    }

    void dispose() {
      userTokenController.close();
    }

    return InfoBorrowerBloc._(
      getUserToken: getData,
      userTokenStream: userTokenController.stream,
      dispose: dispose,
    );
  }
}
