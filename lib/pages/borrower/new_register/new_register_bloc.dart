import 'dart:async';

import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class NewRegisterBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getWilayah;
  final BehaviorSubject<int> step;

  //step 1
  final BehaviorSubject<String?> nama;
  final BehaviorSubject<String?> email;
  final BehaviorSubject<String?> noHp;
  final BehaviorSubject<String?> referral;
  final BehaviorSubject<bool> setuju;
  final Stream<bool> buttonStep1;

  //step 1 validation
  final Function1<String, void> changeEmail;
  final Function1<String, void> changeHp;
  final Function({
    required String hp,
    required String ref,
  }) changeRef;
  final Stream<String?> emailValid;
  final Stream<String?> hpValid;
  final Stream<String?> referralValid;

  //step 2
  final BehaviorSubject<String?> pw;
  final BehaviorSubject<String?> konfirmasiPw;
  final Stream<bool> buttonStep2;

  final Stream<String?> errorMessage;
  final Stream<bool> isLoading;

  final Function0<void> submit;
  final Function0<void> getCurrentLocation;

  //step 3
  final Stream<List<dynamic>> listProvinsi;
  final Stream<List<dynamic>> listKota;
  final Stream<Map<String, dynamic>?> provinsi;
  final Function1<Map<String, dynamic>, void> changeProvinsi;
  final BehaviorSubject<Map<String, dynamic>?> kota;
  final Stream<bool> buttonStep3;

  final Stream<RegisterBorrowerMessage?> message;
  final Stream<CekLokasiMessage?> lokasiMessage;

  NewRegisterBloc._({
    required this.step,
    required this.getWilayah,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.referral,
    required this.pw,
    required this.konfirmasiPw,
    required this.setuju,
    required this.errorMessage,
    required this.buttonStep1,
    required this.buttonStep2,
    required this.submit,
    required this.isLoading,
    required this.message,
    required this.lokasiMessage,
    required this.getCurrentLocation,
    required this.listProvinsi,
    required this.listKota,
    required this.provinsi,
    required this.changeProvinsi,
    required this.kota,
    required this.emailValid,
    required this.hpValid,
    required this.referralValid,
    required this.changeEmail,
    required this.changeHp,
    required this.changeRef,
    required this.buttonStep3,
    required Function0<void> dispose,
  }) : super(dispose);

  factory NewRegisterBloc(
    GetRequestUseCase getRequest,
    GetRequestV2UseCase getV2,
    PostRequestUseCase postRequest,
    RegisterBorrowerUseCase regisBorrower,
  ) {
    final errorMessage = BehaviorSubject<String?>();
    final isLoading = BehaviorSubject<bool>.seeded(false);
    final stepController = BehaviorSubject<int>.seeded(1);
    final listWilayah = BehaviorSubject<List<dynamic>>.seeded([]);
    final listKota = BehaviorSubject<List<dynamic>>.seeded([]);
    final cekLokasi = BehaviorSubject<CekLokasiMessage?>();

    //step 3
    final wilayahSelected = BehaviorSubject<Map<String, dynamic>?>();
    final kotaSelected = BehaviorSubject<Map<String, dynamic>?>();
    final buttonStep3 = BehaviorSubject<bool>.seeded(false);
    buttonStep3.addStream(
      Rx.combineLatest2(
        wilayahSelected.stream,
        kotaSelected.stream,
        (Map<String, dynamic>? wilayah, Map<String, dynamic>? kota) {
          return wilayah != null && kota != null;
        },
      ).shareValueSeeded(false),
    );

    Future<void> changeProvinsi(Map<String, dynamic> data) async {
      try {
        wilayahSelected.add(data);
        kotaSelected.add(null);
        listKota.add(data['kabupaten'] ?? []);
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    Future<void> getWilayah() async {
      print('masuk bang wilayah');
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/v2/master/listprovinsi',
          queryParam: {},
          isUseToken: false,
        );
        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            listWilayah.add(value.data ?? []);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    Future<void> checkKota(
      String kota,
      int idProvinsi,
      List<dynamic> kotaList,
    ) async {
      final kotaString = kota.toLowerCase().replaceAll(
            ' ',
            '',
          );
      try {
        listKota.add(kotaList);
        final kSelect = kotaList.firstWhereOrNull((e) {
          return e['nama_kabupaten']
              .toString()
              .toLowerCase()
              .replaceAll(' ', '')
              .contains(kotaString);
        });

        if (kSelect != null) {
          isLoading.add(false);
          cekLokasi.add(const CekLokasiSuccessMessage());
          kotaSelected.add(kSelect);
        } else {
          isLoading.add(false);
          cekLokasi.add(
            const CekLokasiTidakDitemukanMessage('tidak ditemukan lokasi'),
          );
        }
      } catch (e) {
        isLoading.add(false);
        cekLokasi.add(CekLokasiErrorMessage(e.toString(), e));
      }
    }

    Future<void> checkProvinsi(Placemark placeMark) async {
      try {
        final wilayahList = listWilayah.valueOrNull ?? [];
        final String prov =
            placeMark.administrativeArea.toString().toLowerCase().replaceAll(
                  ' ',
                  '',
                );
        final provinsiSelected = wilayahList.firstWhereOrNull((e) {
          return e['nama_provinsi']
              .toString()
              .toLowerCase()
              .replaceAll(' ', '')
              .contains(prov);
        });
        if (provinsiSelected != null) {
          wilayahSelected.add(provinsiSelected);
          await checkKota(
            placeMark.subAdministrativeArea!,
            provinsiSelected['id_provinsi'] ?? 0,
            provinsiSelected['kabupaten'] ?? [],
          );
        } else {
          isLoading.add(false);
          cekLokasi.add(
            const CekLokasiTidakDitemukanMessage(
              'Lokasi tidak terdaftar',
            ),
          );
        }
      } catch (e) {
        isLoading.add(false);
        cekLokasi.add(CekLokasiErrorMessage(e.toString(), e));
      }
    }

    Future<void> getCurrentLocation() async {
      isLoading.add(true);
      final location = loc.Location();

      bool serviceEnabled;

      PermissionStatus permissionGranted;
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print('Location services are disabled.');
          cekLokasi.add(const CekLokasiDitolak('akses ditolak'));
          isLoading.add(false);
          return;
        }
      }

      // Check if location permission is granted
      permissionGranted = await Permission.location.status;
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await Permission.location.request();
        if (permissionGranted != PermissionStatus.granted) {
          print('Location permission is not granted.');
          cekLokasi.add(const CekLokasiDitolak('akses ditolak'));
          isLoading.add(false);
          return;
        }
      }

      loc.LocationData currentLocation;
      try {
        currentLocation = await location.getLocation();
        log.d(currentLocation);
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        log.d(placemarks[0]);
        await checkProvinsi(placemarks[0]);
      } catch (e) {
        isLoading.add(false);
        cekLokasi.add(CekLokasiErrorMessage(e.toString(), e));
        print('Error getting location: $e');
        return;
      }
    }

    //step 1
    final namaController = BehaviorSubject<String?>();
    final noHpController = BehaviorSubject<String?>();
    final hpError = BehaviorSubject<String?>();
    final hpValid = BehaviorSubject<bool>.seeded(false);
    final emailController = BehaviorSubject<String?>();
    final emailError = BehaviorSubject<String?>();
    final emailValid = BehaviorSubject<bool>.seeded(false);
    final referral = BehaviorSubject<String?>.seeded('');
    final refError = BehaviorSubject<String?>();
    final refValid = BehaviorSubject<bool>.seeded(true);
    final setujuController = BehaviorSubject<bool>.seeded(false);
    Timer? debounceEmail;
    Future<void> changeEmail(String email) async {
      emailController.add(email);
      if (email.isValidEmail()) {
        //kondisi ketika email valid, validasi apakah email ada di db ato nggak
        emailError.add(null);
        if (debounceEmail?.isActive ?? false) debounceEmail?.cancel();
        debounceEmail = Timer(const Duration(milliseconds: 500), () async {
          try {
            final response = await getRequest.call(
              url: 'api/beeborroweruser/v1/user/validationHpEmail',
              queryParam: {
                'email': email,
              },
              isUseToken: false,
            );
            response.fold(
              ifLeft: (left) {
                emailValid.add(false);
                emailError.add('Email sudah terdaftar');
              },
              ifRight: (right) {
                emailError.add(null);
                emailValid.add(true);
              },
            );
          } catch (e) {
            errorMessage.add(e.toString());
          }
        });
      } else {
        //email gak valid
        emailValid.add(false);
        emailError.add('Alamat email tidak valid');
      }
    }

    Timer? debounceHp;
    Future<void> changeHp(String hp) async {
      noHpController.add(hp);
      if (Validator.isValidPhoneNumber(hp)) {
        //kondisi ketika nomor hp valid, validasi apakah nomor hp ada di db ato nggak
        hpError.add(null);
        if (debounceHp?.isActive ?? false) debounceHp?.cancel();
        debounceHp = Timer(const Duration(milliseconds: 500), () async {
          try {
            final response = await getRequest.call(
              url: 'api/beeborroweruser/v1/user/validationHpEmail',
              queryParam: {
                'noHp': hp,
              },
              isUseToken: false,
            );
            response.fold(
              ifLeft: (left) {
                hpValid.add(false);
                hpError.add('Nomor handphone sudah terdaftar');
              },
              ifRight: (right) {
                hpError.add(null);
                hpValid.add(true);
              },
            );
          } catch (e) {
            errorMessage.add(e.toString());
          }
        });
      } else {
        //no hp gak valid
        hpValid.add(false);
        hpError.add('Nomor handphone tidak valid');
      }
    }

    Timer? debounceReferral;

    Future<void> changeRef({
      required String hp,
      required String ref,
    }) async {
      referral.add(ref);
      if (ref.isNotEmpty) {
        if (Validator.isValidLength(ref, 6)) {
          refError.add(null);
          if (debounceReferral?.isActive ?? false) debounceReferral?.cancel();
          debounceReferral = Timer(const Duration(milliseconds: 500), () async {
            try {
              final response = await getRequest.call(
                url: 'api/beeborroweruser/v1/user/referral',
                queryParam: {
                  'kodeVoucher': ref,
                  'noHp': hp,
                },
                isUseToken: false,
              );
              response.fold(
                ifLeft: (left) {
                  refError.add('Kode Referral tidak terdaftar');
                  refValid.add(false);
                },
                ifRight: (right) {
                  refError.add(null);
                  refValid.add(true);
                },
              );
            } catch (e) {
              errorMessage.add(e.toString());
            }
          });
        } else {
          refValid.add(false);
          refError.add('Kode referral tidak valid');
        }
      } else {
        refValid.add(true);
        refError.add(null);
      }
    }

    final buttonStep1 = BehaviorSubject<bool>.seeded(false);
    buttonStep1.addStream(
      Rx.combineLatest5(
        namaController.stream,
        hpValid.stream,
        emailValid.stream,
        refValid.stream,
        setujuController.stream,
        (String? nama, bool noHp, bool email, bool ref, bool setuju) {
          final bool namaValid = nama != null && nama.length >= 3;

          return namaValid &&
              noHp == true &&
              email == true &&
              ref == true &&
              setuju == true;
        },
      ).shareValueSeeded(false),
    );

    //step 2
    final pwController = BehaviorSubject<String?>();
    final confirmPwController = BehaviorSubject<String?>();
    final buttonStep2 = BehaviorSubject<bool>.seeded(false);
    buttonStep2.addStream(
      Rx.combineLatest2(
        pwController.stream,
        confirmPwController.stream,
        (String? pw, String? confirmPw) {
          final bool pwValid = pw != null && Validator.isValidPasswordRegis(pw);
          final bool confirmPwValid = confirmPw != null &&
              Validator.isValidPasswordRegis(confirmPw) &&
              pw != null &&
              confirmPw == pw;
          return pwValid && confirmPwValid;
        },
      ).shareValueSeeded(false),
    );

    final submitController = PublishSubject<void>();
    final submitClick = submitController.stream.share();
    final credential$ = Rx.combineLatest7(
      namaController.stream,
      emailController.stream,
      noHpController.stream,
      referral.stream,
      pwController.stream,
      wilayahSelected.stream,
      kotaSelected.stream,
      (
        String? nama,
        String? email,
        String? noHp,
        String? ref,
        String? password,
        Map<String, dynamic>? wilayah,
        Map<String, dynamic>? kota,
      ) {
        return {
          'namaBorrower': nama ?? '',
          'tlpMobile': noHp ?? '',
          'email': email ?? '',
          'referalBpkb': ref ?? '',
          'password': password ?? '',
          'idWilayah': wilayah!['id_wilayah'] ?? 0,
          'idCabang': kota!['id_cabang'] ?? 0,
        };
      },
    );

    final message$ = Rx.merge([
      submitClick
          .withLatestFrom(credential$, (_, Map<String, dynamic> cred) => cred)
          .exhaustMap(
            (value) => regisBorrower(payload: value),
          )
          .map(_responseToMessage)
    ]);

    void dispose() {
      namaController.close();
      emailController.close();
      noHpController.close();
      referral.close();
      pwController.close();
      confirmPwController.close();
      setujuController.close();
      errorMessage.close();
      buttonStep1.close();
      buttonStep2.close();
    }

    return NewRegisterBloc._(
      getWilayah: getWilayah,
      step: stepController,
      nama: namaController,
      email: emailController,
      noHp: noHpController,
      referral: referral,
      pw: pwController,
      konfirmasiPw: confirmPwController,
      setuju: setujuController,
      errorMessage: errorMessage,
      buttonStep1: buttonStep1.stream,
      buttonStep2: buttonStep2.stream,
      isLoading: isLoading.stream,
      submit: () => submitController.add(null),
      message: message$,
      getCurrentLocation: getCurrentLocation,
      lokasiMessage: cekLokasi.stream,
      kota: kotaSelected,
      listKota: listKota.stream,
      listProvinsi: listWilayah.stream,
      changeProvinsi: changeProvinsi,
      provinsi: wilayahSelected.stream,
      changeEmail: changeEmail,
      changeHp: changeHp,
      changeRef: changeRef,
      emailValid: emailError.stream,
      hpValid: hpError.stream,
      referralValid: refError.stream,
      buttonStep3: buttonStep3.stream,
      dispose: dispose,
    );
  }

  static RegisterBorrowerMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const RegisterBorrowerSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : RegisterBorrowerErrorMessage(appError.message!, appError.error!),
    );
  }
}
