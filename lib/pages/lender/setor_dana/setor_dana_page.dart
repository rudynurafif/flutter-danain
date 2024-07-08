import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'setor_dana.dart';

class SetorDanaLenderPage extends StatefulWidget {
  static const routeName = '/setor_dana_page';
  const SetorDanaLenderPage({super.key});

  @override
  State<SetorDanaLenderPage> createState() => _SetorDanaLenderPageState();
}

class _SetorDanaLenderPageState extends State<SetorDanaLenderPage> {
  @override
  void initState() {
    context.bloc<SetorDanaBloc>().getData();
    super.initState();
    context.bloc<SetorDanaBloc>().errorMessage.listen((value) {
      if (value != null) {
        value.toToastError(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<SetorDanaBloc>();
    final List<Widget> listWidget = [
      Step1SetorDana(setorBloc: bloc),
      Step2SetorDana(setorBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.step.stream,
      builder: (context, snapshot) {
        final step = snapshot.data ?? 1;
        return WillPopScope(
          child: listWidget[step - 1],
          onWillPop: () async {
            if (step > 1) {
              bloc.step.add(step - 1);
            } else {
              Navigator.pop(context);
            }
            return false;
          },
        );
      },
    );
  }
}
