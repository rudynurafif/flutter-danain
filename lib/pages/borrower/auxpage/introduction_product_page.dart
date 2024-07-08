import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_danain/component/introduction/introduction_component.dart';

class IntroductionProduct extends StatelessWidget {
  static const routeName = '/introduction_gadai_emas';
  final String? content;
  const IntroductionProduct({super.key, this.content});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as IntroductionProduct?;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousWidget(context),
      body: args != null
          ? (args.content == '0'
              ? gadaiEmasContent(context) 
              : cicilEmasContent(context))
          : Center(
              child: Headline1(
                text: 'Opps Sepertinya ada yang salah',
              ),
            ),
    );
  }
}


