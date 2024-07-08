import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class SimulasiCicilanBloc {
  final isReady = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isReadyStream => isReady.stream;

  //step
  // "1" adalah halaman awal
  // "2" adalah halaman pencarian emas
  final stepControl = BehaviorSubject<int>.seeded(1);
  Stream<int> get stepStream => stepControl.stream;

  //master list emas
  final masterEmasList = BehaviorSubject<List<dynamic>>();
  Stream<List<dynamic>> get masterEmasStream => masterEmasList.stream;

  final jenisEmasList = BehaviorSubject<List<dynamic>>.seeded([]);
  Stream<List<dynamic>> get jenisEmasListStream => jenisEmasList.stream;

  //tenor
  final tenorListController =
      BehaviorSubject<List<ListProductResponse>>.seeded([]);
  Stream<List<ListProductResponse>> get tenorListStream =>
      tenorListController.stream;
  final tenorController = BehaviorSubject<int>();
  Stream<int> get tenorStream => tenorController.stream;

  final idProductController = BehaviorSubject<int>();
  Stream<int> get idProductStream => idProductController.stream;

  //jenis emas selected
  final jenisEmasSelected =
      BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);
  Stream<List<Map<String, dynamic>>> get jenisEmasSelectedStream =>
      jenisEmasSelected.stream;

  final totalHarga = BehaviorSubject<int>.seeded(0);
  Stream<int> get totalHargaStream => totalHarga.stream;

  final idEmasSelected = BehaviorSubject<int>();
  Stream<int> get idEmasSelectedStream => idEmasSelected.stream;

  //angsuran
  final angsuranPertamaControl = BehaviorSubject<Map<String, dynamic>>();
  final listAngsuran = BehaviorSubject<List<dynamic>>.seeded([]);
  final totalAngsuran = BehaviorSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get angsuranPertamaStream =>
      angsuranPertamaControl.stream;

  Stream<List<dynamic>> get listAngsuranStream => listAngsuran.stream;

  Stream<Map<String, dynamic>> get totalAngsuranStream => totalAngsuran.stream;

  void iniGetMaster() async {
    //get tenor
    final List<ListProductResponse> dataTenor =
        await _apiService.getListProduct(2);
    tenorListController.sink.add(dataTenor);

    final ListProductResponse initTenor = dataTenor.where((element) => element.tenor == 6).first;
    tenorController.sink.add(initTenor.tenor);
    idProductController.sink.add(initTenor.id);

    //get list Emas
    try {
      final List<dynamic> dataEmasMaster = await _apiService.getMasterJenisEmas();
      masterEmasList.sink.add(dataEmasMaster);
      print(masterEmasList.value);
    } catch (e) {
      print(e.toString());
    }

    final masterEmas = masterEmasList.value;
    final Map<String, dynamic> emasFirst = masterEmas[0];
    idEmasSelected.sink.add(emasFirst['idJenisEmas']);
    try {
      final List<dynamic> jenisEmasRes = await _apiService.getListJenisEmas(emasFirst['namaJenisEmas'], 1);
      jenisEmasList.sink.add(jenisEmasRes);
      print(jenisEmasList.value.toString());
    } catch (e) {
      print(e.toString());
    }
    isReady.sink.add(true);
  }

  void dispose() {
    masterEmasList.close();
    tenorController.close();
    jenisEmasList.close();
    tenorListController.close();
  }

  void getJenisEmas(String namaJenisEmas, int page) async {
    try {
      final List<dynamic> jenisEmasRes =
          await _apiService.getListJenisEmas(namaJenisEmas, page);
      jenisEmasList.sink.add(jenisEmasRes);
      print(jenisEmasList.value.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void calculateSimulasi() async {
    final detailEmas = jenisEmasSelected.valueOrNull ?? [];
    final totalHargaStore = totalHarga.valueOrNull ?? 0;
    final idProduct = idProductController.valueOrNull ?? 11;
    final tenor = tenorController.valueOrNull ?? 12;
    if (detailEmas.isEmpty) {
      angsuranPertamaControl.sink.add({});
      listAngsuran.sink.add([]);
      totalAngsuran.sink.add({});
      totalHarga.sink.add(0);
    } else {
      try {
        final response = await _apiService.calculateSimulasiCicilan(
          detailEmas,
          totalHargaStore,
          idProduct,
          tenor,
          0
        );
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final dataBody = jsonDecode(response.body);
          final data = dataBody['data'];
          angsuranPertamaControl.sink.add(data['angsuranPertama']);
          listAngsuran.sink.add(data['skemaPembayaran']);
          totalAngsuran.sink.add(data['totalAngsuranBulan']);
        } else {}
      } catch (e) {
        print(e.toString());
      }
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
