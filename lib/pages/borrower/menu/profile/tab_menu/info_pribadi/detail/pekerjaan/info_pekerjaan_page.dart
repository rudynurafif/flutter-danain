import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pekerjaan/info_pekerjaan_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class InformasiPekerjaanPage extends StatefulWidget {
  static const routeName = '/informasi_pekerjaan_page';
  const InformasiPekerjaanPage({super.key});

  @override
  State<InformasiPekerjaanPage> createState() => _InformasiPekerjaanPageState();
}

class _InformasiPekerjaanPageState extends State<InformasiPekerjaanPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.bloc<InfoKerjaBloc>();
    bloc.getData();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<InfoKerjaBloc>();
    return Scaffold(
      appBar: previousTitle(context, 'Informasi Pekerjaan'),
      body: dataKerjaWidget(bloc),
    );
  }

  Widget dataKerjaWidget(InfoKerjaBloc kejaBloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: kejaBloc.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(
              text: snapshot.error.toString(),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          );
        }
        if (snapshot.hasData) {
          final Map<String, dynamic> data = snapshot.data ?? {};
          final Map<String, dynamic> jabatan = jabatanList.firstWhere(
            (item) => item['id'] == data['jabatan'],
            orElse: () => {},
          );
          final Map<String, dynamic> pekerjaan = pekerjaanList.firstWhere(
            (item) => item['id'] == data['pekerjaan'],
            orElse: () => {},
          );
          final Map<String, dynamic> bidangUsaha = bidangUsahaList.firstWhere(
            (item) =>
                item['id'] == int.tryParse(data['bidang_usaha_perusahaan']),
            orElse: () => {},
          );
          final Map<String, dynamic> sumberDana = sumberDanaList.firstWhere(
            (item) => item['id'] == data['sumber_dana_utama'],
            orElse: () => {},
          );

          return Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  alertUpdate(context),
                  const SizedBox(height: 24),
                  keyValVertical('Sumber Dana', sumberDana['nama'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Pekerjaan', pekerjaan['nama'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Jabatan', jabatan['nama'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Bidang Usaha', bidangUsaha['nama'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Nama Perusahaan', data['nama_perusahaan'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Alamat Perusahaan', data['alamat_perusahaan'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical('Provinsi', data['nama_provinsi'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Kabupaten/Kota', data['nama_kabupaten'] ?? ''),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Kode Pos', data['kode_pos_perusahaan'].toString()),
                  const SizedBox(height: 16),
                  keyValVertical(
                      'Lama Bekerja(tahun)', data['lama_bekerja'].toString()),
                  const SizedBox(height: 16),
                  keyValVertical('Penghasilan Perbulan',
                      rupiahFormat(data['penghasilan_per_bulan'])),
                  const SizedBox(height: 16),
                  keyValVertical('Biaya Hidup Perbulan',
                      rupiahFormat(data['biaya_hidup_per_bulan'])),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                ShimmerLong4(
                  height: 58,
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(height: 24),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 16),
                keyValVerticalLoading(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget alertUpdate(BuildContext context) {
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
                            const url = 'https://wa.link/rvbmhx';
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
                                      'Untuk memperbarui data pekerjaan Anda silakan ',
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
                        ),
                      ),
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

Widget alertUpdateLender(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: ShapeDecoration(
      color: HexColor('#F1FCF4'),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: HexColor('#F1FCF4')),
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
                  Icons.info_outline,
                  color: HexColor('#28AF60'),
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
                            const url = 'https://wa.link/6tdrkq';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              context.showSnackBarError(
                                'Maaf sepertinya terjadi kesalahan',
                              );
                            }
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text:
                                      'Untuk memperbarui data pekerjaan Anda silakan ',
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
                                    color: HexColor('#28AF60'),
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
