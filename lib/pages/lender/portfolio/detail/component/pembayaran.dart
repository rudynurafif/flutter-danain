import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/list_page.dart/component.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class PembayaranWidget extends StatelessWidget {
  final int noUrut;
  final String tgl;
  final String keterangan;
  final num nominal;
  final int isStatus;
  final String tglBayar;
  final num bunga;
  final num denda;
  final num pokokDana;
  final num total;
  final bool isLast;
  const PembayaranWidget({
    super.key,
    required this.keterangan,
    required this.noUrut,
    required this.tgl,
    required this.nominal,
    required this.isStatus,
    this.tglBayar = '0001-01-01T00:00:00Z',
    required this.bunga,
    this.denda = 0,
    this.pokokDana = 0,
    required this.total,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return modalContent(context);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: const Color(0xffEEEEEE),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Pembayaran ke-$noUrut',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                TextWidget(
                  text: isLast
                      ? rupiahFormat(pokokDana + nominal)
                      : rupiahFormat(nominal), // info dari BE diminta nambah sendiri di depannya
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff111827),
                ),
              ],
            ),
            const SpacerV(value: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: dateFormat(tgl),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff777777),
                ),
                statusWidget(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget modalContent(BuildContext context) {
    return ModaLBottomTemplate(
      isUseMark: false,
      padding: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextWidget(
                text: 'Detail Pembayaran',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: Color(0xffAAAAAA),
                ),
              ),
            ],
          ),
          const SpacerV(value: 24),
          KeyValGeneral(
            title: 'Periode',
            value: 'Pembayaran ke-$noUrut',
          ),
          const SpacerV(),
          KeyValGeneral(
            title: 'Jatuh Tempo',
            value: dateFormatComplete(tgl),
          ),
          const SpacerV(),
          if (isLast)
            Column(
              children: [
                KeyValGeneral(
                  title: 'Pokok Dana',
                  value: rupiahFormat(pokokDana),
                ),
                const SpacerV(),
              ],
            ),
          if (tglBayar != '0001-01-01T00:00:00Z')
            Column(
              children: [
                KeyValGeneral(
                  title: 'Tanggal Pembayaran',
                  value: dateFormatComplete2(tgl),
                ),
                const SpacerV(),
              ],
            ),
          KeyValGeneral(
            title: 'Bunga',
            value: rupiahFormat(bunga),
          ),
          const SpacerV(),
          KeyValGeneral(
            title: 'Denda Keterlambatan',
            value: rupiahFormat(denda),
          ),
          const SpacerV(),
          const DividerWidget(height: 1, isDashed: true),
          const SpacerV(),
          KeyValGeneralMedium(
            title: 'Total',
            value: isLast
                ? rupiahFormat(pokokDana + bunga + denda)
                : rupiahFormat(bunga + denda), // info dari BE disuruh nambah sendiri di depannya
          ),
          if (isStatus == 2)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacerV(value: 16),
                AlertComponent(
                  message:
                      'Tim Danain akan berupaya melakukan penagihan pembayaran melalui SMS, email dan telpon',
                  icon: Icon(
                    Icons.info_outline,
                    color: Color(0xffFF8829),
                    size: 16,
                  ),
                  messageColor: Color(0xff777777),
                  color: Color(0xffFFF5F2),
                  borderColor: Color(0xffFFF5F2),
                  radius: 8,
                )
              ],
            )
        ],
      ),
    );
  }

  Widget statusWidget(BuildContext context) {
    if (isStatus == 1) {
      return StatusBuilder(
        title: keterangan,
        bgColor: const Color(0xffF4FEF5),
        textColor: Constants.get.lenderColor,
      );
    }

    if (isStatus == 2) {
      return StatusBuilder(
        title: keterangan,
        bgColor: const Color(0xffFEF4E8),
        textColor: const Color(0xffF7951D),
      );
    }

    if (isStatus == 0) {
      return StatusBuilder(
        title: keterangan,
        bgColor: const Color(0xffEEEEEE),
        textColor: const Color(0xff777777),
      );
    }
    return const SizedBox.shrink();
  }
}
