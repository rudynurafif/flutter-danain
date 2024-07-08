import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

Widget jualBeliEmasWidget(BuildContext context, Map<String, dynamic> data) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(
      top: 16,
      left: 16,
      right: 34,
      bottom: 16,
    ),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      shadows: const [
        BoxShadow(
          color: Color(0x0C000000),
          blurRadius: 10,
          offset: Offset(0, 4),
          spreadRadius: 0,
        )
      ],
    ),
    child:  Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Subtitle3(
                text: 'harga beli emas /gr',
                color: Color(0xFF777777),
              ),
              const SizedBox(height: 4),
              Text(
                rupiahFormat(data['hargaEmas']['hargaBeli']),
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
         Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Subtitle3(
                text: 'harga jual emas /gr',
                color: Color(0xFF777777),
              ),
              const SizedBox(height: 4),
              Text(
                rupiahFormat(data['hargaEmas']['hargaJual']),
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
