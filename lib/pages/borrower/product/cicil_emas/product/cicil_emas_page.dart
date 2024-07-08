import 'dart:async';
import 'dart:convert';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/page_gagal.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_state.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/step/step_detail_angsuran.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/step/step_detail_co.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/step/step_list_emas.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/step/step_otp_privy.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/step/step_payment.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/loading/loading_circular.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localstorage/localstorage.dart';

import '../../../../help_temp/help_temp.dart';

class CicilEmas2Page extends StatefulWidget {
  static const routeName = '/cicil_emas_page_2';
  const CicilEmas2Page({super.key});

  @override
  State<CicilEmas2Page> createState() => _CicilEmas2PageState();
}

class _CicilEmas2PageState extends State<CicilEmas2Page>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CicilEmas2Bloc>().messageFdc)
        .exhaustMap((message) => handleMessageFdc(message))
        .listen((_) {});
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CicilEmas2Bloc>().jenisEmasSelected$)
        .exhaustMap((products) => handleProduct(products))
        .listen((_) {});
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CicilEmas2Bloc>().messageReqOtp)
        .exhaustMap((value) => handleMessageReq(value))
        .listen((_) {});
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<CicilEmas2Bloc>().messageValidateOtp)
        .exhaustMap((value) => handleMessageVal(value))
        .listen((_) {});
    context.bloc<CicilEmas2Bloc>().initGetAllData();
  }

  @override
  void dispose() {
    super.dispose();
    context.bloc<CicilEmas2Bloc>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CicilEmas2Bloc>(context);
    return StreamBuilder<int>(
      stream: bloc.isValidStream$,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        switch (data) {
          case 1:
            return const LoadingDanain();
          case 2:
            return bodyBuilder(bloc);
          case 3:
            return gagalWidget();
          case 4:
            return Scaffold(
              appBar: previousWidget(context),
              body: const Center(
                child: Subtitle2(text: 'Maaf sepertinya terjadi kesalahan'),
              ),
            );
          default:
            return const LoadingDanain();
        }
      },
    );
  }

  Widget gagalWidget() {
    return Scaffold(
      appBar: previousWidget(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/icons/location_failed.svg'),
            const SizedBox(height: 8),
            const Headline2(
              align: TextAlign.center,
              text: 'Cicil Emas Akan Segera Tersedia!',
            ),
            const SizedBox(height: 8),
            Subtitle2(
              align: TextAlign.center,
              text:
                  'Saat ini layanan cicil emas belum tersedia di lokasi Anda. Namun, kami sedang mempersiapkan ini ke lebih banyak lokasi. Tunggu kabar baik dari tim kami segera!!',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 40),
            Button1(
              btntext: 'OK',
              action: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Subtitle2(
              text: 'Perlu informasi lebih lanjut?',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Subtitle2(
                  text: 'Kunjungi ',
                  color: HexColor('#777777'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, HelpTemporary.routeName);
                  },
                  child: Subtitle2Large(
                    text: 'Bantuan',
                    color: HexColor(primaryColorHex),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget bodyBuilder(CicilEmas2Bloc bloc) {
    final List<Widget> listWidget = [
      StepListEmas(cBloc: bloc),
      StepDetailCo(cicilBloc: bloc),
      const LoadingDanain(),
      StepDetailAngsuran(cBloc: bloc),
      OtpPrivyCicilan(cBloc: bloc),
      StepBayarCicilan(cicilBloc: bloc),
    ];
    return Stack(
      children: [
        StreamBuilder<int>(
          stream: bloc.stepStream$,
          builder: (context, snapshot) {
            final step = snapshot.data ?? 1;
            return WillPopScope(
              child: step == 10
                  ? DocumentPerjanjian(cBloc: bloc)
                  : listWidget[step - 1],
              onWillPop: () async {
                if (step == 1) {
                  Navigator.pop(context);
                } else if (step == 4) {
                  bloc.stepChange(2);
                } else if (step == 6) {
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.routeName, (Route<dynamic> route) => false);
                } else if (step == 10) {
                  bloc.stepChange(2);
                } else {
                  bloc.stepChange(step - 1);
                }
                return false;
              },
            );
          },
        ),
        StreamBuilder<bool>(
          stream: bloc.isLoadingCalculate,
          builder: (context, snapshot) {
            final isLoading = snapshot.data ?? false;
            if (isLoading == true) {
              print('true bang');
              return const LoadingCircular();
            }
            print('false bang bang');

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Stream<void> handleMessageFdc(message) async* {
    final bloc = BlocProvider.of<CicilEmas2Bloc>(context);
    if (message is CicilEmasSuccess) {
      bloc.stepChange(4);
    }
    if (message is CicilEmasError) {
      unawaited(
        Navigator.pushNamed(
          context,
          PengajuanCicilanGagal.routeName,
          arguments: 'cicilan',
        ),
      );
    }
  }

  Stream<void> handleMessageReq(message) async* {
    final bloc = BlocProvider.of<CicilEmas2Bloc>(context);
    final LocalStorage storage = LocalStorage('todo_app.json');
    if (message is CicilEmasSuccess) {
      final kode = storage.getItem('kode_checkout').toString();
      print('kode cok: $kode');
      bloc.kodeCheckoutChange(kode);
      bloc.stepChange(5);
    }
    if (message is CicilEmasError) {
      context.showSnackBarError(message.message);
    }
  }

  Stream<void> handleMessageVal(message) async* {
    final bloc = BlocProvider.of<CicilEmas2Bloc>(context);
    bloc.isLoadingChange(false);
    final LocalStorage storage = LocalStorage('todo_app.json');
    if (message is CicilEmasSuccess) {
      final data = storage.getItem('response_cicil');
      final dataBody = jsonDecode(data);
      print(dataBody);
      bloc.resultChange(dataBody);
      bloc.stepChange(6);
    }
    if (message is CicilEmasError) {
      if (message.message.startsWith('Unautho')) {
        bloc.otpErrorChange('Kode OTP yang dimasukkan tidak sesuai');
      } else {
        context.showSnackBarError(message.message);
      }
    }
  }

  Stream<void> handleProduct(List<Map<String, dynamic>> products) async* {
    final bloc = BlocProvider.of<CicilEmas2Bloc>(context);
    if (products.isEmpty) {
      bloc.stepChange(1);
    }
  }

  Stream<void> handleCalculate(CicilEmasMessage? message) async* {
    if (message is CicilEmasError) {
      print(message);
      context.showSnackBarError(message.message);
    }
  }
}
