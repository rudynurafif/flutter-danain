import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class Step1RegisLender extends StatefulWidget {
  final RegisterLenderBloc regisBloc;
  const Step1RegisLender({super.key, required this.regisBloc});

  @override
  State<Step1RegisLender> createState() => _Step1RegisLenderState();
}

class _Step1RegisLenderState extends State<Step1RegisLender> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController kodeController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.regisBloc.nameValue.valueOrNull ?? '';
    emailController.text = widget.regisBloc.emailValue.valueOrNull ?? '';
    phoneController.text = widget.regisBloc.phoneValue.valueOrNull ?? '';
    kodeController.text = widget.regisBloc.kodeValue.valueOrNull ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.regisBloc;
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        Navigator.pop(context);
      }),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Headline1(text: 'Buat Akun'),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Buat akun sekarang untuk memulai pendanaan emas dan berbagai program di Danain',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 24),
              nameForm(bloc),
              const SizedBox(height: 16),
              emailForm(bloc),
              const SizedBox(height: 16),
              phoneForm(bloc),
              const SizedBox(height: 16),
              kodeForm(bloc),
              const SizedBox(height: 16),
              checkForm(bloc),
              const SizedBox(height: 24)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<bool>(
              stream: bloc.buttonStep1Stream,
              builder: (context, snapshot) {
                final isValid = snapshot.data ?? false;
                return ButtonNormalLender(
                    btntext: 'Buat Akun',
                    color:
                        isValid ? HexColor(lenderColor) : HexColor('#ADB3BC'),
                    action: isValid
                        ? () {
                            bloc.reqOtp();
                          }
                        : null);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget nameForm(RegisterLenderBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.nameError$,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Nama Lengkap',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topRight,
              children: [
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(
                      fontFamily: 'Poppins', color: Colors.black),
                  onChanged: bloc.nameControl,
                  decoration: InputDecoration(
                    hintText: formNamePlaceholder,
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: HexColor('#BEBEBE'),
                        fontSize: 14),
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    errorText: snapshot.data != null ? '' : null,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor('#DDDDDD'))),
                    focusedBorder: const OutlineInputBorder(
                      // Set the focused border color
                      borderSide: BorderSide(
                          color: Color(
                              0xFF27AE60)), // Change to the desired blue color
                    ),
                  ),
                ),
                if (snapshot.hasData)
                  Padding(
                    padding: const EdgeInsets.only(top: 66),
                    child: Subtitle2(
                      text: snapshot.data!,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget emailForm(RegisterLenderBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.emailError$,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Alamat Email',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topRight,
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                      fontFamily: 'Poppins', color: Colors.black),
                  onChanged: (val) {
                    print(val);
                    bloc.emailControl(val);
                  },
                  decoration: InputDecoration(
                    hintText: formEmailPlaceHolder,
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: HexColor('#BEBEBE'),
                        fontSize: 14),
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    errorText: snapshot.data != null ? '' : null,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor('#DDDDDD'))),
                    focusedBorder: const OutlineInputBorder(
                      // Set the focused border color
                      borderSide: BorderSide(
                          color: Color(
                              0xFF27AE60)), // Change to the desired blue color
                    ),
                  ),
                ),
                if (snapshot.hasData)
                  Padding(
                    padding: const EdgeInsets.only(top: 66),
                    child: Subtitle2(
                      text: snapshot.data!,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget phoneForm(RegisterLenderBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.phoneError$,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Nomor Handphone',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topRight,
              children: [
                TextFormField(
                  controller: phoneController,
                  style: const TextStyle(
                      fontFamily: 'Poppins', color: Colors.black),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    print(val);
                    bloc.phoneControl(val);
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: formPhonePlaceHolder,
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: HexColor('#BEBEBE'),
                        fontSize: 14),
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    errorText: snapshot.data != null ? '' : null,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor('#DDDDDD'))),
                    focusedBorder: const OutlineInputBorder(
                      // Set the focused border color
                      borderSide: BorderSide(
                          color: Color(
                              0xFF27AE60)), // Change to the desired blue color
                    ),
                  ),
                ),
                if (snapshot.hasData)
                  Padding(
                    padding: const EdgeInsets.only(top: 66),
                    child: Subtitle2(
                      text: snapshot.data!,
                      color: Colors.red,
                    ),
                  )
              ],
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
                Subtitle3(text: formPhoneDesc)
              ],
            ),
          ],
        );
      },
    );
  }

  Widget kodeForm(RegisterLenderBloc bloc) {
    return StreamBuilder<String?>(
        stream: bloc.kodeError$,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle3(
                text: 'Kode Ajakan Teman (Opsional)',
                color: HexColor('#AAAAAA'),
              ),
              const SizedBox(height: 4),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    controller: kodeController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontFamily: 'Poppins', color: Colors.black),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.isEmpty) {
                        bloc.kodeControl(null);
                      } else {
                        bloc.kodeControl(value);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Contoh: 122457',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: HexColor('#BEBEBE'),
                          fontSize: 14),
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorText: snapshot.data != null ? '' : null,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#DDDDDD'))),
                      focusedBorder: const OutlineInputBorder(
                        // Set the focused border color
                        borderSide: BorderSide(
                            color: Color(
                                0xFF27AE60)), // Change to the desired blue color
                      ),
                    ),
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 66),
                      child: Subtitle2(
                        text: snapshot.data!,
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            ],
          );
        });
  }

  Widget checkForm(RegisterLenderBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.checkStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? false;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (data == true) {
              bloc.checkControl(false);
            } else {
              bloc.stepControl(10);
            }
          },
          child: checkBoxLender(
            data,
            Row(
              children: [
                const Subtitle2(text: acceptSyarat1),
                const SizedBox(width: 2.0),
                Subtitle2(
                  text: acceptSyarat2,
                  color: HexColor('#27AE60'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
