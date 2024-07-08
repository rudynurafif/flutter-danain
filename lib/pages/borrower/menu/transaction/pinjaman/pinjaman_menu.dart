// import 'package:did_change_dependencies/did_change_dependencies.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
// import 'package:flutter_danain/data/constants.dart';
// import 'package:flutter_danain/domain/models/user.dart';
// import 'package:flutter_danain/pages/borrower/after_login/pengajuan_pinjaman/pengajuan_pinjaman_page.dart';
// import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
// import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
// import 'package:flutter_danain/widgets/widget_element.dart';
// import 'package:flutter_disposebag/flutter_disposebag.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:intl/intl.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

// import '../../../../../component/home/action_modal_component.dart';
// import '../../../../../domain/models/app_error.dart';
// import '../../../../../domain/models/auth_state.dart';
// import '../../../product/cicil_emas/product/page_gagal.dart';
// import '../../../home/qrcode_pages.dart';
// import 'detail_pinjaman/detail_riwayat_pinjaman_proses_page.dart';
// import 'pinjaman_bloc.dart';

// class RiwayatPinjaman extends StatefulWidget {
//   static const routeName = 'homePage';
//   final HomeBloc homeBloc;
//   const RiwayatPinjaman({super.key, required this.homeBloc});

//   @override
//   State<RiwayatPinjaman> createState() => _RiwayatPinjamanState();
// }

// class _RiwayatPinjamanState extends State<RiwayatPinjaman>
//     with DidChangeDependenciesStream, DisposeBagMixin {
//   final pinjamanBloc = PinjamanMenuBloc();
//   Map<String, dynamic> dataHome = {};
//   int pinjamanAktif = 10000000;
//   int totalTransaksi = 1;
//   final ScrollController _scrollController = ScrollController();
//   String sort = '';
//   String getParameter() {
//     final produk = selectedStatus.map((id) => 'statusPinjaman=$id').join('&');
//     return '&sortBy=$currentItemList&$produk';
//   }

//   @override
//   void initState() {
//     super.initState();
//     pinjamanBloc.initGetData(getParameter());
//     _scrollController.addListener(() {
//       if (_scrollController.position.atEdge) {
//         pinjamanBloc.getNewList(getParameter());
//       }
//     });
//   }

//   Stream<void> validationFdc(response) async* {
//     if (response['data']['fdc'] == true) {
//       await Navigator.pushNamed(
//         context,
//         PengajuanPinjaman.routeName,
//       );
//     } else {
//       await Navigator.pushNamed(
//         context,
//         PengajuanCicilanGagal.routeName,
//         arguments: 'pinjaman',
//       );
//     }

//     await delay(1000);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   List<Map<String, dynamic>> filterList = [
//     {
//       'id': 'terbaru',
//       'nama': 'Terbaru',
//     },
//     {
//       'id': 'terlama',
//       'nama': 'Terlama',
//     },
//     {
//       'id': 'terendah',
//       'nama': 'Pinjaman Terendah',
//     },
//     {
//       'id': 'tertinggi',
//       'nama': 'Pinjaman Tertinggi',
//     },
//   ];

//   List<Map<String, dynamic>> statusList = [
//     {
//       'id': 'ProsesPencairan',
//       'name': 'Proses Pencairan',
//     },
//     {
//       'id': 'Aktif',
//       'name': 'Aktif',
//     },
//     {
//       'id': 'TelatBayar',
//       'name': 'Telat Bayar',
//     },
//     {
//       'id': 'Selesai',
//       'name': 'Selesai',
//     },
//     {
//       'id': 'Pemutusan',
//       'name': 'Pemutusan',
//     },
//     {
//       'id': 'GagalBayar',
//       'name': 'Gagal Bayar',
//     },
//   ];

//   String currentItemList = '';
//   List<String> selectedStatus = [];
//   void showFilterModal() {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (context) => filterModal(context, pinjamanBloc),
//     );
//   }

