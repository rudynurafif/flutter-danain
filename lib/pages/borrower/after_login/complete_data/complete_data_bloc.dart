import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/after_login/complete_data/component.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

import 'complete_data_state.dart';

class CompleteDataBloc {
  final stepController = BehaviorSubject<int>();

  //step 1
  final sumberDanaController = BehaviorSubject<int>();
  final jenisPekerjaanController = BehaviorSubject<String>();
  final jabatanController = BehaviorSubject<String>();
  final bidangUsahaController = BehaviorSubject<String>();
  final namaPerusahaanController = BehaviorSubject<String>();
  final alamatPerusahaanController = BehaviorSubject<String>();
  final provinsiController = BehaviorSubject<int>();
  final kotaController = BehaviorSubject<int?>();
  final kodePosController = BehaviorSubject<int>();
  final lamaBekerjaController = BehaviorSubject<int>();
  final penghasilanPerbulanController = BehaviorSubject<int>();
  final biayaHidupBulananController = BehaviorSubject<int>();

  //step 2
  final bankController = BehaviorSubject<int>();
  final bankNameController = BehaviorSubject<String>();
  final noRekController = BehaviorSubject<String>();
  final kotaBankController = BehaviorSubject<String>();

  //message
  final messageController = BehaviorSubject<CompleteDataMessage>();

  Stream<int> get sumberDanaStream => sumberDanaController.stream;
  Stream<String> get jenisPekerjaanStream => jenisPekerjaanController.stream;
  Stream<String> get jabatanStream => jabatanController.stream;
  Stream<String> get bidangUsahaStream => bidangUsahaController.stream;
  Stream<String> get namaPerusahaanStream => namaPerusahaanController.stream;
  Stream<String> get alamatPerusahaanStream =>
      alamatPerusahaanController.stream;
  Stream<int> get provinsiStream => provinsiController.stream;
  Stream<int?> get kotaStream => kotaController.stream;
  Stream<int> get kodePosStream => kodePosController.stream;
  Stream<int> get lamaKerjaStream => lamaBekerjaController.stream;
  Stream<int> get penghasilanBulananStream =>
      penghasilanPerbulanController.stream;
  Stream<int> get biayaHidupStream => biayaHidupBulananController.stream;

  Stream<bool> get step1Button => Rx.combineLatest3(
        Rx.combineLatest4(
          sumberDanaStream,
          jenisPekerjaanStream,
          jabatanStream,
          bidangUsahaStream,
          (int sumberDana, String jenikerja, String jabatan,
              String bidangUsaha) {
            return sumberDana != 0 &&
                jenikerja.length > 0 &&
                jabatan.length > 0 &&
                bidangUsaha.length > 0;
          },
        ),
        Rx.combineLatest5(
          namaPerusahaanStream,
          alamatPerusahaanStream,
          provinsiStream,
          kotaStream,
          kodePosStream,
          (String namaPerusahaan, String alamatPerusahaan, int provinsi,
              int? kota, int kodePos) {
            return namaPerusahaan.length > 0 &&
                alamatPerusahaan.length > 0 &&
                provinsi != 0 &&
                kota != 0 &&
                kota != null &&
                kodePos != -1;
          },
        ),
        Rx.combineLatest3(
          lamaKerjaStream,
          penghasilanBulananStream,
          biayaHidupStream,
          (int lamaKerja, int penghasilan, int biayaHidup) {
            return [lamaKerja, penghasilan, biayaHidup]
                .every((value) => value != -1);
          },
        ),
        (bool isValid1, bool isValid2, bool isValid3) {
          return isValid1 && isValid2 && isValid3;
        },
      );

  //step 2
  Stream<int> get bankStream => bankController.stream;
  Stream<String> get bankNameStream => bankNameController.stream;
  Stream<String> get noRekStream => noRekController.stream;
  Stream<String> get kotaBankStream => kotaBankController.stream;

