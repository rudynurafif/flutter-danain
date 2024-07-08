import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/menu/help/detail/answer_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class FaqDetailPage extends StatefulWidget {
  static const routeName = '/faqDetail';
  final dynamic id_faq;
  final String? faqTitle;
  final List<dynamic>? fa_bantuan_pertanyaan;
  const FaqDetailPage({
    super.key,
    this.id_faq,
    this.faqTitle,
    this.fa_bantuan_pertanyaan,
  });

  @override
  State<FaqDetailPage> createState() => _FaqDetailPageState();
}

class _FaqDetailPageState extends State<FaqDetailPage> {
  String title = 'Umum';
  dynamic id_faqDetail = 1;
  List<dynamic> list_detail = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as FaqDetailPage?;
    if (args != null &&
        args.faqTitle != null &&
        args.fa_bantuan_pertanyaan != null) {
      setState(() {
        title = args.faqTitle!;
        id_faqDetail = args.id_faq!;
        list_detail = args.fa_bantuan_pertanyaan!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, title),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: ListView.builder(
          itemCount: list_detail.length,
          itemBuilder: (context, index) {
            final faqItem = list_detail[index];
            return faqDetailContent(
              context,
              faqItem['id_bantuan_pertanyaan'],
              faqItem['pertanyaan'],
              faqItem,
            );
          },
        ),
      ),
    );
  }

  Widget faqDetailContent(
    BuildContext context,
    dynamic id_faq_detail,
    String question,
    Map<String,dynamic> faqItem
  ) {
    return GestureDetector(
      onTap: () {
        // print(tutor.toString());
        Navigator.pushNamed(
          context,
          AnswerFaqPage.routeName,
          arguments: AnswerFaqPage(
            title: title,
            itemFaq: faqItem,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(238, 238, 238, 1), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Subtitle2(text: question),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              color: Color(0xffAAAAAA),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
