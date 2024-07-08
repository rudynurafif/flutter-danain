import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

Widget tipsnTrickWidget(BuildContext context, List<String> data) {
  return ListView.separated(
    itemCount: data.length,
    separatorBuilder: (context, index) => SizedBox(height: 8),
    itemBuilder: (context, index) {
      String item = data[index];
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            color: Colors.black,
            size: 3,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Subtitle2(text: item),
          )
        ],
      );
    },
  );
}
