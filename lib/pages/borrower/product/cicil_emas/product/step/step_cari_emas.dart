import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchEmasList extends StatefulWidget {
  final CicilEmas2Bloc cBloc;
  const SearchEmasList({super.key, required this.cBloc});

  @override
  State<SearchEmasList> createState() => _SearchEmasListState();
}

class _SearchEmasListState extends State<SearchEmasList> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool showReset = false;
  int page = 1;
  String name = '';
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.cBloc.searchEmasByString(name, page + 1, true);
        setState(() {
          page = page + 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.cBloc;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            bloc.makeNullEmas();
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/images/icons/back.svg'),
        ),
        elevation: 0,
        toolbarHeight: 70,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: HexColor('#F0F4F4'),
          ),
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/icons/search.svg',
                color: Colors.grey,
                width: 16,
                height: 16,
                fit: BoxFit.scaleDown,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  style: TextStyle(color: HexColor('#555555')),
                  onChanged: (String val) {
                    setState(
                      () {
                        if (val.length > 0) {
                          showReset = true;
                        } else {
                          showReset = false;
                        }
                      },
                    );
                  },
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (value) {
                    setState(() {
                      page = 1;
                      name = value;
                    });
                    bloc.searchEmasByString(value, page, false);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari emas di toko ini',
                    hintStyle: TextStyle(
                      color: HexColor('#BEBEBE'),
                    ),
                    contentPadding: const EdgeInsets.only(left: 0, top: 10),
                    suffixIcon: Visibility(
                      visible: showReset,
                      child: IconButton(
                        onPressed: () {
                          bloc.makeNullEmas();
                          searchController.clear();
                        },
                        icon: SvgPicture.asset(
                            'assets/images/icons/close_circle.svg'),
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: StreamBuilder<List<dynamic>?>(
          stream: bloc.emasBySearch,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              if (data.length < 1) {
                return notFound();
              } else {
                return listProdukWidget(data);
              }
            }
            return const SizedBox.shrink();
          },
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
            text: 'Pencarian Tidak Ditemukan',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text:
                'Kami tidak menemukan hasil yang sesuai untuk kata yang Anda cari. Coba kata kunci lain.',
            color: HexColor('#777777'),
            align: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget buttonSubmit(CicilEmas2Bloc bloc) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: bloc.jenisEmasSelected$,
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
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
                Navigator.pop(context);
                bloc.calculateCicilan(1);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Headline3500(
                    text: 'Lanjutkan - ${data.length} item',
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
}
