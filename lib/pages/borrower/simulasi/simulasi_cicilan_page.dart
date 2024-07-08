import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_danain/data/constants.dart';

import 'package:flutter_danain/pages/borrower/simulasi/tambah_emas_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_danain/component/simulasi/cicilan_emas_component.dart';

import '../../../layout/appBar_previousTitle.dart';

class SimulasiCicilan extends StatefulWidget {
  static const routeName = 'simulasi_cicilan';
  final List<Map<String, dynamic>>? dataEmas;
  const SimulasiCicilan({super.key, this.dataEmas});

  @override
  State<SimulasiCicilan> createState() => _SimulasiCicilanState();
}

class _SimulasiCicilanState extends State<SimulasiCicilan> {
  Color six = const Color(0xffE9F6EB);
  Color? twelve;
  Color? twentyFour;
  num jangkaWaktu = 6;
  int _currentIndex = 0;
  List<Map<String, dynamic>> dataEmas = [];
  num totalHarga = 0;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as SimulasiCicilan?;
    setState(() {
      if (args != null && args.dataEmas != null) {
        dataEmas = args.dataEmas!;
        totalHarga = dataEmas.fold(0, (sum, item) => sum + item['total_harga']);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousTitle(context, 'Simulasi Cicilan Emas'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            args == null
                ? dataEmasEmpty(context)
                : (args.dataEmas != null
                    ? DataEmasNotEmpty(
                        data: dataEmas,
                        updateTotalHarga: (total) {
                          setState(() {
                            totalHarga = total;
                          });
                        },
                      )
                    : dataEmasEmpty(context)),
            dividerFull(context),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Headline3(
                    text: jangkaWaktuCicilan,
                    align: TextAlign.start,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 0;
                            jangkaWaktu = 6;
                          });
                        },
                        child: jangkaWaktuMenu(
                            context, '6 Bulan', 0, _currentIndex),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 1;
                            jangkaWaktu = 12;
                          });
                        },
                        child: jangkaWaktuMenu(
                            context, '12 Bulan', 1, _currentIndex),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 2;
                            jangkaWaktu = 24;
                          });
                        },
                        child: jangkaWaktuMenu(
                            context, '24 Bulan', 2, _currentIndex),
                      ),
                    ],
                  )
                ],
              ),
            ),
            dividerFull(context),
            args == null
                ? simulasiCicilanEmpty(context)
                : (args.dataEmas != null
                    ? simulasiCicilanNotEmpty(
                        context, totalHarga, 20000, jangkaWaktu)
                    : simulasiCicilanEmpty(context)),
            dividerFull(context),
            annoutcement(context)
          ],
        ),
      ),
    );
  }
}

//data mas
Widget dataEmasEmpty(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3(text: jenisEmas, align: TextAlign.start),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, TambahEmas.routeName);
          },
          child: const Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Color(0xff24663F),
              ),
              SizedBox(width: 10),
              Headline3(
                text: tambahEmas,
                color: Color(0xff24663F),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
//end data mas

//jangka waktu menu
Widget jangkaWaktuMenu(
    BuildContext context, String text, int index, int _currentIndex) {
  return Container(
      width: 98.67,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: _currentIndex == index ? const Color(0xffE9F6EB) : Colors.white,
          border: Border.all(
            width: 1,
            color:
                _currentIndex == index ? const Color(0xff8EB69B) : const Color(0xffDDDDDD),
          )),
      child: Center(
        child: Subtitle2(
          text: text,
          color: _currentIndex == index ? const Color(0xff24663F) : const Color(0xff777777),
        ),
      ));
}
//end jangka waktu menu

//simulasi cicilan
Widget simulasiCicilanEmpty(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3(text: simulasiCicilanTitle),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color(0xffE9F6EB)),
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xffF9FFFA),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/simulasi/simulasi.svg',
                  width: 56, height: 56),
              const SizedBox(width: 12),
              const Flexible(
                child: Subtitle3(
                  text: simulasiCicilanDesc,
                  align: TextAlign.start,
                  color: Color(0xff777777),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget simulasiCicilanNotEmpty(
    BuildContext context, num totalCicilan, num biayaAdmin, num jangkaWaktu) {
  int cicilanPerbulan = (totalCicilan / jangkaWaktu + biayaAdmin).round();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3(text: simulasiCicilanTitle),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xffF9FFFA),
              border: Border.all(width: 1, color: const Color(0xffE9F6EB)),
              borderRadius: BorderRadius.circular(4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Subtitle1(text: cicilanPerBulanText),
                  Headline3(text: rupiahFormat(cicilanPerbulan))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: const Color(0xffDDDDDD))),
              ),
              const SizedBox(height: 12),
              const Subtitle1(text: pembayaranAwal),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Subtitle2(text: cicilanAwal, color: Color(0xff777777)),
                  Subtitle2(
                    text: rupiahFormat((totalCicilan / jangkaWaktu).round()),
                    color: const Color(0xff333333),
                  )
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Subtitle2(
                    text: biayaAdminText,
                    color: Color(0xff777777),
                  ),
                  Subtitle2(
                    text: rupiahFormat(biayaAdmin.round()),
                    color: const Color(0xff333333),
                  )
                ],
              ),
              const SizedBox(height: 8),
              DashedDivider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Subtitle2(text: totalText),
                  Headline3(
                    text: rupiahFormat(
                      (totalCicilan / jangkaWaktu + biayaAdmin).round(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Button1(
          btntext: resetText,
          color: Colors.white,
          action: () {
            print("sip der");
          },
          textcolor: const Color(0xff24663F),
        )
      ],
    ),
  );
}
//end simulasi

//announcement
Widget annoutcement(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
        color: const Color(0xffFDE8CF), borderRadius: BorderRadius.circular(8)),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, size: 16, color: Colors.orange),
        SizedBox(width: 8),
        Flexible(
          child: Subtitle3(
            text: alertSimulasiCicilan,
            color: Color(0xff777777),
            align: TextAlign.start,
          ),
        )
      ],
    ),
  );
}

class DashedDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;

  DashedDivider({
    this.height = 1.0,
    this.dashWidth = 5.0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Flex(
          children: List.generate(dashCount, (index) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
