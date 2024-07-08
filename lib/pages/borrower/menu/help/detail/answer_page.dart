import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class AnswerFaqPage extends StatefulWidget {
  static const routeName = '/answer_faq';
  final String? title;
  final Map<String, dynamic>? itemFaq;
  const AnswerFaqPage({
    super.key,
    this.title,
    this.itemFaq,
  });

  @override
  State<AnswerFaqPage> createState() => _AnswerFaqPageState();
}

class _AnswerFaqPageState extends State<AnswerFaqPage> {
  String titlee = 'Lorem';
  Map<String, dynamic> faqDetail = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as AnswerFaqPage?;
    if (args != null && args.itemFaq != null && args.title != null) {
      setState(() {
        titlee = args.title!;
        faqDetail = args.itemFaq!;
      });
    }
  }

  RegExp httpsPattern = RegExp(r'https://');
  RegExp httpPattern = RegExp(r'http://');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, titlee),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline3500(text: faqDetail['pertanyaan']),
              const SizedBox(height: 24),
              contentBody(faqDetail),
              contentIsChat(faqDetail['isChat'])
            ],
          ),
        ),
      ),
    );
  }

  Widget contentBody(Map<String, dynamic> data) {
    final List<dynamic> faqStep = data['faq_bantuan_step'];
    if (faqStep.length < 1) {
      return Subtitle2(
        text: data['jawaban'] ?? '',
        color: HexColor('#5F5F5F'),
      );
    } else {
      return listTutorWidget(faqStep);
    }
  }

  Widget listTutorWidget(List<dynamic> tutor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tutor.map((val) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: HexColor('#F1FCF4'),
                    ),
                    child: Headline3500(text: val['noUrut'].toString()),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Subtitle2(text: val['keteranganStep']),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: val['image'] != ''
                  ? Image.network(val['image'])
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget contentIsChat(int isChat) {
    switch (isChat) {
      case 1:
        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Subtitle2Extra(
                  text: 'Butuh bantuan lebih lanjut?',
                  color: HexColor('#555555'),
                ),
                ButtonSmall3(
                  btntext: 'Chat Kami',
                  action: () async {
                    const url = urlChat;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      // ignore: use_build_context_synchronously
                      context.showSnackBarError(
                          'Maaf sepertinya terjadi kesalahan');
                    }
                  },
                )
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
