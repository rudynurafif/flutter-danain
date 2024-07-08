import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:hexcolor/hexcolor.dart';

class LoadingDanain extends StatelessWidget {
  const LoadingDanain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  data == 2
                      ? 'assets/images/icons/loading_danain.png'
                      : 'assets/lender/loading/danain.png',
                ),
                const SizedBox(height: 16),
                Subtitle2(
                  text: 'Mohon Menunggu....',
                  color: HexColor(
                    data == 2 ? primaryColorHex : lenderColor,
                  ),
                )
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class LoadingModal extends StatelessWidget {
  const LoadingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const AbsorbPointer(
          child: Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        ),
        FutureBuilder(
          future: getUserStatus(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? 1;
            return Container(
              height: 130,
              child: Column(
                children: [
                  Image.asset(
                    data == 2
                        ? 'assets/images/icons/loading_danain.png'
                        : 'assets/lender/loading/danain.png',
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
