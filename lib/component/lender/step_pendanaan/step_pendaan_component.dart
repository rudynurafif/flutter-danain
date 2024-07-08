import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

export 'step_pengenalan/step_pembuka.dart';
export 'step_pengenalan/step_list_pendanaan.dart';
export 'step_pengenalan/step_pengenalan_produk.dart';
export 'step_detail/step_detail.dart';
export 'step_document/step_document.dart';
export 'step_otp/step_otp_pendanaan.dart';

Widget announcementPendanaan(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: HexColor('#EEEEEE'),
          ),
          borderRadius: BorderRadius.circular(4)),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.rotate(
            angle: 3.14159265,
            child: Icon(
              Icons.error_outline,
              color: HexColor(lenderColor),
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Subtitle3(
              text:
                  'Pastikan Anda sudah mempelajari dan memahami spesifikasi dari masing-masing pinjaman. Danain akan melakukan upaya penagihan sejak H+1 dan apabila peminjam tidak bisa membayar akan dilakukan penjualan agunan.',
              color: HexColor('#777777'),
            ),
          ),
        ],
      ),
    ),
  );
}
