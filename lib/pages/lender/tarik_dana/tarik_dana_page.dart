import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';
import 'step_tarik_dana/step_tarik_dana_component.dart';
import 'tarik_dana.dart';

class TarikDanaPage extends StatefulWidget {
  static const routeName = '/tarik_dana_lender_page';
  const TarikDanaPage({super.key});

  @override
  State<TarikDanaPage> createState() => _TarikDanaPageState();
}

class _TarikDanaPageState extends State<TarikDanaPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  @override
  void initState() {
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<TarikDanaBloc>().message)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TarikDanaBloc>(context);
    final List<Widget> listWidget = [
      Step1TarikDana(tdBloc: bloc),
      Step2TarikDana(tdBloc: bloc),
      const LoadingDanain(),
      Step4TarikDana(tdBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return WillPopScope(
          child: listWidget[data - 1],
          onWillPop: () async {
            if (data == 1) {
              Navigator.pop(context);
            } else if (data == 4) {
              await Navigator.pushNamedAndRemoveUntil(
                context,
                HomePageLender.routeNeme,
                (route) => false,
              );
            } else {
              bloc.stepControl(data - 1);
            }
            return false;
          },
        );
      },
    );
  }

  Stream<void> handleMessage(message) async* {
    final bloc = BlocProvider.of<TarikDanaBloc>(context);
    bloc.isLoadingChange(false);
    if (message is TarikDanaSuccessMessage) {
      bloc.stepControl(4);
    }

    if (message is TarikDanaErrorMessage) {
      await showDialog(
        context: context,
        builder: (context) => ModalPopUpNoClose(
          icon: 'assets/lender/home/payung2.svg',
          title: 'Transaksi Tidak Dapat Diproses',
          message:
              'Mohon maaf atas kendala yang terjadi, silakan coba beberapa saat lagi',
          actions: [
            Button2(
              btntext: 'Kembali',
              color: HexColor(lenderColor),
              action: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePageLender.routeNeme,
                  (Route<dynamic> route) => false,
                );
              },
            )
          ],
        ),
      );
    }
    if (message is TarikDanaSalahPinMessage) {
      await showDialog(
        context: context,
        builder: (context) => ModalPopUpNoClose(
          icon: 'assets/lender/home/payung2.svg',
          title: 'Transaksi Tidak Dapat Diproses',
          message:
              'Terdapat percobaan tarik dana sebanyak 3 kali . Harap tunggu 10 menit sebelum coba kembali',
          actions: [
            Button2(
              btntext: 'Kembali',
              color: HexColor(lenderColor),
              action: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePageLender.routeNeme,
                  (Route<dynamic> route) => false,
                );
              },
            )
          ],
        ),
      );
    }
  }
}
