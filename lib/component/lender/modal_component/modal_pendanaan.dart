import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/rdl/regis_rdl_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

Widget notVerifPopUp(BuildContext context) {
  return ModalPopUp(
    icon: 'assets/images/home/datadirilender.svg',
    title: 'Data Diri Anda Belum Lengkap',
    message: 'Anda harus melengkapi data diri sebelum melakukan pendanaan',
    actions: [
      Button2(
        btntext: 'Lengkapi Data Diri',
        action: () {
          Navigator.popAndPushNamed(context, VerifikasiPage.routeName);
        },
      )
    ],
  );
}
Widget regisRdlPopUp(BuildContext context) {
  return ModalPopUp(
    icon: 'assets/images/home/datadirilender.svg',
    title: 'Data Diri Anda Belum Lengkap',
    message: 'Anda harus melengkapi data diri sebelum melakukan pendanaan',
    actions: [
      Button2(
        btntext: 'Lengkapi Data Diri',
        action: () {
          Navigator.popAndPushNamed(context, RegisRdlPage.routeName);
        },
      )
    ],
  );
}

Widget waitingVerifPopUp(BuildContext context) {
  return const ModalPopUp(
    icon: 'assets/lender/pendanaan/waiting.svg',
    title: 'Akun Anda Belum Aktif',
    message:
        'Data Anda sedang dalam tahap verifikasi. Transaksi bisa dilakukan setelah akun Anda berhasil diverifikasi',
  );
}

Widget rejectVerifPopUp(BuildContext context) {
  return const ModalPopUp(
    icon: 'assets/images/icons/warning_red.svg',
    title: 'Akun Anda Belum Aktif',
    message:
        'Data Anda sedang dalam tahap verifikasi. Transaksi bisa dilakukan setelah akun Anda berhasil diverifikasi',
  );
}
