import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class AjakTemanLoading extends StatelessWidget {
  const AjakTemanLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          SvgPicture.asset('assets/lender/profile/ajak_teman.svg'),
          const SizedBox(height: 16),
          const Headline3500(
            text: 'Ajak Teman Pakai Danain',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Subtitle2(
              text:
                  'Bagikan kode referal dan dapatkan keuntungan 5% dari pendapatan bunga teman Anda.',
              color: HexColor('#777777'),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: HexColor('#F1FCF4'),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            child: Subtitle1(
              text: 'Selengkapnya >',
              color: HexColor(lenderColor),
            ),
          ),
          dividerFull(context),
          const SizedBox(height: 8),
          referralLoading(context),
          const SizedBox(height: 8),
          dividerFull(context),
          const SizedBox(height: 8),
          pendapantanAjakTeman(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget referralLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DottedBorder(
              color: HexColor('#DDDDDD'),
              strokeWidth: 1,
              dashPattern: const [10, 6],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Subtitle3(
                          text: 'Kode Referral Anda',
                          color: HexColor('#AAAAAA'),
                        ),
                        const SizedBox(height: 4),
                        ShimmerLong(
                          height: 27,
                          width: MediaQuery.of(context).size.width / 2.5,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(
                            180 * 3.1415926535897932 / 180,
                          ),
                          child: Icon(
                            Icons.content_copy,
                            color: HexColor(lenderColor),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Subtitle2Extra(text: 'Salin')
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Button1(
            btntext: 'Bagikan Kesosial Media',
            color: HexColor(lenderColor),
            action: () {},
          )
        ],
      ),
    );
  }

  Widget pendapantanAjakTeman(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: HexColor('#BDDCCA'),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Subtitle2Extra(
                  text: 'Pendapatan Ajak Teman',
                ),
                const SizedBox(height: 8),
                ShimmerLong(
                  height: 36,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            height: 53,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Subtitle2Extra(
                  text: 'Teman yang di ajak',
                  color: HexColor('#777777'),
                ),
                const ShimmerCircle(height: 20, width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
