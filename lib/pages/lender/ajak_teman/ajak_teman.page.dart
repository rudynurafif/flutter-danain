import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/ajak_teman_bloc.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/step/ajak_teman_onboarding.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/step/step_list_teman.dart';

class AjakTemanPage extends StatefulWidget {
  static const routeName = '/ajak_teman_page';
  const AjakTemanPage({super.key});

  @override
  State<AjakTemanPage> createState() => _AjakTemanPageState();
}

class _AjakTemanPageState extends State<AjakTemanPage> {
  @override
  void initState() {
    super.initState();
    context.bloc<AjakTemanBloc>().getAjakTemanData();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AjakTemanBloc>(context);
    final List<Widget> listWidget = [
      AjakTemanOnboarding(aBloc: bloc),
      ListAjakTeman(aBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return listWidget[data - 1];
      },
    );
  }
}
