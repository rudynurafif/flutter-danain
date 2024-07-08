import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/home/page/beranda/beranda_loading.dart';
import 'package:flutter_danain/pages/lender/home/page/beranda/beranda_success.dart';

class BerandaLenderScreen extends StatefulWidget {
  final HomeLenderBloc homeBloc;
  const BerandaLenderScreen({
    super.key,
    required this.homeBloc,
  });

  @override
  State<BerandaLenderScreen> createState() => _BerandaLenderScreenState();
}

class _BerandaLenderScreenState extends State<BerandaLenderScreen> {
  @override
  void initState() {
    super.initState();
    widget.homeBloc.getDataHome();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: widget.homeBloc.dataHome,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? {};
          return BerandaLenderSuccess(
            homeBloc: widget.homeBloc,
            dataHome: data,
          );
        }

        return const BerandaLenderLoading();
      },
    );
  }
}
