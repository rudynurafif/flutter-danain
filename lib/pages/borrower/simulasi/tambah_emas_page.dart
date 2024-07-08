import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_danain/pages/borrower/simulasi/simulasi_cicilan_page.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:intl/intl.dart';
import 'package:flutter_danain/component/simulasi/tambah_emas_component.dart';

class TambahEmas extends StatefulWidget {
  static const routeName = 'tambah_emas';
  const TambahEmas({super.key});

  @override
  State<TambahEmas> createState() => _TambahEmasState();
}

class _TambahEmasState extends State<TambahEmas> with SingleTickerProviderStateMixin {
  //total price
  num antamTotal = 0;
  num ubsTotal = 0;
  num lotusTotal = 0;
  num galeriTotal = 0;
  num totalHarga = 0;

  //antam
  List<Map<String, dynamic>> antamData = [
    {
      "id": 'Antam-1',
      "varian": "Antam - 0,5 gr",
      "harga": 540000,
    },
    {
      "id": 'Antam-2',
      "varian": "Antam - 1 gr",
      "harga": 1040000,
    },
    {
      "id": "Antam-3",
      "varian": "Antam - 2 gr",
      "harga": 2010000,
    },
    {
      "id": 'Antam-4',
      "varian": "Antam - 5 gr",
      "harga": 4010000,
    },
    {
      "id": 'Antam-5',
      "varian": "Antam - 10 gr",
      "harga": 9010000,
    },
  ];
  List<Map<String, dynamic>> selectedAntam = [];
  //end antam

  //ubs
  List<Map<String, dynamic>> ubs = [
    {
      "id": "UBS-1",
      "varian": "UBS - 0,5 gr",
      "harga": 540000,
    },
    {
      "id": "UBS-2",
      "varian": "UBS - 1 gr",
      "harga": 1040000,
    },
    {
      "id": "UBS-3",
      "varian": "UBS - 2 gr",
      "harga": 2010000,
    },
    {
      "id": "UBS-4",
      "varian": "UBS - 5 gr",
      "harga": 4010000,
    },
    {
      "id": "UBS-5",
      "varian": "UBS - 10 gr",
      "harga": 9010000,
    },
  ];
  List<Map<String, dynamic>> selectedUbs = [];
  //end ubs

  //lotus
  List<Map<String, dynamic>> lotus = [
    {
      "id": "Lotus-1",
      "varian": "Lotus - 0,5 gr",
      "harga": 540000,
    },
    {
      "id": "Lotus-2",
      "varian": "Lotus - 1 gr",
      "harga": 1040000,
    },
    {
      "id": "Lotus-3",
      "varian": "Lotus - 2 gr",
      "harga": 2010000,
    },
    {
      "id": "Lotus-4",
      "varian": "Lotus - 5 gr",
      "harga": 4010000,
    },
    {
      "id": "Lotus-5",
      "varian": "Lotus - 10 gr",
      "harga": 9010000,
    },
  ];
  List<Map<String, dynamic>> selectedLotus = [];
  //endLotus

  //galeri 24
  List<Map<String, dynamic>> galeri24 = [
    {
      "id": "Galeri24-1",
      "varian": "Galeri24 - 0,5 gr",
      "harga": 540000,
    },
    {
      "id": "Galeri24-2",
      "varian": "Galeri24 - 1 gr",
      "harga": 1040000,
    },
    {
      "id": "Galeri24-3",
      "varian": "Galeri24 - 2 gr",
      "harga": 2010000,
    },
    {
      "id": "Galeri24-4",
      "varian": "Galeri24 - 5 gr",
      "harga": 4010000,
    },
    {
      "id": "Galeri24-5",
      "varian": "Lotus - 10 gr",
      "harga": 9010000,
    },
  ];
  List<Map<String, dynamic>> selectedGaleri = [];
  //end galeri 24

  List<Map<String, dynamic>> allItem = [];



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Headline2(text: 'Tambah Emas'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Color(0xff24663F),
              ),
              tabs: [
                tabItem(context, 'Antam'),
                tabItem(context, 'Ubs'),
                tabItem(context, 'Lotus Archi'),
                tabItem(context, 'Galeri 24')
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            EmasPage(
              data: antamData,
              image: 'assets/images/simulasi/antam.svg',
              updateData: (data, total) {
                setState(() {
                  selectedAntam = data;
                  antamTotal = total;
                  totalHarga = antamTotal + ubsTotal + lotusTotal + galeriTotal;
                  allItem = selectedAntam +
                      selectedGaleri +
                      selectedLotus +
                      selectedUbs;
                });
              },
            ),
            EmasPage(
              data: ubs,
              image: 'assets/images/simulasi/ubs.svg',
              updateData: (data, total) {
                setState(() {
                  selectedUbs = data;
                  ubsTotal = total;
                  totalHarga = antamTotal + ubsTotal + lotusTotal + galeriTotal;
                  allItem = selectedAntam +
                      selectedGaleri +
                      selectedLotus +
                      selectedUbs;
                });
              },
            ),
            EmasPage(
              data: lotus,
              image: 'assets/images/simulasi/lotus.svg',
              updateData: (data, total) {
                setState(() {
                  selectedLotus = data;
                  lotusTotal = total;
                  totalHarga = antamTotal + ubsTotal + lotusTotal + galeriTotal;
                  allItem = selectedAntam +
                      selectedGaleri +
                      selectedLotus +
                      selectedUbs;
                });
              },
            ),
            EmasPage(
              data: galeri24,
              image: 'assets/images/simulasi/galeri.png',
              updateData: (data, total) {
                setState(() {
                  selectedGaleri = data;
                  galeriTotal = total;
                  totalHarga = antamTotal + ubsTotal + lotusTotal + galeriTotal;
                  allItem = selectedAntam +
                      selectedGaleri +
                      selectedLotus +
                      selectedUbs;
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(16),
          height: 94,
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(width: 4, color: Color(0xffEEEEEE)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle2(
                    text: 'Total Harga Emas',
                    color: Colors.grey,
                  ),
                  Headline2(
                      text: '${NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(totalHarga)}')
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, SimulasiCicilan.routeName,
                      arguments: SimulasiCicilan(
                        dataEmas: allItem,
                      ));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  child: Headline3(
                    text: 'Tambah',
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget tabItem(BuildContext context, String name) {
  return Container(
    width: 100, // Set the desired fixed width for the tabs
    height: 34,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.transparent, width: 1),
    ),
    child: Align(
      alignment: Alignment.center,
      child: Text(
        name,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
