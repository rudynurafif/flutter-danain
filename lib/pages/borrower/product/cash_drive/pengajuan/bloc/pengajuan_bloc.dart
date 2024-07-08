import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_hubungan_keluarga_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_master_use_case.dart';
import 'package:flutter_danain/domain/usecases/pengajuan_cnd_use_case.dart';
import 'package:flutter_danain/domain/usecases/upload_file_use_case.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/pengajuan_page.dart';
import 'package:flutter_danain/utils/utils.dart';

class PengajuanCashDriveBloc extends DisposeCallbackBaseBloc {
  final BehaviorSubject<PengajuanCashDriveParams> paramsSimulasi;
  final BehaviorSubject<int> step;
  final BehaviorSubject<int> anKendaraan;
  final BehaviorSubject<String?> plat;
  final BehaviorSubject<String?> noStnk;
  final BehaviorSubject<String?> fotoStnk;
  final BehaviorSubject<String?> noBpkb;
  final BehaviorSubject<String?> fotoBpkb;

  final Stream<bool> buttonKendaraan;
  final Stream<bool> isLoading;
  final Stream<String?> errorMessage;
  final Stream<bool> buttonAlamat;

  //master provinsi
  final Stream<List<dynamic>> masterProvinsi;
  final BehaviorSubject<Map<String, dynamic>?> provinsi;

  //master kota
  final Stream<List<dynamic>> masterKota;
  final BehaviorSubject<Map<String, dynamic>?> kota;
  final Function0<void> getProvinsi;

  final BehaviorSubject<String?> alamat;
  final BehaviorSubject<String?> alamatDetail;
  final BehaviorSubject<String?> tglSurvey;
  final BehaviorSubject<String?> jamSurvey;
  final Function0<void> postPengajuan;
  final BehaviorSubject<Map<String, dynamic>?> response;

  final Function0<void> getPasangan;
  final Stream<Map<String, dynamic>?> pasangan;

  final Stream<bool> isPostDone;

  final Function2<TypeFile, String, void> postFile;

  PengajuanCashDriveBloc._({
    required this.isPostDone,
    required this.paramsSimulasi,
    required this.step,
    required this.anKendaraan,
    required this.plat,
    required this.noStnk,
    required this.fotoStnk,
    required this.noBpkb,
    required this.fotoBpkb,
    required this.buttonKendaraan,
    required this.isLoading,
    required this.errorMessage,
    required this.postFile,
    required this.masterProvinsi,
    required this.provinsi,
    required this.getProvinsi,
    required this.masterKota,
    required this.kota,
    required this.alamat,
    required this.alamatDetail,
    required this.tglSurvey,
    required this.jamSurvey,
    required this.buttonAlamat,
    required this.postPengajuan,
    required this.response,
    required this.pasangan,
    required this.getPasangan,
    required final Function0<void> dispose,
  }) : super(dispose);

