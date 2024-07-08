import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_hubungan_keluarga_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_master_use_case.dart';
import 'package:flutter_danain/domain/usecases/post_hubungan_keluarga.dart';
import 'package:flutter_danain/utils/type_defs.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HubunganKeluargaBloc extends DisposeCallbackBaseBloc {
  final Function0<void> checkBeranda;
  final Function0<void> getHubunganKeluarga;
  final Function0<void> getMasterHubungan;
  final Stream<Map<String, dynamic>> berandaData;

  //pasangan
  final Stream<int> isPasangan;
  final Stream<Map<String, dynamic>?> pasanganData;

  //pasangan form
  final BehaviorSubject<String?> namePasangan;
  final BehaviorSubject<String?> noKtpPasangan;
  final BehaviorSubject<String?> noHpPasangan;
  final Stream<bool> buttonPasangan;

  //keluarga
  final Stream<int> isKeluarga;
  final Stream<Map<String, dynamic>?> keluargaData;

  //keluarga form
  final BehaviorSubject<String?> nameKeluarga;
  final BehaviorSubject<Map<String, dynamic>?> hubunganKeluarga;
  final BehaviorSubject<String?> noHpKeluarga;
  final Stream<bool> buttonKeluarga;

  //all form
  final Stream<bool> buttonAll;

  final Stream<List<dynamic>> listHubungan;

  final Stream<String?> errorMessage;
  final Stream<bool> isLoading;

  final Function1<bool, void> postKeluarga;
  final Function0<void> postPasangan;
  final Stream<bool> isPostDone;

  HubunganKeluargaBloc._({
    required this.checkBeranda,
    required this.getHubunganKeluarga,
    required this.berandaData,
    required this.pasanganData,
    required this.keluargaData,
    required this.isPasangan,
    required this.isKeluarga,
    required this.errorMessage,
    required this.listHubungan,
    required this.isLoading,
    required this.getMasterHubungan,
    required this.namePasangan,
    required this.noKtpPasangan,
    required this.noHpPasangan,
    required this.nameKeluarga,
    required this.hubunganKeluarga,
    required this.noHpKeluarga,
    required this.buttonKeluarga,
    required this.buttonPasangan,
    required this.buttonAll,
    required this.postKeluarga,
    required this.postPasangan,
    required this.isPostDone,
    required Function0<void> dispose,
  }) : super(dispose);

  factory HubunganKeluargaBloc(
    GetAuthStateStreamUseCase getAuthState,
    GetMasterDataUseCase getMaster,
    GetHubunganKeluargaUseCase getHubungan,
    PostHubunganKeluargaUseCase postHubungan,
  ) {
    final berandaController = BehaviorSubject<Map<String, dynamic>>();
    final listHubunganController = BehaviorSubject<List<dynamic>>();
    final pasanganController = BehaviorSubject<Map<String, dynamic>?>();
    final keluargaController = BehaviorSubject<Map<String, dynamic>?>();
    final isPasangan = BehaviorSubject<int>();
    final isKeluarga = BehaviorSubject<int>();
    final isLoading = BehaviorSubject<bool>.seeded(true);
    final isPostDone = BehaviorSubject<bool>.seeded(false);
    final errorMessage = BehaviorSubject<String?>();
    final auth = getAuthState();

    //form
    final namaKeluarga = BehaviorSubject<String?>();
    final hubunganKeluargaController = BehaviorSubject<Map<String, dynamic>?>();
    final noHpKeluargaController = BehaviorSubject<String?>();
    final buttonKeluarga = BehaviorSubject<bool>.seeded(false);

    buttonKeluarga.addStream(
      Rx.combineLatest3(
        namaKeluarga.stream,
        hubunganKeluargaController.stream,
        noHpKeluargaController.stream,
        (name, hubungan, noHp) {
          print('Name: $name');
          print('Hubungan: $hubungan');
          print('No HP: $noHp');

          final nameValid = name != null && name.isNotEmpty;
          final hubunganValid = hubungan != null;
          final noHpValid = noHp != null && noHp.isNotEmpty && noHp.length > 10;

          print('Name Valid: $nameValid');
          print('Hubungan Valid: $hubunganValid');
          print('No HP Valid: $noHpValid');

          return nameValid && hubunganValid && noHpValid;
        },
      ),
    );

    final namePasangan = BehaviorSubject<String?>();
    final noKtpController = BehaviorSubject<String?>();
    final noHpPasangan = BehaviorSubject<String?>();
    final buttonPasanganController = BehaviorSubject<bool>.seeded(false);
    buttonPasanganController.addStream(
      Rx.combineLatest3(
        namePasangan.stream,
        noKtpController.stream,
        noHpPasangan.stream,
        (a, b, c) {
          return a != null &&
              b != null &&
              b.length == 16 &&
              c != null &&
              c.length > 9;
        },
      ),
    );

    final buttonAll = BehaviorSubject<bool>.seeded(false);
    buttonAll.addStream(
      Rx.combineLatest2(
        buttonKeluarga.stream,
        buttonPasanganController.stream,
        (a, b) => a == true && b == true,
      ),
    );

    Future<void> checkBeranda() async {
      try {
        final event = await auth.first;
        final data = event.orNull()!.userAndToken;
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(
          data!.beranda,
        );
        berandaController.add(decodedToken['beranda']);
        final status = decodedToken['beranda']['status'];
        print('pasangan = ${status['is_pasangan']}');
        isPasangan.add(status['is_pasangan']);
        isKeluarga.add(status['is_keluarga']);
      } catch (e) {
        print(e.toString());
      }
    }

    Future<void> getListHubungan() async {
      final response = await getMaster.call(
        endpoint: 'hubungankeluarga',
        params: {},
      );
      response.fold(
        ifLeft: (value) {
          errorMessage.add(value);
        },
        ifRight: (value) {
          listHubunganController.add(value.data ?? []);
        },
      );
      isLoading.add(false);
    }

    Future<void> dispose() async {
      await berandaController.close();
      await isPasangan.close();
      await isKeluarga.close();
    }

    Future<void> getHubunganKeluarga() async {
      try {
        final response = await getHubungan.call();
        print('responsenya ini bang $response');
        response.fold(
          ifLeft: (value) {
            errorMessage.add(value);
          },
          ifRight: (value) {
            print('masuk bang datanya');
            final List<dynamic> data = value.data;
            final pasangan = data.firstWhereOrNull(
              (e) => e['idHubunganKeluarga'] == 1,
            );
            if (pasangan != null) {
              print('ini masuk pasangan bang');
              pasanganController.add(pasangan);
            }
            final keluarga = data.firstWhereOrNull(
              (e) => e['idHubunganKeluarga'] != 1,
            );
            if (keluarga != null) {
              print('ini masuk keluarga bang');
              keluargaController.add(keluarga);
            }
          },
        );
      } catch (e) {
        print('error ini bang ${e.toString()}');
        errorMessage.add(e.toString());
      }
    }

    Future<void> postPasangan() async {
      isLoading.add(true);
      try {
        final response = await postHubungan.call(
          payload: DataKeluargaPayload(
            idHubunganKeluarga: 1,
            namaLengkap: namePasangan.valueOrNull ?? '',
            noHp: noHpPasangan.valueOrNull ?? '',
            noKtp: noKtpController.valueOrNull ?? '',
          ),
        );
        response.fold(
          ifLeft: (value) {
            isLoading.add(false);
            errorMessage.add(value);
          },
          ifRight: (value) {
            isLoading.add(false);
            isPostDone.add(true);
          },
        );
      } catch (e) {
        isLoading.add(false);
        errorMessage.add(e.toString());
      }
    }

    Future<void> postKeluarga(bool isWithPasangan) async {
      isLoading.add(true);
      final hubungan = hubunganKeluargaController.valueOrNull ?? {};
      try {
        final response = await postHubungan.call(
          payload: DataKeluargaPayload(
            idHubunganKeluarga: hubungan['idHubunganKeluarga'] ?? 0,
            namaLengkap: namaKeluarga.valueOrNull ?? '',
            noHp: noHpKeluargaController.valueOrNull ?? '',
            noKtp: '',
          ),
        );
        response.fold(
          ifLeft: (error) {
            isLoading.add(false);
            errorMessage.add(error);
          },
          ifRight: (value) {
            if (isWithPasangan) {
              postPasangan();
            } else {
              isLoading.add(false);
              isPostDone.add(true);
            }
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
        isLoading.add(false);
      }
    }

    return HubunganKeluargaBloc._(
      checkBeranda: checkBeranda,
      berandaData: berandaController.stream,
      isPasangan: isPasangan.stream,
      isKeluarga: isKeluarga.stream,
      getHubunganKeluarga: getHubunganKeluarga,
      pasanganData: pasanganController.stream,
      keluargaData: keluargaController.stream,
      errorMessage: errorMessage.stream,
      isLoading: isLoading.stream,
      listHubungan: listHubunganController.stream,
      getMasterHubungan: getListHubungan,
      dispose: dispose,
      namePasangan: namePasangan,
      noKtpPasangan: noKtpController,
      noHpPasangan: noHpPasangan,
      nameKeluarga: namaKeluarga,
      hubunganKeluarga: hubunganKeluargaController,
      noHpKeluarga: noHpKeluargaController,
      buttonKeluarga: buttonKeluarga.stream,
      buttonPasangan: buttonPasanganController.stream,
      buttonAll: buttonAll.stream,
      postKeluarga: postKeluarga,
      isPostDone: isPostDone.stream,
      postPasangan: postPasangan,
    );
  }
}
