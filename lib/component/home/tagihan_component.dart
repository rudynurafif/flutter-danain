import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class TagihanComponent extends StatelessWidget {
  final num tagihan;
  final num totalCashback;
  const TagihanComponent({
    super.key,
    required this.tagihan,
    required this.totalCashback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding:
            const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 17),
        decoration: BoxDecoration(
          color: const Color.fromARGB(92, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'Tagihan Bulan Ini',
                    color: HexColor('#333333'),
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    text: rupiahFormat(tagihan),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Subtitle3(
                      text: 'Total Cashback',
                      color: HexColor('#333333'),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ModalDetailAngsuran(
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextWidget(
                                    text: 'Total Cashback',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SpacerV(),
                                  TextWidget(
                                    text:
                                        'Cashback yang akan didapatkan dari setiap pembayaran angsuran yang tepat waktu',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: HexColor('#777777'),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.info,
                        color: HexColor('#8EB69B'),
                        size: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                TextWidget(
                  text: rupiahFormat(totalCashback),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