  Stream<bool> get buttonStep2 =>
      Rx.combineLatest3(bankStream, noRekStream, kotaBankStream,
          (int bank, String noRek, String kotaBank) {
        return bank != 0 && noRek.length > 0 && kotaBank.length > 0;
      });

  //message stream
  //message stream
  Stream<CompleteDataMessage> get messageStream => messageController.stream;

  void dispose() {
    sumberDanaController.close();
    jenisPekerjaanController.close();
    jabatanController.close();
    bidangUsahaController.close();
    namaPerusahaanController.close();
    alamatPerusahaanController.close();
    provinsiController.close();
    kotaController.close();
    kodePosController.close();
    lamaBekerjaController.close();
    penghasilanPerbulanController.close();
    biayaHidupBulananController.close();

    //step 2
    bankController.close();
    noRekController.close();
    kotaBankController.close();

    messageController.close();
  }

  void changePerusahaan(String val) {
    namaPerusahaanController.sink.add(val);
    if (val.length < 1) {
      namaPerusahaanController.sink.addError('Nama Perusahaan Wajib diisi');
    }
  }

  void changeCompanyAddress(String val) {
    alamatPerusahaanController.sink.add(val);
    if (val.length < 1) {
      alamatPerusahaanController.sink.addError('Alamat Perusahaan Wajib diisi');
    }
  }

  void changeProvinsi(int val) {
    getKotaByIdProvinsi(val);
    provinsiController.sink.add(val);
    kotaController.sink.add(null);
    if (val == 0) {
      provinsiController.sink.addError('Provinsi Perusahaan Wajib diisi');
    }
  }

  void changeKota(int val) {
    kotaController.sink.add(val);
    if (val == 0) {
      kotaController.sink.addError('Kota/Kabupaten Perusahaan Wajib diisi');
    }
  }

  void changeKodePos(String val) {
    final data = int.tryParse(val);
    if (val.length < 1) {
      kodePosController.sink.add(-1);
      kodePosController.sink.addError('Kode Pos Wajib diisi');
    } else {
      kodePosController.sink.add(data!);
    }

    if (val.length != 5) {
      kodePosController.sink.addError('Kode Pos Wajib 5 karakter');
    }
  }

  void changeLamaBekerja(String val) {
    final data = int.tryParse(val);
    if (val.length < 1) {
      lamaBekerjaController.sink.add(-1);
      lamaBekerjaController.sink.addError('Lama Bekerja Wajib diisi');
    } else {
      lamaBekerjaController.sink.add(data!);
    }
  }

  void changePenghasilanBulanan(String val) {
    String replace = val.replaceAll('Rp ', '').replaceAll('.', '');
    final data = int.tryParse(replace);

    if (val.length < 1) {
      penghasilanPerbulanController.sink.add(-1);
      penghasilanPerbulanController.sink
          .addError('Penghasilan Bulanan Wajib diisi');
    } else {
      penghasilanPerbulanController.sink.add(data!);
    }
  }

  void changeBiayaHidup(String val) {
    String replace = val.replaceAll('Rp ', '').replaceAll('.', '');
    final data = int.tryParse(replace);

    if (val.length < 1) {
      biayaHidupBulananController.sink.add(-1);
      biayaHidupBulananController.sink
          .addError('Biaya Hidup Bulanan Wajib diisi');
    } else {
      biayaHidupBulananController.sink.add(data!);
    }
  }

  //step 2
  void changeNoRek(String val) {
    if (val.length < 1) {
      noRekController.sink.addError('Nomor Rekening Wajib Diisi');
    } else {
      noRekController.sink.add(val);
    }
  }

  void changeKotaBank(String val) {
    if (val.length < 1) {
      kotaBankController.sink.addError('Kota Bank Wajib Diisi');
    } else {
      kotaBankController.sink.add(val);
    }
  }

