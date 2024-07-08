import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_page.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_review.dart';

class TokoEmasIndex extends StatefulWidget {
  static const routeName = '/toko_emas';
  final int? idSupplier;
  const TokoEmasIndex({super.key, this.idSupplier});

  @override
  State<TokoEmasIndex> createState() => _TokoEmasIndexState();
}

class _TokoEmasIndexState extends State<TokoEmasIndex> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as TokoEmasIndex?;
    if (args != null && args.idSupplier != null) {
      context.bloc<SupplierEmasBloc>().getData(args.idSupplier!);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    context.bloc<SupplierEmasBloc>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SupplierEmasBloc>(context);
    final List<Widget> listWidget = [
      TokoEmas(bloc: bloc),
      TokoEmasReview(bloc: bloc),
    ];
    return StreamBuilder(
      stream: bloc.stepStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        return WillPopScope(
          child: listWidget[data - 1],
          onWillPop: () async {
            if (data == 1) {
              Navigator.pop(context);
            } else {
              bloc.stepChange(data - 1);
            }
            return false;
          },
        );
      },
    );
  }
}
