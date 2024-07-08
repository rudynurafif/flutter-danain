import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:intl/intl.dart';

class EmasPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String image;
  final Function(List<Map<String, dynamic>>, num) updateData;

  const EmasPage({
    super.key,
    required this.data,
    required this.image,
    required this.updateData,
  });

  @override
  State<EmasPage> createState() => _EmasPageState();
}

class _EmasPageState extends State<EmasPage>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> dataSelected = [];

  num totalHarga = 0;
  bool isSvg = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.image.endsWith(".svg")) {
      setState(() {
        isSvg = true;
      });
    }
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        child: Column(
          children: widget.data.map(
            (item) {
              bool isItemSelected = dataSelected.any((selectedItem) => selectedItem['id'] == item['id']);

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal:
                            BorderSide(width: 0.1, color: Colors.grey))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          isSvg
                              ? SvgPicture.asset(
                                  widget.image,
                                  width: 56,
                                  height: 56,
                                )
                              : Image.asset(
                                  widget.image,
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
                                  text: '${NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(item['harga'])}')
                            ],
                          ),
                        ],
                      ),
                    ),
                    isItemSelected
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      for (int i = 0; i < dataSelected.length; i++) {
                                        if (dataSelected[i]['id'] == item['id']) {
                                          dataSelected[i]['total'] = dataSelected[i]['total'] - 1;
                                          dataSelected[i]['total_harga'] = dataSelected[i]['total'] * item['harga'];
                                          if (dataSelected[i]['total'] <= 0) {
                                            dataSelected.removeAt(i);
                                          }
                                          break;
                                        }
                                      }
                                      totalHarga = dataSelected.fold(
                                          0,
                                          (sum, item) =>
                                              sum + item['total_harga']);
                                      widget.updateData(
                                          dataSelected, totalHarga);
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
                                          '${dataSelected.firstWhere((selectedItem) => selectedItem['id'] == item['id'])['total']}',
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
                                      for (int i = 0;
                                          i < dataSelected.length;
                                          i++) {
                                        if (dataSelected[i]['id'] ==
                                            item['id']) {
                                          dataSelected[i]['total'] =
                                              dataSelected[i]['total'] + 1;
                                          dataSelected[i]['total_harga'] =
                                              dataSelected[i]['total'] *
                                                  dataSelected[i]['harga'];
                                          break;
                                        }
                                      }
                                      totalHarga = dataSelected.fold(
                                          0,
                                          (sum, item) =>
                                              sum + item['total_harga']);
                                      widget.updateData(
                                          dataSelected, totalHarga);
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
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              elevation: MaterialStatePropertyAll(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                    color: Color(0xff288C50),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              bool itemExists = false;

                              for (int i = 0; i < dataSelected.length; i++) {
                                if (dataSelected[i]['id'] == item['id']) {
                                  dataSelected[i]['total'] =
                                      dataSelected[i]['total'] + 1;
                                  itemExists = true;
                                  break;
                                }
                              }

                              if (!itemExists) {
                                dataSelected.add({
                                  'id': item['id'],
                                  'varian': item['varian'],
                                  'harga': item['harga'],
                                  'total': 1,
                                  'total_harga': item['harga'] * 1,
                                  'image': widget.image
                                });
                              }
                              totalHarga = dataSelected.fold(
                                  0, (sum, item) => sum + item['total_harga']);
                              setState(() {});
                              widget.updateData(dataSelected, totalHarga);
                            },
                            child: Text(
                              'Tambah',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff288C50),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
