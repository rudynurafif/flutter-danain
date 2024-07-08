import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class Step1Regis extends StatefulWidget {
  final RegisterBloc regisBloc;
  const Step1Regis({super.key, required this.regisBloc});

  @override
  State<Step1Regis> createState() => _Step1RegisState();
}

class _Step1RegisState extends State<Step1Regis> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController referralController = TextEditingController();

  String? nameError;
  String? emailError;
  String? phoneError;
  String? referralError;

  @override
  void initState() {
    super.initState();
    final rgBloc = widget.regisBloc;
    if (rgBloc.nameController.hasValue) {
      nameController.text = rgBloc.nameController.value;
    }
    if (rgBloc.emailController.hasValue) {
      emailController.text = rgBloc.emailController.value;
    }
    if (rgBloc.phoneController.hasValue) {
      phoneNumberController.text = rgBloc.phoneController.value;
    }
    if (rgBloc.referralController.hasValue) {
      referralController.text = rgBloc.referralController.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline1(text: registerTitle),
              const SizedBox(height: 8),
              const Subtitle2(
                text: registerDesc,
                color: Color(0xff777777),
              ),
              const SizedBox(height: 24),
              nameForm(widget.regisBloc),
              const SizedBox(height: 16),
              emailForm(widget.regisBloc),
              const SizedBox(height: 16),
              phoneNumberForm(widget.regisBloc),
              const SizedBox(height: 16),
              referralForm(widget.regisBloc),
              const SizedBox(height: 24),
              licenses(widget.regisBloc),
              const SizedBox(height: 40),
              buttonStep1(widget.regisBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonStep1(RegisterBloc rgBloc) {
    return StreamBuilder<bool>(
      stream: rgBloc.buttonStep1Stream,
      builder: (context, snapshot) {
        final bool isValid = snapshot.data ?? false;
        return Button1(
          btntext: 'Buat Akun',
          color: isValid ? null : Colors.grey,
          action: isValid
              ? () {
                  rgBloc.nextToOtp(context);
                }
              : null,
        );
      },
    );
  }

  Widget nameForm(RegisterBloc rgBloc) {
    return StreamBuilder<String>(
      stream: rgBloc.nameStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          nameError = snapshot.error.toString();
        } else {
          nameError = null;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nama Lengkap'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                        fontFamily: 'Poppins', color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: Jhon Doe',
                      nameError != null,
                    ),
                    controller: nameController,
                    onChanged: (value) => rgBloc.changeName(value),
                  ),
                  if (nameError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: nameError!,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget emailForm(RegisterBloc rgBloc) {
    return StreamBuilder<String>(
      stream: rgBloc.emailStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          emailError = snapshot.error.toString();
        } else {
          emailError = null;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Alamat Email'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                        fontFamily: 'Poppins', color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: jhondoe@gmail.com',
                      emailError != null,
                    ),
                    controller: emailController,
                    onChanged: (value) {
                      rxPrefs.setString('email_sementara', value);
                      rgBloc.getEmailAndPhone(
                        value,
                        phoneNumberController.text,
                        referralController.text,
                      );

                      // rgBloc.changeEmail(value);
                    },
                  ),
                  if (emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: emailError!,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget phoneNumberForm(RegisterBloc rgBloc) {
    return StreamBuilder<String>(
      stream: rgBloc.phoneStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          phoneError = snapshot.error.toString();
        } else {
          phoneError = null;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nomor Handphone'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                      style: const TextStyle(
                          fontFamily: 'Poppins', color: Colors.black),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: inputDecor(
                        context,
                        'Contoh: 08xxxxxxx',
                        phoneError != null,
                      ),
                      controller: phoneNumberController,
                      onChanged: (value) {
                        rgBloc.getEmailAndPhone(emailController.text, value,
                            referralController.text);
                        // rgBloc.changePhone(value);
                      }),
                  if (phoneError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: phoneError!,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 15,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  formPhoneDesc,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777)),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget referralForm(RegisterBloc rgBloc) {
    return StreamBuilder<String?>(
      stream: rgBloc.referralStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          referralError = snapshot.error.toString();
        } else {
          referralError = null;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Referral(Opsional)'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                        fontFamily: 'Poppins', color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: X11Y232',
                      referralError != null
                          ? referralError == ''
                              ? false
                              : true
                          : false,
                    ),
                    controller: referralController,
                    onChanged: (value) {
                      rgBloc.getEmailAndPhone(emailController.text,
                          phoneNumberController.text, value);
                    },
                  ),
                  if (referralError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: referralError!,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget licenses(RegisterBloc rgBloc) {
    return StreamBuilder<bool>(
      stream: rgBloc.agreeStream,
      builder: (context, snapshot) {
        final isCheked = snapshot.data ?? false;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            final agree = rgBloc.agreeController.value;
            if (agree == false) {
              rgBloc.stepController.add(10);
            } else {
              rgBloc.changeAgree(false);
            }
          },
          child: checkBoxBorrower(
            isCheked,
            const Row(
              children: [
                Subtitle2(text: acceptSyarat1),
                SizedBox(width: 2.0),
                Subtitle2(
                  text: acceptSyarat2,
                  color: Color(0xff288C50),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
