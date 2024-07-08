import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/regis_rdl_lender_use_case.dart';
import 'package:flutter_danain/pages/lender/rdl/regis_rdl_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class RegisRdlBloc extends DisposeCallbackBaseBloc {
  final Function0<void> initGetMaster;
  final Function1<int, void> stepChange;
  final Stream<int> stepStream;

  final Stream<bool> isLoading;

  //data pribadi change
  final Function1<String, void> nameChange;
  final Function1<String, void> ktpChange;
  final Function1<String, void> tempatLahirChange;
  final Function1<DateTime, void> tanggalLahirChange;
  final Function1<String, void> genderChange;
  final Function1<String, void> namaIbuChange;
  final Function1<String, void> npwpChange;
  final Function1<bool, void> npwpHideChange;
  final Function1<Map<String, dynamic>, void> statusKawinChange;
  final Function1<Map<String, dynamic>, void> agamaChange;
  final Function1<Map<String, dynamic>, void> pendidikanChange;
  final Function1<Map<String, dynamic>, void> pekerjaanChange;
  final Function1<Map<String, dynamic>, void> penghasilanChange;
  final Function1<Map<String, dynamic>, void> sumberPenghasilanChange;
  final Function1<Map<String, dynamic>, void> tujuanChange;

  //stream data pribadi
  final BehaviorSubject<String> nameValue;
  final BehaviorSubject<String> noKtpValue;
  final BehaviorSubject<String> tempatLahirValue;
  final BehaviorSubject<DateTime> tanggalLahirValue;
  final BehaviorSubject<String> genderValue;
  final BehaviorSubject<String?> namaIbuValue;
  final BehaviorSubject<String?> npwpValue;
  final Stream<bool> npwpHideStream;
  final Stream<Map<String, dynamic>> statusKawinStream;
  final Stream<Map<String, dynamic>> agamaStream;
  final Stream<Map<String, dynamic>> pendidikanStream;
  final Stream<Map<String, dynamic>> pekerjaanStream;
  final Stream<Map<String, dynamic>> penghasilanStream;
  final Stream<Map<String, dynamic>> sumberPenghasilanStream;
  final Stream<Map<String, dynamic>> tujuanStream;
  final Stream<String> genderStream;

  //data pribadi error
  final Stream<String?> nameErrorStream;
  final Stream<String?> ktpErrorStream;
  final Stream<String?> tempatLahirErrorStream;
  final Stream<String?> tanggalLahirErrorStream;
  final Stream<String?> genderErrorStream;
  final Stream<String?> npwpErrorStream;

  //data alamat
  final Function1<String, void> alamatChange;
  final Function1<Map<String, dynamic>, void> provinsiChange;
  final Function1<Map<String, dynamic>, void> kotaChange;
  final Function1<String, void> kecamatanChange;
  final Function1<String, void> kelurahanChange;
  final Function1<String, void> kodePosChange;

  //alamat
  final BehaviorSubject<String> alamatValue;
  final BehaviorSubject<String> kecamatanValue;
  final BehaviorSubject<String> kelurahanValue;
  final BehaviorSubject<String> kodePosValue;
  //alamat Stream
  final Stream<Map<String, dynamic>> provinsiStream;
  final Stream<Map<String, dynamic>?> kotaStream;
  final Stream<List<dynamic>> provinsiList;
  final Stream<List<dynamic>> kotaList;
  final Stream<List<dynamic>> pekerjaanList;

  //data alamat error
  final Stream<String?> alamatErrorStream;
  final Stream<String?> kelurahanError;
  final Stream<String?> kecamatanError;
  final Stream<String?> kodePosError;

  //button
  final Stream<bool> buttonDataPribadi;
  final Stream<bool> buttonAlamat;
  final Function0<void> postPrivy;
  final Stream<RegisRdlMessage?> messageVerif;
  RegisRdlBloc._({
    required this.initGetMaster,
    required this.stepChange,
    required this.stepStream,
    required this.genderValue,
    required this.nameValue,
    required this.noKtpValue,
    required this.tempatLahirValue,
    required this.tanggalLahirValue,
    required this.nameChange,
    required this.nameErrorStream,
    required this.ktpErrorStream,
    required this.ktpChange,
    required this.tempatLahirChange,
    required this.tempatLahirErrorStream,
    required this.tanggalLahirErrorStream,
    required this.tanggalLahirChange,
    required this.genderErrorStream,
    required this.genderChange,
    required this.namaIbuValue,
    required this.namaIbuChange,
    required this.npwpChange,
    required this.npwpValue,
    required this.npwpErrorStream,
    required this.npwpHideChange,
    required this.npwpHideStream,
    //data pribadi
    required this.statusKawinStream,
    required this.statusKawinChange,
    required this.agamaStream,
    required this.agamaChange,
    required this.pendidikanStream,
    required this.pendidikanChange,
    required this.pekerjaanStream,
    required this.pekerjaanChange,
    required this.penghasilanChange,
    required this.penghasilanStream,
    required this.sumberPenghasilanChange,
    required this.sumberPenghasilanStream,
    required this.tujuanChange,
    required this.tujuanStream,
    required this.alamatErrorStream,
    required this.alamatValue,
    required this.alamatChange,
    required this.kecamatanChange,
    required this.kecamatanValue,
    required this.kecamatanError,
    required this.kelurahanError,
    required this.kelurahanChange,
    required this.kelurahanValue,
    required this.provinsiChange,
    required this.provinsiStream,
    required this.kotaChange,
    required this.kotaStream,
    required this.kodePosChange,
    required this.kodePosError,
    required this.kodePosValue,
    required this.provinsiList,
    required this.kotaList,
    required this.pekerjaanList,
    required this.buttonAlamat,
    required this.buttonDataPribadi,
    required this.messageVerif,
    required this.postPrivy,
    required this.genderStream,
    required this.isLoading,
    required Function0<void> dispose,
  }) : super(dispose);

  factory RegisRdlBloc(
    GetAuthStateStreamUseCase getAuthState,
    RegisRdlLenderUseCase regisRdl,
  ) {
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    //step 1
    final stepController = BehaviorSubject<int>.seeded(1);
    final isLoadingController = BehaviorSubject<bool>.seeded(true);
    //step2
    //error
    final nameErrorStream = BehaviorSubject<String?>();
    final ktpErrorStream = BehaviorSubject<String?>();
    final tempatLahirErrorStream = BehaviorSubject<String?>();
    final genderErrorStream = BehaviorSubject<String?>();
    final tanggalLahirErrorStream = BehaviorSubject<String?>();
    final npwpErrorController = BehaviorSubject<String?>();

    final ktpFileController = BehaviorSubject<File>();
    final ktpFileSementaraController = BehaviorSubject<File>();
    final selfieFileController = BehaviorSubject<File>();
    final stepKtpController = BehaviorSubject<int>.seeded(1);
    final nameController = BehaviorSubject<String>();
    final noKtpController = BehaviorSubject<String>();
    final tempatLahirController = BehaviorSubject<String>();
    final genderController = BehaviorSubject<String>();
    final tanggalLahirController = BehaviorSubject<DateTime>();
    final namaIbuController = BehaviorSubject<String?>();
    final npwpController = BehaviorSubject<String?>.seeded('');
    final npwpHideController = BehaviorSubject<bool>.seeded(false);

    //store id
    final statusPerkawinanController = BehaviorSubject<Map<String, dynamic>>();
    final agamaController = BehaviorSubject<Map<String, dynamic>>();
    final pendidikanController = BehaviorSubject<Map<String, dynamic>>();
    final pekerjaanController = BehaviorSubject<Map<String, dynamic>>();
    final provinsiController = BehaviorSubject<Map<String, dynamic>>();
    final kotaController = BehaviorSubject<Map<String, dynamic>?>();

    //store nama
    final sumberPenghasilanController = BehaviorSubject<Map<String, dynamic>>();
    final penghasilanController = BehaviorSubject<Map<String, dynamic>>();
    final tujuanPendanaanController = BehaviorSubject<Map<String, dynamic>>();

    //alamat
    final alamatController = BehaviorSubject<String>();
    final kecamatanController = BehaviorSubject<String>();
    final kelurahanController = BehaviorSubject<String>();
    final kodePosController = BehaviorSubject<String>();

    //alamat error
    final alamatErrorController = BehaviorSubject<String?>();
    final kecamatanErrorController = BehaviorSubject<String?>();
    final kelurahanErrorController = BehaviorSubject<String?>();
    final kodePosErrorController = BehaviorSubject<String?>();

    //list from api
    final dataProvinsi = BehaviorSubject<List<dynamic>>();
    final dataKota = BehaviorSubject<List<dynamic>>();
    final dataPekerjaan = BehaviorSubject<List<dynamic>>();
    final authState$ = getAuthState();

    npwpHideController.listen((value) {
      final bool npwpValid =
          value == true ? true : npwpController.stream.value!.length == 15;
      print('check hide npwp $npwpValid');
    });

    final Stream<bool> buttonDataDiri = Rx.combineLatest3(
      Rx.combineLatest5(
        nameController.stream,
        noKtpController.stream,
        tempatLahirController.stream,
        tanggalLahirController.stream,
        genderController.stream,
        (String? nama, String? ktp, String? tempat, DateTime? tanggal,
            String? gender) {
          return nama != null &&
              ktp != null &&
              tempat != null &&
              tanggal != null &&
              gender != null;
        },
      ),
      Rx.combineLatest6(
        statusPerkawinanController.stream,
        agamaController.stream,
        pendidikanController.stream,
        pekerjaanController.stream,
        npwpController.stream,
        npwpHideController.stream,
        (
          Map<String, dynamic>? statusKawin,
          Map<String, dynamic>? agama,
          Map<String, dynamic>? pendidikan,
          Map<String, dynamic>? pekerjaan,
          String? npwp,
          bool hide,
        ) {
          if (hide == false) {
            return statusKawin != null &&
                agama != null &&
                pendidikan != null &&
                npwp != null &&
                npwp.length == 15;
          } else {
            return statusKawin != null && agama != null && pendidikan != null;
          }
        },
      ),
      Rx.combineLatest3(
        penghasilanController.stream,
        sumberPenghasilanController.stream,
        tujuanPendanaanController.stream,
        (Map<String, dynamic>? a, Map<String, dynamic>? b,
                Map<String, dynamic>? c) =>
            a != null && b != null && c != null,
      ),
      (a, b, c) => a && c && b,
    ).shareValueSeeded(false);

    final validButtonAlamat = Rx.combineLatest6(
      alamatController.stream,
      provinsiController.stream,
      kotaController.stream,
      kecamatanController.stream,
      kelurahanController.stream,
      kodePosController.stream,
      (
        String? a,
        Map<String, dynamic>? b,
        Map<String, dynamic>? c,
        String? d,
        String? e,
        String? f,
      ) =>
          a != null &&
          a.isNotEmpty &&
          b != null &&
          c != null &&
          d != null &&
          d.isNotEmpty &&
          e != null &&
          e.isNotEmpty &&
          f != null &&
          f.length == 5,
    ).shareValueSeeded(false);

    nameErrorStream.addStream(nameController.stream.asyncMap((event) async {
      if (event.length <= 3) {
        return ('Nama minimal lebih dari 3 karakter.');
      }
      return null;
    }));
    npwpErrorController.addStream(npwpController.stream.asyncMap((event) async {
      if (event!.isNotEmpty && event.length != 15) {
        return ('Npwp harus 15 karakter.');
      }
      return null;
    }));

    ktpErrorStream.addStream(noKtpController.stream.asyncMap((event) async {
      if (event.length != 16) return ('Nomor KTP harus 16 karakter.');
      return null;
    }));
    tempatLahirErrorStream
        .addStream(tempatLahirController.stream.asyncMap((event) async {
      if (event.isEmpty) return ('Tempat lahir wajib diisi');
      return null;
    }));

    tanggalLahirErrorStream
        .addStream(tanggalLahirController.stream.asyncMap((event) async {
      if (Validator.isLessThan18YearsFromNow(event)) {
        return 'Anda belum berusia 18 tahun';
      }
      return null;
    }));

    genderErrorStream.addStream(genderController.stream.asyncMap((event) async {
      if (event.isEmpty) return 'Jenis Kelamin wajib diisi';
      if (event != 'L' && event != 'P') return 'Jenis kelamin tidak valid';
      return null;
    }));

    alamatErrorController
        .addStream(alamatController.stream.asyncMap((event) async {
      if (event.length < 1) {
        return ('Alamat wajib diisi.');
      }
      return null;
    }));
    kecamatanErrorController
        .addStream(kecamatanController.stream.asyncMap((event) async {
      if (event.length < 1) {
        return ('Kecamatan wajib diisi.');
      }
      return null;
    }));
    kelurahanErrorController
        .addStream(kelurahanController.stream.asyncMap((event) async {
      if (event.length < 1) {
        return ('Kelurahan wajib diisi.');
      }
      return null;
    }));
    kodePosErrorController
        .addStream(kodePosController.stream.asyncMap((event) async {
      if (event.length < 1) {
        return ('Kode pos wajib diisi.');
      }
      if (event.length != 5) {
        return ('Kode pos harus 5 karakter');
      }
      return null;
    }));

    void getProvinsi() async {
      final response =
          await apiService.getListMasterLender('listprovinsi', null);
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body)['data'];
        dataProvinsi.sink.add(data);
      } else {
        print(response.body);
      }
    }

    void getPekerjaanSelected(int id) async {
      print('ini pekerjaan');
      final response = await apiService.getListMasterLender(
        'listpekerjaan',
        null,
      );
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body)['data'];
        dataPekerjaan.add(data);
        final Map<String, dynamic>? pekerjaan = data.firstWhere(
          (item) => item['idPekerjaan'] == id,
          orElse: null,
        );
        if (pekerjaan != null) {
          pekerjaanController.add(pekerjaan);
        }
      } else {
        print(response.body);
      }
    }

    void getKotaByIdProvinsi(int idprov, bool isGetKota, String kota) async {
      final response = await apiService.getListMasterLender(
        'listkota',
        'idProvinsi=$idprov',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        dataKota.add(data);
        print(dataKota.value);
        if (isGetKota == true) {
          print('kota string: $kota');
          final Map<String, dynamic>? kotaNih = data.firstWhere(
            (element) =>
                element['keterangan'].toString().toLowerCase() ==
                kota.toLowerCase(),
            orElse: () => null,
          );
          if (kotaNih != null) {
            print('kotanya bang: $kotaNih');
            kotaController.add(kotaNih);
          }
        }
      } else {
        print(response.body);
      }
    }

    void getProvinsiWithId(int id) async {
      final response =
          await apiService.getListMasterLender('listprovinsi', null);
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body)['data'];
        dataProvinsi.sink.add(data);
        final Map<String, dynamic>? provinsi = data.firstWhere(
          (item) => item['idPropinsi'] == id,
          orElse: () => null,
        );
        if (provinsi != null) {
          provinsiController.add(provinsi);
        }
      } else {
        print(response.body);
      }
    }

    void getKotaForId(int idprov, int kota) async {
      final response = await apiService.getListMasterLender(
        'listkota',
        'idProvinsi=$idprov',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        dataKota.add(data);
        print(dataKota.value);
        final Map<String, dynamic>? kotaNih = data.firstWhere(
          (element) => element['idKota'] == kota,
          orElse: () => null,
        );
        if (kotaNih != null) {
          kotaController.add(kotaNih);
        }
      } else {
        print(response.body);
      }
    }

    void getPekerjaan() async {
      final response = await apiService.getListMasterLender(
        'listpekerjaan',
        null,
      );
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body)['data'];
        dataPekerjaan.add(data);
      } else {
        print(response.body);
      }
    }

    void getRdlData() async {
      try {
        final event = await authState$.first;
        final beranda = event.orNull()!.userAndToken!.beranda.toString();
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(beranda);
        final dataProfile = decodedToken['profile'];
        final profile = dataProfile['data'];

        final npwp =
            profile['npwp'].toString().replaceAll('.', '').replaceAll('-', '');
        getKotaForId(profile['idpropinsi'], profile['idkota']);
        nameController.add(profile['username']);
        noKtpController.add(profile['ktp']);
        tempatLahirController.add(profile['tempatLahir']);
        namaIbuController.add(profile['ibukandung']);
        alamatController.add(profile['alamat']);
        kecamatanController.add(profile['kecamatan']);
        kelurahanController.add(profile['kelurahan']);
        kodePosController.add(profile['kodepos']);
        tanggalLahirController.add(
          DateTime.parse(profile['tgllahir']).toLocal(),
        );
        genderController.add(profile['jenkel']);
        final Map<String, dynamic>? pernikahan = pendidikanList.firstWhere(
          (item) => item['id'] == int.tryParse(profile['statusPernikahan']),
          orElse: null,
        );
        if (pernikahan != null) {
          statusPerkawinanController.add(pernikahan);
        }
        final Map<String, dynamic>? agama = agamaList.firstWhere(
          (item) => item['id'] == profile['idAgama'],
          orElse: null,
        );
        if (agama != null) {
          agamaController.add(agama);
        }
        final Map<String, dynamic>? pendidikan = pendidikanList.firstWhere(
          (item) => item['id'] == profile['idpendidikan'],
          orElse: null,
        );
        if (pendidikan != null) {
          pendidikanController.add(pendidikan);
        }
        if (npwp == '') {
          npwpHideController.add(true);
        }
        npwpController
            .add(profile['npwp'].replaceAll('.', '').replaceAll('-', ''));
        getPekerjaanSelected(profile['idpekerjaan']);
        getProvinsiWithId(profile['idpropinsi']);
        final Map<String, dynamic> sumberPenghasilan =
            sumberDanaList.firstWhere(
          (item) =>
              item['nama'].toString().toLowerCase() ==
              profile['sumberpenghasilan'].toString().toLowerCase(),
          orElse: null,
        );
        if (sumberPenghasilan != null) {
          sumberPenghasilanController.add(sumberPenghasilan);
        }
        final Map<String, dynamic>? penghasilan =
            penghasilanBulananList.firstWhere(
          (item) =>
              item['nama'].toString().toLowerCase() ==
              profile['penghasilan'].toString().toLowerCase(),
          orElse: null,
        );
        if (penghasilan != null) {
          penghasilanController.add(penghasilan);
        }

        final Map<String, dynamic>? tujuanPendanaan =
            tujuanPendanaanList.firstWhere(
          (item) =>
              item['nama'].toString().toLowerCase() ==
              profile['tujuan'].toString().toLowerCase(),
          orElse: null,
        );
        if (tujuanPendanaan != null) {
          tujuanPendanaanController.add(tujuanPendanaan);
        }
      } catch (e) {
        print('errornya bang: ${e.toString()}');
        getProvinsi();
        getPekerjaan();
      }
      isLoadingController.add(false);
    }

    final goVerifButton = PublishSubject<void>();
    final goVerifClick = goVerifButton.stream.share();
    final credentialVerif = Rx.combineLatest3(
        Rx.combineLatest8(
          nameController.stream,
          noKtpController.stream,
          tempatLahirController.stream,
          tanggalLahirController.stream,
          genderController.stream,
          pekerjaanController.stream,
          alamatController.stream,
          provinsiController.stream,
          (name, ktp, tempat, tanggal, gender, kerja, alamat, prov) => {
            'nama': name,
            'nik': ktp,
            'tempatlahir': tempat,
            'tanggallahir': tanggal.toString(),
            'jeniskelamin': gender,
            'pekerjaan': kerja['idPekerjaan'],
            'alamat': alamat,
            'provinsi': prov['idPropinsi'],
          },
        ),
        Rx.combineLatest8(
          kotaController.stream,
          kecamatanController.stream,
          kelurahanController.stream,
          penghasilanController.stream,
          sumberPenghasilanController.stream,
          tujuanPendanaanController.stream,
          kodePosController.stream,
          npwpController.stream,
          (
            kota,
            kecamatan,
            kelurahan,
            penghasilan,
            sumberPenghasilan,
            tujuan,
            kode,
            String? npwp,
          ) =>
              {
            'npwp': npwp ?? '',
            'kota': kota!['idKota'],
            'kecamatan': kecamatan,
            'kelurahan': kelurahan,
            'penghasilan': penghasilan['nama'],
            'sumberpenghasilan': sumberPenghasilan['nama'],
            'tujuan': tujuan['nama'],
            'kodepos': kode,
          },
        ),
        Rx.combineLatest4(
          statusPerkawinanController.stream,
          namaIbuController.stream,
          agamaController.stream,
          pendidikanController.stream,
          (pernikahan, namaIbu, agama, pendidikan) => {
            'statusPernikahan': pernikahan['id'],
            'ibuKandung': namaIbu,
            'idagama': agama['id'],
            'idpendidikan': pendidikan['id'],
          },
        ), (stream1, stream2, stream3) {
      final Map<String, dynamic> result = {
        'nama': stream1['nama'],
        'anrekening': stream1['nama'],
        'nik': stream1['nik'],
        'tempatlahir': stream1['tempatlahir'],
        'tanggallahir': stream1['tanggallahir'],
        'jeniskelamin': stream1['jeniskelamin'],
        'pekerjaan': stream1['pekerjaan'],
        'npwp': (stream2['npwp'] == null || stream2['npwp'] == 'null'
            ? ''
            : 'kosong'),
        'alamat': stream1['alamat'],
        'provinsi': stream1['provinsi'],
        'kota': stream2['kota'],
        'kecamatan': stream2['kecamatan'],
        'kelurahan': stream2['kelurahan'],
        'penghasilan': stream2['penghasilan'],
        'sumberpenghasilan': stream2['sumberpenghasilan'],
        'tujuan': stream2['tujuan'],
        'kodepos': stream2['kodepos'],
        'statusPernikahan': stream3['statusPernikahan'],
        'ibuKandung': stream3['ibuKandung'],
        'idagama': stream3['idagama'],
        'idpendidikan': stream3['idpendidikan'],
      };
      return CredentialRegis(payload: result);
    });

    final messageVerif = Rx.merge([
      goVerifClick
          .withLatestFrom(credentialVerif, (_, CredentialRegis cred) => cred)
          .exhaustMap(
            (value) => regisRdl(payload: value.payload),
          )
          .map(_responseToMessage)
    ]);

    return RegisRdlBloc._(
      initGetMaster: getRdlData,
      isLoading: isLoadingController.stream,
      stepChange: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      genderChange: (String val) => genderController.add(val),
      genderValue: genderController,
      nameValue: nameController,
      noKtpValue: noKtpController,
      tempatLahirValue: tempatLahirController,
      tanggalLahirValue: tanggalLahirController,
      nameChange: (String val) => nameController.add(val),
      nameErrorStream: nameErrorStream.stream,
      ktpErrorStream: ktpErrorStream.stream,
      ktpChange: (String val) => noKtpController.add(val),
      tempatLahirChange: (String val) => tempatLahirController.add(val),
      tempatLahirErrorStream: tempatLahirErrorStream,
      tanggalLahirChange: (DateTime val) => tanggalLahirController.add(val),
      tanggalLahirErrorStream: tanggalLahirErrorStream,
      genderErrorStream: genderErrorStream,
      statusKawinChange: (val) => statusPerkawinanController.add(val),
      statusKawinStream: statusPerkawinanController.stream,
      agamaChange: (val) => agamaController.add(val),
      agamaStream: agamaController.stream,
      pendidikanChange: (val) => pendidikanController.add(val),
      pendidikanStream: pendidikanController.stream,
      pekerjaanChange: (val) => pekerjaanController.add(val),
      pekerjaanStream: pekerjaanController.stream,
      namaIbuChange: (String? val) => namaIbuController.add(val),
      namaIbuValue: namaIbuController,
      npwpChange: (val) => npwpController.add(val),
      npwpValue: npwpController,
      npwpErrorStream: npwpErrorController.stream,
      npwpHideChange: (val) => npwpHideController.add(val),
      npwpHideStream: npwpHideController.stream,
      penghasilanChange: (val) => penghasilanController.add(val),
      penghasilanStream: penghasilanController.stream,
      sumberPenghasilanChange: (val) => sumberPenghasilanController.add(val),
      sumberPenghasilanStream: sumberPenghasilanController.stream,
      tujuanChange: (val) => tujuanPendanaanController.add(val),
      tujuanStream: tujuanPendanaanController.stream,
      provinsiList: dataProvinsi.stream,
      kotaList: dataKota.stream,
      provinsiStream: provinsiController.stream,
      kotaStream: kotaController.stream,
      provinsiChange: (val) {
        provinsiController.add(val);
        kotaController.add(null);
        getKotaByIdProvinsi(
          val['idPropinsi'],
          false,
          '',
        );
      },
      kotaChange: (val) => kotaController.add(val),
      alamatChange: (val) => alamatController.add(val),
      alamatValue: alamatController,
      alamatErrorStream: alamatErrorController.stream,
      kecamatanChange: (val) => kecamatanController.add(val),
      kecamatanError: kecamatanErrorController.stream,
      kecamatanValue: kecamatanController,
      kelurahanChange: (val) => kelurahanController.add(val),
      kelurahanError: kelurahanErrorController.stream,
      kelurahanValue: kelurahanController,
      kodePosChange: (val) => kodePosController.add(val),
      kodePosError: kodePosErrorController.stream,
      kodePosValue: kodePosController,
      pekerjaanList: dataPekerjaan.stream,
      buttonAlamat: validButtonAlamat,
      buttonDataPribadi: buttonDataDiri,
      postPrivy: () => goVerifButton.add(null),
      messageVerif: messageVerif,
      genderStream: genderController.stream,
      dispose: () {
        ktpFileSementaraController.close();
        stepKtpController.close();
        stepController.close();
        ktpFileController.close();
        selfieFileController.close();
        nameController.close();
        noKtpController.close();
        tempatLahirController.close();
        statusPerkawinanController.close();
        alamatController.close();
        genderController.close();
        kecamatanController.close();
        kelurahanController.close();
        tanggalLahirController.close();
      },
    );
  }
  static RegisRdlMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const RegisRdlSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : RegisRdlErrorMessage(appError.message!, appError.error!),
    );
  }
}

class CredentialRegis {
  final Map<String, dynamic> payload;
  const CredentialRegis({
    required this.payload,
  });
}
