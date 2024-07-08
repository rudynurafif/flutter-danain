import 'package:flutter/material.dart';
import 'package:flutter_danain/component/auxpage/search_location_2.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class Step3Regis extends StatefulWidget {
  final RegisterBloc regisBloc;
  const Step3Regis({super.key, required this.regisBloc});

  @override
  State<Step3Regis> createState() => _Step3RegisState();
}

class _Step3RegisState extends State<Step3Regis> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController provinsiController = TextEditingController();
  TextEditingController kotaController = TextEditingController();

  bool _passwordSee = true;
  bool _confirmSee = true;
  Icon vis = Icon(
    Icons.visibility,
    size: 16,
    color: HexColor('#AAAAAA'),
  );
  Icon visOff = Icon(
    Icons.visibility_off,
    size: 16,
    color: HexColor('#AAAAAA'),
  );
  bool _isShow = false;

  @override
  void initState() {
    super.initState();
    if (widget.regisBloc.passwordController.hasValue) {
      passwordController.text = widget.regisBloc.passwordController.value;
    }
    if (widget.regisBloc.confirmPasswordController.hasValue) {
      confirmPasswordController.text =
          widget.regisBloc.confirmPasswordController.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline1(text: cpTitle),
            const SizedBox(height: 8),
            const Subtitle2(
              text: cpSubtitle,
              color: Color(0xff777777),
              align: TextAlign.start,
            ),
            const SizedBox(height: 24),
            passwordTextField(widget.regisBloc),
            validationPassword(widget.regisBloc),
            const SizedBox(height: 16),
            confirmPasswordForm(widget.regisBloc),
            const SizedBox(height: 32),
            buttonConfirm(widget.regisBloc)
          ],
        ),
      ),
    );
  }

  Widget passwordTextField(RegisterBloc rgBloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Kata Sandi'),
        const SizedBox(height: 4),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.black),
                obscureText: _passwordSee,
                decoration: InputDecoration(
                  hintText: 'Masukan kata sandi',
                  hintStyle: TextStyle(
                    color: HexColor('#BEBEBE'),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffDDDDDD),
                      width: 1.0,
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 247, 4, 4),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff288C50),
                      width: 1.0,
                    ),
                  ),
                  fillColor: Colors.grey,
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          _passwordSee = !_passwordSee;
                        },
                      );
                    },
                    icon: _passwordSee ? visOff : vis,
                  ),
                ),
                controller: passwordController,
                onChanged: (value) {
                  rgBloc.passwordChange(value);
                  setState(() {
                    if (value.length > 0) {
                      _isShow = true;
                    } else {
                      _isShow = false;
                    }
                  });
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget validationPassword(RegisterBloc rgBloc) {
    return StreamBuilder<String>(
      stream: rgBloc.passwordStream,
      builder: (context, snapshot) {
        bool passwordLowerCase = false;
        bool passwordUpperCase = false;
        bool passwordNumber = false;
        bool passwordLength = false;
        if (snapshot.hasError) {
          List<String> errors = snapshot.error as List<String>;
          if (errors.contains('1')) {
            passwordLowerCase = true;
          } else {
            passwordLowerCase = false;
          }
          if (errors.contains('2')) {
            passwordUpperCase = true;
          } else {
            passwordUpperCase = false;
          }
          if (errors.contains('3')) {
            passwordNumber = true;
          } else {
            passwordNumber = false;
          }
          if (errors.contains('4')) {
            passwordLength = true;
          } else {
            passwordLength = false;
          }
        } else {
          _isShow = false;
        }
        return PasswordValidate(
          isShow: _isShow,
          passwordLowerCase: passwordLowerCase,
          passwordUpperCase: passwordUpperCase,
          passwordNumber: passwordNumber,
          passwordLength: passwordLength,
        );
      },
    );
  }

  Widget confirmPasswordForm(RegisterBloc rgBloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Konfirmasi Kata Sandi'),
        const SizedBox(height: 4),
        TextFormField(
            style: const TextStyle(color: Colors.black),
            obscureText: _confirmSee,
            decoration: InputDecoration(
              hintText: 'Konfirmasi kata sandi',
              hintStyle: TextStyle(
                color: HexColor('#BEBEBE'),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffDDDDDD),
                  width: 1.0,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 247, 4, 4),
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff288C50),
                  width: 1.0,
                ),
              ),
              fillColor: Colors.grey,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(
                    () {
                      _confirmSee = !_confirmSee;
                    },
                  );
                },
                icon: _confirmSee ? visOff : vis,
              ),
            ),
            controller: confirmPasswordController,
            onChanged: (value) => rgBloc.confirmChange(value)),
      ],
    );
  }

  Widget buttonConfirm(RegisterBloc rgBloc) {
    return StreamBuilder<bool>(
      stream: rgBloc.passwordButtonStream,
      builder: (context, snapshot) {
        bool isValid = snapshot.data ?? false;
        return Button1(
          btntext: 'Lanjut',
          color: isValid ? null : Colors.grey,
          action: isValid
              ? () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (ctx) => ModaLBottom(
                      image: 'assets/images/register/aktifkan_lokasi.svg',
                      title: locationActive,
                      subtitle: locationActiveSub,
                      action: SearchLocation2(
                        textButton: agreeText,
                        provinsi: provinsiController,
                        kota: kotaController,
                        nextAction: () {
                          Navigator.pop(context);
                          rgBloc.postPassword(context, provinsiController.text,
                              kotaController.text);
                        },
                      ),
                    ),
                  );
                }
              : null,
        );
      },
    );
  }
}
