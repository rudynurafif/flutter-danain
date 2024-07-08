import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../component/lender/modal_component/modal_pendanaan.dart';
import '../../../../data/constants.dart';
import '../../../../utils/string_format.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/divider/divider.dart';
import '../../../../widgets/filter/date_filter.dart';
import '../../../../widgets/filter/filter_bottom.dart';
import '../../../../widgets/form/keyVal.dart';
import '../../../../widgets/form/selectForm.dart';
import '../../../../widgets/modal/modalBottom.dart';
import '../../../../widgets/rupiah_format.dart';
import '../../../../widgets/text/headline.dart';
import '../../../../widgets/text/subtitle.dart';
import '../../setor_dana/setor_dana_page.dart';
import 'detail/detail_transaksi_page.dart';
import 'riwayat_transaksi_bloc.dart';

class DetailRiwayat extends StatelessWidget {
  final RiwayatTransaksiBloc bloc;
  final ScrollController scrollController;
  final Map<String, dynamic>? data;

  const DetailRiwayat({
    super.key,
    required this.bloc,
    required this.scrollController,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: bloc.periodeStream,
      builder: (context, snapshot) {
        if (data == null) {
          return const Center(
            child: Text('Data is null'),
          );
        }

        print('data list $data');
        final List<Widget> transactionWidgets = [];
        var firstTransaction = data!.entries.first;
        if (firstTransaction.value is Iterable) {
          for (var transaction in firstTransaction.value) {
            transactionWidgets.add(
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    DetailTransaksiPage.routeName,
                    arguments: DetailTransaksiPage(
                      dataTransaksi: transaction,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    children: [
                      keyValHeaderRiwayatTrans(
                        transaction['keterangan'],
                        transaction['kdtrans'],
                        rupiahFormat(transaction['nominal'] ?? 0),
                        transaction['status_wd'] ?? 0,
                      ),
                      const SizedBox(height: 3),
                      if (transaction['no_sbg'] != '')
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Subtitle2(
                                  text: 'No PP ${transaction['no_sbg'] ?? ''}',
                                  color: const Color(0xFFAAAAAA),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Subtitle2(
                                  text: dateFormat(transaction['tgl_proses'] ?? ''),
                                  color: const Color(0xFFAAAAAA),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      if (transaction['keterangan'] == 'Tarik Dana' ||
                          transaction['keterangan'] == 'Penarikan Dana')
                        keyValTarikDana(
                          dateFormat(transaction['tgl_proses'] ?? ''),
                          transaction['status_wd'],
                        ),
                      const SizedBox(height: 16),
                      dividerFullNoPadding(context),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          print('Unexpected type: ${firstTransaction.value.runtimeType}');
        }

        return Column(children: transactionWidgets);
      },
    );
  }
}

class NoTransactionWidget extends StatelessWidget {
  final BuildContext context;
  final int statusBank;
  final String username;
  final int status;
  final RiwayatTransaksiBloc bloc;

  const NoTransactionWidget({
    super.key,
    required this.context,
    required this.statusBank,
    required this.username,
    required this.status,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/no_message.svg'),
          const SizedBox(height: 8),
          const Headline2(
            text: 'Belum Ada Transaksi',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle1(
            text:
                'Anda belum memiliki riwayat transaksi. Mulailah bertransaksi untuk melihat semua daftar transaksi di sini',
            align: TextAlign.center,
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 40),
          StreamBuilder<bool>(
            stream: bloc.haveFilterStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final isHave = snapshot.data!;
                if (!isHave) {
                  return Button1(
                    btntext: 'Mulai Setor Dana Dulu Yuk!',
                    color: HexColor(lenderColor),
                    action: () {
                      if (status == 0) {
                        showDialog(
                          context: context,
                          builder: (context) => notVerifPopUp(context),
                        );
                      } else if (status == 9) {
                        showDialog(
                          context: context,
                          builder: (context) => waitingVerifPopUp(context),
                        );
                      } else if (status == 11 || status == 12) {
                        showDialog(
                          context: context,
                          builder: (context) => rejectVerifPopUp(context),
                        );
                      } else if (status == 1) {
                        Navigator.pushNamed(context, SetorDanaLenderPage.routeName);
                      }
                    },
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class FilterRiwayat extends StatefulWidget {
  final RiwayatTransaksiBloc pBloc;
  const FilterRiwayat({super.key, required this.pBloc});

  @override
  State<FilterRiwayat> createState() => _FilterRiwayatState();
}

class _FilterRiwayatState extends State<FilterRiwayat> {
  List<dynamic> filterSort = [
    {
      'id': 'DEP',
      'nama': 'Setor Dana',
    },
    {
      'id': 'PNP',
      'nama': 'Pendanaan',
    },
    {
      'id': 'PBL',
      'nama': 'Bunga',
    },
    {
      'id': 'PRP',
      'nama': 'Pelunasan Pokok Dana',
    },
    {
      'id': 'WTH',
      'nama': 'Tarik Dana',
    },
    {
      'id': 'RCV',
      'nama': 'Bonus Referral',
    },
  ];

  List<dynamic> periodeList = [
    {
      'id': 4,
      'name': 'Bulan Lalu',
    },
    {
      'id': 3,
      'name': '3 Bulan Terakhir',
    },
    {
      'id': 2,
      'name': 'Pilih Bulan',
    },
  ];

  List<String> durasiSelected = [];
  TextEditingController terendahController = TextEditingController();
  TextEditingController tertinggiController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.pBloc;
    return ModalBottomTemplate2(
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Headline2500(text: 'Filter'),
                  InkWell(
                    onTap: () {
                      bloc.reset();
                    },
                    child: Subtitle1(
                      text: 'Reset',
                      color: HexColor(lenderColor),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              const Headline3500(text: 'Jenis Transaksi'),
              const SizedBox(height: 12),
              StreamBuilder<List<String>>(
                stream: bloc.jenisTransaksiStream,
                builder: (context, snapshot) {
                  final dataProduk = snapshot.data ?? [];
                  return multipleSelectLenderString(
                    filterSort,
                    dataProduk,
                    (List<String> val) {
                      print('check jenis transaksi $val');
                      bloc.jenisTransaksiControl(val);
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              const Headline3500(text: 'Waktu Transaksi'),
              const SizedBox(height: 12),
              StreamBuilder<int>(
                stream: bloc.periodeStream,
                builder: (context, snapshot) {
                  final data = snapshot.data ?? 0;
                  return filterItemLender(
                    periodeList,
                    data,
                    (int val) => bloc.periodeControl(val),
                  );
                },
              ),
              StreamBuilder<int>(
                stream: bloc.periodeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data ?? 0;
                    if (data == 2) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          StreamBuilder<int>(
                            stream: bloc.tahunStream,
                            builder: (context, snapshot) {
                              final tahun = snapshot.data ?? DateTime.now().year;
                              return StreamBuilder<int>(
                                stream: bloc.bulanStream,
                                builder: (context, snapshot) {
                                  final bulan = snapshot.data ?? 1;
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DateFilter(
                                            year: tahun,
                                            month: bulan,
                                            onSelect: (month, year) {
                                              bloc.bulanControl(month);
                                              bloc.tahunControl(year);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: SelecFormMonth(
                                      month: bulanList[bulan],
                                      year: tahun.toString(),
                                      label: 'Bulan',
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 40),
              Button1(
                btntext: 'Terapkan',
                color: HexColor(lenderColor),
                action: () {
                  bloc.terapkan();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
