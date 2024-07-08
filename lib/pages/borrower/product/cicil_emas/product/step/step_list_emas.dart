import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/component/complete_data/textfield_withMoney_component.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/step/step_cari_emas.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_index.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class StepListEmas extends StatefulWidget {
  final CicilEmas2Bloc cBloc;
  const StepListEmas({super.key, required this.cBloc});

  @override
  State<StepListEmas> createState() => _StepListEmasState();
}

class _StepListEmasState extends State<StepListEmas> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.cBloc.infinineScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.cBloc;
    return Scaffold(
      appBar: appBarWidget(bloc),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tokoEmas(bloc),
            const SizedBox(height: 24),
            daftarProdukWidget(bloc),
            StreamBuilder<bool>(
              stream: bloc.isLoadingStream$,
              builder: (context, snapshot) {
                final isLoading = snapshot.data ?? false;
                if (isLoading == true) {
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
      ),
      bottomNavigationBar: StreamBuilder<List<Map<String, dynamic>>>(
        stream: bloc.jenisEmasSelected$,
        builder: (context, snapshot) {
          final data = snapshot.data ?? [];
          if (data.length > 0) {
            return buttonSubmit(bloc);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buttonSubmit(CicilEmas2Bloc bloc) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: bloc.jenisEmasSelected$,
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        num totalItem = data.fold(
            0, (previousValue, element) => previousValue + element['jumlah']);
        return Container(
          height: 100,
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff24663F)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: const BorderSide(color: Color(0xff24663F), width: 1),
                  ),
                ),
              ),
              onPressed: () {
                bloc.calculateCicilan(1);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Headline3500(
                    text: 'Lanjutkan - ${totalItem} item',
                    color: Colors.white,
                  ),
                  StreamBuilder<int>(
                    stream: bloc.totalHargaStream$,
                    builder: (context, snapshot) {
                      final total = snapshot.data ?? 0;
                      print(total);
                      return Headline3(
                        text: rupiahFormat(total),
                        color: Colors.white,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar appBarWidget(CicilEmas2Bloc bloc) {
    return AppBar(
      // toolbarHeight: 65,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset('assets/images/icons/back.svg'),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Subtitle2(
            text: 'Lokasi Anda',
            color: HexColor('#777777'),
          ),
          StreamBuilder<String>(
            stream: bloc.locationStream$,
            builder: (context, snapshot) {
              final data = snapshot.data ?? '';
              return Headline3500(text: data);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) => SearchEmasList(cBloc: bloc),
            );
          },
          icon: SvgPicture.asset('assets/images/icons/search.svg'),
          iconSize: 24,
        )
      ],
    );
  }

  Widget tokoEmas(CicilEmas2Bloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.supplierStream$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Container(
            color: HexColor('#E9F6EB'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  data['imgSupplier'],
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) {
                    print('errornya bang: $error');
                    return Image.asset(
                      'assets/images/transaction/toko_emas.png',
                    );
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Headline1(text: data['namaSupplier']),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                StreamBuilder<double>(
                                  stream: bloc.distance,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    } else if (snapshot.hasError) {
                                      return const SizedBox.shrink();
                                    } else if (snapshot.hasData) {
                                      final data = snapshot.data!;
                                      return iconNText(
                                        Icons.fmd_good_rounded,
                                        HexColor('#FE243D'),
                                        '${data.toInt()} km',
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: HexColor('#AAAAAA'),
                                ),
                                const SizedBox(width: 8),
                                iconNText(
                                  Icons.star,
                                  HexColor('#FFC600'),
                                  data['ratingSupplier'].toString(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            TokoEmasIndex.routeName,
                            arguments: TokoEmasIndex(
                              idSupplier: data['idSupplier'],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          color: HexColor('#AAAAAA'),
                          size: 16,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24)
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget daftarProdukWidget(CicilEmas2Bloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.listEmasStream$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Headline3500(text: 'Daftar Produk'),
                          const SizedBox(height: 8),
                          StreamBuilder<int>(
                            stream: bloc.totalEmas,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Subtitle2(
                                  text: '${snapshot.data} produk',
                                  color: HexColor('#BEBEBE'),
                                );
                              }

                              return Subtitle2(
                                text: '0 produk',
                                color: HexColor('#BEBEBE'),
                              );
                            },
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            useSafeArea: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => FilterCicilEmas(cBloc: bloc),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 6),
                          decoration: BoxDecoration(
                              color: HexColor('#F9FFFA'),
                              border: Border.all(
                                width: 1,
                                color: HexColor('#E9F6EB'),
                              ),
                              borderRadius: BorderRadius.circular(4)),
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
                  ),
                ),
                const SizedBox(height: 24),
                listProdukWidget(data)
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget listProdukWidget(List<dynamic> listProduct) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: widget.cBloc.jenisEmasSelected$,
      builder: (context, snapshot) {
        // ignore: prefer_final_locals
        List<Map<String, dynamic>> productStore = snapshot.data ?? [];
        if (listProduct.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listProduct.map((data) {
              final image = data['imgJenisEmas'];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 17),
                margin: const EdgeInsets.symmetric(horizontal: 24),
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
                          image.toString().endsWith('.svg')
                              ? SvgPicture.network(
                                  image,
                                  width: 56,
                                  height: 56, 
                                )
                              : Image.network(
                                  image,
                                  width: 56,
                                  height: 56,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(error);
                                    return Container(
                                      width: 56,
                                      height: 56,
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
                                text:
                                    '${data['namaJenisEmas']} - ${data['berat']}gr',
                              ),
                              const SizedBox(height: 2),
                              Headline4(text: rupiahFormat(data['hargaJual'])),
                              const SizedBox(height: 2),
                              Subtitle2(
                                text: 'Stok: ${data['stock'] ?? 0}',
                                color: HexColor('#5F5F5F'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    addProductList(
                      data['namaJenisEmas'],
                      data['idProdukSupplier'],
                      data['IdJenisEmas'],
                      data['idProdukSupplier'],
                      data['stock'] ?? 0,
                      data['hargaJual'],
                      data['berat'],
                      data['karat'],
                      data['idSupplier'],
                      image,
                      productStore,
                    )
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          return notFound();
        }
      },
    );
  }

  Widget addProductList(
    String varian,
    int idProdukSupplier,
    int idJenisEmas,
    int idEmas,
    int stok,
    int harga,
    dynamic gram,
    dynamic karat,
    dynamic idVendor,
    String image,
    List<Map<String, dynamic>> productStore,
  ) {
    final bool isSelected = productStore.any((selectedItem) {
      return selectedItem['idInventory'] == idEmas &&
          selectedItem['idJenisEmas'] == idJenisEmas;
    });
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: widget.cBloc.jenisEmasSelected$,
      builder: (context, snapshot) {
        final produkData = snapshot.data ?? [];
        if (stok == 0) {
          return Container();
        }
        if (!isSelected) {
          return ElevatedButton(
            style: buttonDecor(),
            onPressed: () {
              setState(() {
                bool itemExists = false;

                if (!itemExists) {
                  productStore.add({
                    'namaEmas': varian,
                    'stok': stok,
                    'idProdukSupplier': idProdukSupplier,
                    'idJenisEmas': idJenisEmas,
                    'idInventory': idEmas,
                    'jumlah': 1,
                    'idVendor': idVendor,
                    'hargaJual': harga,
                    'totalHarga': harga,
                    'gram': gram,
                    'karat': karat,
                    'image': image,
                    'idJenisBarang': 0,
                  });
                  itemExists = true;
                }
                widget.cBloc.emasSelectedControl(productStore);
                final int totalHarga = productStore.fold(
                    0, (sum, item) => sum + item['totalHarga'] as int);
                print(totalHarga);
                widget.cBloc.totalHargaChange(totalHarga);
              });
            },
            child: Subtitle2Extra(
              text: 'Tambah',
              color: HexColor(primaryColorHex),
            ),
          );
        }

        if (isSelected) {
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
                        productStore[i]['jumlah'] =
                            productStore[i]['jumlah'] - 1;
                        productStore[i]['totalHarga'] =
                            harga * productStore[i]['jumlah'];
                        if (productStore[i]['jumlah'] <= 0) {
                          productStore.removeAt(i);
                        }
                        break;
                      }
                    }
                    widget.cBloc.emasSelectedControl(productStore);
                    final int totalHarga = produkData.fold(
                        0, (sum, item) => sum + item['totalHarga'] as int);
                    widget.cBloc.totalHargaChange(totalHarga);
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff24663F), width: 1),
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
                        if (productStore[i]['jumlah'] < stok) {
                          productStore[i]['jumlah'] =
                              productStore[i]['jumlah'] + 1;
                          productStore[i]['totalHarga'] =
                              harga * productStore[i]['jumlah'];
                        }
                      }
                    }
                    widget.cBloc.emasSelectedControl(productStore);
                    final int totalHarga = produkData.fold(
                        0, (sum, item) => sum + item['totalHarga'] as int);
                    widget.cBloc.totalHargaChange(totalHarga);
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff24663F), width: 1),
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
        return const SizedBox.shrink();
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
            text: 'Data Tidak Ditemukan',
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

  Widget iconNText(IconData icon, Color colorIcon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: colorIcon,
          size: 20,
        ),
        const SizedBox(width: 8),
        SubtitleExtra(
          text: text,
          color: HexColor('#AAAAAA'),
        )
      ],
    );
  }
}

