import 'package:flutter/material.dart';
import 'package:flutter_danain/component/home/action_modal_component.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi.dart';
import 'package:flutter_danain/pages/borrower/after_login/mitra/mitra_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/simulasi/simulasi_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';

class MenusWidget extends StatefulWidget {
  final Map<String, dynamic> data;

  const MenusWidget({
    super.key,
    required this.data,
  });

  @override
  State<MenusWidget> createState() => _MenusWidgetState();
}

class _MenusWidgetState extends State<MenusWidget> {
  @override
  Widget build(BuildContext context) {
    final status = widget.data['status'];
    // final int isPengajuan = status['is_pengajuan_pinjaman'];
    final int isPengajuan = status['is_pengajuan_bpkb'];
    final int isKeluarga = status['is_keluarga'];
    final int isPasangan = status['is_pasangan'];
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                SimulasiCashDrivePage.routeName,
                arguments: SimulasiCashDriveParams(
                  isPengajuan: false,
                ),
              );
            },
            child: MenuItem(
              context: context,
              image: 'assets/images/preference/simulasi_pinjaman.svg',
              text: 'Simulasi',
            ),
          ),
          GestureDetector(
            onTap: () {
              // if (status['aktivasi_status'] != 10) {
              //   if (status['aktivasi_status'] == 9) {
              //     showVerifikasiAlert(context);
              //     return;
              //   }
              //   if (status['aktivasi_status'] == 0) {
              //     showHaventVerifAlert(context);
              //     return;
              //   }
              //   if (status['aktivasi_status'] == 11) {
              //     showHaventVerifAlert(context);
              //     return;
              //   }
              //   if (status['aktivasi_status'] == 12) {
              //     showRejectPrivyAlert(context);
              //     return;
              //   }
              //   return;
              // }
              if (status['bank'] == false) {
                showHasnotBanBorrowerAlert(context);
                return;
              }
              // if (status['status_request_hp'] == 'waiting' ||
              //     status['status_request_email'] == 'waiting') {
              //   showVerifikasiAlert(context);
              //   return;
              // }

              if (isKeluarga == 0 || isPasangan == 1) {
                showKontakDaruratAlert(context);
                return;
              }
              if (isPengajuan > 0) {
                showHavePengajuan(context);
                return;
              }

              Navigator.pushNamed(
                context,
                SimulasiCashDrivePage.routeName,
                arguments: SimulasiCashDriveParams(
                  isPengajuan: true,
                ),
              );
            },
            child: MenuItem(
              context: context,
              image: 'assets/images/home/pinjaman.svg',
              text: 'Pengajuan',
            ),
          ),
          GestureDetector(
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     return ModalPopUpNoClose(
              //       icon: 'assets/images/icons/product.svg',
              //       title: 'Nantikan yang Baru di Danain',
              //       message:
              //           'Danain sedang mempersiapkan sesuatu yang baru. Nantikan dan nikmati layanan terbaik kami',
              //       sizeIcon: 80,
              //       actions: [
              //         ButtonWidget(
              //           paddingY: 7,
              //           fontSize: 12,
              //           fontWeight: FontWeight.w500,
              //           title: 'OK',
              //           onPressed: () {
              //             Navigator.pop(context);
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // );
              // Navigator.pushNamed(context, InfoProduct.routeName);
              Navigator.pushNamed(context, AktivasiPage.routeName);
            },
            child: MenuItem(
              context: context,
              image: 'assets/images/preference/product.svg',
              text: 'Produk',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                MitraPage.routeName,
              );
            },
            child: MenuItem(
              context: context,
              image: 'assets/images/home/mitra.svg',
              text: 'Mitra',
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final BuildContext context;
  final String image;
  final String text;

  const MenuItem({
    super.key,
    required this.context,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            width: 56,
            height: 56,
          ),
          const SizedBox(height: 6),
          Subtitle3(text: text)
        ],
      ),
    );
  }
}
