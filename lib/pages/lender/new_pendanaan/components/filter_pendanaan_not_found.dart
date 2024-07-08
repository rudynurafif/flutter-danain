import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../widgets/text/text_widget.dart';

class FilterPendanaanNotFound extends StatelessWidget {
  const FilterPendanaanNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        SvgPicture.asset('assets/lender/pendanaan/empty.svg'),
        const SizedBox(height: 24),
        const TextWidget(
          text: 'Data Tidak Ditemukan',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: TextWidget(
            text:
                'Kami tidak menemukan pendanaan yang sesuai filter ini. Coba pilih filter yang lain atau reset filter.',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            align: TextAlign.center,
            color: HexColor('#AAAAAA'),
          ),
        )
      ],
    );
  }
}
