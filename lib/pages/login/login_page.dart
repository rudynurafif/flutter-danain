// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/request/request_page.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/route_main/onboarding.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_danain/pages/login/login.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/password_textfield.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../layout/footer_Lisence.dart';
import '../../widgets/button/button.dart';
import '../../widgets/text/headline.dart';
import '../../widgets/text/subtitle.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage>
    with
        SingleTickerProviderStateMixin<LoginPage>,
        DisposeBagMixin,
        DidChangeDependenciesStream {
  bool validEmail = false;
  bool validPassword = false;
  String messages = '';
  late final AnimationController loginButtonController;
  late final Animation<double> buttonSqueezeAnimation;
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  final passwordFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    buttonSqueezeAnimation = Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(
      CurvedAnimation(
        parent: loginButtonController,
        curve: const Interval(
          0.0,
          0.250,
        ),
      ),
    );
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<LoginBloc>().emailError$)
        .exhaustMap(validationEmail)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<LoginBloc>().passwordError$)
        .exhaustMap(validationPassword)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<LoginBloc>().message$)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<LoginBloc>().isLoading$)
        .listen((isLoading) {
      if (isLoading) {
        loginButtonController
          ..reset()
          ..forward();
      } else {
        loginButtonController.reverse();
      }
    }).disposedBy(bag);
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousCustomWidget(context, () {
        Navigator.pushNamed(context, OnboardingMaster.routeName);
      }),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(width: double.infinity),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/images/Danain.svg',
                            width: 127.45,
                            height: 48,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Headline5(
                          text: 'No. Telepon',
                          color: HexColor('#AAAAAA'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: emailTextField(loginBloc),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Headline5(
                          text: formLabelPassword,
                          color: HexColor('#AAAAAA'),
                          align: TextAlign.end,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: passwordTextField(loginBloc),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: forgotPasswordText(context),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: button(loginBloc),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: footerLisence(context),
    );
  }

  Stream<void> validationEmail(response) async* {
    response == null ? validEmail = true : validEmail = false;
    print(validEmail);
    await delay(1000);
  }

  Stream<void> validationPassword(response) async* {
    response == null ? validPassword = true : validPassword = false;
    print(validPassword);
    await delay(1000);
  }

  Stream<void> handleMessage(message) async* {
    final int userStatus = await rxPrefs.getInt('user_status') ?? 0;
    print('user status $userStatus');

    if (message is LoginSuccessMessage) {
      context.showSnackBarSuccess('Login successfully');
      await delay(1000);
      yield null;
      context.hideCurrentSnackBar();
      await Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.routeName, (Route<dynamic> route) => false);
      return;
    }

    if (message is LoginErrorMessage) {
      messages = message.message;
      if (messages ==
              'maaf untuk sementara akun anda di nonaktifkan selama 30 menit!' ||
          messages == 'Harap lakukan reset password!' ||
          messages ==
              'Mohon maaf akun anda untuk sementara di non-aktifkan, harap tunggu 30 menit untuk lakukan login kembali atau melakukan reset password!') {
        await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (ctx) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      color: HexColor('#DDDDDD'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SvgPicture.asset('assets/images/others/penangguhan.svg'),
                  const SizedBox(height: 24),
                  const Headline2(text: 'Akun Anda Ditangguhkan'),
                  const SizedBox(height: 8),
                  Subtitle1(
                    text:
                        'Akun Anda dikunci sementara selama 30 menit karena 3 kali gagal memasukkan kata sandi ',
                    align: TextAlign.center,
                    color: HexColor('#777777'),
                  ),
                  const SizedBox(height: 16),
                  Button1(
                    btntext: 'Reset Kata Sandi',
                    color: userStatus == 1
                        ? HexColor(lenderColor)
                        : HexColor('#24663F'),
                    action: () {
                      Navigator.pushNamed(
                        context,
                        ReqKodeForgotPassword.routeName,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        context.showSnackBarError(message.message);
      }
      return;
    }
  }

  Widget emailTextField(LoginBloc loginBloc) {
    return StreamBuilder<String?>(
      stream: loginBloc.emailError$,
      builder: (context, snapshot) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              TextField(
                controller: emailController,
                autocorrect: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                  errorText: snapshot.data != null ? '' : null,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff24663F),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HexColor('#DDDDDD'),
                    ),
                  ),
                  hintText: 'Contoh: 08xxxxxxx',
                  hintStyle: TextStyle(
                    color: HexColor('#BEBEBE'),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                keyboardType: TextInputType.phone,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                onChanged: loginBloc.emailChanged,
                textInputAction: TextInputAction.next,
                autofocus: false,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(passwordFocusNode);
                },
              ),
              if (snapshot.data != null)
                Padding(
                  padding: const EdgeInsets.only(top: 68),
                  child: Text(
                    snapshot.data!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget passwordTextField(LoginBloc loginBloc) {
    return StreamBuilder<String?>(
      stream: loginBloc.passwordError$,
      builder: (context, snapshot) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              PasswordTextField(
                errorText: snapshot.data != null ? '' : null,
                onChanged: loginBloc.passwordChanged,
                labelText: formPasswordPlaceHolder,
                textInputAction: TextInputAction.done,
                userStatus: 2,
                onSubmitted: () {
                  FocusScope.of(context).unfocus();
                },
                focusNode: passwordFocusNode,
              ),
              if (snapshot.data != null)
                Padding(
                  padding: const EdgeInsets.only(top: 68),
                  child: Text(
                    snapshot.data!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget button(LoginBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.button,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        return AnimatedBuilder(
          animation: buttonSqueezeAnimation,
          builder: (context, child) {
            final value = buttonSqueezeAnimation.value;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              child: Material(
                elevation: 5.0,
                clipBehavior: Clip.antiAlias,
                color: HexColor('#f5f5f5'),
                borderRadius: BorderRadius.circular(8.0),
                child: value > 75.0
                    ? child
                    : const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
              ),
            );
          },
          child: ButtonWidget(
            title: loginText,
            borderColor: Colors.transparent,
            color: isValid ? null : const Color(0xffADB3BC),
            onPressed: () {
              if (isValid) {
                FocusScope.of(context).unfocus();
                bloc.submitLogin();
              }
            },
          ),
        );
      },
    );
  }

  Widget forgotPasswordText(BuildContext context) {
    return FutureBuilder<int?>(
      future: rxPrefs.getInt('user_status'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final userStatus = snapshot.data;
          return Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, ReqKodeForgotPassword.routeName);
              },
              child: Headline3(
                text: forgotPasswordHint,
                color: userStatus == 2
                    ? HexColor('#288C50')
                    : HexColor(lenderColor),
              ),
            ),
          );
        } else {
          // You can return a placeholder or a CircularProgressIndicator while waiting for the future to complete.
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
