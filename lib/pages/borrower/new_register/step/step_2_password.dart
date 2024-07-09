import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_bloc.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepRegistrasiPassword extends StatefulWidget {
  final NewRegisterBloc regisBloc;
  const StepRegistrasiPassword({super.key, required this.regisBloc});

  @override
  State<StepRegistrasiPassword> createState() => _StepRegistrasiPasswordState();
}

class _StepRegistrasiPasswordState extends State<StepRegistrasiPassword> {
  final passwordController = TextEditingController();
  final confirmPwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = widget.regisBloc;
    if (bloc.pw.hasValue) {
      passwordController.text = bloc.pw.valueOrNull ?? '';
    }
    if (bloc.konfirmasiPw.hasValue) {
      confirmPwController.text = bloc.konfirmasiPw.valueOrNull ?? '';
    }
  }

  bool _isShow = false;
  bool visiblePw = true;
  bool visibleConfirm = true;
  Icon vis = const Icon(
    Icons.visibility,
    size: 16,
    color: Color(0xffAAAAAA),
  );
  Icon visOff = const Icon(
    Icons.visibility_off,
    size: 16,
    color: Color(0xffAAAAAA),
  );
  @override
  Widget build(BuildContext context) {
    final bloc = widget.regisBloc;
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          leadingAction: () {
            bloc.step.add(1);
          },
          context: context,
          isLeading: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    HelpTemporary.routeName,
                  );
                },
                child: TextWidget(
                  text: 'Bantuan',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Constants.get.borrowerColor,
                ),
              ),
            ),
          ],
        ),
      ),
      
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SpacerV(value: 24),
            const TextWidget(
              text: 'Buat Kata Sandi',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SpacerV(),
            const TextWidget(
              text:
                  'Buat kata sandi Anda untuk menjamin keamanan saat melakukan transaksi di Danain',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff777777),
            ),
            const SpacerV(value: 24),
            passwordWidget(bloc),
            validationPassword(bloc),
            const SpacerV(value: 16),
            confirmWidget(bloc),
            const SpacerV(value: 44),
            buttonWidget(bloc),
            const SpacerV(value: 24),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(NewRegisterBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.buttonStep2,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        return ButtonWidget(
          title: 'Buat Akun',
          color: isValid ? null : const Color(0xffADB3BC),
          onPressed: () {
            if (isValid) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Builder(builder: (dialogContext) {
                    return ModaLBottomTemplate(
                      padding: 24,
                      alignment: CrossAxisAlignment.center,
                      isUseMark: false,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/register/aktifkan_lokasi.svg',
                          ),
                          const SpacerV(value: 24),
                          const TextWidget(
                            text: 'Aktifkan Lokasi',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          const SpacerV(),
                          const TextWidget(
                            text:
                                'Danain membutuhkan lokasi Anda untuk mendapatkan lokasi wilayah yang akurat',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff777777),
                            align: TextAlign.center,
                          ),
                          const SpacerV(value: 24),
                          ButtonWidget(
                            title: 'Setuju',
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              bloc.getCurrentLocation();
                            },
                          )
                        ],
                      ),
                    );
                  });
                },
              );
            }
          },
        );
      },
    );
  }

  Widget passwordWidget(NewRegisterBloc bloc) {
    return TextF(
      controller: passwordController,
      obscureText: visiblePw,
      suffixIcon: IconButton(
        onPressed: () {
          setState(
            () {
              visiblePw = !visiblePw;
            },
          );
        },
        icon: visiblePw ? visOff : vis,
      ),
      onChanged: (value) {
        bloc.pw.add(value);
        setState(() {
          if (value.length > 0) {
            _isShow = true;
          } else {
            _isShow = false;
          }
        });
        final List<String> errors = [];
        if (!Validator.isValidLowerCase(value)) {
          errors.add('1');
        }
        if (!Validator.isValidUpperCase(value)) {
          errors.add('2');
        }
        if (!Validator.isValidPasswordNumber(value)) {
          errors.add('3');
        }
        if (!Validator.isValidLengthPassWord(value)) {
          errors.add('4');
        }
        bloc.pw.addError(errors);
      },
      hint: 'Kata Sandi',
      hintText: 'Masukkan kata sandi',
    );
  }

  Widget confirmWidget(NewRegisterBloc bloc) {
    return TextF(
      controller: confirmPwController,
      obscureText: visibleConfirm,
      suffixIcon: IconButton(
        onPressed: () {
          setState(
            () {
              visibleConfirm = !visibleConfirm;
            },
          );
        },
        icon: visibleConfirm ? visOff : vis,
      ),
      onChanged: (value) {
        bloc.konfirmasiPw.add(value);
      },
      hint: 'Konfirmasi Kata Sandi',
      hintText: 'Konfirmasi kata sandi',
    );
  }

  Widget validationPassword(NewRegisterBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.pw.stream,
      builder: (context, snapshot) {
        bool passwordLowerCase = false;
        bool passwordUpperCase = false;
        bool passwordNumber = false;
        bool passwordLength = false;
        if (snapshot.hasError) {
          List<String> errors = snapshot.error as List<String>;
          if (errors.isNotEmpty) {
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
