import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/data/remote/response/mitra_terdekat_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class PenyimpanEmasBloc {
  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
  //step 4 controller
  final provinsiController = BehaviorSubject<int>();
  final kotaController = BehaviorSubject<int?>();
  final mitraController = BehaviorSubject<List<MitraTerdekatResponse>>();

  Stream<int> get provinsiStream => provinsiController.stream;
  Stream<int?> get kotaStream => kotaController.stream;
  Stream<List<MitraTerdekatResponse>> get mitraStream => mitraController.stream;
  Stream<bool> get buttonSearchStream =>
      Rx.combineLatest2(provinsiStream, kotaStream, (int? provinsi, int? kota) {
        return provinsi != null && kota != null;
      });

  void dispose() {
    provinsiController.close();
    kotaController.close();
    mitraController.close();
  }

  void changeProvinsi(int provinsi) {
    provinsiController.sink.add(provinsi);
    getKota(provinsi);
    kotaController.sink.add(null);
  }

  void changeKota(int kota) {
    kotaController.sink.add(kota);
  }

  void initGetData(String? provinsiName) async {
    final List<Map<String, dynamic>> resultProvinsi =
        await _apiService.fetchProvince();
    final List<Map<String, dynamic>> provinsiData = [];
    for (var i = 0; i < resultProvinsi.length; i++) {
      provinsiData.add({
        'id': resultProvinsi[i]['id_provinsi'],
        'display': resultProvinsi[i]['nama_provinsi']
      });
    }

    for (var i = 0; i < resultProvinsi.length; i++) {
      if (provinsiName != null) {
        String targetName =
            resultProvinsi[i]['nama_provinsi'].toString().toLowerCase();
        if (targetName.contains(provinsiName.toLowerCase())) {
          provinsiController.sink.add(resultProvinsi[i]['id_provinsi']);
          getKota(resultProvinsi[i]['id_provinsi']);
          break;
        }
      }
    }
    listProvinsi.sink.add(provinsiData);
  }

  void getKota(int idProvinsi) async {
    final List<Map<String, dynamic>> kotaRes =
        await _apiService.fetchCity(idProvinsi);
    final List<Map<String, dynamic>> kotaData = [];
    for (var i = 0; i < kotaRes.length; i++) {
      kotaData.add({
        'id': kotaRes[i]['id_kabupaten'],
        'display': kotaRes[i]['nama_kabupaten']
      });
    }
    listKota.sink.add(kotaData);
  }

  void getMitra(BuildContext context) async {
    final int? provinsi = provinsiController.valueOrNull;
    final int? kota = kotaController.valueOrNull;

    final response = await _apiService.getMitraTerdekat(provinsi!, kota!);
    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> dataResponse = jsonBody['data'];
      final List<MitraTerdekatResponse> data = dataResponse
          .map((item) => MitraTerdekatResponse.fromJson(item))
          .toList();
      mitraController.sink.add(data);
    } else {
      // ignore: use_build_context_synchronously
      context.showSnackBarError(jsonBody['message']);
    }
  }

  final listProvinsi = BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);
  final listKota = BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);
}
