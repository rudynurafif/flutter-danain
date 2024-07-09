import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/borrower/verifikasi_email/change_email_page.dart';
import 'package:flutter_danain/pages/borrower/verifikasi_email/verif_email_bloc.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/utils/constants.dart';
import 'package:flutter_danain/utils/string_ext.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class VerifikasiEmailPage extends StatefulWidget {
  static const routeName = '/verifikasi_email';
  final String email;
  const VerifikasiEmailPage({
    super.key,
    this.email = '',
  });

  @override
  State<VerifikasiEmailPage> createState() => _VerifikasiEmailPageState();
}

class _VerifikasiEmailPageState extends State<VerifikasiEmailPage> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  void initState() {
    super.initState();
    context.bloc<VerifEmailBloc>().getEmail(widget.email);
    context.bloc<VerifEmailBloc>().errorMessage.listen((value) {
      if (value != null) {
        value.toToastError(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<VerifEmailBloc>();
    return WillPopScope(
      onWillPop: () async {
        await rxPrefs.clear();
        await Navigator.pushNamedAndRemoveUntil(
          context,
          PreferencePage.routeName,
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          context: context,
          elevation: 0,
          isLeading: true,
          leadingAction: () {
            rxPrefs.clear();
            Navigator.pushNamedAndRemoveUntil(
              context,
              PreferencePage.routeName,
              (route) => false,
            );
          },
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    HelpTemporary.routeName,
                  );
                },
                child: TextWidget(
                  text: 'Bantuan',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Constants.get.borrowerColor,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/forgot_password/send_email.svg',
                ),
                const SizedBox(height: 24),
                const Headline2(text: checkEmail),
                const SizedBox(height: 8),
                StreamBuilder<String?>(
                  stream: bloc.email.stream,
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? 'email Anda';
                    return Column(
                      children: [
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
                                text: data,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    '. Segera cek email dan klik tombol "Verifikasi Email” untuk melanjutkan proses pendaftaran.',
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
                        const SizedBox(height: 54),
                        Button1(
                          btntext: 'Kirim Ulang Verifikasi',
                          action: () {
                            bloc.getEmail(data);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Headline3(
                    text: 'Ubah Alamat Email',
                    color: Color(0xff288C50),
                  ),
                  onPressed: () async {
                    final email = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeEmailScreen(),
                      ),
                    );
                    if (email != null) {
                      bloc.getEmail(email.toString());
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
