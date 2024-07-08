import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class EmailSuccess extends StatefulWidget {
  final RegisterBloc regisBloc;
  const EmailSuccess({super.key, required this.regisBloc});

  @override
  State<EmailSuccess> createState() => _EmailSuccessState();
}

class _EmailSuccessState extends State<EmailSuccess> {
  @override
  void initState() {
    // print(' token sementara ${widget.regisBloc.tokenController.value}');
    // final token = widget.regisBloc.tokenController.value;
    // final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // widget.regisBloc.emailController.add(decodedToken['email']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/forgot_password/send_email.svg'),
              const SizedBox(height: 24),
              const Headline2(text: checkEmail),
              const SizedBox(height: 8),
              StreamBuilder<String>(
                stream: widget.regisBloc.emailStream,
                builder: (context, snapshot) {
                  final data = snapshot.data ?? 'email Anda';
                  return Text.rich(
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
                              fontWeight: FontWeight.w400),
                        ),
                        const TextSpan(
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
                  );
                },
              ),
              const SizedBox(height: 54),
              Button1(
                btntext: resendEmail,
                action: () => widget.regisBloc.resendEmail(context, 2),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Headline3(
                  text: changeEmailText,
                  color: Color(0xff288C50),
                ),
                onPressed: () {
                  widget.regisBloc.nextStep();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
