import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class Step3RegisLender extends StatefulWidget {
  final RegisterLenderBloc regisBloc;
  const Step3RegisLender({super.key, required this.regisBloc});

  @override
  State<Step3RegisLender> createState() => _Step3RegisLenderState();
}

class _Step3RegisLenderState extends State<Step3RegisLender> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: previousTitleCustom(context,'Buat Kata Sandi', () {
          widget.regisBloc.stepControl(2);
        }),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Subtitle2(
                  text:
                      'Buat kata sandi Anda untuk menjamin keamanan saat melakukan transaksi di Danain',
                  color: Color(0xff777777),
                  align: TextAlign.start,
                ),
                const SizedBox(height: 24),
                passwordTextField(widget.regisBloc),
                const SizedBox(height: 8),
                validationPassword(widget.regisBloc),
                const SizedBox(height: 16),
                confirmPasswordForm(widget.regisBloc),
                const SizedBox(height: 32),
                buttonConfirm(widget.regisBloc)
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        widget.regisBloc.stepControl(2);

        return false;
      },
    );
  }

  Widget passwordTextField(RegisterLenderBloc rgBloc) {
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
                  focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HexColor(lenderColor),
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
                  rgBloc.passwordControl(value);
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

  Widget validationPassword(RegisterLenderBloc rgBloc) {
    return StreamBuilder<List<int>>(
      stream: rgBloc.passwordErrorStream,
      builder: (context, snapshot) {
        bool passwordLowerCase = false;
        bool passwordUpperCase = false;
        bool passwordNumber = false;
        bool passwordLength = false;
        if (snapshot.hasData) {
          final List<int> errors = snapshot.data as List<int>;
          if (errors.contains(1)) {
            passwordLowerCase = true;
          } else {
            passwordLowerCase = false;
          }
          if (errors.contains(2)) {
            passwordUpperCase = true;
          } else {
            passwordUpperCase = false;
          }
          if (errors.contains(3)) {
            passwordNumber = true;
          } else {
            passwordNumber = false;
          }
          if (errors.contains(4)) {
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

  Widget confirmPasswordForm(RegisterLenderBloc rgBloc) {
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
            focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(
                color: HexColor(lenderColor),
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
          onChanged: (value) => rgBloc.confirmPasswordControl(value),
        ),
      ],
    );
  }

  Widget buttonConfirm(RegisterLenderBloc rgBloc) {
    return StreamBuilder<bool>(
      stream: rgBloc.passwordButton,
      builder: (context, snapshot) {
        bool isValid = snapshot.data ?? false;
        return ButtonNormal(
          btntext: 'Lanjut',
          color: isValid ? HexColor(lenderColor) : Colors.grey,
          action: isValid
              ? () {
                  rgBloc.sendRegister();
                }
              : null,
        );
      },
    );
  }
}
