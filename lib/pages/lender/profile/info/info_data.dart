import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/layout/appBar_PreviousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pribadi/info_pribadi_page.dart';
import 'package:flutter_danain/pages/lender/profile/info/info_data_bloc.dart';
import 'package:flutter_danain/pages/lender/profile/info_bank/info_bank_lender_page.dart';
import 'package:flutter_danain/widgets/template/tab.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class InfoDataLender extends StatefulWidget {
  static const routeName = '/info_lender';
  const InfoDataLender({super.key});

  @override
  State<InfoDataLender> createState() => _InfoDataLenderState();
}

class _InfoDataLenderState extends State<InfoDataLender> {
  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<InfoLenderBloc>(context);
    bloc.getUserToken();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<InfoLenderBloc>(context);
    return Scaffold(
      appBar: previousTitle(context, 'Informasi Pribadi'),
      body: StreamBuilder<UserAndToken?>(
        stream: bloc.userTokenStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final Map<String, dynamic> dataBeranda =
                JwtDecoder.decode(data.beranda);
            final beranda = dataBeranda['beranda'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (beranda['status']['Aktivasi'] == 1)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            InformasiPribadiPage.routeName,
                          );
                        },
                        child: tabContentLender(
                          context,
                          'assets/images/icons/profile/data_ktp.svg',
                          'Data Pribadi',
                          true,
                        ),
                      ),
                    if (beranda['status']['bank'] != 0)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            InfoBankLenderPage.routeName,
                            arguments: InfoBankLenderPage(
                              username: beranda['dataBank']?['anRekening'],
                              action: 'Ubah',
                            ),
                          );
                        },
                        child: tabContentLender(
                          context,
                          'assets/images/icons/profile/credit_card.svg',
                          'Informasi Akun Bank',
                          true,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              color: HexColor(lenderColor),
            ),
          );
        },
      ),
    );
  }
}
