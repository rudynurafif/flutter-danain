import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/widgets/rupiah_format.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../domain/models/app_error.dart';
import '../../../../domain/models/auth_state.dart';

class TransactionPage extends StatefulWidget {
  static const routeName = '/transaction';

  // final HomeBloc homeBloc;
  // final int index;
  const TransactionPage({
    super.key,
    // required this.homeBloc,
    // required this.index,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with
        DidChangeDependenciesStream,
        DisposeBagMixin,
        SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: false,
          title: 'Transaksi',
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/transaction/background_transaksi_3.svg',
                  width: MediaQuery.of(context).size.width,
                  // height: 85,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // tagihan
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tagihan Bulan Ini',
                              style: TextStyle(
                                  color: Color(0xff777777), fontSize: 12),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextWidget(
                              text: rupiahFormat(500000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),

                      // divider
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: DividerContent(
                          color: HexColor(primaryColorHex),
                          width: 2,
                          height: 40,
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      // pinjaman
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pinjaman Aktif',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(
                            height: 8,
                          ),
                          TextWidget(
                              text: rupiahFormat(9000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DividerContent extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const DividerContent({
    super.key,
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}
