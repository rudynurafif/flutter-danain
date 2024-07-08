import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/simulasi/cicilan/simulasi_cicilan_bloc.dart';
import 'package:flutter_danain/pages/borrower/simulasi/cicilan/step/first_page.dart';
import 'package:flutter_danain/pages/borrower/simulasi/cicilan/step/list_emas_page.dart';

import 'step/cicilan_loading.dart';

class SimulasiCicilanEmas extends StatefulWidget {
  static const routeName = '/simulasi_cicilan_2';
  final bool? statusLogin;
  final int? statusAktivasi;
  final String? hp;
  final String? email;
  final bool? pekerjaan;
  const SimulasiCicilanEmas({
    super.key,
    this.statusLogin,
    this.statusAktivasi,
    this.email,
    this.hp,
    this.pekerjaan,
  });

  @override
  State<SimulasiCicilanEmas> createState() => _SimulasiCicilanEmasState();
}

class _SimulasiCicilanEmasState extends State<SimulasiCicilanEmas> {
  final bloc = SimulasiCicilanBloc();
  bool isLogin = false;
  int aktivasi = 0;
  String statusHp = 'waiting';
  String statusEmail = 'waiting';
  bool pekerjaanStatus = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as SimulasiCicilanEmas?;
    if (args != null && args.statusLogin != null) {
      setState(() {
        isLogin = args.statusLogin!;
      });
    }
    if (args != null && args.statusAktivasi != null) {
      setState(() {
        aktivasi = args.statusAktivasi!;
      });
    }
    if (args != null && args.hp != null) {
      setState(() {
        statusHp = args.hp!;
      });
    }
    if (args != null && args.email != null) {
      setState(() {
        statusEmail = args.email!;
      });
    }
    if (args != null && args.pekerjaan != null) {
      setState(() {
        pekerjaanStatus = args.pekerjaan!;
      });
    }
  }

  final cicilanBloc = SimulasiCicilanBloc();
  @override
  void initState() {
    cicilanBloc.iniGetMaster();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: cicilanBloc.isReadyStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? false;
        if (data == false) {
          return const SimulasiCicilanLoading();
        } else {
          return _bodyBuilder();
        }
      },
    );
  }

  Widget _bodyBuilder() {
    return StreamBuilder(
      stream: cicilanBloc.stepControl,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        switch (data) {
          case 1:
            return FirstPageSimulasiCicilan(
              simulasiBloc: cicilanBloc,
              isHaveLogin: isLogin,
              aktivasi: aktivasi,
              email: statusEmail,
              hp: statusHp,
              pekerjaan: pekerjaanStatus,
            );
          case 2:
            return ListPilihanEmas(simulasiBloc: cicilanBloc);
          default:
            return FirstPageSimulasiCicilan(
              simulasiBloc: cicilanBloc,
              isHaveLogin: isLogin,
              aktivasi: aktivasi,
              email: statusEmail,
              hp: statusHp,
              pekerjaan: pekerjaanStatus,
            );
        }
      },
    );
  }
}
