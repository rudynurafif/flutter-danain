import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/component/complete_data/textfield_withMoney_component.dart';
import 'package:flutter_danain/component/lender/modal_component/modal_pendanaan.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/layout/appBar_previousTitleAction.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class StepListPendanaan extends StatefulWidget {
  final PendanaanBloc pBloc;
  const StepListPendanaan({super.key, required this.pBloc});

  @override
  State<StepListPendanaan> createState() => _StepListPendanaanState();
}

class _StepListPendanaanState extends State<StepListPendanaan> {
  @override
  void initState() {
    super.initState();
    widget.pBloc.getDataPendanaan();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.pBloc;
    final List<Widget> listAction = [
      IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            isScrollControlled: true,
            builder: (context) => Scaffold(
              appBar: previousWidget(context),
              body: ProdukDetail(bloc: bloc),
            ),
          );
        },
        icon: SvgPicture.asset('assets/lender/pendanaan/alert.svg'),
      )
    ];
    return Scaffold(
      appBar: prevTitleWithAction(context, 'List Pendanaan', listAction, null),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.dataPendanaan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return listPendanaanWidget(data);
          }

          if (snapshot.hasError) {
            return Center(
              child: Subtitle2(text: snapshot.error.toString()),
            );
          }
          return listPendanaanLoading(context);
        },
      ),
    );
  }

  Widget listPendanaanWidget(Map<String, dynamic> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 10,
                offset: Offset(0, 2),
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/lender/pendanaan/dompet.svg'),
                  Subtitle2Extra(
                    text: ' ${rupiahFormat(data['saldo_tersedia'] ?? 0)}',
                  )
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => FilterPendanaan(pBloc: widget.pBloc),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/lender/pendanaan/filter.svg'),
                    const SizedBox(width: 8),
                    const Subtitle2(text: 'Filter')
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: listItemPendanaan(
              data['data'],
            ),
          ),
        )
      ],
    );
  }

  Widget listPendanaanLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 10,
                offset: Offset(0, 2),
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ShimmerCircle(height: 24, width: 24),
                  const SizedBox(width: 8),
                  ShimmerLong(
                    height: 12,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ],
              ),
              ShimmerLong4(
                height: 30,
                width: MediaQuery.of(context).size.width / 5,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return itemLoading(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget listItemPendanaan(List<dynamic> listItem) {
    if (listItem.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: noTransactionWidget(),
      );
    }
    return ListView.builder(
      itemCount: listItem.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = listItem[index];
        print('detail berat ${item['gram']}');
        return itemPendanaan(
          item['no_sbg'],
          item['url'],
          item['nama_produk'],
          item['ratePendana'],
          item['nilai_pinjaman'],
          item['gram'] ?? [],
          item['karat'] ?? [],
          item['tenor'],
        );
      },
    );
  }

  Widget itemPendanaan(
    String noSbg,
    String image,
    String namaProduk,
    dynamic ratePendana,
    int jumlahPendanaan,
    List<dynamic> berat,
    List<dynamic> karat,
    int tenor,
  ) {
    final colorContent = namaProduk.startsWith('C')
        ? const Color.fromARGB(255, 255, 243, 229)
        : const Color.fromARGB(34, 102, 26, 209);
    final HexColor colorText =
        namaProduk.startsWith('C') ? HexColor('#F7951D') : HexColor('#D671AD');
    final imageContent = namaProduk.startsWith('C')
        ? 'assets/lender/pendanaan/cicil_emas.svg'
        : 'assets/lender/pendanaan/maxi.svg';
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: image.endsWith('.svg')
                    ? SvgPicture.network(
                        image,
                        width: 86,
                        height: 76,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        image,
                        width: 86,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/lender/pendanaan/pendanaan_default.png',
                            width: 86,
                            height: 76,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: colorContent,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(imageContent),
                            Subtitle3(
                              text: ' $namaProduk',
                              color: colorText,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: HexColor('#F1FCF4'),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/lender/pendanaan/arrow.svg',
                            ),
                            Subtitle3Extra(
                              text: ' ${ratePendana.toString()}% p.a',
                              color: HexColor(lenderColor),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Subtitle3(
                    text: 'Jumlah Pendanaan',
                    color: HexColor('#AAAAAA'),
                  ),
                  const SizedBox(height: 2),
                  Headline3(
                    text: rupiahFormat(jumlahPendanaan),
                    color: HexColor(lenderColor),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          dividerFullNoPadding(context),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'Berat',
                    color: HexColor('AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  Subtitle2Extra(
                    text: shortenText(
                      berat.map((val) => '${val}G').join(','),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'Karat',
                    color: HexColor('AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  Subtitle2Extra(
                    text: shortenText(
                      karat.map((val) => '${val}K').join(','),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'Tenor',
                    color: HexColor('AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  Subtitle2Extra(
                    text:
                        '$tenor ${namaProduk.startsWith('C') ? 'Bulan' : 'Hari'}',
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonCustomWidth2(
                btntext: 'Detail',
                textcolor: HexColor(lenderColor),
                color: Colors.white,
                action: () {
                  widget.pBloc.detailPendanaanControl(null);
                  widget.pBloc.detailControl(true);
                  widget.pBloc.getDataPendanaanDetail(noSbg);
                  widget.pBloc.stepControl(2);
                },
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: widget.pBloc.dataBeranda,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final dataBeranda = snapshot.data ?? {};
                    return ButtonCustomWidth2(
                      btntext: 'Danain',
                      color: HexColor(lenderColor),
                      action: () {
                        widget.pBloc.detailPendanaanControl(null);
                        widget.pBloc.getDataPendanaanDetail(noSbg);
                        if (dataBeranda['Aktivasi'] == 0) {
                          showDialog(
                            context: context,
                            builder: (context) => notVerifPopUp(context),
                          );
                        }
                        if (dataBeranda['Aktivasi'] == 9) {
                          showDialog(
                            context: context,
                            builder: (context) => waitingVerifPopUp(context),
                          );
                        }
                        if (dataBeranda['Aktivasi'] == 11 ||
                            dataBeranda['Aktivasi'] == 12) {
                          showDialog(
                            context: context,
                            builder: (context) => rejectVerifPopUp(context),
                          );
                        }

                        if (dataBeranda['Aktivasi'] == 1) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => ModalConfirmPendanaan(
                              bloc: widget.pBloc,
                            ),
                          );
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget itemLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLong4(height: 76, width: 86),
              SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShimmerLong(height: 25, width: 80),
                      SizedBox(width: 8),
                      ShimmerLong(height: 25, width: 80),
                    ],
                  ),
                  SizedBox(height: 8),
                  ShimmerLong(height: 11, width: 80),
                  SizedBox(height: 2),
                  ShimmerLong(height: 14, width: 80),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          dividerFullNoPadding(context),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLong(height: 11, width: 80),
                  SizedBox(height: 8),
                  ShimmerLong(height: 12, width: 80),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLong(height: 11, width: 80),
                  SizedBox(height: 8),
                  ShimmerLong(height: 12, width: 80),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLong(height: 11, width: 80),
                  SizedBox(height: 8),
                  ShimmerLong(height: 12, width: 80),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerLong4(
                height: 32,
                width: MediaQuery.of(context).size.width / 3,
              ),
              ShimmerLong4(
                height: 32,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget noTransactionWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/no_message.svg'),
          const SizedBox(height: 8),
          const Headline2(
            text: 'Pendanaan Tidak Tersedia',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text:
                'Cek secara berkala untuk mendapatkan update pendanaan terbaru',
            align: TextAlign.center,
            color: HexColor('#777777'),
          ),
        ],
      ),
    );
  }
}

class FilterPendanaan extends StatefulWidget {
  final PendanaanBloc pBloc;
  const FilterPendanaan({super.key, required this.pBloc});

  @override
  State<FilterPendanaan> createState() => _FilterPendanaanState();
}

class _FilterPendanaanState extends State<FilterPendanaan> {
  List<Map<String, dynamic>> filterSort = [
    {'id': '0', 'nama': 'Pendanaan Baru'},
    {'id': 'asc', 'nama': 'Pendanaan Terendah'},
    {'id': 'desc', 'nama': 'Pendanaan Tertinggi'},
    {'id': '2', 'nama': 'Bunga Tertinggi'},
  ];

  List<Map<String, dynamic>> durasiPengembalianSort = [
    {
      'name': '1-3 bulan',
    },
    {
      'name': '3-6 bulan',
    },
    {
      'name': '>6 bulan',
    },
  ];

  List<String> durasiSelected = [];
  TextEditingController terendahController = TextEditingController();
  TextEditingController tertinggiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pBloc.terendahStream.hasValue &&
        widget.pBloc.terendahStream.value != -1) {
      terendahController.text = rupiahFormat(widget.pBloc.terendahStream.value);
    }
    if (widget.pBloc.tertinggiStream.hasValue &&
        widget.pBloc.tertinggiStream.value != -1) {
      tertinggiController.text = rupiahFormat(
        widget.pBloc.tertinggiStream.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.pBloc;
    int numericValue;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 90,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Container(
              width: 42,
              height: 4,
              decoration: const ShapeDecoration(
                color: Color(0xFFDDDDDD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
                ),
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
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
                          bloc.jenisFilterControl([]);
                          bloc.sortControl('0');
                          terendahController.clear();
                          tertinggiController.clear();
                          bloc.terendahControl(null);
                          bloc.tertinggiControl(null);
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
                  StreamBuilder<String>(
                    stream: bloc.sortStream,
                    builder: (context, snapshot) {
                      final data = snapshot.data ?? '0';
                      return filterItemString(filterSort, data, (String val) {
                        bloc.sortControl(val);
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  const Headline3500(text: 'Jenis Produk'),
                  const SizedBox(height: 12),
                  StreamBuilder<List<dynamic>>(
                    stream: bloc.jenisProductStream,
                    builder: (context, snapshot) {
                      final dataProduk = snapshot.data ?? [];
                      return StreamBuilder<List<int>>(
                        stream: bloc.jenisProdukSortStream,
                        builder: (context, snapshot) {
                          final dataSort = snapshot.data ?? [];
                          return multipleSelectJenisProduk(
                            dataProduk,
                            dataSort,
                            (List<int> val) {
                              bloc.jenisFilterControl(val);
                            },
                          );
                        },
                      );
                    },
                  ),
                  // const SizedBox(height: 32),
                  // const Headline3500(text: 'Durasi Pengembalian'),
                  // const SizedBox(height: 12),
                  // multipleSelect(durasiPengembalianSort, durasiSelected,
                  //     (List<String> val) {
                  //   setState(() {
                  //     durasiSelected = val;
                  //   });
                  // }),
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
                          Subtitle3(
                            text: 'Terendah',
                            color: HexColor('#AAAAAA'),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontFamily: 'Poppins', color: Colors.black),
                              decoration: inputDecorSetHeight(
                                context,
                                'Terendah',
                              ),
                              onChanged: (value) => {
                                if (value.isEmpty)
                                  {
                                    value = '0',
                                  },
                                numericValue = int.tryParse(value) ?? 0,
                                print('check value $value'),
                                if (numericValue.isNegative)
                                  {
                                    bloc.terendahControl('0'),
                                    // Handle the case when the value is negative
                                    // You might want to show an error message or take some other action
                                  }
                                else
                                  {
                                    // Call the bloc method with the validated numeric value
                                    bloc.terendahControl(value),
                                  }
                              },
                              controller: terendahController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                NumberTextInputFormatter()
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
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontFamily: 'Poppins', color: Colors.black),
                              decoration: inputDecorSetHeight(
                                context,
                                'Tertinggi',
                              ),
                              onChanged: (value) => {
                                if (value.isEmpty)
                                  {
                                    value = '0',
                                  },
                                numericValue = int.tryParse(value) ?? 0,
                                if (numericValue.isNegative)
                                  {
                                    bloc.tertinggiControl('0'),
                                    // Handle the case when the value is negative
                                    // You might want to show an error message or take some other action
                                  }
                                else
                                  {
                                    // Call the bloc method with the validated numeric value
                                    bloc.tertinggiControl(value),
                                  }
                              },
                              controller: tertinggiController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                NumberTextInputFormatter()
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 80,
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button1(
                  btntext: 'Terapkan',
                  color: HexColor(lenderColor),
                  action: () {
                    bloc.getDataPendanaan();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
