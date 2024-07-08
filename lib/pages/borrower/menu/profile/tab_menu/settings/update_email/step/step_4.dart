import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/settings_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Step4UbahEmail extends StatefulWidget {
  final UbahEmailBloc ubahBloc;
  final bool isDeepLink;
  const Step4UbahEmail(
      {super.key, required this.ubahBloc, required this.isDeepLink});

  @override
  State<Step4UbahEmail> createState() => _Step4UbahEmailState();
}

class _Step4UbahEmailState extends State<Step4UbahEmail> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isDeepLink == true) {
      showAlertNotification();
    }
  }

  void showAlertNotification() {
    showDialog(
      context: context,
      builder: (context) => ModalPopUp(
        icon: 'assets/images/icons/check.svg',
        title: 'Pengajuan Perubahan Email Berhasil Dikirim',
        message:
            'Proses verifikasi data memerlukan waktu kurang lebih 1x24 jam',
        actions: [
          Button2(
            btntext: 'Selesai',
            action: () {
              Navigator.popAndPushNamed(context, SettingPageBorrower.routeName);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailBloc = widget.ubahBloc;
    return StreamBuilder<String>(
      stream: emailBloc.newEmailStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: previousCustomWidget(context, () {
              emailBloc.stepControl(3);
            }),
            body: bodyBuilder(snapshot.data!),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: Colors.white,
            alignment: Alignment.center,
            child: Button1(
              btntext: 'Kembali ke halaman Pengaturan Akun',
              action: () {
                Navigator.pushNamed(context, SettingPageBorrower.routeName);
              },
            ),
          );
        }
      },
    );
  }

  Widget bodyError() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: const Subtitle1(text: 'Maaf sepertinya terjadi kesalahan'),
    );
  }

  Widget bodyBuilder(String data) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 97),
          SvgPicture.asset('assets/images/forgot_password/send_email.svg'),
          const SizedBox(height: 24),
          const Headline2(text: 'Cek Email Anda'),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Link verifikasi telah dikirim ke ',
                  style: TextStyle(
                    color: Color(0xff777777),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '$data.',
                  style: const TextStyle(
                    color: Color(0XFF333333),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text:
                      ' Segera cek email dan klik tombol “Verifikasi email” untuk melanjutkan proses perubahan email.',
                  style: TextStyle(
                    color: Color(0xff777777),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Button1(
            btntext: 'Kirim Ulang',
            action: () {
              widget.ubahBloc.reqOtp('request');
            },
          )
        ],
      ),
    );
  }
}