class FilterCicilEmas extends StatefulWidget {
  final CicilEmas2Bloc cBloc;
  const FilterCicilEmas({super.key, required this.cBloc});

  @override
  State<FilterCicilEmas> createState() => _FilterCicilEmasState();
}

class _FilterCicilEmasState extends State<FilterCicilEmas> {
  TextEditingController gramController = TextEditingController();
  TextEditingController karatController = TextEditingController();
  TextEditingController terendahController = TextEditingController();
  TextEditingController tertinggiController = TextEditingController();
  List<Map<String, dynamic>> filterList = [
    {
      'id': 1,
      'name': 'Paling Sesuai',
    },
    {
      'id': 2,
      'name': 'Terbaru',
    },
    {
      'id': 4,
      'name': 'Harga Terendah',
    },
    {
      'id': 3,
      'name': 'Harga Tertinggi',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final bloc = widget.cBloc;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height - 150,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    color: HexColor('#DDDDDD'),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Headline3500(text: 'Filter'),
                      InkWell(
                        onTap: () {
                          bloc.urutkanChange(0);
                          bloc.gramChange(null);
                          bloc.karatChange(null);
                          bloc.jenisEmasChange([]);
                          bloc.minChange(null);
                          bloc.maxChange(null);
                          gramController.clear();
                          karatController.clear();
                          terendahController.clear();
                          tertinggiController.clear();
                          bloc.filterControl();
                        },
                        child: Subtitle2(
                          text: 'Reset',
                          color: HexColor(primaryColorHex),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: filterSelect(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: gramKaratFilter(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: hargaFilter(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          bottomNavigationBar: buttonTerapkan(),
        ),
      ),
    );
  }

  Widget buttonTerapkan() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<bool>(
            stream: widget.cBloc.buttonTerapkan,
            builder: (context, snapshot) {
              final isValid = snapshot.data ?? false;
              return Button1(
                btntext: 'Terapkan',
                color: isValid ? null : Colors.grey,
                action: isValid
                    ? () {
                        widget.cBloc.filterControl();
                        Navigator.pop(context);
                      }
                    : null,
              );
            },
          )
        ],
      ),
    );
  }

  Widget filterSelect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Urutkan'),
        const SizedBox(height: 12),
        StreamBuilder<int>(
          stream: widget.cBloc.urutkanParam,
          builder: (context, snapshot) {
            final data = snapshot.data ?? 1;
            return Container(
              child: filterItem(filterList, data, (int id) {
                widget.cBloc.urutkanChange(id);
              }),
            );
          },
        ),
        const SizedBox(height: 24),
        const Headline3500(text: 'Jenis Emas'),
        StreamBuilder<List<dynamic>>(
          stream: widget.cBloc.masterJenisEmasStream$,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return StreamBuilder<List<int>>(
                stream: widget.cBloc.jenisEmasParam,
                builder: (context, snapshot) {
                  final dataSelected = snapshot.data ?? [];
                  return multipleSelectJenisEmas(
                    data,
                    dataSelected,
                    (List<int> val) {
                      widget.cBloc.jenisEmasChange(val);
                    },
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        )
      ],
    );
  }

  Widget gramKaratFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline3500(text: 'Gram'),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2.5,
              child: StreamBuilder<int>(
                stream: widget.cBloc.gramParam,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data! > 0) {
                    gramController.text = snapshot.data!.toString();
                  }
                  return TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration:
                        inputDecorWithSuffixAndSetHeight(context, '1', 'gram'),
                    onChanged: widget.cBloc.gramChange,
                    controller: gramController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CantZero()
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline3500(text: 'Karat'),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2.5,
              child: StreamBuilder<int>(
                stream: widget.cBloc.karatParam,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data! > 0) {
                    karatController.text = snapshot.data!.toString();
                  }
                  return TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration:
                        inputDecorWithSuffixAndSetHeight(context, '1', 'karat'),
                    onChanged: widget.cBloc.karatChange,
                    controller: karatController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CantZero()
                    ],
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget hargaFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline3500(text: 'Harga'),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2.5,
              child: StreamBuilder<int>(
                stream: widget.cBloc.minParam,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data! > 0) {
                    terendahController.text = rupiahFormat(snapshot.data!);
                  }
                  return TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecorSetHeight(
                      context,
                      'Terendah',
                    ),
                    controller: terendahController,
                    onChanged: (value) {
                      if (value.length > 3) {
                        widget.cBloc.minChange(value);
                      } else {
                        terendahController.clear();
                        widget.cBloc.minChange(null);
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumberTextInputFormatter(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AbsorbPointer(
              absorbing: false,
              child: Headline3500(
                text: '',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2.5,
              child: StreamBuilder<int>(
                stream: widget.cBloc.maxParam,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data! > 0) {
                    tertinggiController.text = rupiahFormat(snapshot.data!);
                  }
                  return TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecorSetHeight(
                      context,
                      'Tertinggi',
                    ),
                    controller: tertinggiController,
                    onChanged: (value) {
                      if (value.length > 3) {
                        widget.cBloc.maxChange(value);
                      } else {
                        tertinggiController.clear();
                        widget.cBloc.maxChange(null);
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumberTextInputFormatter(),
                    ],
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
