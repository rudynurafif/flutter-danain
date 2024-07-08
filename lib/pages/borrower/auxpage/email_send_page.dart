import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/auxpage/emailVerificationSuccess/email_status_verif.dart';
import 'package:flutter_svg/svg.dart';
import '../../../layout/appBar_Previous.dart';
import '../../../widgets/widget_element.dart';

class EmailSend extends StatelessWidget {
  static const routeName = '/email_send';
  const EmailSend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousWidget(context),
      body: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.only(top: 60),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/forgot_password/send_email.svg'),
              SizedBox(height: 24),
              Headline2(text: checkEmail),
              SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Link verifikasi telah dikirim ke ',
                      style: TextStyle(
                        color: Color(0xff777777),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'jhondoe@gmail.com',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text:
                          '. Segera cek email dan klik tombol "Verifikasi Email” untuk melanjutkan proses pendaftaran.',
                      style: TextStyle(
                          color: Color(0xff777777),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 54),
              Button1(
                btntext: resendEmail,
                action: () {
                  Navigator.pushNamed(
                    context,
                    EmailStatusVerif.routeName,
                  );
                },
              ),
              SizedBox(height: 20),
              TextButton(
                child: Headline3(
                  text: changeEmailText,
                  color: Color(0xff288C50),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, ChangeEmail.routeName);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
