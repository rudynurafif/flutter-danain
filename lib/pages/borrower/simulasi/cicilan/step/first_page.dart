import 'package:flutter/material.dart';
import 'package:flutter_danain/component/cicilan/angsuran_content.dart';
import 'package:flutter_danain/component/home/action_modal_component.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_page.dart';
import 'package:flutter_danain/pages/borrower/simulasi/cicilan/simulasi_cicilan_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../utils/utils.dart';
import '../../../../../widgets/widget_element.dart';

class FirstPageSimulasiCicilan extends StatefulWidget {
  final bool isHaveLogin;
  final SimulasiCicilanBloc simulasiBloc;
  final int aktivasi;
  final String hp;
  final String email;
  final bool pekerjaan;
  const FirstPageSimulasiCicilan({
    super.key,
    required this.isHaveLogin,
    required this.simulasiBloc,
    required this.aktivasi,
    required this.email,
    required this.hp,
    required this.pekerjaan,
  });

  @override
  State<FirstPageSimulasiCicilan> createState() =>
      _FirstPageSimulasiCicilanState();
}

class _FirstPageSimulasiCicilanState extends State<FirstPageSimulasiCicilan> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.simulasiBloc;
    return Scaffold(
      appBar: previousTitle(context, 'Simulasi Cicilan Emas'),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgetDataEmas(bloc),
              dividerFull(context),
              jangkaWaktuWidget(bloc),
              dividerFull(context),
              angsuranWidget(bloc),
              dividerFull(context),
              annoutcement(context),
              checkLogin(widget.isHaveLogin),
              const SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }

  Widget checkLogin(bool isLogin) {
    if (isLogin) {
      return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Button1(
          btntext: 'Lihat Produk Tersedia',
          action: () {
            switch (widget.aktivasi) {
              case 10:
                switch (widget.hp) {
                  case 'waiting':
                    return showVerifikasiAlert(context);
                }
                switch (widget.email) {
                  case 'waiting':
                    return showVerifikasiAlert(context);
                }
                switch (widget.pekerjaan) {
                  case true:
                    // homeBloc.checkFdcCicilEmas();
                    // Code for innerCondition when it matches innerValue1
                    Navigator.pushNamed(context, CicilEmas2Page.routeName);
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
                print('default gan');
              // homeBloc.checkFdcCicilEmas();
            }
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget widgetDataEmas(SimulasiCicilanBloc bloc) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: bloc.jenisEmasSelectedStream,
      builder: (context, snapshot) {
        final dataSelected = snapshot.data ?? [];
        if (dataSelected.length < 1) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Headline3(text: jenisEmas, align: TextAlign.start),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    bloc.stepControl.sink.add(2);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Color(0xff24663F),
                      ),
                      SizedBox(width: 10),
                      Headline3(
                        text: tambahEmas,
                        color: Color(0xff24663F),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Headline3(text: jenisEmas, align: TextAlign.start),
                    InkWell(
                      onTap: () {
                        bloc.stepControl.sink.add(2);
                      },
                      child: Subtitle2Extra(
                        text: 'Tambah',
                        color: HexColor('#288C50'),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: dataSelected.map((data) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.3, color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                data['image'].toString().endsWith('.svg')
                                    ? SvgPicture.network(
                                        data['image'],
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        data['image'],
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          print(error);
                                          return Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: HexColor('#EEEEEE'),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            alignment: Alignment.center,
                                          );
                                        },
                                      ),
                                const SizedBox(width: 12),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Subtitle1(
                                        text:
                                            '${data['varian']} - ${data['gram'].toString()}gr'),
                                    const SizedBox(height: 2),
                                    Headline4(
                                        text: rupiahFormat(data['hargaJual'])),
                                    const SizedBox(height: 2),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          controlDataSelected(dataSelected, data['idInventory'],
                              data['idJenisEmas'])
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                keyVal4('Total Harga Emas', rupiahFormat(bloc.totalHarga.value))
              ],
            ),
          );
        }
      },
    );
  }

  Widget controlDataSelected(
      List<Map<String, dynamic>> productStore, int idEmas, int idJenisEmas) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              for (int i = 0; i < productStore.length; i++) {
                if (productStore[i]['idInventory'] == idEmas &&
                    productStore[i]['idJenisEmas'] == idJenisEmas) {
                  productStore[i]['jumlah'] = productStore[i]['jumlah'] - 1;
                  productStore[i]['total_harga'] =
                      productStore[i]['hargaJual'] * productStore[i]['jumlah'];
                  if (productStore[i]['jumlah'] <= 0) {
                    productStore.removeAt(i);
                  }
                  break;
                }
              }
              widget.simulasiBloc.jenisEmasSelected.sink.add(productStore);
              final int totalHarga = widget.simulasiBloc.jenisEmasSelected.value
                  .fold(0, (sum, item) => sum + item['total_harga'] as int);
              widget.simulasiBloc.totalHarga.sink.add(totalHarga);
              widget.simulasiBloc.calculateSimulasi();
            });
          },
          child: Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff24663F), width: 1),
                borderRadius: BorderRadius.circular(4)),
            child: const Center(
              child: Icon(
                Icons.remove,
                color: Color(0xff24663F),
                size: 14,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        SizedBox(
          width: 20,
          child: Center(
            child: SubtitleExtra(
              text:
                  '${productStore.firstWhere((selectedItem) => selectedItem['idInventory'] == idEmas && selectedItem['idJenisEmas'] == idJenisEmas)['jumlah']}',
              color: const Color(0xff24663F),
            ),
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        InkWell(
          onTap: () {
            setState(() {
              for (int i = 0; i < productStore.length; i++) {
                if (productStore[i]['idInventory'] == idEmas &&
                    productStore[i]['idJenisEmas'] == idJenisEmas) {
                  if (productStore[i]['jumlah'] < productStore[i]['stok']) {
                    productStore[i]['jumlah'] = productStore[i]['jumlah'] + 1;
                    productStore[i]['total_harga'] = productStore[i]
                            ['hargaJual'] *
                        productStore[i]['jumlah'];
                  }
                }
              }
              widget.simulasiBloc.jenisEmasSelected.sink.add(productStore);
              final int totalHarga = widget.simulasiBloc.jenisEmasSelected.value
                  .fold(0, (sum, item) => sum + item['total_harga'] as int);
              widget.simulasiBloc.totalHarga.sink.add(totalHarga);
              widget.simulasiBloc.calculateSimulasi();
            });
          },
          child: Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff24663F), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: Color(0xff24663F),
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget jangkaWaktuWidget(SimulasiCicilanBloc bloc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Jangka Waktu Angsuran'),
          const SizedBox(height: 12),
          StreamBuilder(
            stream: bloc.tenorController,
            builder: (context, snapshot) {
              final dataTenor = snapshot.data ?? 0;
              final List<ListProductResponse> listTenor =
                  bloc.tenorListController.value;
              listTenor.sort((a, b) => a.tenor.compareTo(b.tenor));
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: listTenor.map(
                  (data) {
                    return GestureDetector(
                      onTap: () {
                        bloc.idProductController.sink.add(data.id);
                        bloc.tenorController.sink.add(data.tenor);
                        bloc.calculateSimulasi();
                      },
                      child: jangkaWaktuMenu(
                        context,
                        data.detail,
                        data.tenor,
                        dataTenor,
                      ),
                    );
                  },
                ).toList(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget jangkaWaktuMenu(
    BuildContext context,
    String text,
    int index,
    int currentIndex,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: currentIndex == index ? const Color(0xffE9F6EB) : Colors.white,
          border: Border.all(
            width: 1,
            color: currentIndex == index
                ? const Color(0xff8EB69B)
                : const Color(0xffDDDDDD),
          )),
      child: Center(
        child: Subtitle2(
          text: text,
          color: currentIndex == index
              ? const Color(0xff24663F)
              : const Color(0xff777777),
        ),
      ),
    );
  }

  Widget angsuranWidget(SimulasiCicilanBloc bloc) {
    final bool isValidAngsuranList = bloc.listAngsuran.value.isNotEmpty;
    final bool isValidAngsuranPertama = bloc.angsuranPertamaControl.hasValue;
    final bool isValidTotalAngsuran = bloc.totalAngsuran.hasValue;

    if (isValidTotalAngsuran && isValidAngsuranPertama && isValidAngsuranList) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Headline3500(text: 'Simulasi Angsuran'),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => listAngsuranWidget(bloc),
                    );
                  },
                  child: Subtitle2(
                    text: 'Skema Bayar',
                    color: HexColor('#288C50'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: HexColor('#E9F6EB'),
                ),
                color: HexColor('#F9FFFA'),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: bloc.angsuranPertamaStream,
                    builder: (context, snapshot) {
                      final dataPertama = snapshot.data ?? {};
                      if (dataPertama.isEmpty) {
                        return const LinearProgressIndicator();
                      } else {
                        return contentAngsuran(
                          'Angsuran Pertama',
                          dataPertama['Total'],
                          () {
                            showDialog(
                              context: context,
                              builder: (context) => ModalDetailAngsuran(
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Headline3500(
                                        text: 'Angsuran Pertama'),
                                    const SizedBox(height: 16),
                                    keyVal('Angsuran Pertama',
                                        rupiahFormat(dataPertama['HargaEmas'])),
                                    const SizedBox(height: 8),
                                    keyVal(
                                        'Biaya Administrasi',
                                        rupiahFormat(
                                            dataPertama['BiayaAdmin'])),
                                    const SizedBox(height: 8),
                                    dividerDashed(context),
                                    const SizedBox(height: 8),
                                    keyValHeader2('Total',
                                        rupiahFormat(dataPertama['Total'])),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  dividerDashed(context),
                  const SizedBox(height: 12),
                  StreamBuilder(
                    stream: bloc.totalAngsuran,
                    builder: (context, snapshot) {
                      final dataPertama = snapshot.data ?? {};
                      if (dataPertama.isEmpty) {
                        return const LinearProgressIndicator();
                      } else {
                        return contentAngsuran(
                          'Total Angsuran Bulanan',
                          dataPertama['Total'].toInt(),
                          () {
                            showDialog(
                              context: context,
                              builder: (context) => ModalDetailAngsuran(
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Headline3500(
                                        text: 'Total Angsuran Perbulan'),
                                    const SizedBox(height: 16),
                                    keyVal('Angsuran Perbulan',
                                        rupiahFormat(dataPertama['HargaEmas'])),
                                    const SizedBox(height: 8),
                                    keyVal('Fee Jasa Mitra',
                                        rupiahFormat(dataPertama['JasaMitra'])),
                                    const SizedBox(height: 8),
                                    dividerDashed(context),
                                    const SizedBox(height: 8),
                                    keyValHeader2('Total',
                                        rupiahFormat(dataPertama['Total'])),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline3(text: simulasiCicilanTitle),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: const Color(0xffE9F6EB)),
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xffF9FFFA),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/simulasi/simulasi.svg',
                      width: 56, height: 56),
                  const SizedBox(width: 12),
                  const Flexible(
                    child: Subtitle3(
                      text: simulasiCicilanDesc,
                      align: TextAlign.start,
                      color: Color(0xff777777),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget listAngsuranWidget(SimulasiCicilanBloc bloc) {
    return Container(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline2500(text: 'Skema Pembayaran'),
          const SizedBox(height: 16),
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                itemCount: bloc.listAngsuran.value.length,
                itemBuilder: (context, index) {
                  final item = bloc.listAngsuran.value[index];
                  return Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Headline3500(text: item['keterangan']),
                            const SizedBox(height: 4),
                            Subtitle2(
                              text: dateFormat(item['tanggalJatuhTempo']),
                              color: HexColor('#777777'),
                            )
                          ],
                        ),
                        Headline3500(text: rupiahFormat(item['nominal']))
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget annoutcement(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          color: const Color(0xffFDE8CF),
          borderRadius: BorderRadius.circular(8)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 16, color: Colors.orange),
          SizedBox(width: 8),
          Flexible(
            child: Subtitle3(
              text: alertSimulasiCicilan,
              color: Color(0xff777777),
              align: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}
