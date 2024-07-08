import 'package:flutter/material.dart';
import 'package:flutter_danain/component/cicilan/angsuran_content.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_bloc.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StepDetailCo extends StatefulWidget {
  final CicilEmas2Bloc cicilBloc;
  const StepDetailCo({super.key, required this.cicilBloc});

  @override
  State<StepDetailCo> createState() => _StepDetailCoState();
}

class _StepDetailCoState extends State<StepDetailCo> {
  List<Map<String, dynamic>> dataJangkaWaktu = [
    {'value': 6, 'name': '6 Bulan'},
    {'value': 12, 'name': '12 Bulan'},
    {'value': 24, 'name': '24 Bulan'},
  ];

  TextEditingController kuponController = TextEditingController();
  String kuponGes = '';
  @override
  void initState() {
    super.initState();
  }

  bool showDetail = false;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final bloc = widget.cicilBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Cicil Emas', () {
        bloc.stepChange(1);
        bloc.makeNullVoucher();
      }),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(bloc),
            listProductSelected(context, bloc),
            const SizedBox(height: 8),
            filterListEmas(bloc),
            dividerFull(context),
            jangkaWaktuWidget(bloc),
            // const SizedBox(height: 16),
            // kuponWidget(bloc),
            const SizedBox(height: 16),
            angsuranWidget(bloc),
            const SizedBox(height: 16),
            mitraEmas(bloc),
            const SizedBox(height: 24),
            agreementLisences(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: buttonBottom(bloc),
    );
  }

  Widget buttonBottom(CicilEmas2Bloc bloc) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 94,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1E3B4A74),
            blurRadius: 12,
            offset: Offset(0, -2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Subtitle2(
                    text: 'Total Pembayaran',
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      showDetailTotal(context);
                    },
                    child: Transform.rotate(
                      angle: 3.14159265,
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 14,
                      ),
                    ),
                  )
                ],
              ),
              StreamBuilder<int>(
                stream: bloc.totalPembayaran,
                builder: (context, snapshot) {
                  final total = snapshot.data ?? 0;
                  return Headline2(
                    text: rupiahFormat(total),
                  );
                },
              )
            ],
          ),
          StreamBuilder<bool>(
              stream: bloc.setujuStream,
              builder: (context, snapshot) {
                final isCheck = snapshot.data ?? false;
                return ButtonCustomWidth(
                  btntext: 'Lanjut',
                  color: isCheck ? null : Colors.grey,
                  action: isCheck
                      ? () {
                          bloc.stepChange(3);
                          bloc.checkFdc();
                        }
                      : null,
                );
              })
        ],
      ),
    );
  }

  // Stream<void> handleAjuan(int ajuanStatus) async* {
  //   if (ajuanStatus == 1) {
  //     widget.cicilBloc.stepController.sink.add(3);
  //   } else if (ajuanStatus == 2) {
  //     await showDialog(
  //       context: context,
  //       builder: (context) => ModalPopUp(
  //         icon: 'assets/images/icons/error_icon.svg',
  //         title: 'Limit Angsuran Tidak Cukup',
  //         message:
  //             'Limit angsuran Anda Rp 150.000. Silakan hubungi customer support untuk meningkatkan limit angsuran.',
  //         actions: [
  //           Button2(
  //             btntext: 'Hubungi CS',
  //             action: () async {
  //               const url = urlChat;
  //               if (await canLaunch(url)) {
  //                 await launch(url);
  //               } else {
  //                 throw 'Could not launch $url';
  //               }
  //             },
  //           )
  //         ],
  //       ),
  //     );
  //   } else if (ajuanStatus == 3) {
  //     await Navigator.pushNamedAndRemoveUntil(
  //         context, PengajuanCicilanGagal.routeName, (route) => false,
  //         arguments: 'cicilan');
  //   }
  // }

  Widget header(CicilEmas2Bloc bloc) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: StreamBuilder<Map<String, dynamic>>(
                    stream: bloc.supplierStream$,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              data['imgSupplier'],
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 8),
                            Subtitle1(text: data['namaSupplier']),
                          ],
                        );
                      }
                      return const LinearProgressIndicator();
                    }),
              ),
              InkWell(
                onTap: () {
                  // bloc.prevStep();
                  bloc.stepChange(1);
                },
                child: Headline5(
                  text: 'Tambah Emas',
                  color: HexColor(primaryColorHex),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          dividerFullNoPadding(context)
        ],
      ),
    );
  }

  Widget listProductSelected(BuildContext context, CicilEmas2Bloc bloc) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: bloc.jenisEmasSelected$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listData = snapshot.data ?? [];
          final int itemLength = showDetail
              ? listData.length
              : (listData.length > 3 ? 3 : listData.length);

          final limitedList = listData.sublist(0, itemLength);

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: limitedList.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLastIndex = index == limitedList.length - 1;
              final image = item['image'] ?? item['image'];
              return Container(
                decoration: BoxDecoration(
                  border: isLastIndex
                      ? null
                      : const Border(
                          bottom: BorderSide(width: 0.3, color: Colors.grey),
                        ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 17),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          image.toString().endsWith('.svg')
                              ? SvgPicture.network(
                                  image,
                                  width: 40,
                                  height: 40,
                                )
                              : Image.network(
                                  image,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(error);
                                    return Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: HexColor('#EEEEEE'),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      alignment: Alignment.center,
                                    );
                                  },
                                ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Subtitle1(
                                text: '${item['namaEmas']} - ${item['gram']}gr',
                              ),
                              const SizedBox(height: 2),
                              Headline4(text: rupiahFormat(item['hargaJual'])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    addProductList(
                      context,
                      bloc,
                      item['idJenisEmas'],
                      item['idInventory'],
                      listData,
                      index,
                      item['jumlah'],
                      item['stok'] ?? 0,
                      item['hargaJual'],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }
        return loadingListEmas(context);
      },
    );
  }

  Widget loadingListEmas(BuildContext context) {
    final List<int> data = [1, 2, 3];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 17),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.3, color: Colors.grey),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ShimmerLong4(height: 40, width: 40),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLong(
                        height: 16,
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      const SizedBox(height: 8),
                      ShimmerLong(
                        height: 16,
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                    ],
                  ),
                ],
              ),
              ShimmerLong4(
                height: 24,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget filterListEmas(CicilEmas2Bloc bloc) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: bloc.jenisEmasSelected$,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        if (showDetail == false && listData.length > 3) {
          return Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                setState(() {
                  showDetail = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Subtitle2(
                    text: 'Lihat Lebih banyak',
                    color: HexColor('#AAAAAA'),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.expand_more,
                    color: Colors.grey,
                    size: 12,
                  ),
                ],
              ),
            ),
          );
        } else if (showDetail == true && listData.length > 3) {
          return Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                setState(() {
                  showDetail = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Subtitle2(
                    text: 'Lihat Lebih Sedikit',
                    color: HexColor('#AAAAAA'),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.expand_less,
                    color: Colors.grey,
                    size: 12,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget addProductList(
    BuildContext context,
    CicilEmas2Bloc bloc,
    int idJenisEmas,
    int idEmas,
    List<Map<String, dynamic>> productStore,
    int index,
    int currentTotal,
    int stok,
    int harga,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (currentTotal <= 1) {
                alertRemove(
                  context,
                  productStore,
                  index,
                );
              } else {
                for (int i = 0; i < productStore.length; i++) {
                  if (productStore[i]['idInventory'] == idEmas &&
                      productStore[i]['idJenisEmas'] == idJenisEmas) {
                    productStore[i]['jumlah'] = productStore[i]['jumlah'] - 1;
                    productStore[i]['totalHarga'] = productStore[i]
                            ['hargaJual'] *
                        productStore[i]['jumlah'];
                  }
                }
                bloc.emasSelectedControl(productStore);
              }

              final int totalHarga = productStore.fold(
                  0, (sum, item) => sum + item['totalHarga'] as int);
              bloc.totalHargaChange(totalHarga);

              bloc.calculateCicilan(0);
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
                  if (productStore[i]['jumlah'] < stok) {
                    productStore[i]['jumlah'] = productStore[i]['jumlah'] + 1;
                    productStore[i]['totalHarga'] =
                        harga * productStore[i]['jumlah'];
                  }
                }
              }
              bloc.emasSelectedControl(productStore);
              final int totalHarga = productStore.fold(
                  0, (sum, item) => sum + item['totalHarga'] as int);
              bloc.totalHargaChange(totalHarga);
              bloc.calculateCicilan(0);
            });
          },
          child: Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff24663F), width: 1),
                borderRadius: BorderRadius.circular(4)),
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

  Widget jangkaWaktuWidget(CicilEmas2Bloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Jangka Waktu Angsuran'),
          const SizedBox(height: 12),
          StreamBuilder<List<ListProductResponse>>(
            stream: bloc.listProduct$,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Loading state
                return ShimmerLong4(
                  height: kToolbarHeight,
                  width: MediaQuery.of(context).size.width,
                );
              } else if (snapshot.hasError) {
                // Error state
                return ShimmerLong4(
                  height: kToolbarHeight,
                  width: MediaQuery.of(context).size.width,
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data ?? [];
                return StreamBuilder<int>(
                  stream: bloc.tenorStream$,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Loading state for the tenor stream
                      return ShimmerLong4(
                        height: kToolbarHeight,
                        width: MediaQuery.of(context).size.width,
                      );
                    } else if (snapshot.hasError) {
                      // Error state for the tenor stream
                      return ShimmerLong4(
                        height: kToolbarHeight,
                        width: MediaQuery.of(context).size.width,
                      );
                    } else if (snapshot.hasData) {
                      final tenor = snapshot.data ?? 6;
                      return SelectFormTenor(
                        data: data,
                        placeHolder: 'Pilih Jangka Waktu',
                        changeResponse: (ListProductResponse? val) {
                          bloc.tenorChange(val!.tenor);
                          bloc.idProdukChange(val.id);
                          bloc.calculateCicilan(0);
                        },
                        value: data.firstWhere((item) => tenor == item.tenor),
                      );
                    } else {
                      return ShimmerLong4(
                        height: kToolbarHeight,
                        width: MediaQuery.of(context).size.width,
                      );
                    }
                  },
                );
              } else {
                return ShimmerLong4(
                  height: kToolbarHeight,
                  width: MediaQuery.of(context).size.width,
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget kuponWidget(CicilEmas2Bloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Makin Hemat Dengan Kupon'),
          const SizedBox(height: 12),
          kuponActive(bloc)
        ],
      ),
    );
  }

  Widget kuponActive(CicilEmas2Bloc bloc) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: bloc.kuponStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!['Status'] == true) {
          final data = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: HexColor('#DDDDDD'),
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/images/icons/kupon.svg'),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Headline3500(
                            text:
                                'Kode Kupon: ${data['Data']['kode_voucher']}'),
                        const SizedBox(height: 2),
                        Subtitle2(
                          text:
                              'Cashback senilai ${rupiahFormat(data['Data']['amount'])}',
                          color: HexColor('#777777'),
                        )
                      ],
                    )
                  ],
                ),
                IconButton(
                  onPressed: () {
                    bloc.makeNullVoucher();
                    kuponController.clear();
                    setState(() {
                      kuponGes = '';
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 20,
                  ),
                )
              ],
            ),
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: kuponController,
                    decoration: inputDecorErrorLeft(
                      context,
                      'Masukan Kupon',
                      snapshot.hasData && snapshot.data!['Status'] == false,
                    ),
                    onChanged: (val) {
                      setState(() {
                        kuponGes = val;
                      });
                      bloc.makeNullVoucher();
                    },
                  ),
                  if (snapshot.hasData && snapshot.data!['Status'] == false)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.data!['Message'],
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: 60,
              child: ButtonSmall(
                color: kuponGes.length > 0 ? null : Colors.grey,
                btntext: 'Gunakan',
                action: kuponGes.length > 0
                    ? () {
                        bloc.getKupon(kuponController.text);
                      }
                    : null,
              ),
            )
          ],
        );
      },
    );
  }

  Widget kuponTextField(CicilEmas2Bloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: kuponController,
                decoration: inputDecorNoError(
                  context,
                  'Masukan Kupon',
                ),
                onChanged: (val) => setState(() {
                  kuponGes = val;
                }),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          height: 60,
          child: ButtonSmall(
            color: kuponGes.length > 0 ? null : Colors.grey,
            btntext: 'Gunakan',
            action: kuponGes.length > 0
                ? () {
                    bloc.getKupon(kuponController.text);
                  }
                : null,
          ),
        )
      ],
    );
  }

  Widget angsuranWidget(CicilEmas2Bloc bloc) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: HexColor('#E9F6EB'),
        ),
        color: HexColor('#F9FFFA'),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<Map<String, dynamic>>(
            stream: bloc.angsuranPertamaStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Loading state
                return angsuranLoading(context);
              } else if (snapshot.hasError) {
                // Error state
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                num total = data['Total'];
                return contentAngsuran(
                  'Angsuran Pertama',
                  total.toInt(),
                  () {
                    showAngsuranPertama(data);
                  },
                );
              } else {
                return angsuranLoading(context);
              }
            },
          ),
          const SizedBox(height: 12),
          dividerDashed(context),
          const SizedBox(height: 12),
          StreamBuilder<Map<String, dynamic>>(
            stream: bloc.totalAngsuran,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                num total = data['Total'];
                return contentAngsuran('Total Angsuran Bulanan', total.toInt(),
                    () {
                  showtotalAngsuran(data);
                });
              } else if (snapshot.hasError) {
                // Error state
                return angsuranLoading(context);
              } else {
                // Loading state
                return angsuranLoading(context);
              }
            },
          )
        ],
      ),
    );
  }

  Widget mitraEmas(CicilEmas2Bloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.mitraStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Headline3500(text: 'Lokasi Mitra Pengambilan Emas'),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: HexColor('#DDDDDD'),
                      ),
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/images/icons/mitra.svg'),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleExtra(text: data['namaBranch']),
                            const SizedBox(height: 4),
                            Subtitle2(
                              text: data['alamat'],
                              color: HexColor('#777777'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return mitraLoading(context);
      },
    );
  }

  Widget mitraLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Lokasi Mitra Pengambilan Emas'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: HexColor('#DDDDDD'),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/images/icons/mitra.svg'),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLong(
                        height: 14,
                        width: MediaQuery.of(context).size.width / 2.5,
                      ),
                      const SizedBox(height: 4),
                      ShimmerLong(
                        height: 28,
                        width: MediaQuery.of(context).size.width / 2.5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget agreementLisences() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<bool>(
        stream: widget.cicilBloc.setujuStream,
        builder: (context, snapshot) {
          final valueData = snapshot.data ?? false;
          return GestureDetector(
            onTap: () {
              if (valueData == false) {
                widget.cicilBloc.stepChange(10);
              } else {
                widget.cicilBloc.setujuControl(false);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: checkBoxBorrower(
              valueData,
              const Row(
                children: [
                  Subtitle2(text: acceptSyarat1),
                  SizedBox(width: 2.0),
                  Subtitle2(
                    text: 'Dokumen Perjanjian',
                    color: Color(0xff288C50),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showAngsuranPertama(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: ModalDetailAngsuran(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Angsuran Pertama'),
              const SizedBox(height: 16),
              keyVal('Angsuran Pertama', rupiahFormat(data['HargaEmas'])),
              const SizedBox(height: 8),
              keyVal('Biaya Administrasi', rupiahFormat(data['BiayaAdmin'])),
              const SizedBox(height: 8),
              dividerDashed(context),
              const SizedBox(height: 8),
              keyVal2('Total', rupiahFormat(data['Total'])),
            ],
          ),
        ),
      ),
    );
  }

  void showtotalAngsuran(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: ModalDetailAngsuran(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Total Angsuran Perbulan'),
              const SizedBox(height: 16),
              keyVal('Angsuran Perbulan', rupiahFormat(data['HargaEmas'])),
              const SizedBox(height: 8),
              keyVal('Fee Jasa Mitra', rupiahFormat(data['JasaMitra'])),
              const SizedBox(height: 8),
              dividerDashed(context),
              const SizedBox(height: 8),
              keyVal2('Total', rupiahFormat(data['Total'])),
            ],
          ),
        ),
      ),
    );
  }

  void showDetailTotal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: ModalDetailAngsuran(
          content: StreamBuilder<Map<String, dynamic>>(
            stream: widget.cicilBloc.detailPembayaran,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data ?? {};
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Headline3500(text: 'Detail Total Pembayaran'),
                    const SizedBox(height: 16),
                    keyVal('Harga Perolehan Emas',
                        rupiahFormat(data['hargaPerolehanEmas'])),
                    const SizedBox(height: 8),
                    keyVal('Bunga', rupiahFormat(data['bunga'])),
                    const SizedBox(height: 8),
                    keyVal(
                        'Biaya Administrasi', rupiahFormat(data['biayaAdmin'])),
                    const SizedBox(height: 8),
                    keyVal('Fee Jasa Mitra', rupiahFormat(data['jasaMitra'])),
                    const SizedBox(height: 8),
                    dividerDashed(context),
                    const SizedBox(height: 8),
                    keyVal2('Total Biaya', rupiahFormat(data['total'])),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  void alertRemove(
    BuildContext context,
    List<Map<String, dynamic>> productStore,
    int i,
  ) {
    showDialog(
      context: context,
      builder: (context) => ModalPopUp(
        icon: 'assets/images/icons/warning_red.svg',
        title: 'Hapus Item',
        message: 'Apakah Anda yakin ingin menghapus item ini?',
        actions: [
          Button2(
            btntext: 'Hapus',
            action: () {
              setState(() {
                productStore.removeAt(i);
              });
              widget.cicilBloc.emasSelectedControl(productStore);
              final int totalHarga = productStore.fold(
                  0, (sum, item) => sum + item['totalHarga'] as int);
              widget.cicilBloc.totalHargaChange(totalHarga);
              widget.cicilBloc.calculateCicilan(0);

              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              child: Headline5(
                text: 'Batalkan',
                color: HexColor(primaryColorHex),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}

class DocumentPerjanjian extends StatefulWidget {
  final CicilEmas2Bloc cBloc;
  const DocumentPerjanjian({
    super.key,
    required this.cBloc,
  });

  @override
  State<DocumentPerjanjian> createState() => _DocumentPerjanjianState();
}

class _DocumentPerjanjianState extends State<DocumentPerjanjian> {
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.cBloc;
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        bloc.stepChange(2);
      }),
      body: StreamBuilder<dynamic>(
        stream: bloc.documentPerjanjian,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? '';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              margin: const EdgeInsets.only(bottom: 100),
              height: MediaQuery.of(context).size.height - 170,
              child: Transform(
                transform: Matrix4.identity()..scale(1.2),
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadHtmlString(
                      data.toString(),
                    )
                    ..enableZoom(true),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Subtitle2(text: snapshot.error.toString()),
            );
          }
          return Center(
            child: Image.asset('assets/images/icons/loading_danain.png'),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 150,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isCheck = !isCheck;
                });
              },
              child: checkBoxBorrower(
                isCheck,
                Wrap(
                  children: [
                    Subtitle2(
                      text: 'Saya telah membaca dan menyetujui Dokumen ',
                      color: HexColor('#777777'),
                    ),
                    const Subtitle2(
                      text: 'Perjanjian Pinjaman',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Button1(
              btntext: 'Setuju',
              color: isCheck ? null : Colors.grey,
              action: isCheck
                  ? () {
                      bloc.setujuControl(true);
                      bloc.stepChange(2);
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