//   void reset(StateSetter setState) {
//     setState(() {
//       currentItemList = '';
//       selectedStatus = [];
//       pinjamanBloc.initGetData(getParameter());
//       Navigator.pop(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RxStreamBuilder<Result<AuthenticationState>?>(
//       stream: widget.homeBloc.authState$,
//       builder: (context, result) {
//         final beranda = result?.orNull()?.userAndToken?.beranda;
//         final user = result?.orNull()?.userAndToken!.user;
//         final Map<String, dynamic> decodedToken = JwtDecoder.decode(beranda!);
//         dataHome = decodedToken['beranda'];
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               pinjamanWidget(pinjamanBloc),
//               const SizedBox(height: 24),
//               listData(context, pinjamanBloc),
//               const SizedBox(height: 24),
//               Expanded(
//                 child: riwayatPinjaman2(pinjamanBloc, dataHome, user!, beranda),
//               ),
//               // noTransactionWidget(context),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget pinjamanWidget(PinjamanMenuBloc bloc) {
//     return StreamBuilder<int>(
//       stream: bloc.totalHargaPinjaman.stream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final total = snapshot.data ?? 0;
//           return Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 LayoutBuilder(
//                   builder: (context, BoxConstraints constraints) {
//                     return SizedBox(
//                       width: constraints.maxWidth,
//                       child: SvgPicture.asset(
//                         'assets/images/transaction/background_transaksi.svg',
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   },
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Subtitle2(
//                       text: 'Pinjaman Aktif',
//                       color: HexColor('#777777'),
//                     ),
//                     const SizedBox(height: 8),
//                     Headline1(
//                       text: rupiahFormat(total),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }
//         return const ShimmerTransaction();
//       },
//     );
//   }

//   Widget listData(BuildContext context, PinjamanMenuBloc bloc) {
//     return StreamBuilder<int>(
//       stream: bloc.totalPinjaman.stream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final total = snapshot.data ?? 0;
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Headline3(text: 'List Pinjaman Dana'),
//                   const SizedBox(height: 2),
//                   Subtitle3(
//                     text: '$total transaksi',
//                     color: HexColor('#BEBEBE'),
//                   )
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   showFilterModal();
//                 },
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
//                   decoration: BoxDecoration(
//                     color: HexColor('#F9FFFA'),
//                     border: Border.all(
//                       width: 1,
//                       color: HexColor('#E9F6EB'),
//                     ),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.filter_list,
//                         color: HexColor(primaryColorHex),
//                       ),
//                       const SizedBox(width: 8),
//                       const Subtitle2(text: 'Filter')
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           );
//         }
//         return const ShimmerTotal();
//       },
//     );
//   }

//   Widget noTransactionWidget(
//       BuildContext context,
//       Map<String, dynamic> dataHome,
//       User user,
//       int status,
//       String hp,
//       String email,
//       bool haveAll,
//       String parameter) {
//     final Map<String, dynamic> users = {
//       'email': user.username,
//       'ktp': user.ktp,
//       // Add other properties as needed
//     };
//     final Map<String, dynamic> arguments = {
//       'dataHome': dataHome['barcode'],
//       'user': users,
//     };
//     return parameter == '&sortBy=&'
//         ? Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                     'assets/images/transaction/no_transaction.svg'),
//                 const SizedBox(height: 8),
//                 const Headline2(
//                   text: 'Anda Belum Memiliki Pinjaman',
//                   align: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Subtitle2(
//                   text:
//                       'Saat ini Anda belum memiliki transaksi pinjaman. Ajukan pinjaman Anda sekarang juga.',
//                   align: TextAlign.center,
//                   color: HexColor('#777777'),
//                 ),
//                 const SizedBox(height: 24),
//                 Button1(
//                   btntext: 'Ajukan Pinjaman',
//                   action: () {
//                     if (dataHome['barcode'] != '') {
//                       Navigator.pushNamed(context, QrcodePages.routeName,
//                           arguments: arguments);
//                     } else {
//                       switch (status) {
//                         case 10:
//                           switch (hp) {
//                             case 'waiting':
//                               return showVerifikasiAlert(context);
//                           }
//                           switch (email) {
//                             case 'waiting':
//                               return showVerifikasiAlert(context);
//                           }
//                           switch (haveAll) {
//                             case true:
//                               Navigator.pushNamed(
//                                 context,
//                                 PengajuanPinjaman.routeName,
//                               );
//                               break;
//                             case false:
//                               return showAktivasiAlert(context);
//                             default:
//                           }
//                           break;
//                         case 9:
//                           return showVerifikasiAlert(context);
//                         case 0:
//                           return showHaventVerifAlert(context);
//                         case 12:
//                           return showRejectPrivyAlert(context);
//                         case 11:
//                           return showRejectPrivyAlert(context);
//                         default:
//                           Navigator.pushNamed(
//                             context,
//                             PengajuanPinjaman.routeName,
//                           );
//                       }
//                     }
//                   },
//                 )
//               ],
//             ),
//           )
//         : Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset('assets/images/icons/empty_search.svg'),
//                 const SizedBox(height: 33),
//                 const Headline2(
//                   text: 'Data Tidak Ditemukan',
//                   align: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Subtitle2(
//                   text:
//                       'Kami tidak menemukan produk yang sesuai filter ini. Coba pilih filter yang lain atau reset filter.',
//                   color: HexColor('#777777'),
//                   align: TextAlign.center,
//                 )
//               ],
//             ),
//           );
//   }

