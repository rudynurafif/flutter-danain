import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_bloc.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class Step1InfoBank extends StatefulWidget {
  final InformasiBankBloc bankBloc;
  const Step1InfoBank({super.key, required this.bankBloc});

  @override
  State<Step1InfoBank> createState() => _Step1InfoBankState();
}

class _Step1InfoBankState extends State<Step1InfoBank> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.bankBloc;
    return StreamBuilder<Map<String, dynamic>?>(
      stream: bloc.bank.stream,
      builder: (context, snapshot) {
        return Parent(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(
              context: context,
              isLeading: true,
              title: 'Informasi Akun Bank',
              actions: [
                if (snapshot.hasData)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () {
                        bloc.step.add(2);
                      },
                      child: const TextWidget(
                        text: 'Ubah',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff288C50),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          child: dataWidget(snapshot),
        );
      },
    );
  }

  Widget dataWidget(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      final data = snapshot.data;
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 181,
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: SvgPicture.asset(
                            'assets/images/profile/bank_template.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/profile/sim_card.svg',
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Subtitle2Large(
                                        text: data!['nama_bank'] ??
                                            data['keterangan'].toString(),
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SvgPicture.asset(
                                'assets/images/profile/master_card.svg',
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Subtitle2(
                              text: data['an_rekening'] ??
                                  data['anrekening'].toString(),
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Headline1(
                              text: data['no_rekening'] ??
                                  data['norekening'].toString(),
                              color: Colors.white,
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            annoutcementBank(context)
          ],
        ),
      );
    }
    if (snapshot.hasError) {
      return Center(
        child: TextWidget(
          text: snapshot.error.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          align: TextAlign.center,
        ),
      );
    }
    return loadingBank();
  }

  Widget loadingBank() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 181,
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: SvgPicture.asset(
                          'assets/images/profile/bank_template.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/profile/sim_card.svg',
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerLong(
                                      height: 18,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              'assets/images/profile/master_card.svg',
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLong(
                            height: 18,
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                          const SizedBox(height: 4),
                          ShimmerLong(
                            height: 27,
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          annoutcementBank(context)
        ],
      ),
    );
  }

  Widget annoutcementBank(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: HexColor('#FFF5F2'),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: HexColor('FDE8CF'),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 16, color: HexColor('#FF8829')),
          const SizedBox(width: 8),
          const Flexible(
            child: Subtitle3(
              text:
                  'Nomor rekening akan menjadi tujuan pencairan dana. Pastikan rekening bank Anda sudah sesuai. ',
              color: Color(0xff5F5F5F),
              align: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}
