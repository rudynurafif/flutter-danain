import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/home/component/portofolio_component.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/home/page/portfolio/portfolio_screen.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/components/new_pendanaan.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class PendanaanAktif extends StatefulWidget {
  final HomeLenderBloc homeBloc;
  final ScrollController controller;
  const PendanaanAktif({
    super.key,
    required this.homeBloc,
    required this.controller,
  });

  @override
  State<PendanaanAktif> createState() => _PendanaanAktifState();
}

class _PendanaanAktifState extends State<PendanaanAktif> {
  final pageController = BehaviorSubject<int>.seeded(1);
  List<dynamic> produkFilter = [];
  String? urutkanFilter;
  bool isFilter = false;
  @override
  void initState() {
    super.initState();
    widget.homeBloc.getPendanaanAktif(
      params: {
        'page': 1,
        'pageSize': 10,
        'status': 'Aktif',
      },
    );
    widget.controller.addListener(() {
      if (widget.controller.position.pixels ==
          widget.controller.position.maxScrollExtent) {
        final page = pageController.stream.valueOrNull ?? 1;
        widget.homeBloc.infiniteAktif(params: {
          'page': page + 1,
          'pageSize': 10,
          'pendanaan': urutkanFilter ?? '',
          'idProduk': produkFilter,
          'status': 'Aktif',
        });
        pageController.add(page + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget(
                  text: 'Pendanaan Aktif',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SpacerV(value: 2),
                StreamBuilder<int>(
                  stream: widget.homeBloc.totalAktif,
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? 0;
                    return TextWidget(
                      text: '$data pendanaan',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffBEBEBE),
                    );
                  },
                )
              ],
            ),
            FilterComponent(
              title: 'Filter',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FilterAktif(
                      jenisProduk: produkFilter,
                      urutkan: urutkanFilter,
                      onSelect: (urutkan, jenisProduk) {
                        setState(() {
                          urutkanFilter = urutkan;
                          produkFilter = jenisProduk;
                          isFilter = true;
                        });
                        pageController.add(1);
                        widget.homeBloc.getPendanaanAktif(
                          params: {
                            'page': 1,
                            'pageSize': 10,
                            'status': 'Aktif',
                            'pendanaan': urutkan ?? '',
                            'idProduk': jenisProduk,
                          },
                        );
                      },
                      reset: () {
                        setState(() {
                          urutkanFilter = null;
                          produkFilter = [];
                          isFilter = false;
                        });
                        pageController.add(1);
                        widget.homeBloc.getPendanaanAktif(
                          params: {
                            'page': 1,
                            'pageSize': 10,
                            'status': 'Aktif',
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SpacerV(value: 16),
        StreamBuilder<List<dynamic>?>(
          stream: widget.homeBloc.listPendanaanAktif,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data ?? [];
              if (data.isEmpty) {
                if (isFilter) {
                  return emptyFilter(context);
                }
                return emptyListWidget(context);
              }
              return Column(
                children: data.map((e) {
                  return PendanaanStatus(
                    idPendanaan: e['idAgreement'] ?? 0,
                    namaProduk: e['nmProduk'] ?? '',
                    picture: e['link'] ?? '',
                    noPerjanjianPinjaman: e['noPerjanjian'] ?? '',
                    jumlahPendanaan: e['pokokPendana'] ?? 0,
                    bunga: e['ratePendana'] ?? 0,
                    status: e['status'] ?? '',
                    date: e['tglJt'] ?? '',
                  );
                }).toList(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}

class FilterAktif extends StatefulWidget {
  final String? urutkan;
  final List<dynamic> jenisProduk;
  final Function2<String?, List<dynamic>, void> onSelect;
  final VoidCallback reset;
  const FilterAktif({
    super.key,
    this.urutkan,
    required this.jenisProduk,
    required this.onSelect,
    required this.reset,
  });

  @override
  State<FilterAktif> createState() => _FilterAktifState();
}

class _FilterAktifState extends State<FilterAktif> {
  late String? urutkan;
  late List<dynamic> jenisProduk;

  @override
  void initState() {
    super.initState();
    urutkan = widget.urutkan;
    jenisProduk = List<dynamic>.from(widget.jenisProduk);
  }

  @override
  Widget build(BuildContext context) {
    return ModaLBottomTemplate(
      padding: 24,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget(
                  text: 'Filter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    widget.reset();
                  },
                  child: TextWidget(
                    text: 'Reset',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: HexColor(lenderColor),
                  ),
                )
              ],
            ),
            const SpacerV(value: 24),
            const TextWidget(
              text: 'Urutkan',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SpacerV(value: 12),
            SingleFilter(
              type: FilterType.kapsul,
              currentValue: urutkan,
              idKey: 'id',
              displayKey: 'nama',
              dataList: Constants.get.pendanaanFilter,
              onSelect: (value) {
                setState(() {
                  urutkan = value;
                });
              },
              primaryColor: HexColor(lenderColor),
            ),
            const SpacerV(value: 32),
            const TextWidget(
              text: 'Jenis Produk',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SpacerV(value: 12),
            MultipleFilter(
              dataSelected: jenisProduk,
              type: FilterType.kapsul,
              idKey: 'idProduk',
              displayKey: 'namaProduk',
              dataList: Constants.get.listProduk,
              onSelect: (value) {
                setState(() {
                  jenisProduk = value;
                });
              },
              contentColor: HexColor('#F4FEF5'),
              titleColor: HexColor(lenderColor),
            ),
            const SpacerV(value: 40),
            ButtonWidget(
              title: 'Terapkan',
              color: jenisProduk.isNotEmpty || urutkan != null
                  ? HexColor(lenderColor)
                  : HexColor('#ADB3BC'),
              onPressed: () {
                if (jenisProduk.isNotEmpty || urutkan != null) {
                  Navigator.pop(context);
                  widget.onSelect(urutkan, jenisProduk);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
