import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/simulasi/cicilan/simulasi_cicilan_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class ListPilihanEmas extends StatefulWidget {
  final SimulasiCicilanBloc simulasiBloc;
  const ListPilihanEmas({super.key, required this.simulasiBloc});

  @override
  State<ListPilihanEmas> createState() => _ListPilihanEmasState();
}

class _ListPilihanEmasState extends State<ListPilihanEmas> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.simulasiBloc;
    return Scaffold(
      appBar: previousTitleCustom(
          context, 'Tambah Emas', () => bloc.stepControl.sink.add(1)),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dataListEmas(bloc),
              const SizedBox(height: 16),
              jenisEmasListWidget(bloc),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buttonBottom(bloc),
    );
  }

  Widget buttonBottom(SimulasiCicilanBloc bloc) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: bloc.jenisEmasSelectedStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        if (data.length < 1) {
          return const SizedBox.shrink();
        } else {
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
                    const Subtitle2(
                      text: 'Total Harga Emas',
                      color: Color(0xFFA3A3A3),
                    ),
                    Headline2(
                      text: rupiahFormat(bloc.totalHarga.value),
                    )
                  ],
                ),
                ButtonCustomWidth(
                  btntext: 'Tambah',
                  action: () {
                    bloc.stepControl.sink.add(1);
                  },
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget dataListEmas(SimulasiCicilanBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.idEmasSelected.stream, // Use the idEmasSelected stream
      builder: (context, snapshot) {
        final currentItem = snapshot.data;
        return StreamBuilder<List<dynamic>>(
          stream: bloc.masterEmasStream,
          builder: (context, snapshot) {
            final data = snapshot.data ?? [];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: data.map((item) {
                  return GestureDetector(
                    onTap: () {
                      bloc.getJenisEmas(item['namaJenisEmas'], 1);
                      bloc.idEmasSelected.sink.add(item['idJenisEmas']);
                    },
                    child: emasWidget(
                      currentItem!,
                      item['idJenisEmas'],
                      item['namaJenisEmas'],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget emasWidget(int currentItem, int id, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            width: 1,
            color: currentItem == id
                ? HexColor(primaryColorHex)
                : Colors.transparent),
        color:
            currentItem == id ? HexColor(primaryColorHex) : HexColor('#EEEEEE'),
      ),
      child: Subtitle2(
        text: name,
        color: currentItem == id ? Colors.white : null,
      ),
    );
  }

  Widget jenisEmasListWidget(SimulasiCicilanBloc bloc) {
    final List<Map<String, dynamic>> productStore =
        bloc.jenisEmasSelected.value;

    return StreamBuilder<List<dynamic>>(
      stream: bloc.jenisEmasList,
      builder: (context, snapshot) {
        List<dynamic> listProduct = snapshot.data ?? [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listProduct.map((data) {
              return SingleChildScrollView(
                child: Container(
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
                            data['imgJenisEmas'].toString().endsWith('.svg')
                                ? SvgPicture.network(
                                    data['imgJenisEmas'],
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    data['imgJenisEmas'],
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Subtitle1(
                                    text:
                                        '${data['namaJenisEmas']} - ${data['berat'].toString()}gr'),
                                const SizedBox(height: 2),
                                Headline4(
                                    text: rupiahFormat(data['hargaJual'])),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                      addProductList(
                        data['namaJenisEmas'],
                        data['IdJenisEmas'],
                        data['idProdukSupplier'],
                        data['stock'] ?? 0,
                        data['hargaJual'],
                        data['berat'],
                        data['karat'],
                        data['idVendor'],
                        data['imgJenisEmas'],
                        productStore,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget addProductList(
    String varian,
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
                'varian': varian,
                'stok': stok,
                'idJenisEmas': idJenisEmas,
                'idInventory': idEmas,
                'jumlah': 1,
                'idVendor': idVendor,
                'hargaJual': harga,
                'total_harga': harga,
                'gram': gram,
                'karat': karat,
                'image': image,
              });
              itemExists = true;
            }
            widget.simulasiBloc.jenisEmasSelected.sink.add(productStore);
            final int totalHarga = widget.simulasiBloc.jenisEmasSelected.value
                .fold(0, (sum, item) => sum + item['total_harga'] as int);
            widget.simulasiBloc.totalHarga.sink.add(totalHarga);
            widget.simulasiBloc.calculateSimulasi();
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
                    productStore[i]['jumlah'] = productStore[i]['jumlah'] - 1;
                    productStore[i]['total_harga'] =
                        harga * productStore[i]['jumlah'];
                    if (productStore[i]['jumlah'] <= 0) {
                      productStore.removeAt(i);
                    }
                    break;
                  }
                }
                widget.simulasiBloc.jenisEmasSelected.sink.add(productStore);
                final int totalHarga = widget
                    .simulasiBloc.jenisEmasSelected.value
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
                    if (productStore[i]['jumlah'] < stok) {
                      productStore[i]['jumlah'] = productStore[i]['jumlah'] + 1;
                      productStore[i]['total_harga'] =
                          harga * productStore[i]['jumlah'];
                    }
                  }
                }
                widget.simulasiBloc.jenisEmasSelected.sink.add(productStore);
                final int totalHarga = widget
                    .simulasiBloc.jenisEmasSelected.value
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
    return Container();
  }
}
