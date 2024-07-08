import 'package:flutter/material.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pekerjaan/info_pekerjaan_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pribadi/info_pribadi_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pribadi/info_pribadi_loading.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class InformasiPribadiPage extends StatefulWidget {
  static const routeName = '/informasi_pribadi_page';
  const InformasiPribadiPage({super.key});

  @override
  State<InformasiPribadiPage> createState() => _InformasiPribadiPageState();
}

class _InformasiPribadiPageState extends State<InformasiPribadiPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    context.bloc<InfoPribadiBloc>().getData();
  }

  @override
  void dispose() {
    super.dispose();
    context.bloc<InfoPribadiBloc>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<InfoPribadiBloc>();
    return Scaffold(
      appBar: previousTitle(context, 'Data Pribadi'),
      body: dataPribadiWidget(bloc),
    );
  }

  Widget dataPribadiWidget(InfoPribadiBloc dataBloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: dataBloc.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? {};
          final String tglLahir = dateFormatComplete(data['tanggal_lahir']);

          final Map<String, dynamic> statusKawin = statusKawinList.firstWhere(
            (item) =>
                item['id'] ==
                int.tryParse(data['id_status_perkawinan'] ?? 'null'),
            orElse: () => {},
          );
          final Map<String, dynamic> pendidikan = pendidikanList.firstWhere(
            (item) => item['id'] == data['id_pendidikan_terakhir'],
            orElse: () => {},
          );
          final Map<String, dynamic> agama = agamaList.firstWhere(
            (item) => item['id'] == int.tryParse(data['id_agama'] ?? 'null'),
            orElse: () => {},
          );
          final Map<String, dynamic> statusRumah = statusRumahList.firstWhere(
            (item) =>
                item['id'] == int.tryParse(data['status_rumah'] ?? 'null'),
            orElse: () => {},
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  alertUpdate1(context),
                  const SizedBox(height: 24),
                  const Headline3500(text: 'Data Diri'),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Nama Sesuai KTP', data['nama_borrower'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Nomor KTP', data['ktp'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Tempat Lahir', data['tempat_lahir'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Tanggal Lahir', tglLahir),
                  const SizedBox(height: 16),
                  keyValVertical('Jenis Kelamin',
                      data['idjenis_kelamin'] == 1 ? 'Laki-Laki' : 'Perempuan'),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Status Perkawinan', statusKawin['nama'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Status Perkawinan', pendidikan['nama'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Agama', agama['nama'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('NPWP', data['nwp'] ?? ''),
                  const SizedBox(height: 16),
                  const Headline3500(text: 'Informasi Tambahan'),
                  const SizedBox(height: 16),
                  keyValVertical('Nama Ibu Kandung',
                      data['ibu_kandung'] ?? data['ibukandung']),
                  const SizedBox(height: 16),
                  keyValVertical('Status Rumah', statusRumah['nama'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Lama Tinggal(tahun)', data['lama_tinggal'].toString()),
                  const SizedBox(height: 16),
                  const Headline3500(text: 'Alamat Sesuai KTP'),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Alamat', data['alamat_rumah'] ?? data['alamat']),
                  const SizedBox(height: 16),
                  keyValVertical('Provinsi', data['nama_provinsi'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Kabupaten/Kota', data['nama_kabupaten'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Kecamatan', data['kecamatan'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Kelurahan', data['kelurahan'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Kode Pos', data['kode_pos'] ?? ''),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }
        return const BorrowerLoading();
      },
    );
  }

  Widget dataLenderWidget(Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              dataPribadi(data),
              dividerFull(context),
              dataAlamat(data),
            ],
          ),
        ],
      ),
    );
  }

  Widget dataPribadiWidgetLender(InfoPribadiBloc dataBloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: dataBloc.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? {};
          print('tanggal lahir${data['tanggal_lahir']}');
          final String tglLahir = dateFormatComplete(data['tanggal_lahir']);

          final Map<String, dynamic> statusKawin = statusKawinList.firstWhere(
            (item) =>
                item['id'] ==
                int.tryParse(data['id_status_perkawinan'] ?? 'null'),
            orElse: () => {},
          );
          final Map<String, dynamic> pendidikan = pendidikanList.firstWhere(
            (item) => item['id'] == data['id_pendidikan_terakhir'],
            orElse: () => {},
          );
          final Map<String, dynamic> agama = agamaList.firstWhere(
            (item) => item['id'] == int.tryParse(data['id_agama'] ?? 'null'),
            orElse: () => {},
          );
          final Map<String, dynamic> statusRumah = statusRumahList.firstWhere(
            (item) =>
                item['id'] == int.tryParse(data['status_rumah'] ?? 'null'),
            orElse: () => {},
          );

          return Container(
            child: FutureBuilder<int?>(
              future: rxPrefs.getInt('user_status'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error: Unable to load user status.'),
                  );
                } else if (snapshot.hasData) {
                  int? userStatus = snapshot.data;

                  if (userStatus == null) {
                    return const Center(
                      child: Text('No user status available.'),
                    );
                  } else {
                    if (userStatus == 2) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              alertUpdate1(context),
                              const SizedBox(height: 24),
                              const Headline3500(text: 'Data Diri'),
                              const SizedBox(height: 16),
                              keyValVertical('Nama Sesuai KTP',
                                  data['nama_borrower'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical('Nomor KTP', data['ktp'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical(
                                  'Tempat Lahir', data['tempat_lahir'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical('Tanggal Lahir', tglLahir),
                              const SizedBox(height: 16),
                              keyValVertical(
                                  'Jenis Kelamin',
                                  data['idjenis_kelamin'] == 1
                                      ? 'Laki-Laki'
                                      : 'Perempuan'),
                              const SizedBox(height: 16),
                              keyValVertical('Status Perkawinan',
                                  statusKawin['nama'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical('Status Perkawinan',
                                  pendidikan['nama'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical('Agama', agama['nama'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical('NPWP', data['nwp'] ?? ''),
                              const SizedBox(height: 16),
                              const Headline3500(text: 'Informasi Tambahan'),
                              const SizedBox(height: 16),
                              keyValVertical('Nama Ibu Kandung',
                                  data['ibu_kandung'] ?? data['ibukandung']),
                              const SizedBox(height: 16),
                              keyValVertical(
                                  'Status Rumah', statusRumah['nama'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical('Lama Tinggal(tahun)',
                                  data['lama_tinggal'].toString()),
                              const SizedBox(height: 16),
                              const Headline3500(text: 'Alamat Sesuai KTP'),
                              const SizedBox(height: 16),
                              keyValVertical('Alamat',
                                  data['alamat_rumah'] ?? data['alamat']),
                              const SizedBox(height: 16),
                              keyValVertical(
                                  'Provinsi', data['nama_provinsi'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical('Kabupaten/Kota',
                                  data['nama_kabupaten'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical(
                                  'Kecamatan', data['kecamatan'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical(
                                  'Kelurahan', data['kelurahan'] ?? ''),
                              const SizedBox(height: 16),
                              keyValVertical(
                                  'Kode Pos', data['kode_pos'] ?? ''),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                dataPribadi(data),
                                dividerFull(context),
                                dataAlamat(data),
                              ],
                            ),
                            // Add more widgets if needed
                          ],
                        ),
                      );
                    }
                    // Depending on the user status, display user information
                  }
                } else {
                  return const Center(
                    child: Text('No user status available.'),
                  );
                }
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget dataPribadi(Map<String, dynamic> data) {
    final tgl = DateTime.parse(data['tanggal_lahir'] ?? data['tgllahir']);
    final String tglLahir = DateFormat('dd MMMM yyyy', 'en_US').format(tgl);
    final String jenKel = data['jenkel'] == 'L' ? 'Laki-laki' : 'Perempuan';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            alertUpdateLender(context),
            const SizedBox(height: 24),
            const Headline3500(text: 'Data Pribadi'),
            const SizedBox(height: 16),
            keyValVertical('Nama Lengkap', data['username'] ?? ''),
            const SizedBox(height: 16),
            keyValVertical('Nomor KTP', data['ktp'] ?? ''),
            const SizedBox(height: 16),
            keyValVertical('Tempat Lahir', data['tempatLahir'] ?? ''),
            const SizedBox(height: 16),
            keyValVertical('Tanggal Lahir', tglLahir),
            const SizedBox(height: 16),
            keyValVertical('Jenis Kelamin', jenKel),
            const SizedBox(height: 16),
            keyValVertical('NPWP', data['npwp'] ?? ''),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget dataAlamat(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Headline3500(text: 'Data Alamat'),
            const SizedBox(height: 16),
            keyValVertical('Alamat', data['alamat_rumah'] ?? data['alamat']),
            const SizedBox(height: 16),
            keyValVertical('Kelurahan', data['kelurahan'] ?? ''),
            const SizedBox(height: 16),
            keyValVertical('Kecamatan', data['kecamatan'] ?? ''),
            const SizedBox(height: 16),
            keyValVertical('Kabupaten/Kota', data['namaKota'] ?? ''),
            const SizedBox(height: 16),
            keyValVertical('Provinsi', data['namaProvinsi'] ?? ''),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

Widget alertUpdate1(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: ShapeDecoration(
      color: const Color(0xFFFFF5F2),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFFDE8CF)),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: HexColor('#FF8829'),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () async {
                              // Handle the tap action, e.g., open a contact form or perform a phone call
                              const url = 'https://wa.link/tepong';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                context.showSnackBarError(
                                  'Maaf sepertinya terjadi kesalahan',
                                );
                              }
                            },
                            child: const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Untuk memperbarui data Pribadi Anda silakan ',
                                    style: TextStyle(
                                      color: Color(0xFF5F5F5F),
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'hubungi kami',
                                    style: TextStyle(
                                      color: Color(0xFFFF8829),
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
