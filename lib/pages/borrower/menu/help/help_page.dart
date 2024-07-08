import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/response/faq_response.dart';
import 'package:flutter_danain/layout/appBar_title_center.dart';
import 'package:flutter_danain/pages/borrower/menu/help/detail/detail_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../layout/appBar_previousTitle.dart';
import 'help_bloc.dart';

class HelpContent extends StatefulWidget {
  final bool? statusHome;
  static const routeName = '/help_page';

  const HelpContent({super.key, this.statusHome});

  @override
  State<HelpContent> createState() => _HelpContentState();
}

class _HelpContentState extends State<HelpContent> {
  final FaqBloc _faqBloc = FaqBloc();
  String textToTitleCase(String text) {
    if (text.length > 1) {
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    } else if (text.length == 1) {
      return text[0].toUpperCase();
    }

    return '';
  }

  @override
  void initState() {
    super.initState();
    _faqBloc.getFaqList();
  }

  @override
  void dispose() {
    _faqBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusHome = widget.statusHome ?? false;
    return Scaffold(
      appBar: statusHome
          ? titleCenter(context, 'Bantuan')
          : previousTitle(context, 'Bantuan'),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: StreamBuilder<List<FaqResponse2>>(
          stream: _faqBloc.faqStream,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: HexColor(primaryColorHex),
                ),
              );
            } else if (snapshot.hasData) {
              List<FaqResponse2> faqResponse = snapshot.data!;
              return ListView.builder(
                itemCount: faqResponse.length,
                itemBuilder: ((context, index) {
                  final faqItem = faqResponse[index];
                  final judul_bantuan = faqItem.judul_bantuan;
                  final data = judul_bantuan
                      .split(' ')
                      .map((element) => textToTitleCase(element))
                      .toList()
                      .join(' ');
                  List<String> iconData = [
                    'assets/images/icons/faq/icon_1.svg',
                    'assets/images/icons/faq/icon_2.svg',
                    'assets/images/icons/faq/icon_3.svg',
                    'assets/images/icons/faq/icon_4.svg',
                    'assets/images/icons/faq/icon_5.svg',
                    'assets/images/icons/faq/icon_6.svg',
                    'assets/images/icons/faq/icon_7.svg',
                  ];
                  return faqContent(
                    context,
                    faqItem.id_bantuan,
                    iconData[index],
                    data,
                    faqItem.fa_bantuan_pertanyaan,
                  );
                }),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Subtitle2(text: '${snapshot.error}'),
              );
            }
            return const Center(
              child: Subtitle2(
                text:
                    'Sepertinya ada yang salah, silakan coba beberapa saat lagi',
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget faqContent(BuildContext context, dynamic id_faq, String icon,
      String keterangan, List<dynamic> list_detail) {
    return GestureDetector(
      onTap: () {
        print(id_faq);
        Navigator.pushNamed(
          context,
          FaqDetailPage.routeName,
          arguments: FaqDetailPage(
            id_faq: id_faq,
            faqTitle: keterangan,
            fa_bantuan_pertanyaan: list_detail,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffEEEEEE), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xffE9F6EB),
                    ),
                    child: SvgPicture.asset(
                      icon,
                      width: 16,
                      height: 16,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Headline5(
                    text: keterangan,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  FaqDetailPage.routeName,
                  arguments: FaqDetailPage(
                    faqTitle: keterangan,
                    id_faq: id_faq,
                    fa_bantuan_pertanyaan: list_detail,
                  ),
                );
              },
              icon: const Icon(
                Icons.keyboard_arrow_right,
                color: Color(0xffAAAAAA),
                size: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
