import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/type_defs.dart';

class AktivasiAkunBloc extends DisposeCallbackBaseBloc {
  final BehaviorSubject<int> step;
  final Stream<bool> isLoading;
  final Stream<String?> errorMessage;

  final Function0<void> getMasterData;
  final Function1<int, void> getKota;

  //list data
  final Stream<List<dynamic>> sumberDanaList;
  final Stream<List<dynamic>> jenisPekerjaanList;
  final Stream<List<dynamic>> bidangUsahaList;
  final Stream<List<dynamic>> provinsiList;
  final Stream<List<dynamic>> kotaList;
  final Stream<List<dynamic>> bankList;
  final Stream<List<dynamic>> jabatanList;
  final Stream<List<dynamic>> hubunganList;

  //step 1
  final BehaviorSubject<Map<String, dynamic>?> sumberDana;
  final BehaviorSubject<Map<String, dynamic>?> jenisKerja;
  final BehaviorSubject<Map<String, dynamic>?> jabatan;
  final BehaviorSubject<Map<String, dynamic>?> bidangUsaha;
  final BehaviorSubject<String?> namaPerusahaan;
  final BehaviorSubject<String?> alamatPerusahaan;
  final BehaviorSubject<Map<String, dynamic>?> provinsi;
  final BehaviorSubject<Map<String, dynamic>?> kota;
  final BehaviorSubject<String?> kodePos;
  final BehaviorSubject<String?> lamaKerja;
  final BehaviorSubject<int?> penghasilan;
  final BehaviorSubject<int?> biayaHidup;
  final Stream<bool> buttonStep1;

  // step 2
  final BehaviorSubject<String?> namaLengkapKontakDarurat;
  final BehaviorSubject<Map<String, dynamic>?> hubunganKontakDarurat;
  final BehaviorSubject<String?> noHandphoneKontakDarurat;
  final BehaviorSubject<String?> namaLengkapPasangan;
  final BehaviorSubject<String?> noKtpPasangan;
  final BehaviorSubject<String?> noHandphonePasangan;
  final Stream<bool> buttonStep2;

  //step 3
  final BehaviorSubject<Map<String, dynamic>?> namaBank;
  final BehaviorSubject<String?> noRekening;
  final BehaviorSubject<String?> kotaBank;
  final Stream<bool> buttonStep3;

  final Function0<void> getBankData;
  final Stream<Map<String, dynamic>?> infoBank;

  final Function0<void> postDataPendukung;
  final Stream<bool> isPostDone;

  AktivasiAkunBloc._({
    required this.step,
    required this.getMasterData,
    required this.sumberDanaList,
    required this.jenisPekerjaanList,
    required this.bidangUsahaList,
    required this.provinsiList,
    required this.kotaList,
    required this.bankList,
    required this.sumberDana,
    required this.jenisKerja,
    required this.jabatan,
    required this.jabatanList,
    required this.hubunganList,
    required this.bidangUsaha,
    required this.namaPerusahaan,
    required this.alamatPerusahaan,
    required this.provinsi,
    required this.kota,
    required this.kodePos,
    required this.lamaKerja,
    required this.penghasilan,
    required this.biayaHidup,
    required this.namaLengkapKontakDarurat,
    required this.hubunganKontakDarurat,
    required this.noHandphoneKontakDarurat,
    required this.namaLengkapPasangan,
    required this.noKtpPasangan,
    required this.noHandphonePasangan,
    required this.namaBank,
    required this.noRekening,
    required this.getKota,
    required this.kotaBank,
    required this.buttonStep1,
    required this.buttonStep2,
    required this.buttonStep3,
    required this.isLoading,
    required this.errorMessage,
    required this.getBankData,
    required this.infoBank,
    required this.postDataPendukung,
    required this.isPostDone,
    required Function0<void> dispose,
  }) : super(dispose);

