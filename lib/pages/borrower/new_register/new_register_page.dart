import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_bloc.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_state.dart';
import 'package:flutter_danain/pages/borrower/new_register/step/step_1_data_diri.dart';
import 'package:flutter_danain/pages/borrower/new_register/step/step_2_password.dart';
import 'package:flutter_danain/pages/borrower/new_register/step/step_3_lokasi.dart';
import 'package:flutter_danain/pages/borrower/verifikasi_email/verif_email_page.dart';
import 'package:flutter_danain/utils/constants.dart';
import 'package:flutter_danain/utils/loading.dart';
import 'package:flutter_danain/utils/string_ext.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewRegisterBorrowerPage extends StatefulWidget {
  static const routeName = '/new_register_borrower';
  const NewRegisterBorrowerPage({super.key});

  @override
  State<NewRegisterBorrowerPage> createState() =>
      _NewRegisterBorrowerPageState();
}

class _NewRegisterBorrowerPageState extends State<NewRegisterBorrowerPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    context.bloc<NewRegisterBloc>().getWilayah();
    context.bloc<NewRegisterBloc>().errorMessage.listen((value) {
      if (value != null) {
        value.toToastError(context);
      }
    });
    context.bloc<NewRegisterBloc>().isLoading.listen((value) {
      try {
        if (value == true) {
          context.showLoading();
        } else {
          context.dismiss();
        }
      } catch (e) {
        context.dismiss();
      }
    });
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<NewRegisterBloc>().message)
        .exhaustMap(
          (value) {
            return handleMessage(
              value,
              context.bloc<NewRegisterBloc>(),
            );
          },
        )
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<NewRegisterBloc>().lokasiMessage)
        .exhaustMap(
          (value) {
            return handleLokasimessage(
              value,
              context.bloc<NewRegisterBloc>(),
            );
          },
        )
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<NewRegisterBloc>();
    final List<Widget> listWidget = [
      Step1DataDiri(regisBloc: bloc),
      StepRegistrasiPassword(regisBloc: bloc),
      StepRegistrasiLokasi(regisBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.step.stream,
      builder: (context, snapshot) {
        final step = snapshot.data ?? 1;
        return WillPopScope(
          child: listWidget[step - 1],
          onWillPop: () async {
            if (step < 2) {
              Navigator.pop(context);
            } else {
              bloc.step.add(step - 1);
            }
            return false;
          },
        );
      },
    );
  }

  Stream<void> handleMessage(message, NewRegisterBloc bloc) async* {
    if (message is RegisterBorrowerErrorMessage) {
      await showDialog(
        context: context,
        builder: (context) {
          return Builder(builder: (dialogContext) {
            return ModalPopUp(
              icon: 'assets/images/icons/warning_red.svg',
              title: 'Sepertinya terjadi kesalahan',
              message: message.message,
              actions: [
                ButtonWidget(
                  title: 'Kembali',
                  paddingY: 9,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                )
              ],
            );
          });
        },
      );
    }
    if (message is RegisterBorrowerSuccessMessage) {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        VerifikasiEmailPage.routeName,
        arguments: VerifikasiEmailPage(
          email: bloc.email.valueOrNull ?? '',
        ),
        (route) => false,
      );
    }
  }

  Stream<void> handleLokasimessage(
    CekLokasiMessage? message,
    NewRegisterBloc bloc,
  ) async* {
    if (message is CekLokasiSuccessMessage) {
      bloc.submit();
    }

    if (message is CekLokasiErrorMessage) {
      await showDialog(
        context: context,
        builder: (context) {
          return Builder(builder: (dialogContext) {
            return ModalPopUp(
              icon: 'assets/images/icons/warning_red.svg',
              title: 'Sepertinya terjadi kesalahan',
              message: message.message,
              actions: [
                ButtonWidget(
                  title: 'Kembali',
                  paddingY: 9,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                )
              ],
            );
          });
        },
      );
    }
    if (message is CekLokasiTidakDitemukanMessage) {
      await showDialog(
        context: context,
        builder: (context) {
          return Builder(builder: (dialogContext) {
            return ModalPopUpNoClose(
              icon: 'assets/images/icons/warning_red.svg',
              title: 'Lokasi Belum Terjangkau',
              message:
                  'Layanan belum tersedia di lokasi Anda. Silakan cek lokasi yang terjangkau layanan Danain',
              actions: [
                ButtonWidget(
                  title: 'Cek Lokasi Tersedia',
                  paddingY: 9,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    bloc.step.add(3);
                  },
                ),
                const SpacerV(value: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        PreferencePage.routeName,
                        (route) => false,
                      );
                    },
                    child: TextWidget(
                      text: 'Batal Daftar',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Constants.get.borrowerColor,
                    ),
                  ),
                )
              ],
            );
          });
        },
      );
    }
    if (message is CekLokasiDitolak) {
      await showModalBottomSheet(
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
  }
}
