import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/api/api_service_helper.dart';
import '../../../data/constants.dart';
import '../../../domain/models/app_error.dart';
import '../../../widgets/shimmer/shimmer_widget.dart';
import '../../../widgets/widget_element.dart';
import 'components/filter/filter_pendanaan.dart';
import 'components/filter_pendanaan_not_found.dart';
import 'components/list_pendanaan.dart';
import 'components/list_pendanaan_not_found.dart';
import 'new_pendanaan_bloc.dart';

class NewPendanaanPage extends StatefulWidget {
  static const routeName = '/new_pendanaan_lender_page';

  const NewPendanaanPage({super.key});

  @override
  State<NewPendanaanPage> createState() => _NewPendanaanPageState();
}

class _NewPendanaanPageState extends State<NewPendanaanPage> {
  late NewPendanaanBloc bloc;
  final pageController = BehaviorSubject<int>.seeded(1);
  final ScrollController scrollController = ScrollController();

  bool isFiltered = false;
  String urutkan = '';
  List<dynamic> listProduk = [];
  num? terendah;
  num? tertinggi;

  @override
  void initState() {
    super.initState();
    context.bloc<NewPendanaanBloc>().getDataHome();
    context.bloc<NewPendanaanBloc>().getNewListPendanaan(params: {
      'page': 1,
      'pageSize': 10,
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        final page = pageController.stream.valueOrNull ?? 1;
        Map<String, dynamic> params = {
          'page': 1,
          'pageSize': 10,
          'jenisProduk': listProduk,
        };
        if (urutkan != '') {
          params['urutan'] = urutkan;
        }
        if (terendah != null) {
          params['nominalMin'] = terendah;
        }
        if (tertinggi != null) {
          params['nominalMax'] = tertinggi;
        }
        bloc.infiniteListPendanaan(params: {
          'page': page + 1,
          'pageSize': 10,
          'jenisProduk': listProduk,
          'urutan': urutkan,
          'nominalMin': terendah ?? '',
          'nominalMax': tertinggi ?? '',
        });
        pageController.add(page + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<NewPendanaanBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        bloc.getDataHome();
        pageController.add(1);
        bloc.getNewListPendanaan(params: {
          'page': 1,
          'pageSize': 10,
        });
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(128),
          child: AppBarWidget(
            context: context,
            isLeading: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SvgPicture.asset('assets/lender/portofolio/alert.svg'),
              )
            ],
            title: 'List Pendanaan',
            elevation: 10,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            color: HexColor('#f5f9f6'),
                          ),
                          child: SvgPicture.asset(
                            'assets/lender/portofolio/dompet.svg',
                          ),
                        ),
                        const SizedBox(width: 10),
                        StreamBuilder<Map<String, dynamic>?>(
                          stream: bloc.summaryData,
                          builder: (context, snapshot) {
                            final data = snapshot.data ?? {};
                            if (snapshot.hasData) {
                              return TextWidget(
                                text: rupiahFormat(
                                  data['saldoTersedia'],
                                ),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              );
                            }
                            return const SaldoLenderLoading();
                          },
                        )
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          builder: (context) {
                            return FilterListPendanaan(
                              urutkan: urutkan,
                              listProduk: listProduk,
                              terendah: terendah,
                              tertinggi: tertinggi,
                              onSelect: (
                                ur,
                                lProduk,
                                rendah,
                                tinggi,
                              ) {
                                setState(() {
                                  urutkan = ur;
                                  listProduk = lProduk;
                                  terendah = rendah;
                                  tertinggi = tinggi;
                                  isFiltered = true;
                                });

                                pageController.add(1);
                                Map<String, dynamic> params = {
                                  'page': 1,
                                  'pageSize': 10,
                                  'jenisProduk': lProduk,
                                };
                                if (ur != '') {
                                  params['urutan'] = ur;
                                }
                                if (rendah != null) {
                                  params['nominalMin'] = rendah;
                                }
                                if (tinggi != null) {
                                  params['nominalMax'] = tinggi;
                                }
                                bloc.getNewListPendanaan(params: params);
                              },
                              reset: () {
                                setState(() {
                                  urutkan = '';
                                  listProduk = [];
                                  terendah = null;
                                  tertinggi = null;
                                  isFiltered = false;
                                });
                                pageController.add(1);
                                bloc.getNewListPendanaan(params: {
                                  'page': 1,
                                  'pageSize': 10,
                                });
                              },
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/lender/portofolio/filter.svg',
                          ),
                          const SizedBox(width: 8),
                          StreamBuilder<List<dynamic>?>(
                              stream: bloc.listPendanaan,
                              builder: (context, snapshot) {
                                final data = snapshot.data ?? [];
                                if (snapshot.hasData) {
                                  if (data.isEmpty) {
                                    return const TextWidget(
                                      text: 'Filter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    );
                                  }
                                  return TextWidget(
                                    text: 'Filter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: HexColor(lenderColor2),
                                  );
                                }
                                return const TextWidget(
                                  text: 'Filter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                );
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child: Column(
            children: [
              StreamBuilder<List<dynamic>?>(
                stream: bloc.listPendanaan,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final dataPendanaan = snapshot.data ?? [];
                    if (dataPendanaan.isEmpty) {
                      return isFiltered
                          ? const FilterPendanaanNotFound()
                          : const ListPendanaanNotFound();
                    }
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListPendanaan(data: dataPendanaan),
                        ),
                        const DividerFull(paddingTop: 0),
                        Center(
                          child: Subtitle2(
                            text: 'Semua pendanaan sudah ditampilkan',
                            color: HexColor('#AAAAAA'),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
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

class SaldoLenderLoading extends StatelessWidget {
  const SaldoLenderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 10),
        ShimmerLong(height: 20, width: 80),
      ],
    );
  }
}
