import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/tarik_dana_use_case.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'tarik_dana.dart';
import 'package:crypto/crypto.dart';

class TarikDanaBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepControl;
  final Function0<void> getWithDraw;
  final Function1<String, void> saldoTarikControl;
  final Function1<String, void> errorPinControl;
  final Function1<String, void> pinControl;
  final Function1<String, void> checkPin;
  final Function0<void> submitBre;
  final Function1<bool, void> isLoadingChange;

  final Stream<int> stepStream;
  final Stream<Map<String, dynamic>> withDrawStream;
  final Stream<int> saldoTarikStream;
  final Stream<bool> isValidTarikDana;
  final Stream<bool> isLoading;
  final Stream<String?> errorPin;
  final Stream<TarikDanaMessage?> message;
  final Stream<String?> errorMessage;
  final Stream<Map<String, dynamic>?> responseTarikDana;

  final BehaviorSubject<int> saldoTarikController;
  TarikDanaBloc._({
    required this.stepControl,
    required this.stepStream,
    required this.withDrawStream,
    required this.getWithDraw,
    required this.saldoTarikControl,
    required this.saldoTarikStream,
    required this.isValidTarikDana,
    required this.errorPin,
    required this.errorPinControl,
    required this.pinControl,
    required this.message,
    required this.submitBre,
    required this.isLoadingChange,
    required this.isLoading,
    required this.errorMessage,
    required this.checkPin,
    required this.saldoTarikController,
    required this.responseTarikDana,
    required Function0<void> dispose,
  }) : super(dispose);

  factory TarikDanaBloc(
    final GetAuthStateStreamUseCase getAuthState,
    final TarikDanaUseCase tarikDanaPost,
    final GetRequestUseCase getRequest,
    final PostRequestUseCase postRequest,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final withDrawController = BehaviorSubject<Map<String, dynamic>>();
    final saldoTarikController = BehaviorSubject<int>();
    final pinController = BehaviorSubject<String>();
    final errorPinController = BehaviorSubject<String?>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final errorMessage = BehaviorSubject<String?>();
    final messageTarikDana = BehaviorSubject<TarikDanaMessage?>();
    final responseTarikDana = BehaviorSubject<Map<String, dynamic>?>();
    final deviceNameController = BehaviorSubject<String?>();
    final authState = getAuthState();
    Future<void> getDeviceName() async {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String deviceName;
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = '${androidInfo.model} - ${androidInfo.brand}';

        final fullDevice = encoder.convert(androidInfo.data);
        log.d(
          'ini device full bang: \n'
          '$fullDevice',
        );
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
        final fullDevice = encoder.convert(iosInfo.data);
        log.d(
          'ini device full bang: \n'
          '$fullDevice',
        );
      } else {
        deviceName = 'Unsupported platform';
      }
      print('devicenya nih bang: $deviceName');
      deviceNameController.add(deviceName);
    }

    Future<void> postTarikDana() async {
      final wdData = withDrawController.valueOrNull ?? {};
      final num biaya = wdData['biayaTarikDana'] ?? 0;
      final num nominal = saldoTarikController.valueOrNull ?? 0;
      final dataBank = wdData['dataBank'] ?? {};

      // hash email
      final event = await authState.first;
      final email = event.orNull()!.userAndToken!.user.email.toString();
      print('ini email $email');
      final emailHash = md5.convert(utf8.encode(email)).toString();

      try {
        final response = await postRequest.call(
          url: 'api/beedanainuser/v1/users/tarikdana',
          moreHeader: {
            'md': emailHash,
          },
          body: {
            'amount': nominal + biaya,
            'idBank': dataBank['idBank'] ?? 0,
            'noRekening': dataBank['noRekening'] ?? '',
            'anRekening': dataBank['anRekening'],
            'device': deviceNameController.valueOrNull ?? '',
            'namaBank': dataBank['namaBank'] ?? '',
          },
        );
        response.fold(
          ifLeft: (message) {
            messageTarikDana.add(
              TarikDanaErrorMessage(
                message,
                {},
              ),
            );
          },
          ifRight: (value) {
            messageTarikDana.add(const TarikDanaSuccessMessage());
            final dataDetail = value.data['detail'] ?? {};
            responseTarikDana.add(dataDetail);
          },
        );
      } catch (e) {
        messageTarikDana.add(TarikDanaErrorMessage(e.toString(), e));
      }
    }

    Future<void> checkPin(
      String pin,
    ) async {
      try {
        stepController.add(3);
        final response = await postRequest.call(
          url: 'api/beedanainuser/v1/users/checkpin',
          body: {'pin': pin, 'type': 'wd'},
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (error) {
            if (error == 'salah pin 3x harap tunggu 10 menit') {
              messageTarikDana.add(TarikDanaSalahPinMessage(error, {}));
            } else {
              errorPinController.add('Pin yang Anda masukkan salah');
              stepController.add(2);
            }
          },
          ifRight: (value) {
            if (value.data['pinStatus'] == true) {
              postTarikDana();
              errorPinController.add(null);
            } else {
              stepController.add(2);
              errorPinController.add('Pin yang Anda masukkan salah');
            }
          },
        );
      } catch (e) {
        stepController.add(2);
        errorPinController.add('Mohon maaf terjadi kesalahan ${e.toString()}');
      }
    }

    final tarikDanaValid = Rx.combineLatest2(
      withDrawController.stream,
      saldoTarikController.stream,
      (Map<String, dynamic> draw, int? tarikan) {
        final saldo = draw['saldo'];
        return tarikan != null && tarikan >= 10000 && tarikan + 10000 <= saldo;
      },
    ).shareValueSeeded(false);

    void tarikControl(String val) {
      if (val.length <= 3) {
        saldoTarikController.add(0);
      } else {
        final String replace = val.replaceAll('Rp ', '').replaceAll('.', '');
        final value = int.tryParse(replace);
        saldoTarikController.add(value ?? 0);
      }
      print(saldoTarikController.valueOrNull ?? 0);
    }

    void dispose() {
      stepController.close();
      withDrawController.close();
    }

    Future<void> getWithDraw() async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanainuser/v1/users/tarikdana',
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (message) {
            errorMessage.add(message);
          },
          ifRight: (value) {
            withDrawController.add(value.data as Map<String, dynamic>);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    return TarikDanaBloc._(
      stepControl: (int val) => stepController.add(val),
      saldoTarikControl: tarikControl,
      saldoTarikStream: saldoTarikController.stream,
      stepStream: stepController.stream,
      withDrawStream: withDrawController.stream,
      isValidTarikDana: tarikDanaValid,
      errorPin: errorPinController.stream,
      errorPinControl: (String? val) => errorPinController.add(val),
      pinControl: (String val) {
        errorPinController.add(null);
        pinController.add(val);
      },
      message: messageTarikDana.stream,
      errorMessage: errorMessage.stream,
      submitBre: postTarikDana,
      isLoadingChange: (bool val) => isLoadingController.add(val),
      isLoading: isLoadingController.stream,
      saldoTarikController: saldoTarikController,
      checkPin: checkPin,
      responseTarikDana: responseTarikDana.stream,
      getWithDraw: () async {
        await getWithDraw();
        await getDeviceName();
      },
      dispose: dispose,
    );
  }
}
