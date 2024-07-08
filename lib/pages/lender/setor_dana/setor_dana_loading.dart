import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:hexcolor/hexcolor.dart';

class SetorDanaLoading extends StatelessWidget {
  const SetorDanaLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(bottom: 16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: HexColor('#EEEEEE'),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ShimmerLong4(height: 42, width: 42),
                  const SizedBox(width: 16),
                  ShimmerLong(
                    height: 12,
                    width: MediaQuery.of(context).size.width / 3.5,
                  )
                ],
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }
}
