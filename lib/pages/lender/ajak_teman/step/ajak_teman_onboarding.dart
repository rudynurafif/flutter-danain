import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/ajak_teman_bloc.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/step/ajak_teman_loading.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/step/ajak_teman_syarat.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/divider/divider.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_danain/widgets/rupiah_format.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class AjakTemanOnboarding extends StatefulWidget {
  final AjakTemanBloc aBloc;
  const AjakTemanOnboarding({super.key, required this.aBloc});

  @override
  State<AjakTemanOnboarding> createState() => _AjakTemanOnboardingState();
}

class _AjakTemanOnboardingState extends State<AjakTemanOnboarding> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.aBloc;
    return Scaffold(
      appBar: previousTitle(context, 'Ajak Teman'),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.ajakTemanStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  SvgPicture.asset('assets/lender/profile/ajak_teman.svg'),
                  const SizedBox(height: 16),
                  const Headline3500(
                    text: 'Ajak Teman Pakai Danain',
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Subtitle2(
                      text:
                          'Bagikan kode referal dan dapatkan keuntungan 5% dari pendapatan bunga teman Anda.',
                      color: HexColor('#777777'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (context) => const AjakTemanSyarat(),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: HexColor('#F1FCF4'),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      child: Subtitle1(
                        text: 'Selengkapnya >',
                        color: HexColor(lenderColor),
                      ),
                    ),
                  ),
                  dividerFull(context),
                  const SizedBox(height: 8),
                  referralCode(data['kode_ajakteman'] ?? ''),
                  const SizedBox(height: 8),
                  dividerFull(context),
                  const SizedBox(height: 8),
                  pendapantanAjakTeman(
                    data['total_amount'] ?? 0,
                    data['data_referal'] ?? [],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Subtitle1(text: snapshot.error.toString()),
            );
          }

          return const AjakTemanLoading();
        },
      ),
    );
  }

  Widget referralCode(String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DottedBorder(
              color: HexColor('#DDDDDD'),
              strokeWidth: 1,
              dashPattern: [10, 6],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Subtitle3(
                          text: 'Kode Referral Anda',
                          color: HexColor('#AAAAAA'),
                        ),
                        const SizedBox(height: 4),
                        Headline1500(text: code)
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: code));
                        BuildContext? dialogContext;

                        showDialog(
                          context: context,
                          builder: (context) {
                            dialogContext = context;
                            return const AlertDialog(
                              backgroundColor: Colors.white,
                              content: Subtitle2(
                                text: 'Kode Referral Berhasi disalin',
                                align: TextAlign.center,
                              ),
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            );
                          },
                        );
                        Future.delayed(
                          const Duration(seconds: 1),
                          () => Navigator.of(dialogContext!).pop(),
                        );
                      },
                      child: Row(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                              180 * 3.1415926535897932 / 180,
                            ),
                            child: Icon(
                              Icons.content_copy,
                              color: HexColor(lenderColor),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Subtitle2Extra(text: 'Salin')
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Button1(
            btntext: 'Bagikan Kesosial Media',
            color: HexColor(lenderColor),
            action: () {
              showDialog(
                context: context,
                builder: (context) => ModalPopUpCustomeContent(
                  title: 'Bagikan Ke',
                  content: ajakTemanPopUp(widget.aBloc),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget pendapantanAjakTeman(
    num pendapatan,
    List<dynamic> dataPendapatan,
  ) {
    int pendapatanInt = pendapatan.toInt();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: HexColor('#BDDCCA'),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Subtitle2Extra(
                  text: 'Pendapatan Ajak Teman',
                ),
                const SizedBox(height: 8),
                Text(
                  rupiahFormat(pendapatanInt),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: HexColor(lenderColor),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.aBloc.stepChange(2);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              height: 53,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Subtitle2Extra(
                    text: 'Teman yang di ajak',
                    color: HexColor('#777777'),
                  ),
                  Headline3500(text: '${dataPendapatan.length} >')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ajakTemanPopUp(AjakTemanBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.linkAjakTeman,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final url = 'whatsapp://send?text=$data';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/lender/profile/whatsapp.svg'),
                    const SizedBox(height: 4),
                    Subtitle3(
                      text: 'Whatsapp',
                      color: HexColor('#5F5F5F'),
                      align: TextAlign.center,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final url =
                      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(data)}';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/lender/profile/x.svg'),
                    const SizedBox(height: 4),
                    Subtitle3(
                      text: 'X',
                      color: HexColor('#5F5F5F'),
                      align: TextAlign.center,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: data));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/lender/profile/link.svg'),
                    const SizedBox(height: 4),
                    Subtitle3(
                      text: 'Tautan',
                      color: HexColor('#5F5F5F'),
                      align: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Subtitle1(text: snapshot.error.toString()),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
