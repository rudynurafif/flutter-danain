import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../component/complete_data/textfield_withMoney_component.dart';
import '../../../../../data/constants.dart';
import '../../../../../domain/models/app_error.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/button/button.dart';
import '../../../../../widgets/filter/filter_widget.dart';
import '../../../../../widgets/form/input_decoration.dart';
import '../../../../../widgets/modal/modalBottom.dart';
import '../../../../../widgets/text/headline.dart';
import '../../../../../widgets/text/subtitle.dart';
import '../../new_pendanaan_bloc.dart';

class FilterListPendanaan2 extends StatefulWidget {
  final NewPendanaanBloc pBloc;
  final ScrollController controller;
  final String? urutkan;
  final List<dynamic> jenisProduk;
  final Function(bool) onFilterApplied;

  const FilterListPendanaan2({
    super.key,
    this.urutkan,
    required this.jenisProduk,
    required this.pBloc,
    required this.controller,
    required this.onFilterApplied,
  });

  @override
  State<FilterListPendanaan2> createState() => _FilterListPendanaan2State();
}

class _FilterListPendanaan2State extends State<FilterListPendanaan2> {
  final pageController = BehaviorSubject<int>.seeded(1);

  late String? urutanFilter;
  late List<dynamic> selectedProducts;
  String? nominalMin;
  String? nominalMax;

  @override
  void initState() {
    super.initState();

    urutanFilter = widget.urutkan;
    selectedProducts = widget.jenisProduk;

    widget.controller.addListener(() {
      if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
        final page = pageController.stream.valueOrNull ?? 1;
        widget.pBloc.getNewListPendanaan(params: {
          'page': page + 1,
          'pageSize': 10,
          'urutan': urutanFilter ?? '',
          'jenisProduk': selectedProducts,
          'nominalMin': nominalMin ?? '',
          'nominalMax': nominalMax ?? '',
        });
      }
    });
  }

  void reset() {
    setState(() {
      urutanFilter = null;
      selectedProducts.clear();
      nominalMin = null;
      nominalMax = null;
    });
    widget.onFilterApplied(false);
    widget.pBloc.getNewListPendanaan(params: {
      'page': 1,
      'pageSize': 10,
    });
  }

  bool isNominalValid() {
    if (nominalMin != null && nominalMax != null) {
      try {
        final int min = int.parse(nominalMin!.replaceAll('.', ''));
        final int max = int.parse(nominalMax!.replaceAll('.', ''));
        return min < max;
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  void applyFilter() {
    if ((selectedProducts.isNotEmpty ||
            urutanFilter != null ||
            nominalMin != null ||
            nominalMax != null) &&
        isNominalValid()) {
      final params = {
        'page': 1,
        'pageSize': 10,
        // ada bug filter disini, perbedaan antara params 'urutan' dan 'urutkan'
        // 'urutan': urutanFilter ?? '', // sort urutan jalan, filter jenis produk dan nominal ga jalan
        'urutkan':
            urutanFilter ?? '', // sort urutan ga jalan, filter jenis produk dan nominal jalan
        'jenisProduk': selectedProducts,
        'nominalMin': nominalMin?.replaceAll('.', '') ?? '',
        'nominalMax': nominalMax?.replaceAll('.', '') ?? '',
      };

      widget.pBloc.getFilterListPendanaan(params: params);
      widget.onFilterApplied(true);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomTemplate2(
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Headline2500(text: 'Filter'),
                  InkWell(
                    onTap: reset,
                    child: Subtitle1(
                      text: 'Reset',
                      color: HexColor(lenderColor),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              const Headline3500(text: 'Urutkan'),
              const SizedBox(height: 12),
              SingleFilter(
                type: FilterType.kapsul,
                currentValue: urutanFilter,
                idKey: 'id',
                displayKey: 'nama',
                dataList: Constants.get.filterSort,
                onSelect: (value) {
                  setState(() {
                    urutanFilter = value;
                  });
                },
                primaryColor: HexColor(lenderColor),
              ),
              const SizedBox(height: 32),
              const Headline3500(text: 'Jenis Produk'),
              const SizedBox(height: 12),
              MultipleFilter(
                dataSelected: selectedProducts,
                type: FilterType.kapsul,
                idKey: 'idProduk',
                displayKey: 'namaProduk',
                dataList: Constants.get.jenisProduk,
                onSelect: (value) {
                  setState(() {
                    selectedProducts = value;
                  });
                },
                contentColor: HexColor('#F4FEF5'),
                titleColor: HexColor(lenderColor),
              ),
              const SizedBox(height: 32),
              const Headline3500(text: 'Nominal Pendanaan'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Subtitle3(
                            text: 'Terendah',
                            color: HexColor('#AAAAAA'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextFormField(
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          decoration: inputDecorSetHeight(
                            context,
                            'Terendah',
                          ),
                          onChanged: (value) {
                            setState(() {
                              nominalMin = value.isNotEmpty ? value : null;
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            NumberTextInputFormatter2()
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle3(
                        text: 'Tertinggi',
                        color: HexColor('#AAAAAA'),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextFormField(
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          decoration: inputDecorSetHeight(
                            context,
                            'Tertinggi',
                          ),
                          onChanged: (value) {
                            setState(() {
                              nominalMax = value.isNotEmpty ? value : null;
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            NumberTextInputFormatter2()
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 40),
              ButtonWidget(
                title: 'Terapkan',
                color: (selectedProducts.isNotEmpty ||
                            urutanFilter != null ||
                            nominalMin != null ||
                            nominalMax != null) &&
                        isNominalValid()
                    ? HexColor(lenderColor)
                    : HexColor('#ADB3BC'),
                onPressed: applyFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
