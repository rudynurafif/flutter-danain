// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_danain/component/auxpage/search_location_2.dart';
import 'package:flutter_danain/component/introduction/contentmenu_component.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/lokasi_penyimpanan_emas_page.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/supplier_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../data/constants.dart';

class MitraPage extends StatefulWidget {
  static const routeName = '/mitra_page';
  const MitraPage({super.key});

  @override
  State<MitraPage> createState() => _MitraPageState();
}

class _MitraPageState extends State<MitraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Mitra'),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline2500(text: 'Mitra'),
            const SizedBox(height: 8),
            Subtitle2(
              text:
                  'Temukan lokasi mitra Danain untuk membantu kebutuhan transaksi Anda',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: HexColor('#EEEEEE'))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: contentSupplier(),
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: HexColor('#EEEEEE'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: contentPenyimpan(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contentSupplier() {
    return ContentMenu(
      image: 'assets/images/preference/jangkauan_supplier_emas.svg',
      title: 'Supplier Emas',
      subtitle: 'Mitra supplier atau toko penyedia emas logam mulia',
      icon: true,
      navigate: () {
        Navigator.pushNamed(context, SupplierEmasPage.routeName);
      },
    );
  }

  Widget contentPenyimpan() {
    final TextEditingController provinsiController = TextEditingController();
    return ContentMenu(
      image: 'assets/images/preference/lokasi_penyimpan_emas.svg',
      title: 'Penyimpan Emas',
      subtitle: 'Mitra pergadaian tempat menyimpan emas.',
      icon: true,
      navigate: () async {
        final PermissionStatus status = await Permission.location.status;
        if (status == PermissionStatus.granted) {
          context.showSnackBarSuccess('Mohon Tunggu...');
          checkLocationInfo(provinsiController, null, () {
            Navigator.pushNamed(
              context,
              PenyimpananEmas.routeName,
              arguments: PenyimpananEmas(
                provinceName: provinsiController.text,
              ),
            );
          });
        } else {
          await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (ctx) => ModaLBottom(
              image: 'assets/images/register/aktifkan_lokasi.svg',
              title: locationActive,
              subtitle: locationActiveSub,
              action: SearchLocation2(
                textButton: agreeText,
                provinsi: provinsiController,
                nextAction: () {
                  print('provinsi ku: ${provinsiController.text}');
                  Navigator.popAndPushNamed(
                    context,
                    PenyimpananEmas.routeName,
                    arguments: PenyimpananEmas(
                      provinceName: provinsiController.text,
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
