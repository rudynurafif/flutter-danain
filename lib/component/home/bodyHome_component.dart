// import 'package:flutter/material.dart';
// import 'package:flutter_danain/domain/models/user.dart';
// import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
// import 'package:flutter_danain/widgets/widget_element.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../layout/footer_Lisence.dart';
// import '../../pages/borrower/product/cash_drive/konfirmasi_jadwal_survey_cd/konfirmasi_jadwal_survey_page.dart';
// import '../../pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_page.dart';
// import 'appBarHome_layout.dart';
// import 'btmSheetPenyerahan_component.dart';
// import 'carousel_produk_component.dart';
// import 'menu_component_2.dart';
// import 'tagihan_component.dart';
// import 'verif_component.dart';

// class BodyHomeWidget extends StatelessWidget {
//   final Map<String, dynamic> dataHome;
//   final HomeBloc homeBloc;
//   final User? user;

//   const BodyHomeWidget({
//     super.key,
//     required this.dataHome,
//     required this.homeBloc,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final num tkb = 90;
//     final String tkbString = tkb.toString();
//     final int decimalIndex = tkbString.indexOf('.');
//     final String tkbConvert = tkbString.substring(0, decimalIndex + 3);

//     return Stack(
//       children: [
//         SvgPicture.asset(
//           'assets/images/home/background_borrower.svg',
//           width: MediaQuery.of(context).size.width,
//           fit: BoxFit.fitWidth,
//         ),
//         Column(
//           children: [
//             AppBarHome(
//               tkb: tkbConvert,
//               notif: dataHome['status']['notifikasi'],
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                       ),
//                       child: TagihanWidget(data: dataHome, homeBloc: homeBloc),
//                     ),
//                     const SizedBox(height: 24),
//                     Stack(
//                       alignment: Alignment.topCenter,
//                       children: [
//                         Column(
//                           children: [
//                             const SpacerV(
//                               value: 50,
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               height: 200,
//                               color: Colors.white,
//                             )
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               child: MenusWidget(data: dataHome, homeBloc: homeBloc, user: user!),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               color: Colors.white,
//                               child: Column(
//                                 children: [
//                                   if (dataHome['konfirmasi_survey'] != null)
//                                     DetailKonfirmasiJadwalSurveyComponent(
//                                       idTask: dataHome['konfirmasi_survey']['noPengajuan'],
//                                       jumlahPinjaman: dataHome['konfirmasi_survey']['pengajuan'],
//                                       status: '-',
//                                       alamatUtama: dataHome['konfirmasi_survey']['alamat'],
//                                       alamatDetail: dataHome['konfirmasi_survey']['detailAlamat'],
//                                       tglSurvey: dataHome['konfirmasi_survey']['tglSurvey'],
//                                       onTap: () {
//                                         Navigator.pushNamed(
//                                           context,
//                                           KonfirmasJadwalSurveyPage.routeName,
//                                           arguments: KonfirmasJadwalSurveyPage(
//                                             idTaskPengajuan: dataHome['konfirmasi_survey']
//                                                     ['idTaskPengajuan']
//                                                 .toString(),
//                                             idPengajuan: dataHome['konfirmasi_survey']
//                                                     ['idPengajuan']
//                                                 .toString(),
//                                           ),
//                                         );
//                                       },
//                                       isStatus:
//                                           dataHome['konfirmasi_survey']['isStatus'].toString(),
//                                     ),
//                                   PengajuanPenyerahanBPKBComponent(
//                                     nilaiPinjaman: 10000000,
//                                     tipe: 'HONDA - CRV - 1.5L CVT BLACK EDITION - 1100 CC -  2022',
//                                     onTap: () {
//                                       showModalBottomSheet(
//                                         context: context,
//                                         useSafeArea: true,
//                                         isScrollControlled: true,
//                                         builder: (context) => BtmSheetPenyerahan(context),
//                                       );
//                                     },
//                                   ),
//                                   if (dataHome['pengajuan_pinjaman'] != null)
//                                     PinjamanBPKBComponent(
//                                       nilaiPinjaman:
//                                           dataHome['pengajuan_pinjaman']['nilai_pinjaman'] ?? "",
//                                       noPenawaran:
//                                           dataHome['pengajuan_pinjaman']['no_penawaran'] ?? "",
//                                       tipe: dataHome['pengajuan_pinjaman']['keterangan'] ?? "",
//                                       onTap: () {
//                                         Navigator.pushNamed(
//                                             context, KonfirmasiPinjamanPage.routeName,
//                                             arguments: KonfirmasiPinjamanPage(
//                                               idPengajuan: dataHome['pengajuan_pinjaman']
//                                                   ['id_pengajuan'],
//                                             ));
//                                       },
//                                     ),
//                                   const CarouselProduk(),
//                                   dividerFull(context),
//                                   footerLisence(context),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
