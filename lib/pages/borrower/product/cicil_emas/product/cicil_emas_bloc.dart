import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/cicil_emas_req_use_case.dart';
import 'package:flutter_danain/domain/usecases/cicil_emas_val_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:location/location.dart' as loc;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class CicilEmas2Bloc extends DisposeCallbackBaseBloc {
  final Function1<bool, void> isLoadingChange;
  final Stream<bool> isLoading;

  final Function0<void> initGetAllData;
  final Function1<int, void> stepChange;
  final Function1<int, void> tenorChange;
  final Function1<int, void> idProdukChange;
  final Function1<List<Map<String, dynamic>>, void> emasSelectedControl;
  final Function1<int, void> totalHargaChange;
  final Function0<void> infinineScroll;
  final Function0<void> filterControl;
  final Function1<bool, void> setujuControl;
  final Function1<String, void> getKupon;
  final Function0<void> makeNullEmas;
  final Function1<int, void> calculateCicilan;
  final Function0<void> checkFdc;
  final Function0<void> getMasterBank;

  //control param
  final Function1<int, void> urutkanChange;
  final Function1<List<int>, void> jenisEmasChange;
  final Function1<String?, void> minChange;
  final Function1<String?, void> maxChange;
  final Function1<String?, void> karatChange;
  final Function1<String?, void> gramChange;
  final Function3<String, int, bool, void> searchEmasByString;
  final Function0<void> makeNullVoucher;

  //stream
  final Stream<int> isValidStream$;
  final Stream<int> stepStream$;
  final Stream<bool> isPageStream$;
  final Stream<String> locationStream$;
  final Stream<List<dynamic>> listEmasStream$;
  final Stream<Map<String, dynamic>> supplierStream$;
  final Stream<bool> isLoadingStream$;
  final Stream<List<dynamic>> masterJenisEmasStream$;
  final Stream<List<ListProductResponse>> listProduct$;
  final Stream<bool> setujuStream;
  final Stream<List<dynamic>?> emasBySearch;
  final Stream<String> noHpStream$;
  final Stream<int> totalEmas;
  final Stream<String?> kuponAktifStream$;
  final Stream<double> distance;
  final Stream<Map<String, dynamic>> caraBayarStream;

  //result stream
  final Stream<Map<String, dynamic>> angsuranPertamaStream;
  final Stream<List<dynamic>> listAngsuranStream;
  final Stream<Map<String, dynamic>> totalAngsuran;
  final Stream<Map<String, dynamic>> detailPembayaran;
  final Stream<int> totalPembayaran;
  final Stream<Map<String, dynamic>> infoAngsuran;
  final Stream<Map<String, dynamic>?> kuponStream;
  final Stream<Map<String, dynamic>> mitraStream;

  //params stream
  final Stream<int> urutkanParam;
  final Stream<List<int>> jenisEmasParam;
  final Stream<int> minParam;
  final Stream<int> maxParam;
  final Stream<int> karatParam;
  final Stream<int> gramParam;

  //payload stream
  final Stream<List<Map<String, dynamic>>> jenisEmasSelected$;
  final Stream<int> totalHargaStream$;
  final Stream<int> tenorStream$;

  //trigger post
  final Function0<void> reqOtpClick;
  final Function1<String, void> kodeCheckoutChange;
  final Function1<String, void> otpChange;
  final Function1<String?, void> otpErrorChange;
  final Stream<String> otpStream$;
  final Stream<String?> otpErrorStream$;
  final Stream<dynamic> documentPerjanjian;

  final Stream<bool> isLoadingCalculate;
  final Stream<bool> buttonTerapkan;

  //trigger validate otp
  final Function0<void> valOtpClick;
  final Function1<Map<String, dynamic>, void> resultChange;
  final Stream<Map<String, dynamic>> resultValidate;
  //message
  final Stream<CicilEmasMessage?> messageFdc;
  final Stream<CicilEmasMessage?> messageReqOtp;
  final Stream<CicilEmasMessage?> messageValidateOtp;
  final Stream<CicilEmasMessage?> messageCalculate;

  CicilEmas2Bloc._({
    required this.stepChange,
    required this.isValidStream$,
    required this.initGetAllData,
    required this.stepStream$,
    required this.isPageStream$,
    required this.locationStream$,
    required this.listEmasStream$,
    required this.supplierStream$,
    required this.jenisEmasSelected$,
    required this.idProdukChange,
    required this.tenorChange,
    required this.tenorStream$,
    required this.totalHargaStream$,
    required this.totalHargaChange,
    required this.emasSelectedControl,
    required this.infinineScroll,
    required this.isLoadingStream$,
    required this.masterJenisEmasStream$,
    required this.listProduct$,
    required this.filterControl,
    required this.jenisEmasParam,
    required this.maxParam,
    required this.minParam,
    required this.urutkanParam,
    required this.jenisEmasChange,
    required this.maxChange,
    required this.minChange,
    required this.urutkanChange,
    required this.karatChange,
    required this.gramChange,
    required this.gramParam,
    required this.karatParam,
    required this.angsuranPertamaStream,
    required this.listAngsuranStream,
    required this.totalAngsuran,
    required this.calculateCicilan,
    required this.detailPembayaran,
    required this.infoAngsuran,
    required this.totalPembayaran,
    required this.setujuControl,
    required this.setujuStream,
    required this.getKupon,
    required this.kuponStream,
    required this.makeNullEmas,
    required this.emasBySearch,
    required this.searchEmasByString,
    required this.checkFdc,
    required this.messageFdc,
    required this.mitraStream,
    required this.makeNullVoucher,
    required this.messageReqOtp,
    required this.reqOtpClick,
    required this.kodeCheckoutChange,
    required this.noHpStream$,
    required this.otpChange,
    required this.otpErrorChange,
    required this.otpStream$,
    required this.otpErrorStream$,
    required this.totalEmas,
    required this.messageValidateOtp,
    required this.resultChange,
    required this.resultValidate,
    required this.valOtpClick,
    required this.kuponAktifStream$,
    required this.distance,
    required this.caraBayarStream,
    required this.getMasterBank,
    required this.isLoading,
    required this.isLoadingChange,
    required this.documentPerjanjian,
    required this.isLoadingCalculate,
    required this.buttonTerapkan,
    required this.messageCalculate,
    required Function0<void> dispose,
  }) : super(dispose);

  factory CicilEmas2Bloc(
    GetAuthStateStreamUseCase getAuthState,
    CicilEmasReqUseCase reqOtpGan,
    CicilEmasValUseCase validateOtpGan,
  ) {
    // notes is valid
    // 1 loading
    // 2 data valid
    // 3 cicil emas tidak ditemukan
    // 4 kesalahan tidak diketahui
    final isValidController = BehaviorSubject<int>.seeded(1);
    final isLoadingCalculateController = BehaviorSubject<bool>.seeded(false);
    final pageContoller = BehaviorSubject<int>.seeded(1);
    final stepController = BehaviorSubject<int>.seeded(1);
    final provinsiController = BehaviorSubject<int>();
    final kotaController = BehaviorSubject<int>();
    final locationController = BehaviorSubject<String>();
    final isPage = BehaviorSubject<bool>();
    final supplierController = BehaviorSubject<Map<String, dynamic>>();
    final listEmasController = BehaviorSubject<List<dynamic>>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final masterEmasController = BehaviorSubject<List<dynamic>>();
    final listProductController = BehaviorSubject<List<ListProductResponse>>();
    final isTerapkanController = BehaviorSubject<bool>.seeded(false);
    final setujuController = BehaviorSubject<bool>.seeded(false);
    final noHpController = BehaviorSubject<String>();
    final totalEmasController = BehaviorSubject<int>.seeded(0);
    final idBorrowerController = BehaviorSubject<int>();
    final myLatController = BehaviorSubject<double>();
    final myLongController = BehaviorSubject<double>();
    final caraBayarController = BehaviorSubject<Map<String, dynamic>>();
    final documentPerjanjianController = BehaviorSubject<dynamic>();
    final totalPageController = BehaviorSubject<int>();
    final calculateMessage = BehaviorSubject<CicilEmasMessage?>();

    //params controller
    final urutkanController = BehaviorSubject<int>.seeded(0);
    final emasFilterController = BehaviorSubject<List<int>>.seeded([]);
    final minController = BehaviorSubject<int>.seeded(-1);
    final maxController = BehaviorSubject<int>.seeded(-1);
    final karatController = BehaviorSubject<int>.seeded(-1);
    final gramController = BehaviorSubject<int>.seeded(-1);
    final buttonTerapkanController = BehaviorSubject<bool>.seeded(false);
    buttonTerapkanController.addStream(Rx.combineLatest6(
      urutkanController.stream,
      emasFilterController.stream,
      minController.stream,
      maxController.stream,
      karatController.stream,
      gramController.stream,
      (
        int urutkan,
        List<int> emasFilter,
        int min,
        int max,
        int karat,
        int gram,
      ) {
        return urutkan != 0 ||
            emasFilter.length >= 1 ||
            min >= 1 ||
            max >= 1 ||
            karat >= 1 ||
            gram >= 1;
      },
    ).shareValueSeeded(false));

    final messageFdc = BehaviorSubject<CicilEmasMessage?>();

    //params function
    void minChange(String? val) {
      print(val);
      if (val == null) {
        minController.add(-1);
      } else {
        final String replace = val.replaceAll('Rp ', '').replaceAll('.', '');
        final value = int.tryParse(replace);
        if (value == 0) {
          minController.add(-1);
        } else {
          minController.add(value!);
        }
      }
      print(minController.valueOrNull);
    }

    void maxChange(String? val) {
      if (val == null) {
        maxController.add(-1);
      } else {
        final String replace = val.replaceAll('Rp ', '').replaceAll('.', '');
        final value = int.tryParse(replace);
        if (value == 0) {
          maxController.add(-1);
        } else {
          maxController.add(value!);
        }
      }
    }

    void gramChange(String? val) {
      if (val == null || val.isEmpty) {
        gramController.add(-1);
      } else {
        final value = int.tryParse(val);
        if (value == 0) {
          gramController.add(-1);
        } else {
          gramController.add(value!);
        }
      }
      print(gramController.value);
    }

    void karatChange(String? val) {
      if (val == null || val.isEmpty) {
        karatController.add(-1);
      } else {
        final value = int.tryParse(val);
        if (value == 0) {
          karatController.add(-1);
        } else {
          karatController.add(value!);
        }
      }
    }

    String getJenisFilter(List<int> value) {
      if (value.isNotEmpty) {
        final queryString = value.map((id) => 'idJenisEmas=$id').join('&');
        return '&$queryString';
      }
      return '';
    }

    String getParams() {
      final urutkan = urutkanController.valueOrNull ?? 1;
      final terendah = minController.valueOrNull ?? 0;
      final tertinggi = maxController.valueOrNull ?? 0;
      final gram = gramController.valueOrNull ?? 0;
      final karat = karatController.valueOrNull ?? 0;
      final jenisFilter = emasFilterController.valueOrNull ?? [];
      final tertinggiVal =
          tertinggi <= 0 ? '' : '&hargaTertinggi=${tertinggi.toString()}';
      final terendahVal =
          terendah <= 0 ? '' : '&hargaTerendah=${terendah.toString()}';
      final gramVal = gram <= 0 ? '' : '&berat=${gram.toString()}';
      final karatVal = karat <= 0 ? '' : '&karat=${karat.toString()}';
      final String jenis = getJenisFilter(jenisFilter);
      final urutkanVal = '&urutkan=$urutkan';
      final result =
          '${urutkanVal}${jenis}${tertinggiVal}${terendahVal}${gramVal}${karatVal}';
      return result;
    }

    //payload controller
    final emasSelectedController =
        BehaviorSubject<List<Map<String, dynamic>>>();
    final totalHargaController = BehaviorSubject<int>.seeded(0);
    final tenorController = BehaviorSubject<int>();
    final idProdukController = BehaviorSubject<int>();

    //result controller
    final angsuranPertamaController = BehaviorSubject<Map<String, dynamic>>();
    final listAngsuranController = BehaviorSubject<List<dynamic>>.seeded([]);
    final totalAngsuranController = BehaviorSubject<Map<String, dynamic>>();
    final infoAngsuranController = BehaviorSubject<Map<String, dynamic>>();
    final detailPembayaranController = BehaviorSubject<Map<String, dynamic>>();
    final totalPembayaranController = BehaviorSubject<int>();
    final mitraController = BehaviorSubject<Map<String, dynamic>>();

    final emasListByString = BehaviorSubject<List<dynamic>?>();

    final kuponController = BehaviorSubject<Map<String, dynamic>?>();
    final kuponAktifController = BehaviorSubject<String?>();

    final Stream<double> distanceStream = Rx.combineLatest3(
      supplierController.stream,
      myLatController.stream,
      myLongController.stream,
      (sup, lat, long) {
        final String latSup = sup['latitude'].toString();
        final String longSup = sup['longitude'].toString();
        return distanceKilometers(
          double.parse(latSup),
          double.parse(longSup),
          lat,
          long,
        );
      },
    ).shareValueSeeded(0.0);

    final authState$ = getAuthState();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    void getKupon(String val) async {
      final event = await authState$.first;

      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        final response = await apiService.getKuponCicilEmas(val, token);
        kuponController.add(response);
        if (response['Status'] == true) {
          kuponAktifController.add(response['Data']['kode_voucher']);
        }
      } catch (e) {
        kuponController.addError('Maaf sepertinya terjadi kesalahan');
      }
    }

    void searchListEmas(String? val, int page, bool isInfite) async {
      final value = val ?? '';
      final event = await authState$.first;

      final token = event.orNull()!.userAndToken!.token.toString();
      final provinsi = provinsiController.valueOrNull ?? -1;
      final kota = kotaController.valueOrNull ?? -1;
      final emasList = emasListByString.valueOrNull ?? [];
      final supplier = supplierController.valueOrNull ?? {};
      final response = await apiService.getListCicilEmas(
        token,
        page,
        provinsi,
        kota,
        supplier['idSupplier'],
        '&searchNamaJenisEmas=$value',
      );
      try {
        if (response['data'] != null) {
          final data = response['data']['data'] ?? [];
          if (isInfite == true) {
            emasList.addAll(data);
            emasListByString.add(emasList);
          } else {
            emasListByString.add(data);
          }
        } else if (response['data'] == null && isInfite != true) {
          emasListByString.add([]);
        }
      } catch (e) {
        emasListByString.addError('Maaf sepertinya terjadi kesalahan');
      }
    }

    void terapkan() async {
      isTerapkanController.add(true);
      pageContoller.add(1);
      print(maxController.valueOrNull ?? -1);
      print(minController.valueOrNull ?? -1);
      print(gramController.valueOrNull ?? -1);
      print(karatController.valueOrNull ?? -1);
      print(urutkanController.valueOrNull);
      print(emasFilterController.valueOrNull);
      final event = await authState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      final provinsi = provinsiController.valueOrNull ?? -1;
      final kota = kotaController.valueOrNull ?? -1;
      final supplier = supplierController.valueOrNull ?? {};
      final getDataEmas = await apiService.getListCicilEmas(
        token,
        1,
        provinsi,
        kota,
        supplier['idSupplier'],
        getParams(),
      );
      try {
        if (getDataEmas['data'] == null) {
          // isValidController.add(3);
          listEmasController.add([]);
          totalEmasController.add(0);
        } else {
          // isValidController.add(2);
          // print(isValidController.valueOrNull ?? 0);
          totalEmasController.add(getDataEmas['data']['total']);
          listEmasController.add(getDataEmas['data']['data']);
          totalPageController.add(getDataEmas['data']['total_page']);

          // supplierController.add(getDataEmas['data']['supplier']);
        }
      } catch (e) {
        isValidController.add(4);
      }
    }

    void getDataInti(String provinsiUser, String kotaUser,
        Map<String, dynamic> supplier) async {
      try {
        final isTerapkan = isTerapkanController.valueOrNull ?? false;

        final event = await authState$.first;

        final token = event.orNull()!.userAndToken!.token.toString();
        final noTelp = event.orNull()!.userAndToken!.user.tlpmobile;
        final idBorrower = event.orNull()!.userAndToken!.user.idborrower;
        print('id borrower gan $idBorrower');
        idBorrowerController.add(idBorrower);
        noHpController.add(noTelp);

        final response = await apiService.getMaster('provinsi', null);
        // print(response.body);
        if (response.statusCode == 200) {
          if (provinsiUser == 'Daerah Khusus Ibukota Jakarta') {
            provinsiUser = 'DKI Jakarta';
          }
          final List<dynamic> dataProvinsi = jsonDecode(response.body)['data'];

          final idProvinsi = getIdIndex(dataProvinsi, provinsiUser);

          provinsiController.add(idProvinsi);
          final responseKota = await apiService.getMaster(
            'kotaByProvinsi',
            'idprovinsi=$idProvinsi',
          );
          if (responseKota.statusCode == 200) {
            final List<dynamic> dataKota =
                jsonDecode(responseKota.body)['data'];
            print('check kota $kotaUser');
            print('detail kota $dataKota');

            final idKota = getIdIndex(dataKota, kotaUser);
            kotaController.add(idKota);
          }
        }
        final page = pageContoller.valueOrNull ?? 1;
        final provinsi = provinsiController.valueOrNull ?? -1;
        final kota = kotaController.valueOrNull ?? -1;
        final getDataEmas = await apiService.getListCicilEmas(
          token,
          page,
          provinsi,
          kota,
          supplier['idSupplier'],
          isTerapkan == true ? getParams() : null,
        );

        final masterEmas = await apiService.getMasterJenisEmas();
        print(masterEmas);
        masterEmasController.add(masterEmas);

        final List<ListProductResponse> product =
            await apiService.getListProduct(2);
        listProductController.add(product);
        try {
          final dataTenor = listProductController.valueOrNull ?? [];
          final ListProductResponse initTenor = dataTenor[dataTenor.length - 1];
          tenorController.add(initTenor.tenor);
          idProdukController.add(initTenor.id);
        } catch (e) {
          print('error bang');
        }

        try {
          if (getDataEmas['data'] == null) {
            isValidController.add(3);
          } else {
            print('data total ${getDataEmas['data']['total']}');
            print('data data ${getDataEmas['data']['data']}');
            print('data supplier ${getDataEmas['data']['supplier']}');
            print('data total_page ${getDataEmas['data']['total_page']}');
            print('ini data emas bang ${getDataEmas}');
            isValidController.add(2);
            print(isValidController.valueOrNull ?? 0);
            totalEmasController.add(getDataEmas['data']['total'] ?? 0);
            listEmasController.add(getDataEmas['data']['data'] ?? []);
            print('foto suppplier ${getDataEmas['data']['supplier']}');
            // supplierController.add(getDataEmas['data']['supplier'] ?? {});
            totalPageController.add(getDataEmas['data']['total_page'] ?? 0);
          }
        } catch (e) {
          print('errornya bang ${e.toString()}');
          isValidController.add(4);
        }
      } catch (e) {
        print('kesalahan: ${e.toString()}');
        isValidController.add(4);
      }
    }

    void getSupplier(String provinsiUser, String kotaUser) async {
      try {
        final response = await apiService.getSupplierEmas(null, 1);
        print(response.body);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print(responseData);
          final List<dynamic> listSupllier = responseData['data']['data'];
          if (listSupllier.isNotEmpty) {
            final Map<String, dynamic> supplier = listSupllier[0];
            supplierController.add(supplier);
            getDataInti(provinsiUser, kotaUser, supplier);
          } else {
            isValidController.add(3);
          }
        }
      } catch (e) {
        print(e.toString());
        isValidController.add(4);
      }
    }

    void infiniteScroll() async {
      final totalPage = totalPageController.valueOrNull ?? 1;
      final page = pageContoller.valueOrNull ?? 1;
      if (page < totalPage) {
        try {
          pageContoller.add(page + 1);
          final isTerapkan = isTerapkanController.valueOrNull ?? false;
          isLoadingController.add(true);
          final event = await authState$.first;
          final token = event.orNull()!.userAndToken!.token.toString();
          final provinsi = provinsiController.valueOrNull ?? -1;
          final kota = kotaController.valueOrNull ?? -1;
          final selected = listEmasController.valueOrNull ?? [];
          final supplier = supplierController.valueOrNull ?? {};
          final response = await apiService.getListCicilEmas(
            token,
            page + 1,
            provinsi,
            kota,
            supplier['idSupplier'],
            isTerapkan == true ? getParams() : null,
          );
          if (response['data'] != null) {
            print(response['data']['data']);
            final List<dynamic> data = response['data']['data'];
            selected.addAll(data);
            listEmasController.add(selected);
          }

          isLoadingController.add(false);
        } catch (e) {
          print(e.toString());
        }
      }
    }

    void getMasterBank() async {
      final response = await apiService.getMasterCaraBayar('BNI');
      final Map<String, dynamic> result = {};
      for (var entry in response) {
        final jenisPembayaran = entry['JenisPembayaran'];
        final keterangan = entry['Keterangan'];

        if (!result.containsKey(jenisPembayaran)) {
          result[jenisPembayaran] = [];
        }

        result[jenisPembayaran].add(keterangan);
      }
      caraBayarController.add(result);
    }

    void initGetAllData() async {
      try {
        final loc.Location location = loc.Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            print('Location services are disabled.');
            return;
          }
        }

        _permissionGranted = await Permission.location.status;
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await Permission.location.request();
          if (_permissionGranted != PermissionStatus.granted) {
            print('Location permission is not granted.');
            return;
          }
        }
        loc.LocationData currentLocation;
        try {
          currentLocation = await location.getLocation();
        } catch (e) {
          print('Error getting location: $e');
          return;
        }
        List<Placemark> placemarks = await placemarkFromCoordinates(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        if (placemarks.isNotEmpty) {
          var provinsi = '';
          String provinceName = placemarks[0].administrativeArea ?? '';
          String cityName = placemarks[0].subAdministrativeArea ?? '';
          print('provinsi:$provinceName');
          print('kota:$cityName');
          if (provinceName.toLowerCase().contains('jakarta')) {
            provinsi = 'jakarta';
          } else {
            provinsi = provinceName;
          }
          locationController.add(provinceName);
          myLatController.add(currentLocation.latitude!);
          myLongController.add(currentLocation.longitude!);
          getSupplier(provinsi, cityName);
        } else {
          // locationController.add('Lokasi tidak valid');
          isValidController.add(4);
        }
      } catch (e) {
        isValidController.add(4);
      }
    }

    void getDocumentPerjanjian(Map<String, dynamic> data) async {
      final totalHarga = totalHargaController.valueOrNull ?? 0;
      final listEmas = emasSelectedController.valueOrNull ?? 0;
      final idBorrower = idBorrowerController.valueOrNull ?? 0;
      final idProduk = idProdukController.valueOrNull ?? 12;
      final Map<String, dynamic> dataJson = {
        'idProduk': idProduk,
        'idJaminan': 0,
        'hargaPerolehanEmas': totalHarga,
        'biayaAdmin': data['angsuranPertama']['BiayaAdmin'],
        'totalAngsuranPertama': data['angsuranPertama']['Total'],
        'bunga': data['dataPembayaran']['bunga'],
        'jasaMitra': data['dataPembayaran']['jasaMitra'],
        'idBranch': data['mitraGadai'][0]['idBranch'],
        'tenor': 6,
        'detailEmas': listEmas,
      };
      final response = await apiService.getDocumentPerjanjian(
        dataJson,
        idBorrower,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        documentPerjanjianController.add(response.body);
      } else {
        documentPerjanjianController.addError('Maaf dokumen tidak tersedia');
      }
    }

    void calculateCicilan(int isCount) async {
      isLoadingCalculateController.add(true);
      print(isLoadingCalculateController.valueOrNull);
      final detailEmas = emasSelectedController.valueOrNull ?? [];
      final totalHargaStore = totalHargaController.valueOrNull ?? 0;
      final idProduct = idProdukController.valueOrNull ?? 11;
      final tenor = tenorController.valueOrNull ?? 12;
      if (detailEmas.isEmpty) {
        angsuranPertamaController.add({});
        listAngsuranController.add([]);
        totalAngsuranController.add({});
        mitraController.add({});
        // totalHarga.add(0);
      } else {
        try {
          final response = await apiService.calculateSimulasiCicilan(
            detailEmas,
            totalHargaStore,
            idProduct,
            tenor,
            isCount,
          );
          print(response.body);
          if (response.statusCode == 200 || response.statusCode == 201) {
            final dataBody = jsonDecode(response.body);
            final data = dataBody['data'];
            final List<dynamic> mitra = data['mitraGadai'];
            angsuranPertamaController.add(data['angsuranPertama']);
            listAngsuranController.add(data['skemaPembayaran']);
            totalAngsuranController.add(data['totalAngsuranBulan']);
            infoAngsuranController.add(data['infoAngsuran']);
            detailPembayaranController.add(data['dataPembayaran']);
            totalPembayaranController.add(data['totalPembayaran']);
            mitraController.add(mitra[0]);
            stepController.add(2);
            getDocumentPerjanjian(data);
            calculateMessage.add(const CicilEmasSuccess());
          } else {
            final data = jsonDecode(response.body);
            calculateMessage.add(CicilEmasError(data['message'], data));
            print(response.body);
          }
        } catch (e) {
          calculateMessage.add(CicilEmasError(e.toString(), e));
          print(e.toString());
        }
      }
      isLoadingCalculateController.add(false);
      print(isLoadingCalculateController.valueOrNull);
    }

    void checkFdc() async {
      final event = await authState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        final response = await apiService.getCheckFdcs(token);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          if (result['data']['fdc'] == true) {
            // stepController.add(3);
            messageFdc.add(const CicilEmasSuccess());
          } else {
            messageFdc.add(const CicilEmasError('message', []));
          }
        }
      } catch (e) {
        messageFdc.add(const InvalidInformationMessage());
      }
    }

    //post time
    final reqOtpButton = PublishSubject<void>();
    final kodeCheckOutController = BehaviorSubject<String>();
    final otpController = BehaviorSubject<String>();

    final credentialReqOtp = Rx.combineLatest2(
      idProdukController.stream,
      emasSelectedController.stream,
      (
        int id,
        List<Map<String, dynamic>> dataProduk,
      ) {
        return CredentialReqOtpCicilEmas(
          idProduk: id,
          dataProduk: dataProduk,
        );
      },
    );

    final reqOtpClick = reqOtpButton.stream.share();
    final messageReqOtp = Rx.merge([
      reqOtpClick
          .withLatestFrom(
            credentialReqOtp,
            (_, CredentialReqOtpCicilEmas cred) => cred,
          )
          .exhaustMap(
            (value) => reqOtpGan(
              idProduk: value.idProduk,
              dataProduk: value.dataProduk,
            ),
          )
          .map(_responseToMessage)
    ]);

    final valOtpButton = PublishSubject<void>();
    final resultValidate = BehaviorSubject<Map<String, dynamic>>();
    final valOtpClick = valOtpButton.stream.share();
    final valOtpCredential = Rx.combineLatest8(
      mitraController.stream,
      totalHargaController.stream,
      totalAngsuranController.stream,
      angsuranPertamaController.stream,
      tenorController.stream,
      supplierController.stream,
      kodeCheckOutController.stream,
      otpController.stream,
      (
        mitra,
        totalHarga,
        totalAngsuran,
        angsuranPertama,
        tenor,
        supplier,
        kodeCheckout,
        otp,
      ) {
        final kuponAktif = kuponAktifController.valueOrNull ?? '';
        final idProduk = idProdukController.valueOrNull ?? 12;
        final idBorrower = idBorrowerController.valueOrNull ?? 0;

        final Map<String, dynamic> result = {
          'id_rekening': 0,
          'idborrower': idBorrower,
          'id_produk': idProduk,
          'idjaminan': 0,
          'no_perjanjian': kodeCheckout,
          'otp': otp,
          'tujuan': '',
          'kodeCheckout': kodeCheckout,
          'totalPembayaran': angsuranPertama['Total'],
          'fotoJaminan': '',
          'suratBuktiJaminan': '',
          'kodeKupon': kuponAktif,
          'jenisPencairan': 'CASH',
          'idSupplier': supplier['idSupplier'],
          'jenisPinjaman': 'Cicil Emas',
          'tenor': tenor,
          'hargaEmas': totalHarga,
          'biayaAdmin': angsuranPertama['BiayaAdmin'],
          'angsuran_pertama': angsuranPertama['Total'],
          'angsuran_bulanan': totalAngsuran['Total'],
          'nilaiPinjaman': totalHarga,
          'idBranch': mitra['idBranch'],
          'detailEmas': emasSelectedController.valueOrNull ?? []
        };
        return CredentialValOtpCicilEmas(data: result);
      },
    );

    final messageValOtp = Rx.merge([
      valOtpClick
          .withLatestFrom(
              valOtpCredential, (_, CredentialValOtpCicilEmas cred) => cred)
          .exhaustMap(
            (value) => validateOtpGan(data: value.data),
          )
          .map(_responseToMessage)
    ]);
    final otpErrorController = BehaviorSubject<String?>();
    return CicilEmas2Bloc._(
      stepChange: (int val) {
        otpErrorController.add(null);
        stepController.add(val);
      },
      initGetAllData: initGetAllData,
      stepStream$: stepController.stream,
      isPageStream$: isPage.stream,
      isValidStream$: isValidController.stream,
      locationStream$: locationController.stream,
      listEmasStream$: listEmasController.stream,
      supplierStream$: supplierController.stream,
      idProdukChange: (int val) => idProdukController.add(val),
      jenisEmasSelected$: emasSelectedController.stream,
      tenorChange: (int val) => tenorController.add(val),
      totalHargaChange: (int val) => totalHargaController.add(val),
      tenorStream$: tenorController.stream,
      totalHargaStream$: totalHargaController.stream,
      masterJenisEmasStream$: masterEmasController.stream,
      listProduct$: listProductController.stream,
      emasSelectedControl: (List<Map<String, dynamic>> val) =>
          emasSelectedController.add(val),
      infinineScroll: infiniteScroll,
      isLoadingStream$: isLoadingController.stream,
      filterControl: terapkan,
      jenisEmasChange: (List<int> val) => emasFilterController.add(val),
      jenisEmasParam: emasFilterController.stream,
      maxChange: maxChange,
      minChange: minChange,
      maxParam: maxController.stream,
      minParam: minController.stream,
      urutkanChange: (int val) => urutkanController.add(val),
      urutkanParam: urutkanController.stream,
      gramChange: gramChange,
      karatChange: karatChange,
      gramParam: gramController.stream,
      karatParam: karatController.stream,
      angsuranPertamaStream: angsuranPertamaController.stream,
      calculateCicilan: calculateCicilan,
      listAngsuranStream: listAngsuranController.stream,
      totalAngsuran: totalAngsuranController.stream,
      detailPembayaran: detailPembayaranController.stream,
      infoAngsuran: infoAngsuranController.stream,
      totalPembayaran: totalPembayaranController.stream,
      setujuControl: (bool val) => setujuController.add(val),
      setujuStream: setujuController.stream,
      getKupon: getKupon,
      kuponStream: kuponController.stream,
      emasBySearch: emasListByString.stream,
      searchEmasByString: searchListEmas,
      makeNullEmas: () => emasListByString.add(null),
      checkFdc: checkFdc,
      messageFdc: messageFdc.stream,
      mitraStream: mitraController.stream,
      getMasterBank: getMasterBank,
      caraBayarStream: caraBayarController.stream,
      makeNullVoucher: () {
        kuponController.add(null);
        kuponAktifController.add(null);
      },
      reqOtpClick: () => reqOtpButton.add(null),
      messageReqOtp: messageReqOtp,
      kodeCheckoutChange: (String val) {
        kodeCheckOutController.add(val);
        print(kodeCheckOutController.value);
      },
      noHpStream$: noHpController.stream,
      otpChange: (String val) => otpController.add(val),
      otpErrorChange: (String? val) => otpErrorController.add(val),
      otpErrorStream$: otpErrorController.stream,
      otpStream$: otpController.stream,
      totalEmas: totalEmasController.stream,
      messageValidateOtp: messageValOtp,
      resultChange: (Map<String, dynamic> val) => resultValidate.add(val),
      resultValidate: resultValidate.stream,
      valOtpClick: () => valOtpButton.add(null),
      kuponAktifStream$: kuponAktifController.stream,
      distance: distanceStream,
      isLoading: isLoadingController.stream,
      isLoadingChange: (bool val) => isLoadingController.add(val),
      documentPerjanjian: documentPerjanjianController.stream,
      isLoadingCalculate: isLoadingCalculateController.stream,
      buttonTerapkan: buttonTerapkanController.stream,
      messageCalculate: calculateMessage.stream,
      dispose: () {
        stepController.close();
        provinsiController.close();
        kotaController.close();
        isValidController.close();
        locationController.close();
      },
    );
  }

  static CicilEmasMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const CicilEmasSuccess(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : CicilEmasError(appError.message!, appError.error!),
    );
  }
}

