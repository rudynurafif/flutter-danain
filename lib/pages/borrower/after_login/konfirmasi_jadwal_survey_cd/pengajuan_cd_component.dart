import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/utils/string_format.dart';
import 'package:flutter_danain/widgets/space_h.dart';
import 'package:flutter_danain/widgets/space_v.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class KontakComponent extends StatelessWidget {
  final String nasabahUtama;
  final String kontakUtama;
  const KontakComponent({
    super.key,
    required this.nasabahUtama,
    required this.kontakUtama,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C044607),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Surveyor',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: HexColor('##AAAAAA'),
          ),
          const SpacerV(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/lender/profile/icon_user.svg",
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                  const SpacerH(value: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: nasabahUtama,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      const SpacerV(value: 4),
                      TextWidget(
                        text: kontakUtama,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff7E7E7E),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  launch("tel://$kontakUtama");
                },
                child: SvgPicture.asset(
                  "assets/images/icons/icCall.svg",
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LokasiComponent extends StatelessWidget {
  final String alamatUtama;
  final String alamatDetail;
  final String tanggalSurvey;
  final String maps;
  const LokasiComponent({
    super.key,
    required this.alamatUtama,
    required this.alamatDetail,
    required this.tanggalSurvey,
    required this.maps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C044607),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: HexColor(borrowerColor),
              ),
              const SpacerH(),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: alamatUtama,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    const SpacerV(value: 6),
                    TextWidget(
                      text: alamatDetail,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff7E7E7E),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SpacerV(value: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: HexColor(borrowerColor),
              ),
              const SpacerH(),
              TextWidget(
                text: formatDateFullWithHour(tanggalSurvey),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
