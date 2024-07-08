import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/check_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/ubah_pin_use_case.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin_state.dart';
import 'package:flutter_danain/utils/utils.dart';

class UbahPinLenderBloc extends DisposeCallbackBaseBloc {
  //
  final Function1<int, void> stepChange;
  final Function1<String, void> currentPinChange;
  final Function1<String, void> newPinChange;
  final Function1<String, void> confirmPinChange;
  final Function1<String?, void> errorPinChange;
  final Function1<String?, void> errorCurrentPinChange;
  final Function0<void> postPin;
  final Function0<void> checkPin;
  final Function1<bool, void> isLoadingChange;

  final Stream<int> stepStream;
  final Stream<String> currentPin;
  final Stream<String> newPin;
  final Stream<String> confirmPin;
  final Stream<bool> isLoading;
  final Stream<String?> errorPin;
  final Stream<String?> errorCurrentPin;
  final Stream<UbahPinMessage?> messagePin;
  final Stream<UbahPinMessage?> messageCheckPin;

  UbahPinLenderBloc._({
    required this.stepChange,
    required this.stepStream,
    required this.currentPin,
    required this.newPin,
    required this.newPinChange,
    required this.confirmPin,
    required this.confirmPinChange,
    required this.currentPinChange,
    required this.errorPin,
    required this.messagePin,
    required this.postPin,
    required this.checkPin,
    required this.messageCheckPin,
    required this.errorPinChange,
    required this.errorCurrentPinChange,
    required this.errorCurrentPin,
    required this.isLoading,
    required this.isLoadingChange,
    required Function0<void> dispose,
  }) : super(dispose);

  factory UbahPinLenderBloc(
    UbahPinLenderUseCase ubahPin,
    CheckPinUseCase checkPinLender,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final currentPinController = BehaviorSubject<String>();
    final newPinController = BehaviorSubject<String>();
    final confirmPinController = BehaviorSubject<String>();
    final errorPinController = BehaviorSubject<String?>();
    final errorPinCurrentController = BehaviorSubject<String?>();
    final postPinController = PublishSubject<void>();
    final checkPinController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);

    final postPinClick = postPinController.stream.share();
    final credential = Rx.combineLatest3(
      currentPinController.stream,
      newPinController.stream,
      confirmPinController.stream,
      (current, newPin, confirm) => CredentialUbahPin(
        current: current,
        newPin: newPin,
        confirm: confirm,
      ),
    );
    final messagePin = Rx.merge([
      postPinClick
          .withLatestFrom(credential, (_, CredentialUbahPin cred) => cred)
          .exhaustMap(
            (value) => ubahPin(
              currentPin: value.current,
              newPin: value.newPin,
              confirmPin: value.confirm,
            ),
          )
          .map(_responseToMessage)
    ]);

    final checkPinClick = checkPinController.stream.share();
    final messageCheckPin = Rx.merge([
      checkPinClick
          .withLatestFrom(currentPinController.stream, (_, String val) => val)
          .exhaustMap(
            (value) => checkPinLender(pin: value),
          )
          .map(_responseToMessage)
    ]);

    return UbahPinLenderBloc._(
      stepChange: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      currentPin: currentPinController.stream,
      newPin: newPinController.stream,
      newPinChange: (String val) => newPinController.add(val),
      confirmPin: confirmPinController.stream,
      confirmPinChange: (String val) => confirmPinController.add(val),
      currentPinChange: (String val) => currentPinController.add(val),
      errorPin: errorPinController.stream,
      errorPinChange: (String? val) => errorPinController.add(val),
      errorCurrentPinChange: (String? val) =>
          errorPinCurrentController.add(val),
      errorCurrentPin: errorPinCurrentController.stream,
      messagePin: messagePin,
      postPin: () => postPinController.add(null),
      checkPin: () => checkPinController.add(null),
      messageCheckPin: messageCheckPin,
      isLoadingChange: (bool val) => isLoadingController.add(val),
      isLoading: isLoadingController.stream,
      dispose: () {
        confirmPinController.close();
        newPinController.close();
        currentPinController.close();
        checkPinController.close();
        postPinController.close();
        isLoadingController.close();
      },
    );
  }
  static UbahPinMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const UbahPinSuccess(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : UbahPinError(appError.message!, appError.error!),
    );
  }
}

class CredentialUbahPin {
  final String current;
  final String newPin;
  final String confirm;
  const CredentialUbahPin({
    required this.current,
    required this.newPin,
    required this.confirm,
  });
}
