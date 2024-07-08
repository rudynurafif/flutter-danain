import 'package:flutter/material.dart';

import '../widget_element.dart';

Widget tipsAndTrickWidget(BuildContext context, List<String> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: data.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.circle,
              color: Colors.black,
              size: 3,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Subtitle2(text: item),
            )
          ],
        ),
      );
    }).toList(),
  );

  
}
