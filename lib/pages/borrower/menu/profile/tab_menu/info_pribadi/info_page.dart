import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/user_and_token.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/hubungan_keluarga/hubungan_keluarga_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pekerjaan/info_pekerjaan_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pribadi/info_pribadi_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/info_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class InfoBorrowerPage extends StatefulWidget {
  static const routeName = '/info_borrower_page';
  const InfoBorrowerPage({super.key});

  @override
  State<InfoBorrowerPage> createState() => _InfoBorrowerPageState();
}

class _InfoBorrowerPageState extends State<InfoBorrowerPage> {
  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<InfoBorrowerBloc>(context);
    bloc.getUserToken();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<InfoBorrowerBloc>(context);
    return Scaffold(
      appBar: previousTitle(context, 'Info Pribadi'),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (beranda['status']['aktivasi_status'] == 10)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          InformasiPribadiPage.routeName,
                        );
                      },
                      child: tabContentBorrower(
                        context,
                        'assets/images/icons/profile/data_ktp.svg',
                        'Data Pribadi',
                        true,
                      ),
                    ),
                  if (beranda['status']['pekerjaan'] == true)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          InformasiPekerjaanPage.routeName,
                        );
                      },
                      child: tabContentBorrower(
                        context,
                        'assets/images/icons/profile/data_aktivasi.svg',
                        'Data Pekerjaan',
                        true,
                      ),
                    ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        HubunganKeluargaPage.routeName,
                      );
                    },
                    child: tabContentBorrower(
                      context,
                      'assets/images/icons/profile/data_ktp.svg',
                      'Kontak Darurat',
                      true,
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
