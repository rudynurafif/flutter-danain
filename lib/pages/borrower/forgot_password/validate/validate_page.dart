import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/forgot_password_state.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/validate/validate_bloc.dart';
import 'package:flutter_danain/pages/login/login.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../../../data/constants.dart';

class MakeNewPasswordPage extends StatefulWidget {
  static const routeName = '/make_new_password';
  final String? kodeVerifkasi;
  const MakeNewPasswordPage({super.key, this.kodeVerifkasi});

  @override
  State<MakeNewPasswordPage> createState() => _MakeNewPasswordPageState();
}

class _MakeNewPasswordPageState extends State<MakeNewPasswordPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
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
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)?.settings.arguments as MakeNewPasswordPage?;
    if (args != null && args.kodeVerifkasi != null) {
      context.bloc<MakeNewPasswordBloc>().kodeControl(args.kodeVerifkasi!);
    }
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<MakeNewPasswordBloc>().message)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MakeNewPasswordBloc>(context);
    return Scaffold(
      appBar: previousTitleCustom(context, 'Buat Kata Sandi Baru', () {
        Navigator.pushNamed(context, LoginPage.routeName);
      }),
      body: FutureBuilder<int?>(
        future: rxPrefs.getInt('user_status'),
        builder: (context, snapshot) {
          final int? data = snapshot.data;

          return Container(
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
                  passwordTextField(bloc, data!),
                  validationPassword(bloc, data),
                  const SizedBox(height: 16),
                  confirmPasswordForm(bloc, data),
                  const SizedBox(height: 32),
                  buttonConfirm(bloc, data)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buttonConfirm(MakeNewPasswordBloc bloc, int data) {
    return StreamBuilder<bool>(
      stream: bloc.isValidButton,
      builder: (context, snapshot) {
        final bool isValid = snapshot.data ?? false;
        if (data == 2) {
          return ButtonNormal(
            btntext: 'Lanjut',
            color: isValid ? null : Colors.grey,
            action: isValid ? () => bloc.submit() : null,
          );
        } else {
          return ButtonNormalLender(
            btntext: 'Lanjut',
            color: isValid ? null : Colors.grey,
            action: isValid ? () => bloc.submit() : null,
          );
        }
      },
    );
  }

  Stream<void> handleMessage(message) async* {
    final int user = await getUserStatus() ?? 1;
    if (message is ForgotPasswordSuccessMessage) {
      BuildContext? dialogContext;
      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return ModalPopUpNoClose(
            icon: user == 2
                ? 'assets/images/profile/check_shield.svg'
                : 'assets/lender/profile/shield.svg',
            title: 'Kata Sandi Berhasil Dibuat',
            message: 'Silahkan masuk kembali dengan kata sandi baru Anda',
            actions: [
              Button2(
                btntext: 'Masuk',
                color: HexColor(primaryColorHex),
                action: () {
                  if (dialogContext != null) {
                    Navigator.of(dialogContext!).pop();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginPage.routeName,
                      (route) => false,
                    );
                  }
                },
              )
            ],
          );
        },
      ));
    }

    if (message is ForgotPasswordErrorMessage) {
      context.showSnackBarError(message.message);
    }
  }

  Widget passwordTextField(MakeNewPasswordBloc rgBloc, int data) {
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
                style:
                    const TextStyle(fontFamily: 'Poppins', color: Colors.black),
                obscureText: _passwordSee,
                decoration: InputDecoration(
                  hintText: 'Masukan kata sandi',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
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
                      color: data == 2
                          ? const Color(0xff288C50)
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
                  rgBloc.passwordControl(value);
                  setState(() {
                    if (value.isNotEmpty) {
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

  Widget validationPassword(MakeNewPasswordBloc rgBloc, int data) {
    return StreamBuilder<List<int>?>(
      stream: rgBloc.passwordError,
      builder: (context, snapshot) {
        bool passwordLowerCase = false;
        bool passwordUpperCase = false;
        bool passwordNumber = false;
        bool passwordLength = false;
        final errors = snapshot.data ?? [];
        if (errors.isNotEmpty) {
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

  Widget confirmPasswordForm(MakeNewPasswordBloc rgBloc, int data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Konfirmasi Kata Sandi'),
        const SizedBox(height: 4),
        TextFormField(
          style: const TextStyle(fontFamily: 'Poppins', color: Colors.black),
          obscureText: _confirmSee,
          decoration: InputDecoration(
            hintText: 'Konfirmasi kata sandi',
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
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
                color:
                    data == 2 ? const Color(0xff288C50) : HexColor(lenderColor),
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
          onChanged: (value) => rgBloc.confirmControl(value),
        ),
      ],
    );
  }
}
