import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/cash_drive/step_detail.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/cash_drive/step_riwayat_pembayaran.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/detail_portofolio_bloc.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/dokument_screen.dart';
import 'package:flutter_danain/utils/utils.dart';

class PortofolioDetail extends StatefulWidget {
  static const routeName = '/portofolio_detail_page';
  final int idAgreement;
  const PortofolioDetail({
    super.key,
    required this.idAgreement,
  });

  @override
  State<PortofolioDetail> createState() => _PortofolioDetailState();
}

class _PortofolioDetailState extends State<PortofolioDetail> {
  @override
  void initState() {
    super.initState();
    context.bloc<DetailPortoBloc>().getDataDetail(widget.idAgreement);
    final bloc = context.bloc<DetailPortoBloc>();
    bloc.errorMessage.listen(
      (value) {
        if (value != null) {
          value.toToastError(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DetailPortoBloc>(context);
    final List<Widget> listWidget = [
      StepDetailCashDrive(dpBloc: bloc),
      StepRiwayatCashDrive(pBloc: bloc)
    ];
    return RefreshIndicator(
      onRefresh: () async {
        bloc.getDataDetail(widget.idAgreement);
      },
      child: StreamBuilder<int>(
        stream: bloc.stepStream,
        builder: (context, snapshot) {
          final data = snapshot.data ?? 1;
          return WillPopScope(
            child: data == 10
                ? DokumentPerjanjianScreen(dpBloc: bloc)
                : listWidget[data - 1],
            onWillPop: () async {
              if (data == 10) {
                bloc.stepChange(1);
              } else if (data > 1) {
                bloc.stepChange(data - 1);
              } else {
                Navigator.pop(context);
              }

              return false;
            },
          );
        },
      ),
    );
  }
}
