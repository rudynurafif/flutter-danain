import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/pages/lender/home/component/portofolio_component.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/subjects.dart';

import '../../../../data/constants.dart';
import '../../../../layout/appBar_previousTitleCustom.dart';
import '../../../../utils/string_format.dart';
import '../../../../widgets/shimmer/shimmer_widget.dart';
import '../../../../widgets/widget_element.dart';
import 'detail/detail_transaksi_page.dart';
import 'riwayat_transaksi_bloc.dart';
import 'riwayat_transaksi_components.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  static const routeName = '/riwayat_transaksi_page';
  const RiwayatTransaksiPage({
    super.key,
  });

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  final pageController = BehaviorSubject<int>.seeded(1);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<RiwayatTransaksiBloc>(context);

    context.bloc<RiwayatTransaksiBloc>().getDataHome();
    context.bloc<RiwayatTransaksiBloc>().getListRiwayat(params: {
      'page': 1,
      'pageSize': 10,
    });
    scrollController.addListener(
      () {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          final page = pageController.stream.valueOrNull ?? 1;
          bloc.infiniteScroll(params: {
            'page': page + 1,
            'pageSize': 10,
          });
          pageController.add(page + 1);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RiwayatTransaksiBloc>(context);
    return RefreshIndicator(
      onRefresh: () async {
        bloc.getDataHome();
        bloc.getListRiwayat();
      },
      child: Scaffold(
        appBar: previousTitleCustom(
          context,
          'Riwayat Transaksi',
          () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, BoxConstraints constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: SvgPicture.asset(
                            'assets/lender/portofolio/bg-riwayat-transaksi.svg',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Subtitle2(
                                text: 'Saldo Tersedia',
                                color: HexColor('#777777'),
                                align: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              StreamBuilder<Map<String, dynamic>?>(
                                stream: bloc.summaryData,
                                builder: (context, snapshot) {
                                  final data = snapshot.data ?? {};
                                  if (snapshot.hasData) {
                                    return HeadlineSaldoTersedia2(
                                      text: rupiahFormat3(data['saldoTersedia']),
                                      align: TextAlign.center,
                                    );
                                  }
                                  return const Row(
                                    children: [
                                      ShimmerLong(height: 27, width: 200),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Headline3500(text: 'Riwayat Transaksi'),
                            const SizedBox(height: 4),
                            StreamBuilder<List<dynamic>?>(
                              stream: bloc.listDataStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data ?? [];
                                  return Subtitle3(
                                    text: '${data.length} Transaksi',
                                    color: HexColor('#BEBEBE'),
                                  );
                                }
                                return const ShimmerLong(height: 10, width: 50);
                              },
                            ),
                          ],
                        ),
                        FilterComponent(
                          title: 'Filter',
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => FilterRiwayat(pBloc: bloc),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              StreamBuilder<List<dynamic>?>(
                stream: bloc.listDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data ?? [];
                    if (data.isEmpty) {
                      return NoTransactionWidget(
                        context: context,
                        statusBank: 1,
                        username: 'Nama User',
                        status: 1,
                        bloc: bloc,
                      );
                    }
                    return Column(
                      children: data.map((e) {
                        return DetailRiwayat2(
                            idKasbankDtl2: e['idKasbankDtl2'],
                            keterangan: e['keterangan'],
                            kdTrans: e['kdTrans'],
                            amount: e['amount'],
                            noPerjanjian: e['noPerjanjian'],
                            tanggal: e['tanggal'],
                            status: e['status']);
                      }).toList(),
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: CircularProgressIndicator(
                        color: HexColor(lenderColor),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailRiwayat2 extends StatefulWidget {
  final int idKasbankDtl2;
  final String keterangan;
  final String kdTrans;
  final int amount;
  final String noPerjanjian;
  final String tanggal;
  final String status;

  const DetailRiwayat2({
    super.key,
    required this.idKasbankDtl2,
    required this.keterangan,
    required this.kdTrans,
    required this.amount,
    required this.noPerjanjian,
    required this.tanggal,
    required this.status,
  });

  @override
  State<DetailRiwayat2> createState() => _DetailRiwayat2State();
}

class _DetailRiwayat2State extends State<DetailRiwayat2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailTransaksiPage.routeName,
          arguments: widget.idKasbankDtl2,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            keyValHeaderRiwayatTrans2(
              widget.keterangan,
              widget.kdTrans,
              rupiahFormat(widget.amount),
              widget.noPerjanjian,
            ),
            const SizedBox(height: 8),
            keyValTarikDana(
              dateFormat(widget.tanggal),
              widget.status,
            ),
            const SizedBox(height: 16),
            dividerFullNoPadding(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
