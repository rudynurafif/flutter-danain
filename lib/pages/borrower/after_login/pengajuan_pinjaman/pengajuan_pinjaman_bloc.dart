import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class PengajuanPinjamanBloc {
  final ApiService apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
  final havePinjaman = BehaviorSubject<bool>.seeded(false);
  final agunanFile = BehaviorSubject<File>();
  final buktiAgunanFile = BehaviorSubject<File?>();
  final tujuanPinjamanController = BehaviorSubject<String>();
  final kuponController = BehaviorSubject<String?>.seeded(null);
  final messageSuccessController = BehaviorSubject<String?>.seeded(null);
  final agunanController = BehaviorSubject<String?>.seeded(null);
  final buktiBeliController = BehaviorSubject<String?>.seeded(null);
  final kuponTemController = BehaviorSubject<String?>.seeded(null);
  final buttonGunakanController = BehaviorSubject<bool>.seeded(false);
  final dataPinjaman = BehaviorSubject<String>();
  // 1 fdc not ready
  // 2 fdc true
  // 3 fdc false
  // 4 fdc error
  final fdcController = BehaviorSubject<int>.seeded(1);

  Stream<bool> get statusPinjaman => havePinjaman.stream;
  Stream<File> get agunanFileStream => agunanFile.stream;
  Stream<File?> get buktiAgunanFileStream => buktiAgunanFile.stream;
  Stream<String> get tujuanPinjamanStream => tujuanPinjamanController.stream;
  Stream<String?> get kuponTempStream => kuponTemController.stream;
  Stream<String?> get kuponStream => kuponController.stream;
  Stream<String?> get messageSuccessStream => messageSuccessController.stream;
  Stream<bool> get buttonGunakanStream => buttonGunakanController.stream;
  Stream<int> get fdcStream => fdcController.stream;
  Stream<bool> get buttonPinjamanStream => Rx.combineLatest2(
        agunanFile,
        tujuanPinjamanStream,
        (
          File agunan,
          String tujuan,
        ) {
          final bool agunanValid = agunan != Null;
          final bool tujuanValid = tujuan != Null;
          return agunanValid && tujuanValid;
        },
      );

  Stream<String> get dataPinjamanStream => dataPinjaman.stream;

  void dispose() {
    havePinjaman.close();
    agunanFile.close();
    buktiAgunanFile.close();
    tujuanPinjamanController.close();
    kuponController.close();
    buktiBeliController.close();
    agunanController.close();
    kuponTemController.close();
    messageSuccessController.close();
    buttonGunakanController.close();
  }

  void requestCheckHavePinjaman() async {
    // final response = await apiService.checkPinjaman();
    // dataPinjaman.sink.add(response);
    havePinjaman.sink.add(true);
  }

  void changeKupon(String kupon) {
    if (kupon.isNotEmpty) {
      buttonGunakanController.sink.add(true);
    } else {
      kuponTemController.sink.add(null);
      buttonGunakanController.sink.add(false);
    }
  }

  Future<String?> tokenFromCache() async {
    final prefs = RxSharedPreferences.getInstance();
    return await prefs.getString('token');
  }

  void uploadMaster(BuildContext context, String category, String type) async {
    final File? filePhoto = category == 'jaminan'
        ? agunanFile.valueOrNull
        : buktiAgunanFile.valueOrNull;
    print('file photo $category $filePhoto');
    if (filePhoto == null) {
      context.showSnackBarError('Tidak ada file yang di unggah');
    } else {
      try {
        final response =
            await apiService.masterUploadFile(filePhoto, category, type);
        final data = jsonDecode(response.body);
        print(data['data']['jaminan']);
        print(type);
        print('masuk di atas yah');
        if (type == 'jaminan') {
          print('jaminan');
          agunanController.sink.add(data['data']['jaminan'].toString());
        } else {
          print('bukti beli');
          buktiBeliController.sink.add(data['data']['bukti_beli'].toString());
        }
        print('masuk di bawah yah');
      } catch (e) {}
    }
  }

  void gunakanKuponPress(String kupon) async {
    final response = await apiService.getKupon(kupon);
    print('check kupon ${response.body}');
    final responseCallbackKupon = json.decode(response.body);
    final statusKupon = responseCallbackKupon['data']['Status'];
    final errorMessage = responseCallbackKupon['data']['Message'];
    final dataKupon = responseCallbackKupon['data']['Data']['nama_event'];
    if (statusKupon == false) {
      kuponTemController.addError(errorMessage);
    } else {
      kuponTemController.add(kupon);
      buttonGunakanController.add(false);
      messageSuccessController.add(dataKupon);
    }
    kuponController.add(kuponTemController.value!);
  }

  void checkFdc() async {
    try {
      final token = await tokenFromCache();
      final response = await apiService.getCheckFdcs(token ?? '');
      print('fdc message ${response.body}');
      final data = jsonDecode(response.body);
      if (data['data']['fdc'] == true) {
        fdcController.add(2);
      } else {
        fdcController.add(3);
      }
    } catch (e) {
      print('errornya fdc: ${e.toString()}');
      fdcController.add(4);
    }
  }

  void batalkanKupon() {
    messageSuccessController.sink.add(null);
    kuponController.sink.add(null);
  }

// ...

  void ajukanPinjaman() async {
    final response = await apiService.postPinjaman(
      agunanController.valueOrNull,
      buktiBeliController.valueOrNull,
      tujuanPinjamanController.value,
      kuponController.valueOrNull,
    );

    print(
        '====================== response ajukan pinjaman ============================');
    print(agunanController.valueOrNull);
    print(buktiBeliController.valueOrNull);
    print(
        '====================== response ajukan pinjaman ============================');

    dataPinjaman.sink.add(response.toString());
    havePinjaman.sink.add(true);
  }
}
