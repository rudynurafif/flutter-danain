import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_PreviousHelp.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/new_password_bloc.dart';
import 'package:flutter_danain/pages/login/login.dart';
import 'package:flutter_danain/widgets/form/passwordValidation.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class NewPasswordPage extends StatefulWidget {
  static const routeName = '/new_password_page';
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final npBloc = NewPasswordBloc();
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
  void dispose() {
    npBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousHelpWidget(context),
      body: Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline1(text: 'Buat kata Sandi'),
              SizedBox(height: 8),
              Subtitle2(
                text: createNPW,
                color: Color(0xff777777),
                align: TextAlign.start,
              ),
              SizedBox(height: 24),
              passwordTextField(context),
              validationPassword(context),
              SizedBox(height: 16),
              confirmPasswordForm(context),
              SizedBox(height: 32),
              buttonConfirm(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget passwordTextField(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Kata Sandi'),
        SizedBox(height: 4),
        TextFormField(
          style: TextStyle(color: Colors.black),
          obscureText: _passwordSee,
          decoration: InputDecoration(
            hintText: 'Masukan kata sandi',
            hintStyle: TextStyle(
              color: HexColor('#BEBEBE'),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffDDDDDD),
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 247, 4, 4),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff288C50),
                width: 1.0,
              ),
            ),
            fillColor: Colors.grey,
            focusedErrorBorder: OutlineInputBorder(
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
            npBloc.passwordChange(value);
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
    );
  }

  Widget validationPassword(BuildContext context) {
    return StreamBuilder<String>(
      stream: npBloc.passwordStream,
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

  Widget confirmPasswordForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Konfirmasi Kata Sandi'),
        SizedBox(height: 4),
        TextFormField(
            style: TextStyle(color: Colors.black),
            obscureText: _confirmSee,
            decoration: InputDecoration(
              hintText: 'Konfirmasi kata sandi',
              hintStyle: TextStyle(
                color: HexColor('#BEBEBE'),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffDDDDDD),
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 247, 4, 4),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff288C50),
                  width: 1.0,
                ),
              ),
              fillColor: Colors.grey,
              focusedErrorBorder: OutlineInputBorder(
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
            onChanged: (value) => npBloc.confirmChange(value)),
      ],
    );
  }

  Widget buttonConfirm(BuildContext context) {
    return StreamBuilder<bool>(
      stream: npBloc.passwordButtonStream,
      builder: (context, snapshot) {
        bool isValid = snapshot.data ?? false;
        return Button1(
          btntext: 'Lanjut',
          color: isValid ? null : Colors.grey,
          action: isValid
              ? () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      Future.delayed(Duration(seconds: 5), () {
                        Navigator.pushNamed(
                          context,
                          LoginPage.routeName,
                        );
                      });
                      return ModalPopUp(
                        icon:
                            'assets/images/forgot_password/success_change_password.svg',
                        title: createNPWSuccess,
                        message: createNPWSuccessSub,
                        actions: [],
                      );
                    },
                  );
                }
              : null,
        );
      },
    );
  }
}
