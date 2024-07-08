import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/layout/appBar_title_center%202.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class HelpTemporary extends StatefulWidget {
  final bool? statusHome;
  static const routeName = '/help_page_temp';
  const HelpTemporary({
    super.key,
    this.statusHome,
  });

  @override
  State<HelpTemporary> createState() => _HelpTemporaryState();
}

class _HelpTemporaryState extends State<HelpTemporary> {
  @override
  Widget build(BuildContext context) {
    final statusHome = widget.statusHome ?? false;

    return Scaffold(
      appBar: statusHome
          ? titleCenter(context, 'Kontak Kami')
          : previousTitle(context, 'Kontak Kami'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Headline3500(text: 'Alamat'),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Rukan Kirana Boutique Office, Blok D2 No 8, RT.8/RW.11, Klp. Gading Tim., Kec. Klp. Gading, Kota Jkt Utara, Daerah Khusus Ibukota Jakarta 14240',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              const Headline3500(text: 'Website'),
              const SizedBox(height: 8),
              Subtitle2(
                text: 'www.danain.co.id',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              const Headline3500(text: 'Kontak'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: getUserStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data ?? 1;
                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            data == 1
                                ? HexColor(lenderColor)
                                : HexColor(primaryColorHex),
                            BlendMode.srcIn,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/icons/faq/phone.svg',
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(width: 9),
                  Subtitle2(
                    text: '021 28565355',
                    color: HexColor('#777777'),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: getUserStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data ?? 1;
                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            data == 1
                                ? HexColor(lenderColor)
                                : HexColor(primaryColorHex),
                            BlendMode.srcIn,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/icons/faq/whatsapp.svg',
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(width: 9),
                  Subtitle2(
                    text: '0811 188291',
                    color: HexColor('#777777'),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: getUserStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data ?? 1;
                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            data == 1
                                ? HexColor(lenderColor)
                                : HexColor(primaryColorHex),
                            BlendMode.srcIn,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/icons/faq/mail.svg',
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(width: 9),
                  Subtitle2(
                    text: 'customer-care@danain.co.id',
                    color: HexColor('#777777'),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Headline3500(text: 'Waktu Pelayanan'),
              const SizedBox(height: 8),
              Subtitle2(
                text: 'Hari Kerja: Senin-Jumat',
                color: HexColor('#777777'),
              ),
              Subtitle2(
                text: 'Jam Operasional: 09:00 - 17:00',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Tim dukungan kami siap membantu Anda jika terdapat pertanyaan, masalah, atau dukungan teknis. Gunakan opsi kontak yang tersedia, dan kami akan dengan senang hati membantu.',
                color: HexColor('#777777'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