int getIdIndex(
  List<dynamic> listData,
  String stringResult,
) {
  int result = -1;
  List<String> keywords = stringResult.toLowerCase().split(' ');
  print(listData);
  print(keywords);

  for (var i = 0; i < listData.length; i++) {
    final nama = listData[i]['nama'].toString().toLowerCase();
    bool found = false;

    for (var keyword in keywords) {
      if (nama.contains(keyword)) {
        found = true;
        break;
      }
    }

    if (found) {
      print('dapet nih provinsi bang: ${listData[i]['nama']}');
      if (nama.contains(stringResult.toLowerCase())) {
        result = listData[i]['id'];
        break;
      } else if (result == -1) {
        result = listData[i]['id'];
      }
    }
  }
  return result;
}

int getIdKota(
  List<dynamic> listData,
  String stringResult,
) {
  int result = -1;
  List<String> keywords = stringResult.toLowerCase().split(' ');

  for (var i = 0; i < listData.length; i++) {
    final nama = listData[i]['nama_kabupaten'].toString().toLowerCase();
    bool found = true;

    for (var keyword in keywords) {
      if (!nama.contains(keyword)) {
        found = false;
        break;
      }
    }

    if (found) {
      print('dapet nih kota bang: ${listData[i]['nama_kabupaten']}');
      result = listData[i]['id_kabupaten'];
      break;
    }
  }
  return result;
}

class CredentialReqOtpCicilEmas {
  final int idProduk;
  final List<Map<String, dynamic>> dataProduk;

  const CredentialReqOtpCicilEmas({
    required this.idProduk,
    required this.dataProduk,
  });
}

class CredentialValOtpCicilEmas {
  final Map<String, dynamic> data;
  const CredentialValOtpCicilEmas({
    required this.data,
  });
}

double distanceKilometers(
  double referenceLat,
  double referenceLon,
  double requestLat,
  double requestLon,
) {
  const double earthRadius = 6371.0;

  num deltaLat = radians(requestLat - referenceLat);
  num deltaLon = radians(requestLon - referenceLon);

  double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
      cos(radians(referenceLat)) *
          cos(radians(requestLat)) *
          sin(deltaLon / 2) *
          sin(deltaLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c;

  return distance;
}
