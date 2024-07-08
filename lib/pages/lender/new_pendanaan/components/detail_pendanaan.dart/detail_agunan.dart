import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_danain/utils/format_ribuan.dart';
import 'package:flutter_danain/widgets/divider/divider.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'row_data.dart';

class DetailAgunan extends StatelessWidget {
  final String jenisKendaraan;
  final String merek;
  final String type;
  final String model;
  final String image;
  final String cc;
  final String tahunProduksi;
  final String namaKendaraan;
  final String kondisiKendaraan;
  final String keterangan;
  final String namaMitra;
  const DetailAgunan({
    super.key,
    required this.jenisKendaraan,
    required this.merek,
    required this.type,
    required this.model,
    required this.image,
    required this.cc,
    required this.tahunProduksi,
    required this.namaKendaraan,
    required this.kondisiKendaraan,
    required this.keterangan,
    required this.namaMitra,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ShimmerLong(height: 56, width: 56, radius: 8);
                  },
                ),
              ),
              const SizedBox(width: 16),
              // merk - tipe - model
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: '$merek - $type',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      text: model,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: HexColor('#777777'),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: detailDataAgunanLender(
                  'Jenis Kendaraan',
                  jenisKendaraan,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              SizedBox(
                width: 150,
                child: detailDataAgunanLender(
                  'CC Kendaraan',
                  formatRibuan(cc),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: detailDataAgunanLender(
                  'Tahun Produksi',
                  tahunProduksi,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: detailDataAgunanLender(
                  'Kondisi Kendaraan',
                  kondisiKendaraan,
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          detailDataAgunanLender(
            'Keterangan',
            keterangan,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 12),
          dividerFullNoPadding(context),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                  text: 'Mitra Penyimpanan', fontSize: 14, fontWeight: FontWeight.w500),
              const SizedBox(height: 8),
              TextWidget(
                text:
                    'Perusahaan yang bertanggung jawab menyimpan agunan dan melakukan hak sebagai kreditur.',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: HexColor('#777777'),
              )
            ],
          ),
          const SizedBox(height: 12),
          RowData(
            title: 'Nama Mitra',
            color: '#AAAAAA',
            data: namaMitra,
          ),
          const SizedBox(height: 24)
        ],
      ),
    );
  }
}

Widget detailDataAgunanLender(
  String title,
  String val, {
  FontWeight fontWeight = FontWeight.w500,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Subtitle3(
        text: title,
        color: HexColor('#AAAAAA'),
      ),
      const SizedBox(height: 4),
      Subtitle2Extra(
        text: val,
        color: HexColor('#333333'),
        fWeight: fontWeight,
      ),
    ],
  );
}
