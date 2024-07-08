import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widgets/widget_element.dart';

class ModalBottomSheetWidget extends StatelessWidget {
  final TextEditingController controller;
  final List<String> dataVal;
  final String label;

  ModalBottomSheetWidget(this.controller, this.dataVal, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
      ),
      padding: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Headline3(
                    text: label,
                    align: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: HexColor('#AAAAAA'),
                  size: 16,
                ),
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: dataVal.length,
            itemBuilder: (context, index) {
              final option = dataVal[index];
              return Container(
                color: option == controller.text
                    ? HexColor('#F1FCF4')
                    : Colors.white,
                child: ListTile(
                  title: option == controller.text
                      ? Subtitle500(
                          text: option,
                          align: TextAlign.center,
                        )
                      : SubtitleExtra(
                          text: option,
                          align: TextAlign.center,
                        ),
                  onTap: () {
                    controller.text = option;
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
