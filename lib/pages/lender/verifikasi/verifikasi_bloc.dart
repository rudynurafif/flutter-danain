import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/verifikasi_use_case.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../data/remote/api_service.dart';
import '../../../data/remote/cache.dart';

class VerifikasiBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;

  //funtion
  final Function1<int, void> stepControl;
  final Function1<File, void> ktpControl;
  final Function1<File, void> ktpControlSementara;
  final Function1<File, void> selfieControl;
  final Function1<int, void> stepKtpControl;
  final Function1<bool, void> detailPicControl;
  final Function0<void> sendPhotoSelfie;
  final Function0<void> sendPhotoKtp;
  final Function0<void> getProvinsi;
  final Function0<void> getPekerjaan;
  final Function1<String, void> nameChange;
  final Function1<String, void> ktpChange;
  final Function1<String, void> tempatLahirChange;
  final Function1<DateTime, void> tanggalLahirChange;
  final Function1<String, void> genderChange;
  final Function1<String, void> namaIbuChange;
  final Function1<String, void> npwpChange;
  final Function1<bool, void> npwpHideChange;

  //data alamat
  final Function1<String, void> alamatChange;
  final Function1<Map<String, dynamic>, void> provinsiChange;
  final Function1<Map<String, dynamic>, void> kotaChange;
  final Function1<String, void> kecamatanChange;
  final Function1<String, void> kelurahanChange;
  final Function1<String, void> kodePosChange;

  //data pribadi change
  final Function1<Map<String, dynamic>, void> statusKawinChange;
  final Function1<Map<String, dynamic>, void> agamaChange;
  final Function1<Map<String, dynamic>, void> pendidikanChange;
  final Function1<Map<String, dynamic>, void> pekerjaanChange;
  final Function1<Map<String, dynamic>, void> penghasilanChange;
  final Function1<Map<String, dynamic>, void> sumberPenghasilanChange;
  final Function1<Map<String, dynamic>, void> tujuanChange;

  //stream
  final Stream<int> stepStream;
  final Stream<File> ktpFileStream;
  final Stream<File> ktpFileStreamSementara;
  final Stream<File> selfieFileStream;
  final Stream<bool> buttonPinjamanStream;
  final Stream<int> stepKtpStream;
  final Stream<bool> detailPicStream;
  final Stream<String?> nameErrorStream;
  final Stream<String?> ktpErrorStream;
  final Stream<String?> tempatLahirErrorStream;
  final Stream<String?> tanggalLahirErrorStream;
  final Stream<String?> genderErrorStream;
  final Stream<String?> npwpErrorStream;
  final Stream<String> genderStream;
  final Stream<bool> npwpHideStream;
  final Stream<bool> buttonDataPribadi;
  final Stream<bool> buttonAlamat;

  //data alamat error
  final Stream<String?> alamatErrorStream;
  final Stream<String?> kelurahanError;
  final Stream<String?> kecamatanError;
  final Stream<String?> kodePosError;

  //data pribadi
  final Stream<Map<String, dynamic>> statusKawinStream;
  final Stream<Map<String, dynamic>> agamaStream;
  final Stream<Map<String, dynamic>> pendidikanStream;
  final Stream<Map<String, dynamic>> pekerjaanStream;
  final Stream<Map<String, dynamic>> penghasilanStream;
  final Stream<Map<String, dynamic>> sumberPenghasilanStream;
  final Stream<Map<String, dynamic>> tujuanStream;

  final BehaviorSubject<File> imageKtpValue;
  final BehaviorSubject<File> imaggeSelfieValue;
  final BehaviorSubject<File> imageKtpValueSementara;
  final BehaviorSubject<String> nameValue;
  final BehaviorSubject<String> noKtpValue;
  final BehaviorSubject<String> tempatLahirValue;
  final BehaviorSubject<DateTime> tanggalLahirValue;
  final BehaviorSubject<String> genderValue;
  final BehaviorSubject<String?> namaIbuValue;
  final BehaviorSubject<String?> npwpValue;

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

  final Function0<void> postPrivy;
  final Stream<VerifikasiMessage?> messageVerif;
  VerifikasiBloc._({
    required this.apiService,
    required this.stepControl,
    required this.stepStream,
    required this.ktpFileStream,
    required this.ktpControl,
    required this.selfieFileStream,
    required this.selfieControl,
    required this.buttonPinjamanStream,
    required this.stepKtpControl,
    required this.stepKtpStream,
    required this.detailPicControl,
    required this.detailPicStream,
    required this.imageKtpValue,
    required this.imaggeSelfieValue,
    required this.ktpControlSementara,
    required this.imageKtpValueSementara,
    required this.ktpFileStreamSementara,
    required this.sendPhotoSelfie,
    required this.sendPhotoKtp,
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
    required this.genderStream,
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
    required this.buttonDataPribadi,
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
    required this.getProvinsi,
    required this.pekerjaanList,
    required this.getPekerjaan,
    required this.buttonAlamat,
    required this.messageVerif,
    required this.postPrivy,
    required Function0<void> dispose,
  }) : super(dispose);

  factory VerifikasiBloc(
    VerifikasiLenderUseCase verifUseCase,
  ) {
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    //step 1
    final stepController = BehaviorSubject<int>.seeded(0);

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
    final detailPicController = BehaviorSubject<bool>.seeded(false);
    final messageSelfieController = BehaviorSubject<String>();
    final messageKtpController = BehaviorSubject<String>();
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

    final validButtonPinjaman = Rx.combineLatest2(
      ktpFileController.stream,
      selfieFileController.stream,
      (
        File ktp,
        File selfie,
      ) {
        final bool ktpValid = ktp != Null;
        final bool selfieValid = selfie != Null;
        return ktpValid && selfieValid;
      },
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

    void uploadSelfie() async {
      final selfie = selfieFileController.valueOrNull;
      if (selfie == null) {
        messageSelfieController.add('data tidak ada');
      } else {
        try {
          final response = await apiService.masterUploadFileSelfiLender(
              selfie, 'selfie', 'selfie-borrower');
          final data = jsonDecode(response.body);
          print('data response selfie $data');
          if (response.isSuccessful) {
            await saveToCacheBool('selfie_status', true);
          } else {
            // messageController.sink.add(VerificationError(data['message'], data));
          }
        } catch (e) {
          messageSelfieController.add(e.toString());
        }
      }
    }

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

    void getKotaByIdProvinsi(int idprov, bool isGetKota, String kota) async {
      final response = await apiService.getListMasterLender(
          'listkota', 'idProvinsi=$idprov');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
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

    void uploadKtp() async {
      final ktp = ktpFileController.valueOrNull;
      print('data KTP $ktp');
      if (ktp == null) {
        messageKtpController.add('Tidak ada file yang di unggah');
      } else {
        try {
          final response = await apiService.masterUploadFileLender(
            ktp,
            'ktp',
            'ktp-lender',
          );
          final data = jsonDecode(response.body);

          final dataKtp = data['data'];
          print('data response Ktp ${dataKtp}');
          final String birthday = dataKtp['birthPlaceBirthday'];
          final List<String> listBirthday = birthday.split(',');
          nameController.add(dataKtp['name']);
          noKtpController.add(dataKtp['idNumber']);
          tempatLahirController.add(listBirthday[0]);

          if (dataKtp['gender'].toString().toLowerCase() == 'laki-laki') {
            genderController.add('L');
          } else {
            genderController.add('P');
          }
          // statusPerkawinanController.add(dataKtp['idstatus']);
          alamatController.add(dataKtp['address']);
          // provinsiController.add(dataKtp['provinsi']);
          kecamatanController.add(dataKtp['district']);
          kelurahanController.add(dataKtp['village']);
          final listProvinsi = dataProvinsi.valueOrNull ?? [];
          final Map<String, dynamic>? provinsiNih = listProvinsi.firstWhere(
            (element) =>
                element['keterangan'].toString().toLowerCase() ==
                dataKtp['province'].toString().toLowerCase(),
            orElse: () => null,
          );
          if (provinsiNih != null) {
            provinsiController.add(provinsiNih);
            getKotaByIdProvinsi(
              provinsiNih['idPropinsi'],
              true,
              dataKtp['city'],
            );
          }
          print('birthday bang ${listBirthday[1]}');
          final String tglLahir = listBirthday[1].replaceAll(' ', '');
          DateFormat dateFormat = DateFormat('dd-MM-yyyy');
          DateTime parsedDate = dateFormat.parseStrict(tglLahir);
          print('lagi bang: ${parsedDate}');
          tanggalLahirController.add(parsedDate.toLocal());
          print('BERHASIL BANG');
        } catch (e) {
          print(e.toString());
        }
      }
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
            'npwp': npwp ?? 'kosong',
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
            ? 'kosong'
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
      return CredentialVerif(payload: result);
    });

    final messageVerif = Rx.merge([
      goVerifClick
          .withLatestFrom(credentialVerif, (_, CredentialVerif cred) => cred)
          .exhaustMap(
            (value) => verifUseCase(payload: value.payload),
          )
          .map(_responseToMessage)
    ]);

    return VerifikasiBloc._(
      apiService: apiService,
      stepControl: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      ktpFileStream: ktpFileController,
      ktpControl: (File val) => ktpFileController.add(val),
      selfieFileStream: selfieFileController,
      selfieControl: (File val) => selfieFileController.add(val),
      buttonPinjamanStream: validButtonPinjaman,
      stepKtpControl: (int val) => stepKtpController.add(val),
      stepKtpStream: stepKtpController,
      detailPicControl: (bool val) => detailPicController.add(val),
      detailPicStream: detailPicController,
      genderChange: (String val) => genderController.add(val),
      imageKtpValue: ktpFileController,
      getProvinsi: getProvinsi,
      imaggeSelfieValue: selfieFileController,
      ktpControlSementara: (File val) => ktpFileSementaraController.add(val),
      imageKtpValueSementara: ktpFileSementaraController,
      ktpFileStreamSementara: ktpFileSementaraController,
      sendPhotoSelfie: uploadSelfie,
      sendPhotoKtp: uploadKtp,
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
      buttonDataPribadi: buttonDataDiri,
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
      getPekerjaan: getPekerjaan,
      buttonAlamat: validButtonAlamat,
      postPrivy: () => goVerifButton.add(null),
      messageVerif: messageVerif,
    );
  }
  static VerifikasiMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const VerifikasiSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : VerifikasiErrorMessage(appError.message!, appError.error!),
    );
  }
}

class CredentialVerif {
  final Map<String, dynamic> payload;
  const CredentialVerif({
    required this.payload,
  });
}
