import 'package:disposebag/disposebag.dart';
import '../../../data/api/api_service_helper.dart';
import '../../../domain/models/app_error.dart';
import '../../../domain/usecases/api_use_case.dart';
import '../../../domain/usecases/get_auth_state_stream_use_case.dart';
import '../../../domain/usecases/logout_use_case.dart';
import '../../../utils/type_defs.dart';
import 'check_pin_state.dart';

class CheckPinLenderBloc extends DisposeCallbackBaseBloc {
  final Function1<String, void> pinChange;
  final Stream<String?> pinErrorController;
  final Function1<String?, void> pinErrorChange;
  final Stream<bool> isPinValid;

  final Function0<void> logout;
  final Stream<HomeLenderMessage> logoutMessage$;
  final Stream<CheckPinMessage?> pinMessage;

  CheckPinLenderBloc._({
    required this.pinChange,
    required this.pinErrorController,
    required this.pinErrorChange,
    required this.isPinValid,
    required this.logout,
    required this.logoutMessage$,
    required this.pinMessage,
    required Function0<void> dispose,
  }) : super(dispose);

  factory CheckPinLenderBloc(
    PostRequestUseCase postRequest,
    final LogoutUseCase logout,
    final GetAuthStateStreamUseCase getAuth,
  ) {
    final isPinValid = BehaviorSubject<bool>();
    final pinErrorController = BehaviorSubject<String?>.seeded(null);
    final authenticationState$ = getAuth();
    final pinMessage = BehaviorSubject<CheckPinMessage?>();
    Future<void> pinChange(String pin) async {
      if (pin.length == 6) {
        final response = await postRequest.call(
          url: 'api/beedanainuser/v1/users/cekpin',
          body: {'pin': pin},
        );
        response.fold(
          ifLeft: (value) {
            if (value == 'salah pin 3x harap tunggu 10 menit') {
              pinMessage.add(CheckPinSalah10Menit(value, {}));
              pinErrorController.add(null);
            } else if (value == 'Invalid pin. Please try again.') {
              pinMessage.add(CheckPinSalah(value, {}));
              pinErrorController.add('Pin Salah!');
            } else {
              pinErrorController.add(null);
              pinMessage.add(CheckPinError(value, {}));
            }
            isPinValid.add(false);
          },
          ifRight: (value) {
            pinErrorController.add(null);
            pinMessage.add(const CheckPinSuccess());
            isPinValid.add(true);
          },
        );
      } else {
        pinErrorController.add(null);
      }
    }

    final setLogout = PublishSubject<void>();

    final logoutMessage$ = Rx.merge([
      setLogout.exhaustMap((_) => logout()).map(_resultToLogoutLenderMessage),
      authenticationState$
          .where((result) => result.orNull()?.userAndToken == null)
          .mapTo(const LogoutLenderSuccessMessage()),
    ]);

    final messageLogout$ = Rx.merge([logoutMessage$]).whereNotNull().publish();

    return CheckPinLenderBloc._(
      pinChange: pinChange,
      pinMessage: pinMessage,
      pinErrorController: pinErrorController.stream,
      pinErrorChange: (String? val) => pinErrorController.add(val),
      isPinValid: isPinValid.stream,
      logout: () => setLogout.add(null),
      logoutMessage$: messageLogout$,
      dispose: DisposeBag([messageLogout$.connect()]).dispose,
    );
  }

  static LogoutLenderMessage? _resultToLogoutLenderMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const LogoutLenderSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : LogoutLenderErrorMessage(appError.message!, appError.error!),
    );
  }
}
