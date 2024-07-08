import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_page.dart';
import 'package:flutter_danain/pages/borrower/menu/help/detail/detail_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_danain/component/introduction/introduction_component.dart';
import 'package:hexcolor/hexcolor.dart';

class IntroductionProductAfterLogin extends StatefulWidget {
  static const routeName = '/introduction_product_after_login';
  final int? content;
  const IntroductionProductAfterLogin({super.key, this.content});

  @override
  State<IntroductionProductAfterLogin> createState() =>
      _IntroductionProductAfterLoginState();
}

class _IntroductionProductAfterLoginState
    extends State<IntroductionProductAfterLogin> {
  int contentMenu = 1;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments
        as IntroductionProductAfterLogin?;
    if (args != null) {
      setState(() {
        contentMenu = args.content!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousWidget(context),
      body: SingleChildScrollView(
        child: contentMenu == 1 ? gadaiContent(context) : cicilContent(context),
      ),
    );
  }
}

Widget bottomCicilEmas(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Button1(
        btntext: 'Info Selengkapnya',
        color: Colors.white,
        textcolor: HexColor(primaryColorHex),
        action: () {
          Navigator.pushNamed(
            context,
            FaqDetailPage.routeName,
            arguments: const FaqDetailPage(
              id_faq: 7,
              faqTitle: 'Cicil Emas',
            ),
          );
        },
      ),
    ],
  );
}

Widget bottomGadaiEmas(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Button1(
        btntext: 'Info Selengkapnya',
        color: Colors.white,
        textcolor: HexColor(primaryColorHex),
        action: () {},
      ),
    ],
  );
}

void locationNotExistModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => ModalPopUp(
      icon: 'assets/images/register/warning.svg',
      title: locationNotExistTitle,
      message: locationNotExistSub,
      actions: [
        Button2(
          btntext: 'OK',
          action: () {
            // Navigator.pop(context);
            Navigator.pushNamed(context, CicilEmas2Page.routeName);
          },
        ),
      ],
    ),
  );
}

Widget gadaiContent(BuildContext context) {
  return Column(
    children: [
      imageGadaiContent(context),
      firstGadaiProductContent(context),
    ],
  );
}

Widget cicilContent(BuildContext context) {
  return Column(
    children: [
      imageCicilContent(context),
      firstCicilContent(context),
    ],
  );
}
