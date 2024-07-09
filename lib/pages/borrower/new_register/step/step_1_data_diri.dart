import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_bloc.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

import 'syarat_ketentuan_screen.dart';

class Step1DataDiri extends StatefulWidget {
  final NewRegisterBloc regisBloc;
  const Step1DataDiri({
    super.key,
    required this.regisBloc,
  });

  @override
  State<Step1DataDiri> createState() => _Step1DataDiriState();
}

class _Step1DataDiriState extends State<Step1DataDiri> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final noHpController = TextEditingController();
  final referralController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = widget.regisBloc;
    if (bloc.nama.hasValue) {
      namaController.text = bloc.nama.valueOrNull ?? '';
    }
    if (bloc.email.hasValue) {
      emailController.text = bloc.email.valueOrNull ?? '';
    }
    if (bloc.noHp.hasValue) {
      noHpController.text = bloc.noHp.valueOrNull ?? '';
    }
    if (bloc.referral.hasValue) {
      referralController.text = bloc.referral.valueOrNull ?? '';
    }
  }

  String? errorNama;
  String? errorEmail;
  String? errorHp;
  @override
  Widget build(BuildContext context) {
    final bloc = widget.regisBloc;
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          elevation: 0,
          isLeading: true,
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
      bottomNavigation: buttonWidget(bloc),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SpacerV(value: 24),
            const TextWidget(
              text: 'Buat Akun',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SpacerV(),
            const TextWidget(
              text: 'Buat akun sekarang untuk memulai pinjaman di Danain',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff777777),
            ),
            const SpacerV(value: 24),
            namaWidget(bloc),
            const SpacerV(value: 16),
            emailWidget(bloc),
            const SpacerV(value: 16),
            noHpWidget(bloc),
            const SpacerV(value: 16),
            referral(bloc),
            const SpacerV(value: 16),
            setujuCheckBox(bloc),
            const SpacerV(value: 24),
          ],
        ),
      ),
    );
  }

  Widget namaWidget(NewRegisterBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: namaController,
          hintText: 'Contoh: John Doe',
          hint: 'Nama Lengkap',
          onChanged: (value) {
            if (value.isEmpty) {
              bloc.nama.add(null);
            } else {
              if (value.length >= 3) {
                setState(() {
                  errorNama = null;
                });
              } else {
                setState(() {
                  errorNama = 'Nama lengkap tidak valid';
                });
              }
              bloc.nama.add(value);
            }
          },
          validator: (String? value) {
            if (errorNama != null) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorNama)
      ],
    );
  }

  Widget emailWidget(NewRegisterBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.emailValid,
      builder: (context, snapshot) {
        return Stack(
          children: [
            TextF(
              controller: emailController,
              hintText: 'Contoh: jhon@gmail.com',
              hint: 'Alamat Email',
              onChanged: bloc.changeEmail,
              validator: (String? value) {
                if (snapshot.hasData) {
                  return '';
                }
                return null;
              },
            ),
            ErrorText(error: snapshot.data),
          ],
        );
      },
    );
  }

  Widget noHpWidget(NewRegisterBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<String?>(
          stream: bloc.hpValid,
          builder: (context, snapshot) {
            return Stack(
              children: [
                TextF(
                  controller: noHpController,
                  hintText: 'Contoh: 08xxxxx',
                  hint: 'Nomor Handphone',
                  onChanged: (value) {
                    bloc.changeHp(value);
                    bloc.changeRef(hp: value, ref: referralController.text);
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  validator: (String? value) {
                    if (snapshot.hasData) {
                      return '';
                    }
                    return null;
                  },
                ),
                ErrorText(error: snapshot.data),
              ],
            );
          },
        ),
        const SpacerV(value: 4),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
              color: Color(0xffF7941D),
              size: 14,
            ),
            SpacerH(value: 4),
            Flexible(
              child: TextWidget(
                text: 'Pastikan nomor HP yang Anda masukkan aktif',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color(0xff777777),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget referral(NewRegisterBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.referralValid,
      builder: (context, snapshot) {
        return Stack(
          children: [
            TextF(
              controller: referralController,
              hintText: 'Contoh: 12345',
              hint: 'Referral(Opsional)',
              onChanged: (value) {
                bloc.changeRef(
                  hp: noHpController.text,
                  ref: value,
                );
              },
              inputFormatter: [
                UpperCaseTextFormatter(),
              ],
              validator: (String? value) {
                if (snapshot.hasData) {
                  return '';
                }
                return null;
              },
            ),
            ErrorText(error: snapshot.data)
          ],
        );
      },
    );
  }

  Widget setujuCheckBox(NewRegisterBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.setuju.stream,
      builder: (context, snapshot) {
        final bool isCheck = snapshot.data ?? false;
        return CheckBoxBorrower(
          isCheck: isCheck,
          title: const Text.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(
                text: 'Saya menyetujui ',
                style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Syarat & Ketentuan Layanan',
                style: TextStyle(
                  color: Color(0xff24663F),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ]),
          ),
          onTap: () async {
            if (isCheck == true) {
              bloc.setuju.add(false);
            } else {
              final setuju = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SyaratKetentuanScreen(),
                ),
              );
              if (setuju != null) {
                bloc.setuju.add(true);
              }
            }
          },
        );
      },
    );
  }

  Widget buttonWidget(NewRegisterBloc bloc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: StreamBuilder<bool>(
            stream: bloc.buttonStep1,
            builder: (context, snapshot) {
              final isValid = snapshot.data ?? false;
              return ButtonWidget(
                title: 'Buat Akun',
                color: isValid ? null : const Color(0xffADB3BC),
                onPressed: () {
                  if (isValid) {
                    bloc.step.add(2);
                  }
                },
              );
            },
          ),
        )
      ],
    );
  }
}
