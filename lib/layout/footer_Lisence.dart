import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget footerLisence(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(left:20, right: 20 , bottom: 12),
    color: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Berizin dan Diawasi',
          style: TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  color: Colors.white, // White background color
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/logo/logo_ojk.svg")
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  color: Colors.white, // White background color
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/logo/afpi.svg")
                    ],
                  ),
                ),
              ),
            ),
          ],
        )


      ],
    ),
  );
}