  void validateBank(BuildContext context) async {
    final response = await _apiService.validateBank(
      bankController.value,
      noRekController.value,
    );
    final responseBody = jsonDecode(response.body);
    final data = responseBody['data'];
    print(response.body);
    if (responseBody['status'] == 200) {
      print(response.body);
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return CheckInfoBank(
            bankName: data['bankAccount'],
            nama: data['customerName'],
            kotaBank: kotaBankController.value,
            noRek: data['accountNumber'],
            isValid: true,
            action: () {
              Navigator.pop(context);
              postDataPendukung(data['customerName']);
            },
          );
        },
      );
    } else if (responseBody['status'] == 201) {
      print(response.body);
      final dataR = data['data'];
      // ignore: use_build_context_synchronously
      unawaited(showModalBottomSheet(
        context: context,
        builder: (context) {
          return CheckInfoBank(
            bankName: dataR['bankAccount'],
            nama: dataR['customerName'],
            kotaBank: kotaBankController.value,
            noRek: dataR['accountNumber'],
            isValid: false,
          );
        },
      ));
    } else {
      context.showSnackBarError(responseBody['message']);
    }
  }

  void postDataPendukung(String anRek) async {
    Map<String, dynamic> payload = {
      'sumber_dana_utama': sumberDanaController.value,
      'pekerjaan': jenisPekerjaanController.value,
      'jabatan': jabatanController.value,
      'bidang_usaha_perusahaan': bidangUsahaController.value,
      'nama_perusahaan': namaPerusahaanController.value,
      'alamat_perusahaan': alamatPerusahaanController.value,
      'kota_perusahaan': kotaController.value,
      'provinsi_perusahaan': provinsiController.value,
      'kode_pos_perusahaan': kodePosController.value,
      'lama_bekerja': lamaBekerjaController.value,
      'penghasilan_per_bulan': penghasilanPerbulanController.value,
      'biaya_hidup_per_bulan': biayaHidupBulananController.value,
      'status_pekerjaan': 1,
      'no_rekening': noRekController.value,
      'an_rekening': anRek,
      'id_bank': bankController.value,
      'kota_bank': kotaBankController.value,
      'is_active': 1,
      'idRekening': 0
    };
    try {
      final response = await _apiService.completeData(payload);
      print(response.body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        messageController.sink.add(CompleteDataSuccess());
        await _apiService.setBeranda();
      } else {
        messageController.sink.add(CompleteDataError(data['message'], data));
      }
    } catch (e) {
      messageController.sink.add(CompleteDataError(e.toString(), e));
    }
  }

  final sumberDanaList = BehaviorSubject<List<Map<String, dynamic>>>();
  final jenisPekerjaanList = BehaviorSubject<List<Map<String, dynamic>>>();
  final jabatanList = BehaviorSubject<List<Map<String, dynamic>>>();
  final bidangUsahaList = BehaviorSubject<List<Map<String, dynamic>>>();
  final provinsiList = BehaviorSubject<List<Map<String, dynamic>>>();
  final bankList = BehaviorSubject<List<Map<String, dynamic>>>();

  final kotaList = BehaviorSubject<List<Map<String, dynamic>>?>();

  void initGetMasterData() async {
    getSumberDana();
    getPekerjaan();
    getBidangUsaha();
    getJabatan();
    getProvinsi();
    getBank();
  }

  void getSumberDana() async {
    final response = await _apiService.getMaster('sumber_dana', null);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      sumberDanaList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getPekerjaan() async {
    final response = await _apiService.getMaster('pekerjaan', null);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      jenisPekerjaanList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getBidangUsaha() async {
    final response = await _apiService.getMaster('sektor_kelompok', null);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      bidangUsahaList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getJabatan() async {
    final response = await _apiService.getMaster('jabatan', null);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      jabatanList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getProvinsi() async {
    final response = await _apiService.getMaster('provinsi', null);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      provinsiList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getBank() async {
    final response = await _apiService.getMaster('bank', null);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      bankList.sink.add(List<Map<String, dynamic>>.from(data));
    } else {
      print(response.body);
    }
  }

  void getKotaByIdProvinsi(int idprov) async {
    print('==== ini di kota bang ======');
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

  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
}
