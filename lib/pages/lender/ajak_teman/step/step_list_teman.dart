import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/ajak_teman_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class ListAjakTeman extends StatefulWidget {
  final AjakTemanBloc aBloc;
  const ListAjakTeman({
    super.key,
    required this.aBloc,
  });

  @override
  State<ListAjakTeman> createState() => _ListAjakTemanState();
}

class _ListAjakTemanState extends State<ListAjakTeman> {
  String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    final DateFormat formatter = DateFormat('d MMM y');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.aBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Ajak Teman', () {
        bloc.stepChange(1);
      }),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.ajakTemanStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final List<dynamic> listData = data['data_referal'];
            if (listData.length == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 50),
                child: noItemWidget(),
              );
            } else {
              return Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: listData.map((val) {
                      final tambah = val['amount'];
                      final hasil = tambah.toInt();
                      final String output = rupiahFormat(hasil);
                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: HexColor('#DDDDDD'),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Subtitle2Extra(text: val['username']),
                                const SizedBox(height: 4),
                                Subtitle4(
                                  text:
                                      'Bergabung pada ${formatDate(val['tanggal'].toString())}',
                                )
                              ],
                            ),
                            Subtitle2Large(text: '+${output}', color: HexColor(lenderColor),)
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          }

          if (snapshot.hasError) {
            return Center(
              child: Subtitle1(
                text: snapshot.error.toString(),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget noItemWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/no_message.svg'),
          const SizedBox(height: 8),
          const Headline2(
            text: 'Belum Ada Teman Bergabung',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text:
                'Ayo ajak lebih banyak teman Anda untuk bergabung dan mendanai di Danain',
            align: TextAlign.center,
            color: HexColor('#777777'),
          ),
        ],
      ),
    );
  }
}
