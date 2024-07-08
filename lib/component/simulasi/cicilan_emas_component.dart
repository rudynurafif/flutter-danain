import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:intl/intl.dart';

class DataEmasNotEmpty extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function(num) updateTotalHarga;
  const DataEmasNotEmpty(
      {super.key, required this.data, required this.updateTotalHarga});

  @override
  State<DataEmasNotEmpty> createState() => _DataEmasNotEmptyState();
}

class _DataEmasNotEmptyState extends State<DataEmasNotEmpty> {
  num totalHarga = 0;
  List<Map<String, dynamic>> dataEmas = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      totalHarga =
          widget.data.fold(0, (sum, item) => sum + item['total_harga']);
      dataEmas = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Headline3(text: 'Jenis Emas', align: TextAlign.start),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Headline5(
                  text: 'Tambah',
                  color: Color(0xff288C50),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Column(
            children: dataEmas.map((item) {
              bool isSvg = item['image'].endsWith('svg');
              return Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(width: 0.1, color: Colors.grey),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          isSvg
                              ? SvgPicture.asset(
                                  item['image'],
                                  width: 56,
                                  height: 56,
                                )
                              : Image.asset(
                                  item['image'],
                                  width: 56,
                                  height: 56,
                                ),
                          SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Subtitle1(text: '${item['varian']}'),
                              SizedBox(height: 4),
                              Headline4(
                                  text:
                                      '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item['harga'])}')
                            ],
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                for (int i = 0; i < dataEmas.length; i++) {
                                  if (dataEmas[i]['id'] == item['id']) {
                                    dataEmas[i]['total'] =
                                        dataEmas[i]['total'] - 1;
                                    dataEmas[i]['total_harga'] =
                                        dataEmas[i]['total'] * item['harga'];
                                    if (dataEmas[i]['total'] <= 0) {
                                      dataEmas.removeAt(i);
                                    }
                                    break;
                                  }
                                }
                                totalHarga = dataEmas.fold(0,
                                    (sum, item) => sum + item['total_harga']);
                                widget.updateTotalHarga(totalHarga);
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff24663F), width: 1),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  color: Color(0xff24663F),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Container(
                            width: 20,
                            child: Center(
                              child: SubtitleExtra(
                                text:
                                    '${dataEmas.firstWhere((selectedItem) => selectedItem['id'] == item['id'])['total']}',
                                color: Color(0xff24663F),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                for (int i = 0; i < dataEmas.length; i++) {
                                  if (dataEmas[i]['id'] == item['id']) {
                                    dataEmas[i]['total'] =
                                        dataEmas[i]['total'] + 1;
                                    dataEmas[i]['total_harga'] = dataEmas[i]
                                            ['total'] *
                                        dataEmas[i]['harga'];
                                    break;
                                  }
                                }
                                totalHarga = dataEmas.fold(0,
                                    (sum, item) => sum + item['total_harga']);
                                widget.updateTotalHarga(totalHarga);
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff24663F), width: 1),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xff24663F),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Subtitle2(text: 'Total Harga Emas'),
              Headline3(
                  text:
                      '${NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0).format(totalHarga)}')
            ],
          )
        ],
      ),
    );
  }
}