  factory PengajuanCashDriveBloc(
    GetAuthStateStreamUseCase getAuthState,
    UploadFileUseCase uploadFile,
    GetMasterDataUseCase getMaster,
    PengajuanCndUseCase pengajuan,
    GetHubunganKeluargaUseCase getHubungan,
  ) {
    final isLoading = BehaviorSubject<bool>.seeded(true);
    final errorMessage = BehaviorSubject<String?>();

    final paramsSimulasi = BehaviorSubject<PengajuanCashDriveParams>();
    final step = BehaviorSubject<int>.seeded(1);
    final anKendaraan = BehaviorSubject<int>.seeded(0);
    final plat = BehaviorSubject<String?>();
    final noStnk = BehaviorSubject<String?>();
    final fotoStnk = BehaviorSubject<String?>();
    final noBpkb = BehaviorSubject<String?>();
    final fotoBpkb = BehaviorSubject<String?>();
    final isPostDone = BehaviorSubject<bool>();
    final pasanganController = BehaviorSubject<Map<String, dynamic>?>();

    final responseController = BehaviorSubject<Map<String, dynamic>?>();

    //step data alamat
    final masterProvinsi = BehaviorSubject<List<dynamic>>();
    final provinsi = BehaviorSubject<Map<String, dynamic>?>();

    Future<void> getHubunganKeluarga() async {
      try {
        final response = await getHubungan.call();
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
          },
        );
      } catch (e) {
        print('error ini bang ${e.toString()}');
        errorMessage.add(e.toString());
      }
    }

    Future<void> getProvinsi() async {
      final response = await getMaster.call(
        endpoint: 'provinsi',
        params: {},
      );
      response.fold(
        ifLeft: (value) {
          errorMessage.add(value);
        },
        ifRight: (value) {
          masterProvinsi.add(value.data ?? []);
        },
      );
      isLoading.add(false);
    }

    final masterKota = BehaviorSubject<List<dynamic>>();
    final kota = BehaviorSubject<Map<String, dynamic>?>();
    final tglSurvey = BehaviorSubject<String?>();
    final jamSurvey = BehaviorSubject<String?>();

    Future<void> getKota(int idProvinsi) async {
      isLoading.add(true);
      try {
        kota.add(null);
        masterKota.add([]);
        final response = await getMaster.call(
          endpoint: 'provinsi',
          params: {
            'idProvinsi': idProvinsi,
          },
        );
        response.fold(
          ifLeft: (value) {
            errorMessage.add(value);
            isLoading.add(false);
          },
          ifRight: (value) {
            final Map<String, dynamic> data = value.data[0];
            masterKota.add(data['kabupaten'] ?? []);
            isLoading.add(false);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
        isLoading.add(false);
      }
    }

    final auth = getAuthState();
    final alamat = BehaviorSubject<String?>();
    final alamatDetail = BehaviorSubject<String?>();

    Future<void> postFile(TypeFile type, String pathFile) async {
      isLoading.add(true);
      Map<String, dynamic> params = {};
      var controller = BehaviorSubject<String?>();
      if (type == TypeFile.stnk) {
        params = {
          'id': 0,
          'dir': 'stnk',
        };
        controller = fotoStnk;
      }
      if (type == TypeFile.bpkb) {
        params = {
          'id': 0,
          'dir': 'bpkb',
        };
        controller = fotoBpkb;
      }

      try {
        final response = await uploadFile.call(
          params: params,
          file: pathFile,
        );
        response.fold(
          ifLeft: (value) {
            isLoading.add(false);
            errorMessage.add(value);
          },
          ifRight: (value) {
            final data = (value.data ?? {}) as Map<String, dynamic>;
            final file = data['file'];
            controller.add(file['FileOSS']);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
      isLoading.add(false);
    }

    final buttonAlamat = BehaviorSubject<bool>.seeded(false);
    buttonAlamat.addStream(
      Rx.combineLatest6(
        provinsi.stream,
        kota.stream,
        alamat.stream,
        alamatDetail.stream,
        tglSurvey.stream,
        jamSurvey.stream,
        (a, b, c, d, e, f) {
          return a != null &&
              b != null &&
              c != null &&
              c.length > 1 &&
              d != null &&
              d.length > 1 &&
              e != null &&
              f != null;
        },
      ),
    );

    final buttonKendaraan = BehaviorSubject<bool>.seeded(false);
    buttonKendaraan.addStream(Rx.combineLatest6(
      anKendaraan.stream,
      plat.stream,
      noStnk.stream,
      fotoStnk.stream,
      noBpkb.stream,
      fotoBpkb.stream,
      (an, pl, nStnk, fstnk, nBpkb, fBpkb) {
        return an != 0 &&
            Validator.isValidPlat(pl) &&
            Validator.isValidLength(nStnk, 8) &&
            fstnk != null &&
            fBpkb != null &&
            Validator.isValidLength(nBpkb, 8);
      },
    ));

    provinsi.stream.listen(
      (value) {
        if (value != null) {
          getKota(value['idProvinsi']);
        }
      },
    );

    Future<void> postPengajuan() async {
      isLoading.add(true);
      final params = paramsSimulasi.value;
      final event = await auth.first;
      final user = event.orNull()!.userAndToken!.user;
      final date = DateTime.parse(
        tglSurvey.valueOrNull ?? DateTime.now().toString(),
      );
      final jam = DateTime.parse(
        jamSurvey.valueOrNull ?? DateTime.now().toString(),
      );
      final DateTime combinedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        jam.hour,
        jam.minute,
        jam.second,
        jam.millisecond,
      );
      final prov = provinsi.valueOrNull ?? {};
      final ko = kota.valueOrNull ?? {};
      final pasangan = pasanganController.valueOrNull ?? {};
      final an = anKendaraan.value;
      final payload = {
        'idModel': params.idModel,
        'tahunProduksi': params.tahun,
        'otr': params.responseSimulasi['otr'],
        'ltv': params.responseSimulasi['ltv'],
        'maksPinjaman': params.responseSimulasi['maksimalPinjaman'],
        'nilaiPinjaman': params.nilaiPengajuan,
        'idProdukOffering': params.responseSimulasi['idProdukOffering'],
        'jenisAtasNama': anKendaraan.valueOrNull ?? 0,
        'atasNamaKendaraan': an == 1 ? user.username : pasangan['namaLengkap'],
        'noPolisi': plat.valueOrNull ?? '',
        'noSTNK': noStnk.valueOrNull ?? '',
        'noBPKB': noBpkb.valueOrNull ?? '',
        'fotoSTNK': fotoStnk.valueOrNull ?? '',
        'fotoBPKB': fotoBpkb.valueOrNull ?? '',
        'longitude_pin': 'gaada',
        'latitudePin': 'gaada',
        'alamatDomisiliPin': alamat.valueOrNull ?? '',
        'idProvinsi': prov['idProvinsi'],
        'idKabupaten': ko['idKabupaten'],
        'detailAlamat': alamatDetail.valueOrNull ?? '',
        'barcode': '',
        'namaMerek': params.namaMerek,
        'namaModel': params.namaModel,
        'namaType': params.namaType,
        'idProduk': Constants.get.idProdukCashDrive,
        'latitude': 'gada bang',
        'longitude': 'gada bang',
        'idJenisKendaraan': params.idJenisJaminan,
        'idMerek': params.idMerk,
        'tahun': params.tahun,
        'idType': params.idType,
        'idWilayah': params.idWilayah,
        'tenor': params.idTenor,
        'tglSurvey': combinedDateTime.toString(),
        'nilaiPencairan': params.responseSimulasi['pencairan']['total'] ?? 0,
        'angsuranBulanan':
            params.responseSimulasi['angsuranBulanan']['total'] ?? 0,
        'pelunasanAkhir':
            params.responseSimulasi['pelunasanAkhir']['total'] ?? 0,
      };
      final response = await pengajuan.call(payload: payload);
      response.fold(
        ifLeft: (value) {
          isLoading.add(false);
          isPostDone.add(false);
        },
        ifRight: (value) {
          responseController.add(value.data);
          isLoading.add(false);
          isPostDone.add(true);
        },
      );
    }

    void dispose() {}

    return PengajuanCashDriveBloc._(
      paramsSimulasi: paramsSimulasi,
      step: step,
      anKendaraan: anKendaraan,
      plat: plat,
      noStnk: noStnk,
      fotoStnk: fotoStnk,
      noBpkb: noBpkb,
      fotoBpkb: fotoBpkb,
      isPostDone: isPostDone.stream,
      buttonKendaraan: buttonKendaraan.stream,
      dispose: dispose,
      isLoading: isLoading.stream,
      errorMessage: errorMessage.stream,
      postFile: postFile,
      kota: kota,
      provinsi: provinsi,
      getProvinsi: getProvinsi,
      masterProvinsi: masterProvinsi.stream,
      masterKota: masterKota.stream,
      alamat: alamat,
      alamatDetail: alamatDetail,
      tglSurvey: tglSurvey,
      jamSurvey: jamSurvey,
      buttonAlamat: buttonAlamat.stream,
      postPengajuan: postPengajuan,
      response: responseController,
      getPasangan: getHubunganKeluarga,
      pasangan: pasanganController.stream,
    );
  }
}

enum TypeFile {
  stnk,
  bpkb,
}
