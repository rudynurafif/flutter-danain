import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/ubah_password/ubah_password_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/ubah_password/ubah_password_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';

class ChangePasswordPage extends StatefulWidget {
  static const routeName = '/change_password_page';
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final bloc = ChangePasswordBloc();

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _confirmSee = true;
  bool _newPassSee = true;
  bool _passwordSee = true;

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
    didChangeDependencies$
        .exhaustMap((_) => bloc.messageStream)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Ubah Kata Sandi'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getUserStatus(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  passwordTextField(context, data!),
                  const SizedBox(height: 16),
                  newPasswordWidget(context, data!),
                  validationPassword(context, data),
                  const SizedBox(height: 16),
                  confirmPasswordWidget(context, data),
                  const SizedBox(height: 32),
                  buttonPost(context, data),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Stream<void> handleMessage(message) async* {
    final int user = await getUserStatus() ?? 1;
    if (message is ChangePasswordStateSuccess) {
      BuildContext? dialogContext;
      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return ModalPopUpNoClose(
            icon: user == 2
                ? 'assets/images/profile/check_shield.svg'
                : 'assets/lender/profile/shield.svg',
            title: 'Kata Sandi Berhasil Diubah',
            message: 'Kata sandi digunakan untuk menjamin keamanan di Danain',
          );
        },
      ));
      Future.delayed(const Duration(seconds: 1), () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          Navigator.pop(context);
        }
      });
    }

    if (message is ChangePasswordStateErrorValidation) {
      bloc.passwordController.sink.addError(message.message);
    }

    if (message is ChangePasswordStateError) {
      context.showSnackBarError(message.message);
    }

    if (message is InvalidInformationMessage) {
      context.showSnackBarError('Invalid information');
    }
  }

  Widget buttonPost(BuildContext context, int data) {
    return StreamBuilder<bool>(
      stream: bloc.buttonKataSandi,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        return ButtonNormal(
          btntext: 'Ubah Kata Sandi',
          color: isValid
              ? data == 2
                  ? null
                  : HexColor(lenderColor)
              : HexColor('#ADB3BC'),
          action: isValid
              ? () {
                  bloc.postChangePassword();
                }
              : null,
        );
      },
    );
  }

  Widget passwordTextField(BuildContext context, int data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Kata Sandi Saat Ini'),
        const SizedBox(height: 4),
        StreamBuilder<String>(
          stream: bloc.passwordStream,
          builder: (context, snapshot) {
            return Stack(
              alignment: Alignment.bottomRight,
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
                    errorText: snapshot.hasError ? '' : null,
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 247, 4, 4),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: data == 2
                            ? Color(0xff288C50)
                            : HexColor(lenderColor),
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
                    bloc.passwordController.sink.add(value);
                  },
                ),
                if (snapshot.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight),
                    child: Subtitle2(
                      text: snapshot.error.toString(),
                      color: Colors.red,
                    ),
                  )
              ],
            );
          },
        )
      ],
    );
  }

  Widget newPasswordWidget(BuildContext context, int data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Kata Sandi Baru'),
        const SizedBox(height: 4),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          obscureText: _newPassSee,
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: data == 2 ? Color(0xff288C50) : HexColor(lenderColor),
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
                    _newPassSee = !_newPassSee;
                  },
                );
              },
              icon: _newPassSee ? visOff : vis,
            ),
          ),
          controller: newPasswordController,
          onChanged: (value) {
            bloc.passwordChange(value);
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

  Widget confirmPasswordWidget(BuildContext context, int data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(
            color: HexColor('#AAAAAA'), text: 'Konfirmasi Kata Sandi Baru'),
        const SizedBox(height: 4),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          obscureText: _confirmSee,
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: data == 2 ? Color(0xff288C50) : HexColor(lenderColor),
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
          onChanged: (value) {
            bloc.confirmPasswordController.sink.add(value);
          },
        ),
      ],
    );
  }

  Widget validationPassword(BuildContext context, int data) {
    return StreamBuilder<String>(
      stream: bloc.newPasswordStream,
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
}
