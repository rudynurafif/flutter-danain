import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class AjakTemanSyarat extends StatelessWidget {
  const AjakTemanSyarat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Syarat dan Ketentuan'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Headline2500(text: 'SYARAT DAN KETENTUAN AJAK TEMAN'),
              const SizedBox(height: 24),
              Subtitle2(
                text:
                    'Terima kasih atas keikutsertaan Anda dalam program Ajak Teman.',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              Subtitle2(
                text:
                    'Dengan ini, Anda telah menjadi REPRESENTATIF DANAIN. Kami berusaha semaksimal mungkin melayani Anda dan para pengguna platform Danain (www.danain.co.id) (selanjutnya disebut platform)  agar terjalin hubungan kerjasama yang saling menguntungkan bagi semua pihak.',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              Subtitle2(
                text:
                    'Semua Representatif Danain wajib membaca dan menyetujui syarat dan ketentuan, sebagaimana disebutkan pada poin di bawah ini.',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              Headline3500(
                text: 'Definisi',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 14),
                child: listNumber(context, definisiAjakTemanList),
              ),
              const SizedBox(height: 8),
              Headline3500(
                text: 'Cara Kerja',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 14),
                child: listNumber(context, caraKerjaList),
              ),
              const SizedBox(height: 8),
              Headline3500(
                text: 'Larangan',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 14),
                child: listNumber(context, caraKerjaList),
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text: pembacaanSyaratKetentuan,
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }
}
