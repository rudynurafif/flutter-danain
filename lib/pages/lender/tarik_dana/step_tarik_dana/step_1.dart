import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/component/complete_data/textfield_withMoney_component.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/lender/tarik_dana/tarik_dana_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import 'tarik_dana_loading.dart';

class Step1TarikDana extends StatefulWidget {
  final TarikDanaBloc tdBloc;
  const Step1TarikDana({super.key, required this.tdBloc});

  @override
  State<Step1TarikDana> createState() => _Step1TarikDanaState();
}

class _Step1TarikDanaState extends State<Step1TarikDana> {
  TextEditingController saldoController = TextEditingController();
  @override
  void initState() {
    widget.tdBloc.getWithDraw();
    if (widget.tdBloc.saldoTarikController.hasValue) {
      final value = widget.tdBloc.saldoTarikController.valueOrNull ?? 0;
      saldoController.text = rupiahFormat(value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.tdBloc;
    return Scaffold(
      appBar: previousTitle(context, 'Tarik Dana'),
      body: Container(
        child: bodyBuilder(bloc),
      ),
      bottomNavigationBar: buttonBottom(bloc),
    );
  }

  Widget buttonBottom(TarikDanaBloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<Map<String, dynamic>>(
            stream: bloc.withDrawStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? {};
              final saldo = data['saldoTersedia'] ?? 0;
              final biaya = data['biayaTarikDana'] ?? 0;
              return StreamBuilder<int>(
                stream: bloc.saldoTarikStream,
                builder: (context, snapshot) {
                  final tarikan = snapshot.data ?? 0;
                  final bool isValid =
                      tarikan >= biaya && (tarikan + biaya) <= saldo;
                  return Button1(
                    btntext: 'Lanjut',
                    color: isValid ? HexColor(lenderColor) : Colors.grey,
                    action: isValid
                        ? () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (context) => modalPenarikan(
                                biayaTarikDana: biaya,
                              ),
                            );
                          }
                        : null,
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget bodyBuilder(TarikDanaBloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.withDrawStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final bank = data['dataBank'] ?? {};
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                saldoWidget(
                  bank['anRekening'] ?? '',
                  (data['saldoTersedia'] ?? 0),
                ),
                const SizedBox(height: 16),
                penarikanWidget(
                  data['saldoTersedia'] ?? 0,
                  data['biayaTarikDana'] ?? 0,
                ),
                dividerFull(context),
                rekeningTujuan(
                  bank['namaBank'] ?? '',
                  bank['anRekening'] ?? '',
                  bank['noRekening'] ?? '',
                ),
                dividerFull(context),
                syaratKetentuanTarik(data['syaratKetentuan'] ?? []),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Subtitle2(text: snapshot.error.toString()),
          );
        }

        return const Step1LoadingTarikDana();
      },
    );
  }

  Widget saldoWidget(String nama, int saldo) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: HexColor('#F5F9F6'),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo/danain.png',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline3500(text: nama),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Subtitle2(
                    text: 'Saldo Tersedia: ',
                    color: HexColor('#777777'),
                  ),
                  Subtitle2Extra(
                    text: rupiahFormat(saldo),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget penarikanWidget(
    num saldo,
    num biayaTarikDana,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<int>(
        stream: widget.tdBloc.saldoTarikStream,
        builder: (context, snapshot) {
          final data = snapshot.data ?? 0;
          print('data saldo tarik $data');
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Subtitle3(
                text: 'Nominal Penarikan',
                color: HexColor('#AAAAAA'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: saldoController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onChanged: widget.tdBloc.saldoTarikControl,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  NumberTextInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorText: data == 0
                      ? null
                      : data + biayaTarikDana > saldo
                          ? 'Nominal melebihi saldo tersedia'
                          : null,
                  errorStyle: const TextStyle(fontSize: 11, color: Colors.red),
                  hintText: 'Rp 0',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: HexColor('#AAAAAA'),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: HexColor('#EEEEEE'),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: HexColor('#EEEEEE'),
                    ),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.red,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: HexColor('#EEEEEE'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: '+biaya transaksi: ',
                    color: HexColor('#AAAAAA'),
                  ),
                  Subtitle3(
                    text: rupiahFormat(biayaTarikDana),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget rekeningTujuan(String namaBank, String anBank, String noRek) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Subtitle3(
            text: 'Rekening Tujuan:',
            color: HexColor('#AAAAAA'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(getBankImage(namaBank)),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle2Large(text: anBank),
                      const SizedBox(height: 4),
                      Subtitle2(text: '$namaBank - $noRek')
                    ],
                  )
                ],
              ),
              // Subtitle2(
              //   text: 'Edit',
              //   color: HexColor(lenderColor),
              // )
            ],
          )
        ],
      ),
    );
  }

  Widget syaratKetentuanTarik(List<dynamic> listSyarat) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3500(text: 'Syarat dan Ketentuan Penarikan'),
          const SizedBox(height: 16),
          listStrip(context, listSyarat)
        ],
      ),
    );
  }

  Widget modalPenarikan({
    required num biayaTarikDana,
  }) {
    return ModaLBottomTemplate(
      padding: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpacerV(value: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Headline2500(text: 'Konfirmasi Penarikan'),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Subtitle2(
              text: 'Total Penarikan',
              color: HexColor('#AAAAAA'),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: StreamBuilder<int>(
              stream: widget.tdBloc.saldoTarikStream,
              builder: (context, snapshot) {
                final tarikan = snapshot.data ?? 0;
                return Headline2500(
                  text: rupiahFormat(tarikan),
                );
              },
            ),
          ),
          dividerFull(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Subtitle2(
                  text: 'Rekening Tujuan:',
                  color: HexColor('#AAAAAA'),
                ),
                const SizedBox(height: 16),
                StreamBuilder<Map<String, dynamic>>(
                  stream: widget.tdBloc.withDrawStream,
                  builder: (context, snapshot) {
                    final dataBank = snapshot.data ?? {};
                    final bank = dataBank['dataBank'] ?? {};
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(getBankImage(bank['namaBank'] ?? '')),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Subtitle2Large(text: bank['anRekening'] ?? ''),
                            const SizedBox(height: 4),
                            Subtitle2(
                              text:
                                  '${bank['namaBank'] ?? ''} - ${bank['noRekening'] ?? ''}',
                            )
                          ],
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          dividerFull(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StreamBuilder<int>(
              stream: widget.tdBloc.saldoTarikStream,
              builder: (context, snapshot) {
                final data = snapshot.data ?? 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Headline3500(text: 'Rincian Penarikan'),
                    const SizedBox(height: 8),
                    keyVal('Nominal Penarikan', rupiahFormat(data)),
                    const SizedBox(height: 8),
                    keyVal(
                      'Biaya Transaksi',
                      rupiahFormat(biayaTarikDana),
                    ),
                    const SizedBox(height: 8),
                    dividerDashed(context),
                    const SizedBox(height: 8),
                    keyVal3(
                      'Total Penarikan',
                      rupiahFormat(data + biayaTarikDana),
                    )
                  ],
                );
              },
            ),
          ),
          const SpacerV(value: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Button1(
              btntext: 'Tarik Dana Sekarang',
              color: HexColor(lenderColor),
              action: () {
                Navigator.pop(context);
                widget.tdBloc.stepControl(2);
              },
            ),
          ),
          const SpacerV(value: 24)
        ],
      ),
    );
  }

  String getBankImage(String bank) {
    final name = bank.toLowerCase();
    switch (name) {
      case 'bca':
        return 'assets/lender/bank/bca.svg';
      case 'bni':
        return 'assets/lender/bank/bni.svg';
      case 'atm_bersama':
        return 'assets/lender/bank/atm_bersama.svg';
      default:
        return 'assets/lender/bank/bca.svg';
    }
  }
}
