import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/data/remote/cache.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/verif_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class StepVerifBloc {
  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
  final isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoadingStream => isLoadingController.stream;
  // Step verif
  final stepController = BehaviorSubject<int>();

  //step1
  final ktpFileController = BehaviorSubject<File>();

  //step2
  final selfieController = BehaviorSubject<File>();

  // Input
  final nameController = BehaviorSubject<String>();
  final noKtpController = BehaviorSubject<String>();
  final tempatLahirController = BehaviorSubject<String>();
  final tglLahirController = BehaviorSubject<DateTime>();
  final genderController = BehaviorSubject<int>();
  final statusPerkawinanController = BehaviorSubject<int>();
  final pendidikanTerakhirController = BehaviorSubject<int>();
  final agamaController = BehaviorSubject<int>();
  final npwpController = BehaviorSubject<String?>();
  final notHaveNpwpController = BehaviorSubject<bool>.seeded(false);
  final namaPasanganController = BehaviorSubject<String?>();
  final ibuKandungController = BehaviorSubject<String>();
  final statusRumahController = BehaviorSubject<int>();
  final lamaTinggalController = BehaviorSubject<int>();

  //step 4 controller
  final alamatController = BehaviorSubject<String>();
  final provinsiController = BehaviorSubject<int>();
  final kotaController = BehaviorSubject<int>();
  final kecamatanController = BehaviorSubject<String>();
  final kelurahanController = BehaviorSubject<String>();
  final kodePosController = BehaviorSubject<String>();

  //step 5 controller
  final otpController = BehaviorSubject<String>();
  final otpValidationController = BehaviorSubject<bool>();

  //message
  final messageController = BehaviorSubject<VerificationMessage>();

  // function
  void changeName(String name) => nameController.sink.add(name);
  void changenoKtp(String noktp) => noKtpController.sink.add(noktp);
  void changeTempatLahir(String tempatLahir) =>
      tempatLahirController.sink.add(tempatLahir);
  void changeTglLahir(DateTime tglLahir) =>
      tglLahirController.sink.add(tglLahir);
  void changegender(int gender) => genderController.sink.add(gender);
  void changeStatusKawin(int statusKawin) =>
      statusPerkawinanController.sink.add(statusKawin);
  void changePendTerakhir(int pendTerakhir) =>
      pendidikanTerakhirController.sink.add(pendTerakhir);
  void changeAgama(int agama) => agamaController.sink.add(agama);
  void changeNpwp(String? npwp) => npwpController.sink.add(npwp!);
  void changeNotHaveNpwp(bool status) => notHaveNpwpController.sink.add(status);
  void changeNamaPasangan(String? pasangan) =>
      namaPasanganController.sink.add(pasangan);
  void changeIbuKandung(String ibuKandung) =>
      ibuKandungController.sink.add(ibuKandung);
  void changeStatusRumah(int status) => statusRumahController.sink.add(status);
  void changeLamaTinggal(int lamaTinggal) =>
      lamaTinggalController.sink.add(lamaTinggal);
  void changeAlamat(String alamat) => alamatController.sink.add(alamat);

  //step 4
  void changeProvinsi(int provinsi) => provinsiController.sink.add(provinsi);
  void changeKota(int kota) => kotaController.sink.add(kota);
  void changeKecamatan(String kecamatan) =>
      kecamatanController.sink.add(kecamatan);
  void changeKelurahan(String kelurahan) =>
      kelurahanController.sink.add(kelurahan);
  void changeKodePos(String kodePos) => kodePosController.sink.add(kodePos);

  //step 5
  void changeOtp(String otp) => otpController.sink.add(otp);

  //step 1 stream
  Stream<File> get ktpFileStream => ktpFileController.stream;

  //step 2 stream
  Stream<File> get selfieFileStream => selfieController.stream;

  // Stream
  Stream<String> get nameStream =>
      nameController.stream.transform(validateName);

  Stream<String> get ktpStream => noKtpController.stream.transform(validateKtp);

  Stream<String> get tempatLahirStream =>
      tempatLahirController.stream.transform(validateTempatLahir);

  Stream<DateTime> get tglLahirStream =>
      tglLahirController.stream.transform(validateTglLahir);

  Stream<int> get genderStream =>
      genderController.stream.transform(validateGender);

  Stream<int> get statusKawinStream =>
      statusPerkawinanController.stream.transform(validateStatusKawin);
  Stream<int> get pendTerakhirStream =>
      pendidikanTerakhirController.stream.transform(validatePendTerakhir);

  Stream<int> get agamaStream =>
      agamaController.stream.transform(validateAgama);
  Stream<String?> get npwpStream =>
      npwpController.stream.transform(validateNpwp);
  Stream<bool> get notHaveNpwpStream => notHaveNpwpController.stream;
  Stream<String?> get namaPasanganStream =>
      namaPasanganController.stream.transform(validateNamaPasangan);
  Stream<String> get ibuKandungStream =>
      ibuKandungController.stream.transform(validateIbuKandung);
  Stream<int> get statusRumahStream =>
      statusRumahController.stream.transform(validateStatusRumah);
  Stream<int> get lamaTinggalStream =>
      lamaTinggalController.stream.transform(validateLamaTinggal);
  Stream<bool> get step3Button => Rx.combineLatest3(
        Rx.combineLatest4(
          ibuKandungStream,
          statusRumahStream,
          lamaTinggalStream,
          notHaveNpwpStream,
          (String? ibuKandung, int? statusRumah, int? lamaTinggal,
              bool statusNpwp) {
            final bool ibukandungValid = ibuKandung != null;
            final bool statusRumahValid = statusRumah != null;
            final bool lamaTinggalValid = lamaTinggal != null;
            final bool npwpValid = statusNpwp == true
                ? true
                : npwpController.value!.length == 15
                    ? true
                    : false;
            return ibukandungValid &&
                statusRumahValid &&
                lamaTinggalValid &&
                npwpValid;
          },
        ),
        Rx.combineLatest4(
          agamaStream,
          pendTerakhirStream,
          statusKawinStream,
          genderStream,
          (int? agama, int? pendTerakhir, int? status, int? gender) {
            final bool agamaValid = agama != null;
            final bool pendTerakhirValid = pendTerakhir != null;
            final bool statusValid = status != null;
            final bool genderValid =
                gender != null && (gender == 1 || gender == 2);
            return agamaValid &&
                pendTerakhirValid &&
                statusValid &&
                genderValid;
          },
        ),
        Rx.combineLatest4(
          nameStream,
          ktpStream,
          tempatLahirStream,
          tglLahirStream,
          (String name, String ktp, String tempatLahir, DateTime tglLahir) {
            final nameValid = name.length > 3 && name.isNotEmpty;
            final ktpValid = ktp.isNotEmpty && ktp.length == 16;
            final tempatLahirValid = tempatLahir.isNotEmpty;
            final tglLahirValid = !Validator.isLessThan18YearsFromNow(tglLahir);
            return nameValid && ktpValid && tempatLahirValid && tglLahirValid;
          },
        ),
        (bool isValid1, bool isValid2, bool isValid3) {
          return isValid1 && isValid2 && isValid3;
        },
      );

  //step 4
  Stream<String> get alamatStream =>
      alamatController.stream.transform(validateAlamat);
  Stream<int> get provinsiStream =>
      provinsiController.stream.transform(validateProvinsi);
  Stream<int> get kotaStream => kotaController.stream.transform(validateKota);
  Stream<String> get kecamatanStream =>
      kecamatanController.stream.transform(validateKecamatan);
  Stream<String> get kelurahanStream =>
      kelurahanController.stream.transform(validateKelurahan);
  Stream<String> get kodePosStream =>
      kodePosController.stream.transform(validateKodePos);
  Stream<bool> get step4Button => Rx.combineLatest6(
          alamatStream,
          provinsiStream,
          kotaStream,
          kecamatanStream,
          kelurahanStream,
          kodePosStream, (
        String alamat,
        int provinsi,
        int kota,
        String kecamatan,
        String kelurahan,
        String kodePos,
      ) {
        final bool alamatValid = alamat.isNotEmpty && alamat.length > 3;
        final bool provinsiValid = provinsi != 0;
        final bool kotaValid = kota != 0;
        final bool kecamatanValid = kecamatan.isNotEmpty;
        final bool kelurahanValid = kelurahan.isNotEmpty;
        final bool kodeposValid = kodePos.isNotEmpty && kodePos.length == 5;

        return alamatValid &&
            provinsiValid &&
            kotaValid &&
            kecamatanValid &&
            kelurahanValid &&
            kodeposValid;
      });

  //step 5
  Stream<bool> get otpStream => otpController.stream.transform(otpValidator);
  Stream<bool> get buttonOtpStream =>
      otpController.stream.map((otp) => otp.length == 6 && otp.isNotEmpty);
  Stream<bool> get otpValidationStream => otpValidationController.stream;

  //message stream
  Stream<VerificationMessage> get messageStream => messageController.stream;

  //step control
  Stream<int> get currentStep => stepController.stream;

  void nextStep() {
    int step = stepController.valueOrNull ?? 0;
    if (step < 4) {
      step++;
      stepController.sink.add(step);
    }
  }

  void prevStep() {
    int step = stepController.valueOrNull ?? 0;
    if (step > 0) {
      step--;
      stepController.sink.add(step);
    }
  }

  void otpValidate(String value) {
    if (value == '123456') {
      otpValidationController.sink.add(true);
    } else {
      otpValidationController.sink.add(false);
      otpValidationController.sink
          .addError('Kode OTP yang dimasukan tidak sesuai');
    }
  }

  void dispose() {
    stepController.close();
    nameController.close();
    noKtpController.close();
    tglLahirController.close();
    genderController.close();
    statusPerkawinanController.close();
    agamaController.close();
    pendidikanTerakhirController.close();
    npwpController.close();
    namaPasanganController.close();
    ibuKandungController.close();
    statusRumahController.close();
    lamaTinggalController.close();
    alamatController.close();
    provinsiController.close();
    kotaController.close();
    kecamatanController.close();
    kelurahanController.close();
    kodePosController.close();
    otpController.close();
  }

  //error validate
  final validateName = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) {
      if (text.length <= 3) {
        sink.addError('Nama minimal lebih dari 3 karakter.');
      } else {
        sink.add(text);
      }
    },
  );
  final validateKtp = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) {
      if (text.length != 16) {
        sink.addError('Nomor KTP harus 16 karakter.');
      } else {
        sink.add(text);
      }
    },
  );
  final validateTempatLahir = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) {
      if (text.isEmpty) {
        sink.addError('Tempat lahir wajib diisi');
      } else {
        sink.add(text);
      }
    },
  );
  final validateTglLahir = StreamTransformer<DateTime, DateTime>.fromHandlers(
    handleData: (date, sink) {
      if (Validator.isLessThan18YearsFromNow(date)) {
        sink.addError('Anda belum berusia 18 tahun');
      } else {
        sink.add(date);
      }
    },
  );
  final validateGender = StreamTransformer<int, int>.fromHandlers(
    handleData: (gender, sink) {
      if (gender.isNaN) {
        sink.addError('Jenis Kelamin wajib diisi');
      } else if (gender != 1 && gender != 2) {
        sink.addError('Jenis kelamin tidak valid');
      } else {
        sink.add(gender);
      }
    },
  );
  final validateStatusKawin = StreamTransformer<int, int>.fromHandlers(
    handleData: (status, sink) {
      if (status.isNaN) {
        sink.addError('Status Perkawinan wajib diisi');
      } else {
        sink.add(status);
      }
    },
  );
  final validatePendTerakhir = StreamTransformer<int, int>.fromHandlers(
    handleData: (status, sink) {
      if (status.isNaN) {
        sink.addError('Pendidikan Terakhir wajib diisi');
      } else {
        sink.add(status);
      }
    },
  );
  final validateAgama = StreamTransformer<int, int>.fromHandlers(
    handleData: (status, sink) {
      if (status.isNaN) {
        sink.addError('Agama wajib diisi');
      } else {
        sink.add(status);
      }
    },
  );

  final validateNpwp = StreamTransformer<String?, String?>.fromHandlers(
    handleData: (text, sink) {
      final String data = text!.replaceAll('.', '');
      final String npwp = data.replaceAll('-', '');
      if (npwp.length != 15) {
        sink.addError('NPWP Harus 15 karakter');
      } else {
        sink.add(text);
      }
    },
  );

  final validateNamaPasangan = StreamTransformer<String?, String?>.fromHandlers(
    handleData: (text, sink) {
      sink.add(text!);
    },
  );

  final validateIbuKandung = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) {
      if (text.isEmpty) {
        sink.addError('Nama Ibu Kandung Wajib Diisi');
      } else {
        sink.add(text);
      }
    },
  );

  final validateStatusRumah = StreamTransformer<int, int>.fromHandlers(
    handleData: (text, sink) {
      if (text.isNaN) {
        sink.addError('Status Rumah wajib diisi');
      } else {
        sink.add(text);
      }
    },
  );

  final validateLamaTinggal = StreamTransformer<int, int>.fromHandlers(
    handleData: (lamaTinggal, sink) {
      if (lamaTinggal.isNaN) {
        sink.addError('Lama Tinggal wajib diisi');
      } else {
        sink.add(lamaTinggal);
      }
    },
  );

  final validateAlamat = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) {
      if (text.length <= 3) {
        sink.addError('Alamat minimal lebih dari 3 karakter.');
      } else {
        sink.add(text);
      }
    },
  );

  //step 4
  final validateProvinsi = StreamTransformer<int, int>.fromHandlers(
    handleData: (provinsi, sink) {
      if (provinsi.isNaN) {
        sink.addError('Provinsi wajib diisi');
      } else {
        sink.add(provinsi);
      }
    },
  );
  final validateKota = StreamTransformer<int, int>.fromHandlers(
    handleData: (kota, sink) {
      if (kota.isNaN) {
        sink.addError('Kota wajib diisi');
      } else {
        sink.add(kota);
      }
    },
  );
  final validateKecamatan = StreamTransformer<String, String>.fromHandlers(
    handleData: (kecamatan, sink) {
      if (kecamatan.isEmpty) {
        sink.addError('Kecamatan wajib diisi');
      } else {
        sink.add(kecamatan);
      }
    },
  );
  final validateKelurahan = StreamTransformer<String, String>.fromHandlers(
    handleData: (kelurahan, sink) {
      if (kelurahan.isEmpty) {
        sink.addError('Kelurahan wajib diisi');
      } else {
        sink.add(kelurahan);
      }
    },
  );

  final validateKodePos = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) {
      if (text.length != 5) {
        sink.addError('Kode pos harus terdiri dari 5 karakter');
      } else {
        sink.add(text);
      }
    },
  );

  final otpValidator = StreamTransformer<String, bool>.fromHandlers(
    handleData: (otp, sink) {
      if (otp.length == 6) {
        sink.add(true);
      } else {
        sink.add(false);
      }
    },
  );

  void uploadKtp(BuildContext context) async {
    isLoadingController.add(true);
    final File? ktp = ktpFileController.valueOrNull;
    if (ktp == null) {
      context.showSnackBarError('Tidak ada file yang di unggah');
    } else {
      try {
        final response =
            await _apiService.masterUploadFile(ktp, 'ktp', 'ktp-borrower');
        final data = jsonDecode(response.body);
        debugPrint(response.body);
        if (response.isSuccessful) {
          debugPrint(response.body);
          final dataKtp = data['data']['ktp'];

          //auto fill data diri
          nameController.sink.add(dataKtp['nama']);
          noKtpController.sink.add(dataKtp['ktp']);
          tempatLahirController.sink.add(dataKtp['tempatlahir']);
          statusPerkawinanController.sink.add(dataKtp['status_nikah']);
          alamatController.sink.add(dataKtp['alamat_rumah']);
          provinsiController.sink.add(dataKtp['provinsi']);
          genderController.sink.add(dataKtp['jk']);
          getKotaByIdProvinsi(dataKtp['provinsi']);
          kecamatanController.sink.add(dataKtp['kecamatan']);
          kelurahanController.sink.add(dataKtp['kelurahan']);
          if (dataKtp['tanggal_lahir'] != '') {
            final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
            final DateTime parsedDate =
                dateFormat.parseStrict(dataKtp['tanggal_lahir']);
            tglLahirController.add(parsedDate.toLocal());
          }
          stepController.add(1);
        } else {
          messageController.sink.add(VerificationError(data['message'], data));
        }
      } catch (e) {
        debugPrint(e.toString());
        messageController.sink.add(VerificationError(e.toString(), e));
      }
    }
    isLoadingController.add(false);
  }

  void uploadSelfie(BuildContext context) async {
    isLoadingController.add(true);
    final File? selfie = selfieController.valueOrNull;
    if (selfie == null) {
      context.showSnackBarError('Tidak ada file yang di unggah');
    } else {
      try {
        final response = await _apiService.masterUploadFile(
            selfie, 'selfie', 'selfie-borrower');
        final data = jsonDecode(response.body);
        if (response.isSuccessful) {
          await saveToCacheBool('selfie_status', true);
          stepController.add(2);
        } else {
          messageController.sink.add(VerificationError(data['message'], data));
        }
      } catch (e) {
        messageController.sink.add(VerificationError(e.toString(), e));
      }
    }
    isLoadingController.add(false);
  }

  //init master data
  final statusPerkawinanList = BehaviorSubject<List<Map<String, dynamic>>>();
  final agamaList = BehaviorSubject<List<Map<String, dynamic>>>();
  final pendTerakhirList = BehaviorSubject<List<Map<String, dynamic>>>();
  final statusRumahList = BehaviorSubject<List<Map<String, dynamic>>>();
  final provinsiList = BehaviorSubject<List<Map<String, dynamic>>>();

  final kotaList = BehaviorSubject<List<Map<String, dynamic>>?>();
  void initGetMasterData() async {
    //read cache
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //step validation
    // final ktpFileCache = prefs.getString('ktp_file');
    // if (ktpFileCache != null) {
    //   ktpFileController.sink.add(File(ktpFileCache));
    // }
    // final selfieFileCache = prefs.getString('selfie_file');
    // if (selfieFileCache != null) {
    //   selfieController.sink.add(File(selfieFileCache));
    // }

    getProvinsi();
    getStatusKawinList();
    getAgama();
    getPendTerakhir();
    getStatusRumah();
  }

  void getStatusKawinList() async {
    final response = await _apiService.getMaster('status_perkawinan', null);
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['data'];
      statusPerkawinanList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getAgama() async {
    final response = await _apiService.getMaster('agama', null);
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['data'];
      agamaList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getPendTerakhir() async {
    final response = await _apiService.getMaster('pendidikan', null);
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['data'];
      pendTerakhirList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getStatusRumah() async {
    final response = await _apiService.getMaster('status_rumah', null);

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['data'];
      statusRumahList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getProvinsi() async {
    final response = await _apiService.getMaster('provinsi', null);

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['data'];
      provinsiList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getKotaByIdProvinsi(int idprov) async {
    final response =
        await _apiService.getMaster('kotaByProvinsi', 'idprovinsi=$idprov');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      kotaList.sink.add(List<Map<String, dynamic>>.from(data));
      print(kotaList.value);
    } else {
      print(response.body);
    }
  }

  void postToPrivy(BuildContext context) async {
    isLoadingController.add(true);
    final String tglLahir =
        DateFormat('yyyy-MM-dd').format(tglLahirController.value);
    // Map<String, dynamic> payloadv2 = {
    //   "nama_borrower": nameController.value,
    //   "ktp": noKtpController.value.toString(),
    //   "tempat_lahir": tempatLahirController.value,
    //   "tanggal_lahir": tglLahir,
    //   "idjenis_kelamin": genderController.value,
    //   "idstatus_perkawinan": statusPerkawinanController.value,
    //   "pendidikan_terakhir": pendidikanTerakhirController.value.toString(),
    //   "id_agama": agamaController.value,
    //   "nwp": npwpController.valueOrNull ?? "",
    //   "nama_pasangan": namaPasanganController.valueOrNull ?? "",
    //   "ktp_pasangan": "",
    //   "ibu_kandung": ibuKandungController.value,
    //   "idstatus_rumah": statusRumahController.value,
    //   "lama_tinggal": lamaTinggalController.value,
    //   "alamat_rumah": alamatController.value,
    //   "kelurahan": kelurahanController.value,
    //   "kecamatan": kecamatanController.value,
    //   "kota": kotaController.value,
    //   "provinsi": provinsiController.value,
    //   "kode_pos": kodePosController.value,
    //   "pekerjaan": "",
    //   "isAktivasi": 9
    // };
    final Map<String, dynamic> payloadv1 = {
      'nama_borrower': nameController.value,
      'nik': noKtpController.value,
      'tempat_lahir': tempatLahirController.value,
      'tanggal_lahir': tglLahir,
      'id_jenis_kelamin': genderController.value.toString(),
      'id_status_perkawinan': statusPerkawinanController.value.toString(),
      'id_pendidikan': pendidikanTerakhirController.value.toString(),
      'id_agama': agamaController.value.toString(),
      'npwp': npwpController.valueOrNull ?? '',
      'nama_pasangan': namaPasanganController.valueOrNull ?? '',
      'ktp_pasangan': '',
      'ibu_kandung': ibuKandungController.value,
      'id_status_rumah': statusRumahController.value.toString(),
      'lama_tinggal': lamaTinggalController.value.toString(),
      'alamat_rumah': alamatController.value,
      'kelurahan': kelurahanController.value.toString(),
      'kecamatan': kecamatanController.value.toString(),
      'id_kota': kotaController.value.toString(),
      'id_provinsi': provinsiController.value.toString(),
      'kode_pos': kodePosController.value,
      'pekerjaan': '',
      // "isAktivasi": 9
      'id_pekerjaan': '1',
    };
    try {
      final response = await _apiService.postRegisPrivyV1(payloadv1);
      final data = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        messageController.sink.add(const VerificationSuccess());
        await _apiService.setBeranda();
      } else {
        messageController.sink.add(VerificationError(data['message'], data));
      }
    } catch (e) {
      messageController.sink.add(VerificationError(e.toString(), e));
    }
    isLoadingController.add(false);
  }
}
