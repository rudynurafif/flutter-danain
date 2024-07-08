import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/lender/setor_dana/setor_dana.dart';
import 'package:flutter_danain/pages/lender/setor_dana/step/step_2_loading.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class Step2SetorDana extends StatefulWidget {
  final SetorDanaBloc setorBloc;
  const Step2SetorDana({super.key, required this.setorBloc});

  @override
  State<Step2SetorDana> createState() => _Step2SetorDanaState();
}

class _Step2SetorDanaState extends State<Step2SetorDana> {
  String expandedData = 'stepAtm';
  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<SetorDanaBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        bloc.getTutorial(bloc.idBankSelected.valueOrNull ?? 1);
        setState(() {
          expandedData = 'stepAtm';
        });
      },
      child: Scaffold(
        appBar: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Setor Dana',
          leadingAction: () {
            bloc.step.add(1);
          },
        ),
        body: StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.tutorial,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data ?? {};
              final stepAtm = data['stepsAtm'] ?? {};
              final stepMbanking = data['stepsMbanking'] ?? {};
              final stepIbanking = data['stepsIbanking'] ?? {};
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    rdlSuccess(data['norekLender'].toString()),
                    const DividerWidget(height: 6),
                    const SpacerV(value: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: TextWidget(
                        text: 'Cara Setor Dana',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SpacerV(value: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: caraBayarDetail(
                        expandedName: 'stepAtm',
                        title: stepAtm['Wording'] ?? '',
                        tutor: stepAtm['steps'] ?? {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: caraBayarDetail(
                        expandedName: 'stepMBanking',
                        title: stepMbanking['Wording'] ?? '',
                        tutor: stepMbanking['steps'] ?? {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: caraBayarDetail(
                        expandedName: 'stepIbanking',
                        title: stepIbanking['Wording'] ?? '',
                        tutor: stepIbanking['steps'] ?? {},
                      ),
                    ),
                    const SpacerV(value: 24),
                  ],
                ),
              );
            }
            return const Step2Loading();
          },
        ),
      ),
    );
  }

  Widget rdlLoading(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerLong(
                height: 42,
                width: 42,
                radius: 8,
              ),
              SpacerH(value: 16),
              ShimmerLong(height: 18, width: 100),
            ],
          ),
          SpacerV(value: 16),
          DividerWidget(height: 1),
          SpacerV(value: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLong(height: 17, width: 200),
                  SpacerV(value: 4),
                  ShimmerLong(height: 21, width: 150),
                ],
              ),
              ShimmerLong(height: 21, width: 59),
            ],
          )
        ],
      ),
    );
  }

  Widget rdlSuccess(String rdl) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/lender/bank/bni.svg',
              ),
              const SpacerH(value: 16),
              const TextWidget(
                text: 'BNI',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              )
            ],
          ),
          const SpacerV(value: 16),
          const DividerWidget(height: 1),
          const SpacerV(value: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                    text: 'Nomor Rekening Dana Lender',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                  const SpacerV(value: 4),
                  Headline2500(text: rdl),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: rdl),
                  );
                  BuildContext? dialogContext;
                  showDialog(
                    context: context,
                    builder: (context) {
                      dialogContext = context;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: const TextWidget(
                                text: 'No. Rekening berhasil disalin',
                                align: TextAlign.center,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
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
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget caraBayarDetail({
    required String expandedName,
    required String title,
    required Map<String, dynamic> tutor,
  }) {
    final bool isExpand = expandedName == expandedData;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (isExpand) {
              setState(() {
                expandedData = '';
              });
            } else {
              setState(() {
                expandedData = expandedName;
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Subtitle2(
                text: title,
                color: HexColor('#333333'),
              ),
              Icon(
                isExpand ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              isExpand ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.translationValues(0, isExpand ? 0 : 1, 0),
            child: listTutorial(tutor),
          ),
          secondChild: const SizedBox.shrink(),
        )
      ],
    );
  }

  Widget listTutorial(Map<String, dynamic> tutor) {
    final tutorList = tutor.entries.toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tutorList.asMap().entries.map((entry) {
          final index = entry.key;
          final stepEntry = entry.value;
          final stepDescription = stepEntry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: HexColor(lenderColor)),
                      padding: const EdgeInsets.all(4),
                      width: 25,
                      height: 25,
                      child: Subtitle3(
                        text: '${index + 1}',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Subtitle2(
                        text: stepDescription,
                        color: HexColor('#555555'),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                dividerDashed(context)
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
