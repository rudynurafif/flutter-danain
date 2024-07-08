import 'package:flutter/material.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/step/info_bank_screen.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/step/update_bank_screen.dart';
import 'package:flutter_danain/utils/loading.dart';
import 'package:flutter_danain/utils/utils.dart';

class InfoBankPage extends StatefulWidget {
  static const routeName = '/info_bank';
  const InfoBankPage({super.key});

  @override
  State<InfoBankPage> createState() => _InfoBankPageState();
}

class _InfoBankPageState extends State<InfoBankPage> {
  final bankBloc = InfoBankBloc();

  @override
  void initState() {
    super.initState();
    context.bloc<InformasiBankBloc>().getDataBank();
    context.bloc<InformasiBankBloc>().errorMessage.listen(
      (value) {
        value!.toToastError(context);
      },
    );
    context.bloc<InformasiBankBloc>().isLoading.listen(
      (value) {
        try {
          if (value == true) {
            context.showLoading();
          } else {
            context.dismiss();
          }
          print('valuenya bang $value');
        } catch (e) {
          context.dismiss();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    context.bloc<InformasiBankBloc>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<InformasiBankBloc>();
    final List<Widget> listWidget = [
      Step1InfoBank(bankBloc: bloc),
      UpdateBankScreen(bankBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.step.stream,
      builder: (context, snapshot) {
        final step = snapshot.data ?? 1;
        return WillPopScope(
          child: listWidget[step - 1],
          onWillPop: () async {
            if (step == 1) {
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
}
