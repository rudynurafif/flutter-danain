import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_master_use_case.dart';
import 'package:flutter_danain/domain/usecases/simulasi_cnd_use_case.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/pengajuan_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SimulasiCashDriveBLoc extends DisposeCallbackBaseBloc {
  final Function0<void> getMaster;
  final Function0<void> getBeranda;
  final Stream<String?> errorMessage;
  final Stream<bool> isLoading;

  final Stream<int> jenisKendaraan;
  final Stream<List<dynamic>> jenisKendaraanList;
  final Function1<int, void> kendaraanChange;

  //beranda
  final Stream<Map<String, dynamic>> berandaData;

  //provinsi
  final Stream<List<dynamic>> provinsiList;
  final Stream<Map<String, dynamic>?> provinsi;
  final Function1<Map<String, dynamic>, void> provinsiChange;

  //merek
  final Stream<List<dynamic>> merekList;
  final Stream<Map<String, dynamic>?> merek;
  final Function1<Map<String, dynamic>, void> merekChange;

  //tipe
  final Stream<List<dynamic>> tipeList;
  final Stream<Map<String, dynamic>?> tipe;
  final Function1<Map<String, dynamic>, void> tipeChange;

  //model
  final Stream<List<dynamic>> modelList;
  final Stream<Map<String, dynamic>?> model;
  final Function1<Map<String, dynamic>, void> modelChange;
  //model
  final Stream<List<dynamic>> tahunList;
  final Stream<Map<String, dynamic>?> tahun;
  final Function1<Map<String, dynamic>, void> tahunChange;

  // ini bagian simulasi
  final Function1<int, void> nilaiPinjamanChange;

  final Stream<List<dynamic>> tenorList;
  final Stream<int> tenor;
  final Function1<int, void> tenorChange;
  final Future<void> Function({
    required int tnr,
  }) postSimulasi;

  final Stream<PengajuanCashDriveParams> params;
  final Stream<num> maksimalPinjaman;
  final Stream<String?> errorSimulasi;

  final Stream<Map<String, dynamic>?> responseSimulasi;

  final Stream<bool> isValidButton;
  SimulasiCashDriveBLoc._({
    required this.getMaster,
    required this.isLoading,
    required this.errorMessage,
    required this.jenisKendaraan,
    required this.jenisKendaraanList,
    required this.kendaraanChange,
    required this.merek,
    required this.merekList,
    required this.merekChange,
    required this.tipe,
    required this.tipeList,
    required this.tipeChange,
    required this.provinsi,
    required this.provinsiChange,
    required this.provinsiList,
    required this.model,
    required this.modelList,
    required this.modelChange,
    required this.tahun,
    required this.tahunList,
    required this.tahunChange,
    required this.nilaiPinjamanChange,
    required this.tenor,
    required this.tenorList,
    required this.tenorChange,
    required this.params,
    required this.isValidButton,
    required this.responseSimulasi,
    required this.maksimalPinjaman,
    required this.getBeranda,
    required this.berandaData,
    required this.postSimulasi,
    required this.errorSimulasi,
    required final Function0<void> dispose,
  }) : super(dispose);

  factory SimulasiCashDriveBLoc(
    GetAuthStateStreamUseCase getAuthState,
    SimulasiCndUseCase simulasi,
    GetMasterDataUseCase getMasterData,
  ) {
    final errorMessage = BehaviorSubject<String?>();
    final errorSimulasi = BehaviorSubject<String?>();

    final loading = BehaviorSubject<bool>.seeded(true);

    //jenis kendaraan
    final jenisKendaraaan = BehaviorSubject<int>.seeded(0);
    final jenisKendaraanList = BehaviorSubject<List<dynamic>>();

    //provinsi
    final provinsiList = BehaviorSubject<List<dynamic>>();
    final provinsiController = BehaviorSubject<Map<String, dynamic>?>();

    //merek
    final merkList = BehaviorSubject<List<dynamic>>();
    final merekController = BehaviorSubject<Map<String, dynamic>?>();

    //tipe
    final tipeList = BehaviorSubject<List<dynamic>>();
    final tipeController = BehaviorSubject<Map<String, dynamic>?>();

    //model
    final modelList = BehaviorSubject<List<dynamic>>();
    final modelController = BehaviorSubject<Map<String, dynamic>?>();

    //tahun
    final tahunList = BehaviorSubject<List<dynamic>>();
    final tahunController = BehaviorSubject<Map<String, dynamic>?>();

    //nilai pinjaman
    final nilaiPinjaman = BehaviorSubject<int>.seeded(0);

    //maks pinjaman
    final maksPinjaman = BehaviorSubject<num>.seeded(0);

    //response simulasi
    final responseController = BehaviorSubject<Map<String, dynamic>?>();

    final tenorList =
        BehaviorSubject<List<dynamic>>.seeded(Constants.get.tenorList);
    final tenor = BehaviorSubject<int>.seeded(24);

    final berandaController = BehaviorSubject<Map<String, dynamic>>();
    final auth = getAuthState();
    Future<void> getBeranda() async {
      print('masuk bang');
      try {
        final event = await auth.first;
        final data = event.orNull()!.userAndToken;
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(
          data!.beranda,
        );
        print('beranda nih bang ${decodedToken['beranda']}');
        berandaController.add(decodedToken['beranda']);
      } catch (e) {
        print(e.toString());
      }
    }

    Future<void> getMaster() async {
      final response = await getMasterData.call(
        endpoint: 'wilayah',
        params: {},
      );
      response.fold(
        ifLeft: (value) {
          provinsiList.addError(value);
          errorMessage.add(value);
        },
        ifRight: (value) {
          provinsiList.add(value.data ?? []);
        },
      );
      loading.add(false);
    }

    Future<void> getMerk(int idJenisKendaraan) async {
      loading.add(true);
      merkList.add([]);
      merekController.add(null);

      tipeController.add(null);
      tipeList.add([]);

      modelController.add(null);
      modelList.add([]);

      tahunController.add(null);
      tahunList.add([]);
      final response = await getMasterData.call(
        endpoint: 'merek',
        params: {
          'idJenisKendaraan': idJenisKendaraan,
        },
      );
      response.fold(
        ifLeft: (value) {
          merkList.addError(value);
          errorMessage.add(value);
        },
        ifRight: (value) {
          merkList.add(value.data ?? []);
        },
      );
      loading.add(false);
    }

    Future<void> getTipe(int idMerek) async {
      loading.add(true);
      tipeController.add(null);
      tipeList.add([]);

      modelController.add(null);
      modelList.add([]);

      tahunController.add(null);
      tahunList.add([]);
      final response = await getMasterData.call(
        endpoint: 'type',
        params: {
          'idMerek': idMerek,
        },
      );
      response.fold(
        ifLeft: (value) {
          // tipeList.addError(value);
          // tipeList.add(Constants.get.tipeKendaraan);
          errorMessage.add(value);
        },
        ifRight: (value) {
          tipeList.add(value.data ?? []);
        },
      );
      loading.add(false);
    }

    Future<void> getModel(int idType) async {
      loading.add(true);
      modelController.add(null);
      modelList.add([]);

      tahunController.add(null);
      tahunList.add([]);
      final response = await getMasterData.call(
        endpoint: 'model',
        params: {
          // 'page': 1,
          // 'pageSize': 30,
          'idType': idType,
        },
      );
      response.fold(
        ifLeft: (value) {
          // modelList.addError(value);
          modelList.add(Constants.get.modelKendaraan);
          errorMessage.add(value);
        },
        ifRight: (value) {
          modelList.add(value.data ?? []);
        },
      );
      loading.add(false);
    }

    Future<void> getTahunKendaraan(int idModel) async {
      loading.add(true);
      tahunController.add(null);
      tahunList.add([]);
      final response = await getMasterData.call(
        endpoint: 'tahun',
        params: {
          'idModel': idModel,
        },
      );
      response.fold(
        ifLeft: (value) {
          // tahunList.addError(value);
          tahunList.add(Constants.get.tahunKendaraan);
          errorMessage.add(value);
        },
        ifRight: (value) {
          tahunList.add(value.data ?? []);
        },
      );
      loading.add(false);
    }

    jenisKendaraaan.stream.listen(
      (value) {
        if (value != 0) {
          getMerk(value);
          responseController.add(null);
        }
      },
    );

    final Stream<bool> isValidButton = Rx.combineLatest9(
      jenisKendaraaan.stream,
      provinsiController.stream,
      merekController.stream,
      tipeController.stream,
      modelController.stream,
      tahunController.stream,
      nilaiPinjaman.stream,
      tenor.stream,
      responseController.stream,
      (
        jenis,
        prov,
        merk,
        tipe,
        model,
        tahun,
        pinjaman,
        tenor,
        response,
      ) {
        return jenis != 0 &&
            prov != null &&
            merk != null &&
            tipe != null &&
            model != null &&
            tahun != null &&
            pinjaman > 0 &&
            tenor > 0 &&
            response != null;
      },
    ).shareValueSeeded(false);

    final Stream<PengajuanCashDriveParams> params = Rx.combineLatest9(
      jenisKendaraaan.stream,
      provinsiController.stream,
      merekController.stream,
      tipeController.stream,
      modelController.stream,
      tahunController.stream,
      nilaiPinjaman.stream,
      tenor.stream,
      responseController.stream,
      (
        jenis,
        prov,
        merk,
        tipe,
        model,
        tahun,
        pinjaman,
        tenor,
        response,
      ) {
        return PengajuanCashDriveParams(
          idJenisJaminan: jenis,
          idWilayah: prov!['idWilayah'],
          idMerk: merk!['idMerek'],
          idType: tipe!['idType'],
          idModel: model!['idModel'],
          tahun: tahun!['tahunProduksi'],
          maksPinjaman: 10000000,
          nilaiPengajuan: pinjaman,
          idTenor: tenor,
          responseSimulasi: response!,
          namaMerek: merk['namaMerek'],
          namaModel: model['namaModel'],
          namaType: tipe['namaType'],
        );
      },
    );

    final BehaviorSubject<bool> _isPosting =
        BehaviorSubject<bool>.seeded(false);
    Future<void> postSimulasi({
      required int tnr,
    }) async {
      final tipe = tipeController.stream.valueOrNull;
      final jenisKendaraan = jenisKendaraaan.stream.valueOrNull;
      final provinsi = provinsiController.stream.valueOrNull;
      final merek = merekController.stream.valueOrNull;
      final model = modelController.stream.valueOrNull;
      final tahun = tahunController.stream.valueOrNull;
      final pinjaman = nilaiPinjaman.stream.valueOrNull ?? 0;
      if (tipe != null &&
          jenisKendaraan != 0 &&
          provinsi != null &&
          merek != null &&
          tahun != null &&
          model != null) {
        try {
          if (_isPosting.value) return;
          _isPosting.add(true);

          loading.add(true);

          final parameter = SimulasiParams(
            idJenisKendaraan: jenisKendaraan!,
            idProvinsi: provinsi['idWilayah'],
            idModel: model['idModel'],
            tahun: tahun['tahunProduksi'],
            nilaiPinjaman: pinjaman,
            tenor: tnr,
          );

          final response = await simulasi.call(payload: parameter);
          response.fold(
            ifLeft: (left) {
              errorSimulasi.add(left);
              print("check lefet ${left}");
              responseController.add(null);
              loading.add(false);
            },
            ifRight: (value) {
              final Map<String, dynamic> data =
                  value.data as Map<String, dynamic>;
              if (data.containsKey('angsuranBulanan')) {
                responseController.add(value.data);
                maksPinjaman.add(data['maksimalPinjaman']);
              } else {
                responseController.add(null);
                maksPinjaman.add(data['maksimalPinjaman']);
              }
              loading.add(false);
            },
          );
        } catch (e) {
          loading.add(false);
          errorSimulasi.add(e.toString());
        } finally {
          _isPosting.add(false);
        }
      } else {
        print('mantap bang');
      }
    }

    void dispose() {
      jenisKendaraaan.close();
      merekController.close();
      tipeController.close();
      modelController.close();
      _isPosting.close();
    }

    return SimulasiCashDriveBLoc._(
      errorMessage: errorMessage.stream,
      getMaster: getMaster,
      jenisKendaraan: jenisKendaraaan.stream,
      kendaraanChange: (int val) => jenisKendaraaan.add(val),
      merek: merekController.stream,
      merekList: merkList.stream,
      merekChange: (Map<String, dynamic> value) {
        merekController.add(value);
        getTipe(value['idMerek']);
        responseController.add(null);
      },
      tipeChange: (Map<String, dynamic> value) {
        tipeController.add(value);
        getModel(value['idType']);
        responseController.add(null);
      },
      errorSimulasi: errorSimulasi.stream,
      tipeList: tipeList.stream,
      tipe: tipeController.stream,
      model: modelController.stream,
      modelChange: (value) {
        modelController.add(value);
        getTahunKendaraan(value['idModel']);
      },
      postSimulasi: postSimulasi,
      modelList: modelList.stream,
      dispose: dispose,
      jenisKendaraanList: jenisKendaraanList.stream,
      provinsi: provinsiController.stream,
      provinsiList: provinsiList.stream,
      provinsiChange: (Map<String, dynamic> value) {
        provinsiController.add(value);
        postSimulasi(tnr: tenor.valueOrNull ?? 0);
      },
      tahun: tahunController.stream,
      tahunChange: (value) {
        tahunController.add(value);
        postSimulasi(tnr: tenor.valueOrNull ?? 0);
      },
      tahunList: tahunList.stream,
      nilaiPinjamanChange: (int value) {
        nilaiPinjaman.add(value);
        postSimulasi(tnr: tenor.valueOrNull ?? 0);
      },
      tenor: tenor.stream,
      tenorChange: (p0) {
        tenor.add(p0);
        print('tenornya bang $p0');
      },
      tenorList: tenorList.stream,
      isLoading: loading.stream,
      params: params,
      isValidButton: isValidButton,
      responseSimulasi: responseController.stream,
      maksimalPinjaman: maksPinjaman.stream,
      berandaData: berandaController.stream,
      getBeranda: getBeranda,
    );
  }
}
