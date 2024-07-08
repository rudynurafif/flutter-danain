import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../component/complete_data/textfield_withMoney_component.dart';
import '../../../../../data/constants.dart';
import '../../../../../domain/models/app_error.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/widget_element.dart';

typedef FilterConvert<T> = T Function(
  String urutkan,
  List<dynamic> listProduk,
  num? terendah,
  num? tertinggi,
);

class FilterListPendanaan extends StatefulWidget {
  final String urutkan;
  final List<dynamic> listProduk;
  final num? terendah;
  final num? tertinggi;
  final FilterConvert onSelect;
  final VoidCallback reset;

  const FilterListPendanaan({
    super.key,
    required this.urutkan,
    required this.listProduk,
    this.terendah,
    this.tertinggi,
    required this.onSelect,
    required this.reset,
  });

  @override
  State<FilterListPendanaan> createState() => _FilterListPendanaanState();
}

class _FilterListPendanaanState extends State<FilterListPendanaan> {
  final pageController = BehaviorSubject<int>.seeded(1);

  List<Map<String, dynamic>> filterSort = [
    {'id': 'created_at', 'nama': 'Pendanaan Baru'},
    {'id': 'pokokHutangAsc', 'nama': 'Pendanaan Terendah'},
    {'id': 'pokokHutang', 'nama': 'Pendanaan Tertinggi'},
    {'id': 'bungaHutang', 'nama': 'Bunga Tertinggi'},
  ];

  List<Map<String, dynamic>> jenisProduk = [
    {'id': 1, 'nama': 'Maxi 150'},
    {'id': 2, 'nama': 'Cash & Drive'},
  ];

  late String urutanFilter;
  late List<dynamic> selectedProducts = [];
  late num? terendah;
  late num? tertinggi;
  TextEditingController terendahController = TextEditingController();
  TextEditingController tertinggiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    urutanFilter = widget.urutkan;
    selectedProducts = List.from(widget.listProduk);
    tertinggi = widget.tertinggi;
    terendah = widget.terendah;
    if (widget.terendah != null) {
      terendahController.text = rupiahFormat(widget.terendah).replaceAll('Rp ', '');
    }
    if (widget.tertinggi != null) {
      tertinggiController.text = rupiahFormat(widget.tertinggi).replaceAll('Rp ', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid =
        urutanFilter != '' || selectedProducts.isNotEmpty || tertinggi != null || terendah != null;
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
                    onTap: () {
                      Navigator.pop(context);
                      widget.reset();
                    },
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
                currentValue: urutanFilter,
                idKey: 'id',
                type: FilterType.kapsul,
                displayKey: 'nama',
                dataList: filterSort,
                onSelect: (value) {
                  setState(() {
                    urutanFilter = value;
                  });
                },
                primaryColor: Constants.get.lenderColor,
              ),
              const SizedBox(height: 32),
              const Headline3500(text: 'Jenis Produk'),
              const SizedBox(height: 12),
              MultipleFilter(
                type: FilterType.kapsul,
                dataSelected: selectedProducts,
                idKey: 'id',
                displayKey: 'nama',
                dataList: jenisProduk,
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
                              final v = value.replaceAll('Rp ', '').replaceAll('.', '');
                              terendah = num.tryParse(v);
                              print('value terendah $v');
                            });
                          },
                          controller: terendahController,
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
                              final v = value.replaceAll('Rp ', '').replaceAll('.', '');
                              tertinggi = num.tryParse(v);
                            });
                          },
                          controller: tertinggiController,
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
                color: isValid ? HexColor(lenderColor) : HexColor('#ADB3BC'),
                onPressed: () {
                  widget.onSelect(
                    urutanFilter,
                    selectedProducts,
                    terendah,
                    tertinggi,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
