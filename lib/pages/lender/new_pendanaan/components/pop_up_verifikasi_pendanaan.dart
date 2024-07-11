import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/components/validasi_pendanaan_lender.dart';
import 'package:flutter_danain/pages/lender/rdl/regis_rdl_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

import '../../../borrower/home/home_page.dart';
import '../../setor_dana/setor_dana_page.dart';

Widget notVerifiedPopUp(BuildContext context) {
  return ModalValidasiPendanaan(
    status: 'Data Diri Belum Lengkap',
    description: 'Mohon lengkapi data diri Anda untuk melanjutkan proses pendanaan',
    textButton: 'Lengkapi Data Diri',
    icon: 'assets/lender/pendanaan/Datadiri.svg',
    action1: () {
      Navigator.popAndPushNamed(context, VerifikasiPage.routeName);
    },
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

Widget waitingVerifiedPopUp(BuildContext context) {
  return ModalValidasiPendanaan(
    status: 'Akun Belum Aktif',
    description: 'Tunggu sebentar ya, transaksi ini bisa diakses setelah akun Anda terverifikasi',
    textButton: 'Kembali ke Beranda',
    icon: 'assets/lender/pendanaan/warning.svg',
    action1: () {
      Navigator.popAndPushNamed(context, HomePageLender.routeNeme);
    },
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

Widget balanceNotSufficient(BuildContext context) {
  return ModalValidasiPendanaan(
    status: 'Dana Tidak Cukup',
    description: 'Setor Dana sekarang yuk agar bisa melanjutkan proses pendanaan',
    textButton: 'Setor Dana',
    icon: 'assets/lender/pendanaan/setordana.svg',
    action1: () {
      Navigator.popAndPushNamed(context, SetorDanaLenderPage.routeName);
    },
  );
}
