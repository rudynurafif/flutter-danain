import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class Step4RegisLender extends StatefulWidget {
  final RegisterLenderBloc regisBloc;
  const Step4RegisLender({super.key, required this.regisBloc});

  @override
  State<Step4RegisLender> createState() => _Step4RegisLenderState();
}

class _Step4RegisLenderState extends State<Step4RegisLender> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.regisBloc;
    return WillPopScope(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 72),
              SvgPicture.asset('assets/lender/register/make_pin.svg'),
              const SizedBox(height: 43),
              const Headline2(
                text: 'Jaga Keamanan Akun Anda',
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Subtitle2(
                text:
                    'Buat PIN Anda untuk akses aman dan nyaman di akun Danain',
                color: HexColor('#777777'),
                align: TextAlign.center,
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonNormal(
                btntext: 'Buat PIN Sekarang',
                color: HexColor(lenderColor),
                action: () {
                  bloc.stepControl(5);
                },
              ),
              const SizedBox(height: 24)
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
