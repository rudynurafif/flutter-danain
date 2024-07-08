import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/detail_transaksi/detail_transaksi_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class CardTransaksiComponent extends StatelessWidget {
  final int idAgreement;
  final String image;
  final String namaProduk;
  final String noPp;
  final String status;
  final num pinjaman;
  final int tenor;
  final String tglJt;

  const CardTransaksiComponent({
    super.key,
    required this.idAgreement,
    required this.image,
    required this.namaProduk,
    required this.noPp,
    required this.status,
    required this.pinjaman,
    required this.tenor,
    required this.tglJt,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailTransaksi.routeName,
          arguments: DetailTransaksi(idAgreement: idAgreement),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: HexColor('#F0F0F0'),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              image,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const ShimmerLong(
                                  height: 40,
                                  width: 40,
                                  radius: 8,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                namaProduk,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: HexColor('#333333'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                noPp,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: HexColor('#777777'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: ShapeDecoration(
                          color: status == 'Aktif'
                              ? HexColor('#F2F8FF')
                              : HexColor('#FEF4E8'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Subtitle3(
                              text: status,
                              color: status == 'Aktif'
                                  ? HexColor('#007AFF')
                                  : HexColor('#F7951D'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const DividerWidget(height: 1),
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
                            text: 'Pinjaman',
                            color: HexColor('#AAAAAA'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rupiahFormat(
                              pinjaman,
                            ),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF333333),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Subtitle3(
                            text: 'Tenor',
                            color: HexColor('#AAAAAA'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$tenor bulan',
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Subtitle3(
                            text: 'Jatuh Tempo',
                            color: HexColor('#AAAAAA'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormatComplete(tglJt),
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef ConverterFilter<T> = T Function(
  String urutkan,
  List<dynamic> produk,
  List<dynamic> status,
);

class FilterModal extends StatefulWidget {
  final String urutkan;
  final List<dynamic> produk;
  final List<dynamic> status;
  final VoidCallback reset;
  final ConverterFilter onSubmit;
  const FilterModal({
    super.key,
    required this.urutkan,
    required this.produk,
    required this.status,
    required this.reset,
    required this.onSubmit,
  });

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late String urutkan;
  late List<dynamic> produk;
  late List<dynamic> status;
  List<Map<String, dynamic>> filterList = [
    {
      'id': 'terlama',
      'nama': 'Terlama',
    },
    {
      'id': 'terbaru',
      'nama': 'Terbaru',
    },
    {
      'id': 'pinjamanTerendah',
      'nama': 'Pinjaman Terendah',
    },
    {
      'id': 'pinjamanTertinggi',
      'nama': 'Pinjaman Tertinggi',
    },
  ];

  List<Map<String, dynamic>> productList = [
    {
      'id': Constants.get.idProdukCashDrive,
      'nama': 'Cash & Drive',
    },
    {
      'id': 1,
      'nama': 'Maxi 150',
    }
  ];

  List<Map<String, dynamic>> statusList = [
    {
      'id': 'Aktif',
      'nama': 'Aktif',
    },
    {
      'id': 'Terlambat',
      'nama': 'Telat Bayar',
    },
    {
      'id': 'GagalBayar',
      'nama': 'Gagal Bayar',
    },
    {
      'id': 'Penjualan',
      'nama': 'Penjualan',
    },
    {
      'id': 'Lunas',
      'nama': 'Lunas',
    },
  ];

  @override
  void initState() {
    super.initState();
    urutkan = widget.urutkan;
    produk = List.from(widget.produk);
    status = List.from(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid =
        urutkan != '' || produk.isNotEmpty || status.isNotEmpty;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              color: HexColor('#DDDDDD'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Headline3500(text: 'Filter'),
              InkWell(
                onTap: () {
                  widget.reset();
                  Navigator.pop(context);
                },
                child: Subtitle2(
                  text: 'Reset',
                  color: Constants.get.borrowerColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Headline3500(text: 'Urutkan'),
          const SizedBox(height: 12),
          SingleFilter(
            currentValue: urutkan,
            type: FilterType.kapsul,
            idKey: 'id',
            displayKey: 'nama',
            dataList: filterList,
            onSelect: (value) {
              setState(() {
                urutkan = value;
              });
            },
            primaryColor: Constants.get.borrowerColor,
          ),
          const SizedBox(height: 24),
          const Headline3500(text: 'Produk'),
          const SizedBox(height: 12),
          MultipleFilter(
            type: FilterType.kapsul,
            dataSelected: produk,
            idKey: 'id',
            displayKey: 'nama',
            dataList: productList,
            titleColor: Constants.get.borrowerColor,
            contentColor: const Color(0xffE9F6EB),
            onSelect: (value) {
              setState(() {
                produk = value;
              });
            },
          ),
          const SizedBox(height: 24),
          const Headline3500(text: 'Status'),
          const SizedBox(height: 12),
          MultipleFilter(
            type: FilterType.kapsul,
            dataSelected: status,
            idKey: 'id',
            displayKey: 'nama',
            dataList: statusList,
            titleColor: Constants.get.borrowerColor,
            contentColor: const Color(0xffE9F6EB),
            onSelect: (value) {
              setState(() {
                status = value;
              });
            },
          ),
          const SizedBox(height: 40),
          ButtonWidget(
            title: 'Terapkan',
            color: isValid ? null : Colors.grey,
            borderColor: isValid ? null : Colors.grey,
            onPressed: () {
              if (isValid) {
                Navigator.pop(context);
                widget.onSubmit(urutkan, produk, status);
              }
            },
          ),
        ],
      ),
    );
  }
}
