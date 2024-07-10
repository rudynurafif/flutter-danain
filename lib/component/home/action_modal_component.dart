import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi.dart';
import 'package:flutter_danain/pages/borrower/after_login/complete_data/complete_data_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/fill_personal_data_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/step/create_bank_screen.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/hubungan_keluarga/hubungan_keluarga_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/proses/proses_pengajuan_page.dart';
import 'package:flutter_danain/pages/lender/profile/info_bank/info_bank_lender_page.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widgets/widget_element.dart';

void showVerifikasiAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ModalPopUp(
      icon: 'assets/images/home/verification.svg',
      title: 'Akun Dalam Proses Verifikasi',
      message: 'Proses verifikasi data Anda memerlukan waktu kurang lebih 1x24 jam',
    ),
  );
}

void showHavePengajuan(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return ModalPopUp(
        icon: 'assets/images/icons/warning_red.svg',
        title: 'Pengajuan Tidak Dapat Diproses',
        message:
            ' Saat ini terdapat pinjaman yang sedang dalam proses, harap tunggu hingga proses tersebut selesai sebelum mengajukan pinjaman baru.',
        actions: [
          ButtonWidget(
            title: 'Cek Pengajuan',
            paddingY: 7,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            onPressed: () {
              Navigator.popAndPushNamed(context, ProsesPengajuanPage.routeName);
            },
          )
        ],
      );
    },
  );
}

void showKontakDaruratAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return ModalPopUp(
        icon: 'assets/images/home/datadiri-verif.svg',
        title: 'Lengkapi Kontak Darurat',
        message: 'Lengkapi data kontak darurat di profil  untuk melanjutkan pengajuan',
        actions: [
          ButtonWidget(
            title: 'Lengkapi Kontak Darurat',
            paddingY: 7,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            onPressed: () {
              Navigator.pushNamed(
                context,
                HubunganKeluargaPage.routeName,
              );
            },
          )
        ],
      );
    },
  );
}

void showAktivasiAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ModalPopUp(
      icon: 'assets/images/home/datadiri-verif.svg',
      title: 'Lengkapi Data Pendukung',
      message:
          'Lengkapi data pendukung untuk aktivasi akun Danain dan mulai menikmati layanan Danain',
      actions: [
        Button2(
          btntext: 'Lengkapi Data Pendukung',
          action: () {
            Navigator.pushNamed(context, AktivasiPage.routeName);
          },
        )
      ],
    ),
  );
}

void showHasnotBankAlert(BuildContext context, String username) {
  showDialog(
    context: context,
    builder: (context) => ModalPopUp(
      icon: 'assets/lender/home/bank.svg',
      title: 'Lengkapi Informasi Bank',
      message: 'Akun bank Anda diperlukan untuk melakukan transaksi penarikan dana',
      actions: [
        Button2(
          btntext: 'Lengkapi Informasi Bank',
          action: () {
            Navigator.popAndPushNamed(
              context,
              InfoBankLenderPage.routeName,
              arguments: InfoBankLenderPage(
                username: username,
                action: 'create',
              ),
            );
          },
          color: HexColor(lenderColor),
        )
      ],
    ),
  );
}

void showHasnotBanBorrowerAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ModalPopUp(
      icon: 'assets/lender/home/bank.svg',
      title: 'Lengkapi Informasi Bank',
      message: 'Akun bank Anda diperlukan untuk melakukan pengajuan pinjaman',
      actions: [
        Button2(
          btntext: 'Lengkapi Informasi Bank',
          action: () {
            // Navigator.popAndPushNamed(
            //   context,
            //   InfoBankPage.routeName,
            //   arguments: InfoBankPage(),
            // );
            Navigator.popAndPushNamed(
              context,
              CreateInfoBankPage.routeName,
              arguments: const CreateInfoBankPage(),
            );
          },
          color: HexColor(borrowerColor),
        )
      ],
    ),
  );
}

void showHaventVerifAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ModalPopUp(
      icon: 'assets/images/home/datadiri-verif.svg',
      title: 'Data Diri Anda Belum Lengkap',
      message: 'Lengkapi data diri Anda untuk proses verifikasi data di Danain',
      actions: [
        Button2(
          btntext: 'Lengkapi Data Pendukung',
          action: () {
            Navigator.pushNamed(context, FillPersonalDataPage.routeName);
          },
        )
      ],
    ),
  );
}

void showRejectPrivyAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const ModalPopUp(
      icon: 'assets/images/icons/warning_red.svg',
      title: 'Akun Anda Belum Terverifikasi',
      message: 'Tunggu sebentar ya, transaksi ini bisa diakses setelah akun Anda terverifikasi',
      actions: [],
    ),
  );
}
