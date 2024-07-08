import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_page.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_index.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_card.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../../component/home/action_modal_component.dart';
import '../../../../../domain/models/app_error.dart';
import '../../../../../domain/models/auth_state.dart';

class CicilEmasTransaction extends StatefulWidget {
  final HomeBloc homeBloc;
  const CicilEmasTransaction({
    super.key,
    required this.homeBloc,
  });

  @override
  State<CicilEmasTransaction> createState() => _CicilEmasTransactionState();
}

class _CicilEmasTransactionState extends State<CicilEmasTransaction> {
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
      'id': 'hargatinggi',
      'nama': 'Harga Tertinggi',
    },
    {
      'id': 'hargarendah',
      'nama': 'Harga Terendah',
    },
  ];
  List<Map<String, dynamic>> statusList = [
    {
      'id': 'Pending',
      'name': 'Pending',
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
      'id': 'Lunas',
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

  int currentItemList = 0;
  List<String> selectedStatus = [];
  final ScrollController _scrollController = ScrollController();

  void showFilterModal() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => filterModal(widget.homeBloc),
    );
  }

  void reset() {
    setState(() {
      currentItemList = 0;
      selectedStatus = [];
    });
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.homeBloc.getInitData();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        widget.homeBloc.infiniteScroll();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.homeBloc.isLoadingCicilEmas,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        switch (data) {
          case 1:
            return const SizedBox.shrink();
          case 2:
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cicilanWidget(widget.homeBloc),
                  const SizedBox(height: 24),
                  listData(widget.homeBloc),
                  const SizedBox(height: 24),
                  Expanded(
                    child: listCicilanWidget(widget.homeBloc),
                  ),
                  StreamBuilder<bool>(
                    stream: widget.homeBloc.isInfinite$,
                    builder: (context, snapshot) {
                      final isValid = snapshot.data ?? false;
                      if (isValid == true) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            );
          case 3:
            return const Center(
              child: Subtitle1(text: 'Maaf terjadi kesalahan'),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget cicilanWidget(HomeBloc bloc) {
    return StreamBuilder<num>(
      stream: bloc.totalHargaStream$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? 0;
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                LayoutBuilder(
                  builder: (context, BoxConstraints constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: SvgPicture.asset(
                        'assets/images/transaction/background_transaksi.svg',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Subtitle2(
                      text: 'Cicil Emas Aktif',
                      color: HexColor('#777777'),
                    ),
                    const SizedBox(height: 8),
                    Headline1(
                      text: rupiahFormat(data),
                    )
                  ],
                ),
              ],
            ),
          );
        }
        return const ShimmerTransaction();
      },
    );
  }

  Widget notFound() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/empty_search.svg'),
          const SizedBox(height: 33),
          const Headline2(
            text: 'Pencarian Tidak Ditemukan',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text:
                'Kami tidak menemukan produk yang sesuai filter ini. Coba pilih filter yang lain atau reset filter.',
            color: HexColor('#777777'),
            align: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget listData(HomeBloc bloc) {
    return StreamBuilder<Object>(
      stream: bloc.totalStream$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? 0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Headline3(text: 'List Cicil Emas'),
                  const SizedBox(height: 2),
                  Subtitle3(
                    text: '${data} transaksi',
                    color: HexColor('#BEBEBE'),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  showFilterModal();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
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
        return const ShimmerTotal();
      },
    );
  }

  Widget listCicilanWidget(HomeBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.listCicilanStream$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? [];
          if (data.length < 1) {
            return StreamBuilder<bool>(
              stream: bloc.isTerapkanCicil,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final isTerapkan = snapshot.data ?? false;
                  if (isTerapkan == true) {
                    return notFound();
                  }
                  return noTransactionWidget(context);
                }
                return const ShimmerList();
              },
            );
          } else {
            return ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailCicilanIndex.routeName,
                      arguments: DetailCicilanIndex(
                        idCicilan: data[index]['idJaminan'],
                      ),
                    );
                  },
                  child: cicilanCardWidget(data[index]),
                );
              },
            );
          }
        }
        return const ShimmerList();
      },
    );
  }

  Widget noTransactionWidget(BuildContext context) {
    return RxStreamBuilder<Result<AuthenticationState>?>(
      stream: widget.homeBloc.authState$,
      builder: (context, result) {
        final beranda = result?.orNull()?.userAndToken?.beranda;
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(beranda!);
        final dataHome = decodedToken['beranda'];
        print('transaksi no widget ${dataHome['status']['aktivasi_status']}');
        final int status = dataHome['status']['aktivasi_status'];
        final String hp = dataHome['status']['status_request_hp'];
        final String email = dataHome['status']['status_request_email'];
        final bool haveAll = dataHome['status']['pekerjaan'] == true;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/transaction/no_transaction.svg'),
              const SizedBox(height: 8),
              const Headline2(
                text: 'Anda Belum Memiliki Angsuran',
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Saat ini Anda belum memiliki transaksi cicil emas. Mulai nyicil untuk mendapatkan emas.',
                align: TextAlign.center,
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 24),
              Button1(
                btntext: 'Mulai Nyicil',
                action: () {
                  switch (status) {
                    case 10:
                      switch (hp) {
                        case 'waiting':
                          return showVerifikasiAlert(context);
                      }
                      switch (email) {
                        case 'waiting':
                          return showVerifikasiAlert(context);
                      }
                      switch (haveAll) {
                        case true:
                          // Code for innerCondition when it matches innerValue1
                          Navigator.pushNamed(
                              context, CicilEmas2Page.routeName);
                          break;
                        case false:
                          // Code for innerCondition when it matches innerValue2
                          return showAktivasiAlert(context);
                        default:
                        // Code to execute when neither innerValue1 nor innerValue2 matches innerCondition
                      }
                      break;
                    case 9:
                      return showVerifikasiAlert(context);
                    case 0:
                      return showHaventVerifAlert(context);
                    case 12:
                      return showRejectPrivyAlert(context);
                    case 11:
                      return showRejectPrivyAlert(context);
                    default:
                      Navigator.pushNamed(context, CicilEmas2Page.routeName);
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget filterModal(HomeBloc bloc) {
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
                onTap: () {
                  widget.homeBloc.getInitData();
                },
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
          StreamBuilder<String>(
            stream: bloc.sortStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? 'terbaru';
              return filterItemStringBorrower(
                filterList,
                data,
                (String id) {
                  bloc.sortChange(id);
                },
              );
            },
          ),
          const SizedBox(height: 24),
          const Headline3500(text: 'Status'),
          StreamBuilder<List<String>>(
            stream: bloc.statusStream,
            builder: (context, snapshot) {
              final listData = snapshot.data ?? [];
              return multipleSelect(
                statusList,
                listData,
                (List<String> data) {
                  bloc.statusChange(data);
                },
              );
            },
          ),
          const SizedBox(height: 24),
          Button1(
            btntext: 'Terapkan',
            action: () {
              bloc.terapkanFilter();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget cicilanCardWidget(Map<String, dynamic> data) {
    print(data['imgSupplier']);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      data['imgSupplier'],
                      width: 21,
                      height: 21,
                      errorBuilder: (context, error, stackTrace) {
                        print(error);
                        return Container(
                          width: 21,
                          height: 21,
                          decoration: BoxDecoration(
                            color: HexColor('#EEEEEE'),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SubtitleExtra(text: data['namaSupplier']),
                          const SizedBox(height: 4),
                          Subtitle3(
                            text: dateFormat(data['tanggal']),
                            color: HexColor('#AAAAAA'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              statusBuilder(data['status']),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: HexColor('#EEEEEE'),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                data['imgJenisEmas'],
                width: 46,
                height: 46,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset(
                    'assets/images/simulasi/antam.svg',
                    width: 46,
                    height: 46,
                    fit: BoxFit.contain,
                  );
                },
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleExtra(text: data['namaProduk']),
                  const SizedBox(height: 4),
                  Headline3(
                    text: rupiahFormat(data['harga']),
                    color: HexColor('#333333'),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget statusBuilder(String status) {
    if (status == 'Aktif') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#F2F8FF'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: status,
          color: HexColor('#007AFF'),
        ),
      );
    }

    if (status == 'Lunas') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#F4FEF5'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: 'Selesai',
          color: HexColor('#28AF60'),
        ),
      );
    }
    if (status == 'Terlambat' ||
        status == 'Pending' ||
        status == 'Telat Bayar') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#FEF4E8'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: status,
          color: HexColor('#F7951D'),
        ),
      );
    }
    if (status == 'Gagal Bayar') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#FFF4F4'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: 'Gagal Bayar',
          color: HexColor('#EB5757'),
        ),
      );
    }

    if (status == 'Pemutusan') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor('#EEEEEE'),
        ),
        alignment: Alignment.center,
        child: Subtitle3(
          text: status,
          color: HexColor('#777777'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: HexColor('#EEEEEE'),
      ),
      alignment: Alignment.center,
      child: Subtitle3(
        text: status,
        color: HexColor('#777777'),
      ),
    );
  }
}