  factory AktivasiAkunBloc(
    GetRequestV2UseCase getV2,
    GetInfoBankUseCase getInfoBank,
    PostDataPendukungUseCase postData,
  ) {
    final step = BehaviorSubject<int>.seeded(1);
    final isLoading = BehaviorSubject<bool>.seeded(true);
    final sumberDanaList = BehaviorSubject<List<dynamic>>();
    final jabatanList = BehaviorSubject<List<dynamic>>();
    final jenisPekerjaanList = BehaviorSubject<List<dynamic>>();
    final bidangUsahaList = BehaviorSubject<List<dynamic>>();
    final provinsiList = BehaviorSubject<List<dynamic>>();
    final kotaList = BehaviorSubject<List<dynamic>>();
    final bankList = BehaviorSubject<List<dynamic>>();
    final hubunganList = BehaviorSubject<List<dynamic>>();
    final messageError = BehaviorSubject<String?>();

    final sumberDana = BehaviorSubject<Map<String, dynamic>?>();
    final jenisKerja = BehaviorSubject<Map<String, dynamic>?>();
    final jabatan = BehaviorSubject<Map<String, dynamic>?>();
    final bidangUsaha = BehaviorSubject<Map<String, dynamic>?>();
    final namaPerusahaan = BehaviorSubject<String?>();
    final alamatPerusahaan = BehaviorSubject<String?>();
    final provinsi = BehaviorSubject<Map<String, dynamic>?>();
    final kota = BehaviorSubject<Map<String, dynamic>?>();
    final kodePos = BehaviorSubject<String?>();
    final lamaKerja = BehaviorSubject<String?>();
    final penghasilan = BehaviorSubject<int?>();
    final biayaHidup = BehaviorSubject<int?>();

    final isPostDone = BehaviorSubject<bool>.seeded(false);

    final buttonStep1 = BehaviorSubject<bool>.seeded(false);
    buttonStep1.addStream(
      Rx.combineLatest3(
        Rx.combineLatest4(
          sumberDana.stream,
          jenisKerja.stream,
          jabatan.stream,
          bidangUsaha.stream,
          (a, b, c, d) {
            return a != null && b != null && c != null && d != null;
          },
        ),
        Rx.combineLatest4(
          namaPerusahaan.stream,
          alamatPerusahaan.stream,
          provinsi.stream,
          kota.stream,
          (a, b, c, d) {
            return a != null && b != null && c != null && d != null;
          },
        ),
        Rx.combineLatest4(
          kodePos.stream,
          lamaKerja.stream,
          penghasilan.stream,
          biayaHidup.stream,
          (a, b, c, d) {
            return a != null && a.length == 5 && b != null && c != null && d != null;
          },
        ),
        (bool a, bool b, bool c) {
          return a == true && b == true && c == true;
        },
      ).shareValueSeeded(false),
    );

    //step 2

    final namaLengkapKontakDarurat = BehaviorSubject<String?>();
    final hubunganKontakDarurat = BehaviorSubject<Map<String, dynamic>?>();
    final noHandphoneKontakDarurat = BehaviorSubject<String?>();
    final namaLengkapPasangan = BehaviorSubject<String?>();
    final noKtpPasangan = BehaviorSubject<String?>();
    final noHandphonePasangan = BehaviorSubject<String?>();
    final buttonStep2 = BehaviorSubject<bool>.seeded(false);

    //step 3
    final namaBank = BehaviorSubject<Map<String, dynamic>?>();
    final noRekening = BehaviorSubject<String?>();
    final kotaBank = BehaviorSubject<String?>();
    final infoBank = BehaviorSubject<Map<String, dynamic>?>();
    final buttonStep3 = BehaviorSubject<bool>.seeded(false);
    buttonStep3.addStream(
      Rx.combineLatest3(
        namaBank.stream,
        noRekening.stream,
        kotaBank.stream,
        (a, b, c) {
          return a != null && b != null && c != null;
        },
      ).shareValueSeeded(false),
    );

    Future<void> getBankData() async {
      isLoading.add(true);
      infoBank.add(null);
      try {
        final bank = namaBank.valueOrNull ?? {};
        final response = await getInfoBank.call(
          idBank: bank['id'],
          noRek: noRekening.valueOrNull ?? '',
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            infoBank.add(value.toJson());
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
      isLoading.add(false);
    }

    Future<void> postDataPendukung() async {
      isLoading.add(true);
      try {
        final sD = sumberDana.valueOrNull ?? {};
        final kerja = jenisKerja.valueOrNull ?? {};
        final jbtn = jabatan.valueOrNull ?? {};
        final usaha = bidangUsaha.valueOrNull ?? {};
        final pv = provinsi.valueOrNull ?? {};
        final kotKab = kota.valueOrNull ?? {};
        final bank = namaBank.valueOrNull ?? {};
        final bankInfo = infoBank.valueOrNull ?? {};
        final dataBank = bankInfo['data'] ?? {};
        final Map<String, dynamic> payload = {
          'sumber_dana_utama': sD['id'],
          'pekerjaan': kerja['id'],
          'jabatan': jbtn['id'],
          'bidang_usaha_perusahaan': usaha['id'],
          'nama_perusahaan': namaPerusahaan.valueOrNull ?? '',
          'alamat_perusahaan': alamatPerusahaan.valueOrNull ?? '',
          'kota_perusahaan': kotKab['id'],
          'provinsi_perusahaan': pv['id'],
          'kode_pos_perusahaan': int.tryParse(kodePos.valueOrNull ?? ''),
          'lama_bekerja': int.tryParse(lamaKerja.valueOrNull ?? ''),
          'penghasilan_per_bulan': penghasilan.valueOrNull ?? 0,
          'biaya_hidup_per_bulan': biayaHidup.valueOrNull ?? 0,
          'status_pekerjaan': 1,
          'no_rekening': noRekening.valueOrNull,
          'an_rekening': dataBank['customerName'],
          'id_bank': bank['id'],
          'kota_bank': kotaBank.valueOrNull ?? '',
          'is_active': 1,
          'idRekening': 0
        };
        final response = await postData.call(data: payload);
        response.fold(
          ifLeft: (error) {
            isLoading.add(false);
            messageError.add(error);
          },
          ifRight: (value) {
            isLoading.add(false);
            isPostDone.add(true);
          },
        );
      } catch (e) {
        isLoading.add(false);
        messageError.add(e.toString());
      }
    }

    Future<void> getSumberDana() async {
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/v2/master/listactive/sumber_dana',
          queryParam: {},
        );
        response.fold(
          ifLeft: (error) {
            print('masuk left bang');
            print(error);
            messageError.add(error);
          },
          ifRight: (value) {
            print('masuk right bang');
            sumberDanaList.add(value.data);
          },
        );
      } catch (e) {
        print('masuk error bang bang');
        messageError.add(e.toString());
      }
    }

    Future<void> getJabatan() async {
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/v2/master/listactive/jabatan',
          queryParam: {},
        );
        response.fold(
          ifLeft: (error) {
            print('masuk left bang');
            print(error);
            messageError.add(error);
          },
          ifRight: (value) {
            print('masuk right bang');
            jabatanList.add(value.data);
          },
        );
      } catch (e) {
        print('masuk error bang bang');
        messageError.add(e.toString());
      }
    }

    Future<void> getJenisKerja() async {
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/v2/master/listactive/pekerjaan',
          queryParam: {},
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            jenisPekerjaanList.add(value.data);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    Future<void> getBidangUsaha() async {
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/v2/master/listactive/sektor_kelompok',
          queryParam: {},
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            bidangUsahaList.add(value.data);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    Future<void> getProvinsi() async {
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/v2/master/listactive/provinsi',
          queryParam: {},
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            provinsiList.add(value.data);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    Future<void> getKota(int idProvinsi) async {
      isLoading.add(true);
      kota.add(null);
      kotaList.add([]);
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/v2/master/listactive/kotaByProvinsi',
          queryParam: {
            'idprovinsi': idProvinsi,
          },
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            kotaList.add(value.data);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
      isLoading.add(false);
    }

    Future<void> getBank() async {
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/v2/master/listactive/bank',
          queryParam: {},
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            bankList.add(value.data);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    Future<void> getMasterData() async {
      await getSumberDana();
      await getJenisKerja();
      await getJabatan();
      await getBidangUsaha();
      await getProvinsi();
      await getBank();
      isLoading.add(false);
    }

    return AktivasiAkunBloc._(
      step: step,
      sumberDanaList: sumberDanaList.stream,
      jenisPekerjaanList: jenisPekerjaanList.stream,
      bidangUsahaList: bidangUsahaList.stream,
      provinsiList: provinsiList.stream,
      kotaList: kotaList.stream,
      jabatanList: jabatanList.stream,
      bankList: bankList.stream,
      hubunganList: hubunganList.stream,
      sumberDana: sumberDana,
      jenisKerja: jenisKerja,
      jabatan: jabatan,
      bidangUsaha: bidangUsaha,
      namaPerusahaan: namaPerusahaan,
      alamatPerusahaan: alamatPerusahaan,
      provinsi: provinsi,
      kota: kota,
      kodePos: kodePos,
      lamaKerja: lamaKerja,
      penghasilan: penghasilan,
      biayaHidup: biayaHidup,
      namaLengkapKontakDarurat: namaLengkapKontakDarurat,
      hubunganKontakDarurat: hubunganKontakDarurat,
      noHandphoneKontakDarurat: noHandphoneKontakDarurat,
      namaLengkapPasangan: namaLengkapPasangan,
      noKtpPasangan: noKtpPasangan,
      noHandphonePasangan: noHandphonePasangan,
      namaBank: namaBank,
      noRekening: noRekening,
      kotaBank: kotaBank,
      getMasterData: getMasterData,
      getKota: getKota,
      errorMessage: messageError.stream,
      isLoading: isLoading.stream,
      buttonStep1: buttonStep1.stream,
      buttonStep2: buttonStep2.stream,
      buttonStep3: buttonStep3.stream,
      getBankData: getBankData,
      infoBank: infoBank.stream,
      isPostDone: isPostDone.stream,
      postDataPendukung: postDataPendukung,
      dispose: () {},
    );
  }
}