//   Widget filterModal(BuildContext context, PinjamanMenuBloc pinjamanBloc) {
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setState) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16),
//               topRight: Radius.circular(16),
//             ),
//           ),
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: Container(
//                   width: 42,
//                   height: 4,
//                   color: HexColor('#DDDDDD'),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Headline3500(text: 'Filter'),
//                   InkWell(
//                     onTap: () {
//                       reset(setState);
//                     },
//                     child: Subtitle2(
//                       text: 'Reset',
//                       color: HexColor(primaryColorHex),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 24),
//               const Headline3500(text: 'Urutkan'),
//               const SizedBox(height: 12),
//               filterItemStringBorrower(filterList, currentItemList,
//                   (String id) {
//                 setState(() {
//                   currentItemList = id;
//                 });
//               }),
//               const SizedBox(height: 24),
//               const Headline3500(text: 'Status'),
//               multipleSelectLender(
//                 statusList,
//                 selectedStatus,
//                 (data) => setState(() => selectedStatus = data),
//               ),
//               const SizedBox(height: 24),
//               Button1(
//                 btntext: 'Terapkan',
//                 color: currentItemList != '' || selectedStatus.isNotEmpty
//                     ? null
//                     : Colors.grey,
//                 action: currentItemList != '' || selectedStatus.isNotEmpty
//                     ? () {
//                         pinjamanBloc.initGetData(getParameter());
//                         Navigator.pop(context);
//                       }
//                     : null,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget riwayatPinjaman2(PinjamanMenuBloc bloc, Map<String, dynamic> dataHome,
//       User user, String beranda) {
//     final jwtDecode = JwtDecoder.decode(beranda);
//     final data = jwtDecode['beranda'];
//     final int status = data['status']['aktivasi_status'];
//     final String hp = data['status']['status_request_hp'];
//     final String email = data['status']['status_request_email'];
//     final bool haveAll = data['status']['pekerjaan'] == true;
//     return StreamBuilder<List<dynamic>>(
//       stream: bloc.pinjamanListController.stream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final data = snapshot.data ?? [];
//           if (data.isEmpty) {
//             return noTransactionWidget(context, dataHome, user, status, hp,
//                 email, haveAll, getParameter());
//           } else {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: data.length,
//                     controller: _scrollController,
//                     itemBuilder: (context, index) {
//                       final datalist = data[index];
//                       String backgroundColor;
//                       String mainColor;
//                       if (datalist['status'] == 'Aktif') {
//                         backgroundColor = '#F2F8FF';
//                         mainColor = '#007AFF';
//                       } else if (datalist['status'] == 'Gagal Bayar' ||
//                           datalist['status'] == 'Telat Bayar') {
//                         backgroundColor = '#FEF4E8';
//                         mainColor = '#F7951D';
//                       } else if (datalist['status'] == 'Selesai' ||
//                           datalist['status'] == 'Lunas' ||
//                           datalist['status'] == 'Dijual') {
//                         backgroundColor = '#F4FEF5';
//                         mainColor = '#28AF60';
//                       } else {
//                         backgroundColor = '#EEEEEE';
//                         mainColor = '#777777';
//                       }
//                       return GestureDetector(
//                         onTap: () {
//                           datalist['status'] == 'Proses Pencairan'
//                               ? Navigator.pushNamed(context,
//                                   DetailRiwayatPinjamanProsesPage.routeName,
//                                   arguments: datalist['id_agreement'])
//                               : Navigator.pushNamed(
//                                   context, DetailRiwayatPinjaman.routeName,
//                                   arguments: datalist['id_agreement']);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 16),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               width: 1,
//                               color: HexColor('#F0F0F0'),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 9),
//                                 decoration: BoxDecoration(
//                                   color: HexColor('#E9F6EB'),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                               'assets/images/home/maxi.svg'),
//                                           const SizedBox(width: 8),
//                                           Subtitle2Extra(
//                                               text: datalist['nama_produk']),
//                                         ],
//                                       ),
//                                     ),
//                                     Subtitle2(
//                                       text: datalist['no_perjanjian_pinjaman'],
//                                       color: HexColor('#777777'),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 11),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Subtitle3(
//                                           text: 'Total Pinjaman',
//                                           color: HexColor('#AAAAAA'),
//                                         ),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                             vertical: 2,
//                                           ),
//                                           decoration: ShapeDecoration(
//                                             color: HexColor(backgroundColor),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                             ),
//                                           ),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Subtitle3(
//                                                 text: datalist['status'],
//                                                 color: HexColor(mainColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Headline2(
//                                       text: rupiahFormat(int.parse(
//                                           datalist['pokok_hutang'].toString())),
//                                     ),
//                                     dividerFull2(context),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Subtitle3(
//                                               text: 'Tanggal Pinjam',
//                                               color: HexColor('#AAAAAA'),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               DateFormat('dd MMM yyyy').format(
//                                                   DateTime.parse(datalist[
//                                                           'tanggal_pinjaman'])
//                                                       .toLocal()),
//                                               style: const TextStyle(
//                                                 fontFamily: 'Poppins',
//                                                 color: Color(0xFF333333),
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Subtitle3(
//                                               text: 'Tenor',
//                                               color: HexColor('#AAAAAA'),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               '${datalist['tenor'].toString()} hari',
//                                               style: const TextStyle(
//                                                 color: Color(0xFF333333),
//                                                 fontSize: 12,
//                                                 fontFamily: 'Poppins',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Subtitle3(
//                                               text: 'Jatuh Tempo',
//                                               color: HexColor('#AAAAAA'),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               DateFormat('dd MMM yyyy').format(
//                                                   DateTime.parse(datalist[
//                                                           'tanggal_jatuh_tempo'])
//                                                       .toLocal()),
//                                               style: const TextStyle(
//                                                 color: Color(0xFF333333),
//                                                 fontSize: 12,
//                                                 fontFamily: 'Poppins',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0,
//                                                 // Add your custom text styles here
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 StreamBuilder(
//                   stream: bloc.isLoading.stream,
//                   builder: (context, snapshot) {
//                     final isLoading = snapshot.data ?? false;
//                     if (isLoading == true) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 )
//               ],
//             );
//           }
//         }
//         if (snapshot.hasError) {
//           return Center(
//             child: Subtitle2(text: snapshot.error.toString()),
//           );
//         }

//         return const ShimmerList();
//       },
//     );
//   }

//   Widget riwayatPinjamanWidget(BuildContext context, PinjamanMenuBloc bloc) {
//     return StreamBuilder<List<dynamic>>(
//       stream: bloc.pinjamanListController.stream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final dataList = snapshot.data ?? [];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: dataList.map((datalist) {
//               return GestureDetector(
//                 onTap: () {
//                   datalist['status'] == 'Proses Pencairan'
//                       ? null
//                       : Navigator.pushNamed(
//                           context, DetailRiwayatPinjaman.routeName,
//                           arguments: datalist['id_agreement']);
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       width: 1,
//                       color: HexColor('#DAF1DE'),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 9),
//                         decoration: BoxDecoration(
//                           color: HexColor('#E9F6EB'),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   SvgPicture.asset(
//                                       'assets/images/home/maxi.svg'),
//                                   const SizedBox(width: 8),
//                                   Subtitle2Extra(text: datalist['nama_produk']),
//                                 ],
//                               ),
//                             ),
//                             Subtitle2(
//                               text: datalist['no_perjanjian_pinjaman'],
//                               color: HexColor('#777777'),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 11),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Subtitle3(
//                                   text: 'Total Pinjaman',
//                                   color: HexColor('#AAAAAA'),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 2,
//                                   ),
//                                   decoration: ShapeDecoration(
//                                     color: const Color(0xFFF2F8FF),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Subtitle3(
//                                         text: datalist['status'],
//                                         color: const Color(0xFF007AFF),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//                             Headline2(
//                               text: rupiahFormat(int.parse(
//                                   datalist['pokok_hutang'].toString())),
//                             ),
//                             const SizedBox(height: 21),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Subtitle3(
//                                       text: 'Tanggal Pinjam',
//                                       color: HexColor('#777777'),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       DateFormat('dd MMM yyyy').format(
//                                           DateTime.parse(
//                                               datalist['tanggal_pinjaman'])),
//                                       style: TextStyle(
//                                           fontFamily: 'Poppins',
//                                           color: HexColor('#333333')
//                                           // Add your custom text styles here
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Subtitle3(
//                                       text: 'Tenor',
//                                       color: HexColor('#777777'),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       '${datalist['tenor'].toString()} hari',
//                                       style: TextStyle(
//                                         color: HexColor('#333333'),
//                                         // Add your custom text styles here
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Subtitle3(
//                                       text: 'Jatuh Tempo',
//                                       color: HexColor('#777777'),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       DateFormat('dd MMM yyyy').format(
//                                         DateTime.parse(
//                                                 datalist['tanggal_jatuh_tempo'])
//                                             .toLocal(),
//                                       ),
//                                       style: TextStyle(
//                                         color: HexColor('#333333'),
//                                         // Add your custom text styles here
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         }

//         if (snapshot.hasError) {
//           return Center(
//             child: Subtitle2(text: snapshot.error.toString()),
//           );
//         }

//         return const ShimmerList();
//       },
//     );
//   }
// }

// double calculateTextWidth(String text) {
//   final TextPainter textPainter = TextPainter(
//     text: TextSpan(
//       text: text,
//       style: const TextStyle(
//         fontFamily: 'Poppins',
//         fontSize: 12,
//         fontWeight: FontWeight.w400,
//       ),
//     ),
//   )..layout();

//   return textPainter.width;
// }

// String shortText(String text, int maxLength) {
//   if (text.length > maxLength) {
//     return '${text.substring(0, maxLength - 3)}...';
//   }
//   return text;
// }

// =========================

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/pages/borrower/after_login/pengajuan_pinjaman/pengajuan_pinjaman_page.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../../component/home/action_modal_component.dart';
import '../../../../../domain/models/app_error.dart';
import '../../../../../domain/models/auth_state.dart';
import '../../../product/cicil_emas/product/page_gagal.dart';
import '../../../home/qrcode_pages.dart';
import 'detail_pinjaman/detail_riwayat_pinjaman_proses_page.dart';
import 'pinjaman_bloc.dart';

class RiwayatPinjaman extends StatefulWidget {
  static const routeName = 'homePage';
  const RiwayatPinjaman({super.key});

  @override
  State<RiwayatPinjaman> createState() => _RiwayatPinjamanState();
}

class _RiwayatPinjamanState extends State<RiwayatPinjaman> {
  List<Map<String, dynamic>> data = [
    {
      'nama_produk': 'Maxi 150',
      'picture': 'assets/images/home/maxi.svg',
      'no_perjanjian_pinjaman': 'No. PP 001/29022024/BPKB',
      'pinjaman': 10000000,
      'tenor': '150 hari',
      'jatuh_tempo': '10 Des 2025',
      'status': 'Aktif'
    },
    {
      'nama_produk': 'Cash n DRIVE',
      'picture': 'assets/images/home/maxi_2.svg',
      'no_perjanjian_pinjaman': 'No. PP 002/29022024/BPKB',
      'pinjaman': 10000000,
      'tenor': '24 bulan',
      'jatuh_tempo': '10 Des 2025',
      'status': 'Aktif'
    },
    {
      'nama_produk': 'Cash n DRIVE',
      'picture': 'assets/images/home/maxi_2.svg',
      'no_perjanjian_pinjaman': 'No. PP 003/29022024/BPKB',
      'pinjaman': 10000000,
      'tenor': '24 bulan',
      'jatuh_tempo': '10 Des 2025',
      'status': 'Telat Bayar'
    },
    {
      'nama_produk': 'Cash n DRIVE',
      'picture': 'assets/images/home/maxi_2.svg',
      'no_perjanjian_pinjaman': 'No. PP 003/29022024/BPKB',
      'pinjaman': 10000000,
      'tenor': '24 bulan',
      'jatuh_tempo': '10 Des 2025',
      'status': 'Aktif'
    },
    {
      'nama_produk': 'Cash n DRIVE',
      'picture': 'assets/images/home/maxi_3.svg',
      'no_perjanjian_pinjaman': 'No. PP 003/29022024/BPKB',
      'pinjaman': 10000000,
      'tenor': '24 bulan',
      'jatuh_tempo': '10 Des 2025',
      'status': 'Telat Bayar'
    },
  ];

  String currentItemList = '';
  List<String> selectedStatus = [];
  void showFilterModal() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => filterModal(context),
    );
  }

  void reset(StateSetter setState) {
    setState(() {
      currentItemList = '';
      selectedStatus = [];
      // pinjamanBloc.initGetData(getParameter());
      Navigator.pop(context);
    });
  }

  List<Map<String, dynamic>> filterList = [
    {
      'id': 'terbaru',
      'nama': 'Terbaru',
    },
    {
      'id': 'terlama',
      'nama': 'Terlama',
    },
    {
      'id': 'terendah',
      'nama': 'Pinjaman Terendah',
    },
    {
      'id': 'tertinggi',
      'nama': 'Pinjaman Tertinggi',
    },
  ];

  List<Map<String, dynamic>> statusList = [
    {
      'id': 'ProsesPencairan',
      'name': 'Proses Pencairan',
    },
    {
      'id': 'Aktif',
      'name': 'Aktif',
    },
    {
      'id': 'TelatBayar',
      'name': 'Telat Bayar',
    },
    {
      'id': 'Selesai',
      'name': 'Selesai',
    },
    {
      'id': 'Pemutusan',
      'name': 'Pemutusan',
    },
    {
      'id': 'GagalBayar',
      'name': 'Gagal Bayar',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      listPinjaman(context),
      const SizedBox(height: 24),

      // data
      Data()
    ]);
  }

  ListView Data() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: HexColor('#F0F0F0'),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    '${data[index]['picture']}',
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data[index]['nama_produk']}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          color: HexColor('#333333'),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "${data[index]['no_perjanjian_pinjaman']}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor('#777777')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: ShapeDecoration(
                                  color: data[index]['status'] == 'Aktif'
                                      ? HexColor('#F2F8FF')
                                      : HexColor('#FEF4E8'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Subtitle3(
                                      text: "${data[index]['status']}",
                                      color: data[index]['status'] == 'Aktif'
                                          ? HexColor('#007AFF')
                                          : HexColor('#F7951D'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          dividerFull2(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Subtitle3(
                                    text: 'Pinjaman',
                                    color: HexColor('#AAAAAA'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    rupiahFormat(data[index]['pinjaman']),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF333333),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Subtitle3(
                                    text: 'Tenor',
                                    color: HexColor('#AAAAAA'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${data[index]['tenor']}",
                                    style: const TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Subtitle3(
                                    text: 'Jatuh Tempo',
                                    color: HexColor('#AAAAAA'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${data[index]['jatuh_tempo']}",
                                    style: const TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget listPinjaman(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline3(text: 'List Pinjaman'),
            const SizedBox(height: 2),
            Subtitle3(
              text: '2 transaksi',
              color: HexColor('#BEBEBE'),
            )
          ],
        ),
        GestureDetector(
          onTap: () {
            showFilterModal();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: HexColor('#F9FFFA'),
              border: Border.all(
                width: 1,
                color: HexColor('#E9F6EB'),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: HexColor(primaryColorHex),
                ),
                const SizedBox(width: 8),
                const Subtitle2(text: 'Filter')
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget filterModal(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              color: HexColor('#DDDDDD'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Headline3500(text: 'Filter'),
              InkWell(
                onTap: () {},
                child: Subtitle2(
                  text: 'Reset',
                  color: HexColor(primaryColorHex),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          const Headline3500(text: 'Urutkan'),
          const SizedBox(height: 12),
          filterItemStringBorrower(filterList, currentItemList, (String id) {
            setState(() {
              currentItemList = id;
            });
          }),
          const SizedBox(height: 24),
          const Headline3500(text: 'Status'),
          multipleSelectLender(
            statusList,
            selectedStatus,
            (data) => setState(() => selectedStatus = data),
          ),
          const SizedBox(height: 24),
          Button1(
            btntext: 'Terapkan',
            color: currentItemList != '' || selectedStatus.isNotEmpty
                ? null
                : Colors.grey,
            action: currentItemList != '' || selectedStatus.isNotEmpty
                ? () {
                    Navigator.pop(context);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
