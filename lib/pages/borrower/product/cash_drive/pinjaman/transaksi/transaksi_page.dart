import 'package:flutter/material.dart';
import 'package:flutter_danain/component/home/action_modal_component.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/mainInfo.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/component.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/proses/proses_pengajuan_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/simulasi/simulasi_page.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionPage extends StatefulWidget {
  final HomeBloc homeBloc;
  final int index;
  const TransactionPage({
    super.key,
    required this.homeBloc,
    required this.index,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isFilter = false;
  final scrollController = ScrollController();
  final pageController = BehaviorSubject<int>.seeded(1);
  final listStatus = BehaviorSubject<List<dynamic>>.seeded([]);
  final urutkan = BehaviorSubject<String>.seeded('');
  final listProduk = BehaviorSubject<List<dynamic>>.seeded([]);
  @override
  void initState() {
    super.initState();
    widget.homeBloc.getBeranda();
    widget.homeBloc.getRiwayatTransaksi(
      {
        'page': 1,
        'pageSize': 10,
      },
    );
    scrollController.addListener(
      () async {
        final bool isValid = scrollController.position.pixels ==
            scrollController.position.maxScrollExtent;
        if (isValid) {
          await getInfinite();
        }
      },
    );
  }

  Future<void> getInfinite() async {
    final page = pageController.valueOrNull ?? 1;
    widget.homeBloc.infiniteRiwayat({
      'page': page + 1,
      'pageSize': 10,
      'sort': urutkan.stream.valueOrNull ?? '',
      'search': listStatus.stream.valueOrNull ?? [],
      'idProduk': listProduk.stream.valueOrNull ?? [],
    });
    pageController.add(page + 1);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.homeBloc;
    return RefreshIndicator(
      onRefresh: () async {
        urutkan.add('');
        listProduk.add([]);
        listStatus.add([]);
        pageController.add(1);
        setState(() {
          isFilter = false;
        });
        bloc.getBeranda();
        bloc.getRiwayatTransaksi(
          {
            'page': 1,
            'pageSize': 10,
          },
        );
      },
      child: Scaffold(
        appBar: AppBarWidget(
          context: context,
          isLeading: false,
          title: 'Transaksi',
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerV(value: 24),
                mainInfo(bloc: widget.homeBloc),
                const SpacerV(value: 24),
                prosesPengajuan(context),
                const SpacerV(value: 24),
                filterWidget(bloc: widget.homeBloc),
                const SizedBox(height: 24),
                listRiwayat(widget.homeBloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget prosesPengajuan(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProsesPengajuanPage.routeName);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xffEEEEEE),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset(
                      'assets/images/transaction/proses_pengajuan.svg',
                      colorFilter: ColorFilter.mode(
                        HexColor(primaryColorHex),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const Text(
                    'Proses Pengajuan',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/borrower/transaksi/chevron-right.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainInfo({
    required HomeBloc bloc,
  }) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: widget.homeBloc.berandaData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final beranda = snapshot.data ?? {};
          return MainInfo(
            pinjamanAktif: beranda['pinjaman']['tagihan_bulan_ini'],
            tagihanBulanIni: beranda['pinjaman']['pinjaman_aktif'],
          );
        }
        return ShimmerLong(
          height: 100,
          width: MediaQuery.of(context).size.width,
          radius: 8,
        );
      },
    );
  }

  Widget filterWidget({
    required HomeBloc bloc,
  }) {
    return StreamBuilder<int>(
      stream: bloc.totalResponsetransaksi.stream,
      builder: (context, snapshot) {
        final total = snapshot.data ?? 0;
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
                  text: '$total transaksi',
                  color: HexColor('#BEBEBE'),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  builder: (context) {
                    return FilterModal(
                      urutkan: urutkan.stream.valueOrNull ?? '',
                      produk: listProduk.stream.valueOrNull ?? [],
                      status: listStatus.stream.valueOrNull ?? [],
                      reset: () {
                        urutkan.add('');
                        listProduk.add([]);
                        listStatus.add([]);
                        pageController.add(1);
                        setState(() {
                          isFilter = false;
                        });
                        widget.homeBloc.getRiwayatTransaksi(
                          {
                            'page': 1,
                            'pageSize': 10,
                          },
                        );
                      },
                      onSubmit: (ur, produk, status) {
                        String produkAsString = produk.join(',');
                        String statusAsString = status.join(',');
                        urutkan.add(ur);
                        listProduk.add(produk);
                        listStatus.add(status);
                        pageController.add(1);
                        setState(() {
                          isFilter = true;
                        });
                        widget.homeBloc.getRiwayatTransaksi({
                          'page': 1,
                          'pageSize': 10,
                          'sort': ur,
                          'search': status,
                          'idProduk': produk,
                        });
                      },
                    );
                  },
                );
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
      },
    );
  }

  Widget listRiwayat(HomeBloc bloc) {
    // Check if dataList is empty or not
    return StreamBuilder<List<dynamic>?>(
      stream: bloc.response.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final dataList = snapshot.data ?? [];
          if (dataList.isEmpty) {
            return StreamBuilder<Map<String, dynamic>?>(
              stream: bloc.berandaData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final beranda = snapshot.data ?? {};
                  final status = beranda['status'] ?? {};
                  return emptyList(status);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];
              return CardTransaksiComponent(
                idAgreement: data['idAgreement'] ?? 0,
                image: data['file'] ?? '',
                namaProduk: data['namaProduk'] ?? '',
                noPp: data['noPerjanjian'] ?? '',
                status: data['status'] ?? '',
                pinjaman: data['pokokHutang'] ?? '',
                tenor: data['tenor'] ?? 0,
                tglJt: data['tglJt'] ?? '',
              );
            },
          );
        }
        return Column(
          children: [
            ShimmerLong(
              height: 120,
              width: MediaQuery.of(context).size.width,
              radius: 8,
            ),
            const SpacerV(value: 16),
            ShimmerLong(
              height: 120,
              width: MediaQuery.of(context).size.width,
              radius: 8,
            ),
            const SpacerV(value: 16),
            ShimmerLong(
              height: 120,
              width: MediaQuery.of(context).size.width,
              radius: 8,
            ),
            const SpacerV(value: 16),
          ],
        );
      },
    );
  }

  Widget emptyList(Map<String, dynamic> status) {
    final int isPengajuan = status['is_pengajuan_pinjaman'];
    final int isKeluarga = status['is_keluarga'];
    final int isPasangan = status['is_pasangan'];
    if (isFilter) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/icons/empty_search.svg'),
              const SizedBox(height: 8),
              const Headline2(
                text: 'Data Tidak Ditemukan',
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Kami tidak menemukan pinjaman yang sesuai filter ini. Coba pilih filter yang lain atau reset filter.',
                align: TextAlign.center,
                color: HexColor('#777777'),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/transaction/no_transaction.svg'),
            const SizedBox(height: 8),
            const Headline2(
              text: 'Anda Belum Memiliki Pinjaman',
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Subtitle2(
              text:
                  'Saat ini Anda belum memiliki transaksi pinjaman. Ajukan pinjaman Anda sekarang juga.',
              align: TextAlign.center,
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 24),
            ButtonWidget(
              title: 'Ajukan Pinjaman',
              onPressed: () {
                if (isKeluarga == 0 || isPasangan == 0) {
                  showKontakDaruratAlert(context);
                  return;
                }
                if (isPengajuan > 0) {
                  showHavePengajuan(context);
                  return;
                }

                Navigator.pushNamed(
                  context,
                  SimulasiCashDrivePage.routeName,
                  arguments: SimulasiCashDriveParams(
                    isPengajuan: true,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
