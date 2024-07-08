import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../data/constants.dart';
import '../../../../domain/models/pendanaan.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/text/text_widget.dart';
import 'detail_pendanaan.dart/modal_title.dart';

class ModalValidasiPendanaan extends StatelessWidget {
  final Pendanaan? pendanaan;
  final String status;
  final String description;
  final String textButton;
  final String? textButton2;
  final VoidCallback? action1;
  final VoidCallback? action2;
  final String icon;

  const ModalValidasiPendanaan({
    super.key,
    this.pendanaan,
    required this.status,
    required this.description,
    required this.textButton,
    this.textButton2,
    required this.icon,
    this.action1,
    this.action2,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          const ModalTitle(title: ''),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(icon, height: 64, width: 64),
                const SizedBox(height: 24),
                TextWidget(
                    text: status,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: HexColor('#333333')),
                const SizedBox(height: 16),
                TextWidget(
                  text: description,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: HexColor('#777777'),
                  align: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Button1Lender(
                  btntext: textButton,
                  color: HexColor(lenderColor),
                  action: action1,
                ),
                textButton2 == null ? const SizedBox(height: 40) : const SizedBox(height: 16),
                if (textButton2 != null)
                  Column(
                    children: [
                      Button1Custom(
                        btntext: textButton2!,
                        color: Colors.white,
                        textcolor: HexColor(lenderColor),
                        borderColor: HexColor(lenderColor),
                        action: action2,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
