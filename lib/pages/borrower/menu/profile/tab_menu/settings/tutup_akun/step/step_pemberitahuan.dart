import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/tutup_akun_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class StepPemberitahuan extends StatefulWidget {
  final TutupAkunBloc bloc;
  const StepPemberitahuan({super.key, required this.bloc});

  @override
  State<StepPemberitahuan> createState() => _StepPemberitahuanState();
}

class _StepPemberitahuanState extends State<StepPemberitahuan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Tutup Akun'),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Informasi Penutupan Akun Peminjam'),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Penutupan akun peminjam Anda bersifat permanen. Mohon pastikan bahwa Anda mengetahui ketentuan berikut untuk mengajukan penutupan akun:',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              listCheck(context, tutupAkunList)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Button1(
              btntext: 'Lanjut',
              action: () {
                widget.bloc.stepController.sink.add(2);
              },
            ),
          ],
        ),
      ),
    );
  }
}
