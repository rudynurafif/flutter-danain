import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/simulasi/pinjaman/simulasi_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/simulasi/pinjaman/simulasi_pinjaman_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

import '../../../../layout/appBar_previousTitle.dart';

class SimulasiPinjaman extends StatefulWidget {
  static const routeName = '/simulasi_pinjaman';
  const SimulasiPinjaman({super.key});

  @override
  State<SimulasiPinjaman> createState() => _SimulasiPinjamanState();
}

class _SimulasiPinjamanState extends State<SimulasiPinjaman>
    with
        SingleTickerProviderStateMixin<SimulasiPinjaman>,
        DisposeBagMixin,
        DidChangeDependenciesStream {
  final TextEditingController gramController = TextEditingController();
  final TextEditingController karatController = TextEditingController();
  final TextEditingController nilaiPengajuanController =
      TextEditingController();

  final FocusNode nilaiPinjamanFocus = FocusNode();

  double _currentSliderValue = 1;
  String _jangkaWaktu = '1 Hari';
  int _batasMaximal = 0;
  int _dayValue = 1;
  int _gram = 0;
  int _karat = 0;
  int _biayaAdmin = 0;
  int _pencairanPinjaman = 0;
  int _bunga = 0;
  int _jasaSimpan = 0;
  int _pokok = 0;
  int _totalPelunasan = 0;
  String _ratePerTahun = '0%';
  String _ratePerBulan = '0%';
  String? prefixNilai;
  int _nilaiPengajuan = 0;
  final StreamController<double> _debounceController =
      StreamController<double>.broadcast();

  // Create a stream for debounced values
  Stream<double> get _debouncedValue =>
      _debounceController.stream.debounceTime(Duration(milliseconds: 50));
  @override
  void initState() {
    super.initState();
    final simulasiBloc = BlocProvider.of<SimulasiPinjamanBloc>(context);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<SimulasiPinjamanBloc>().message$)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<SimulasiPinjamanBloc>().gramError$)
        .exhaustMap(handleGram)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<SimulasiPinjamanBloc>().karatError$)
        .exhaustMap(handleKarat)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<SimulasiPinjamanBloc>().isValids$)
        .exhaustMap(handleIsvalid)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap(
            (_) => context.bloc<SimulasiPinjamanBloc>().jangkaWaktuError$)
        .exhaustMap(handleJangkaWaktu)
        .collect()
        .disposedBy(bag);
    _debouncedValue.listen((double value) {
      setState(() {
        _currentSliderValue = value;
        _dayValue = value.toInt();
        _jangkaWaktu = '$_dayValue hari';
      });

      print(value.toInt());

      // Perform your desired actions here (e.g., calling bloc methods)
      simulasiBloc.jangkaWaktuChange(value.toInt());
      simulasiBloc.postPinjaman();
    });
  }

  @override
  void dispose() {
    gramController.dispose();
    karatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final simulasiBloc = BlocProvider.of<SimulasiPinjamanBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousTitle(context, 'Simulasi Pinjaman'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3(
                text: spTitle,
                align: TextAlign.start,
              ),
              const SizedBox(height: 8),
              const Subtitle2(
                text: spSub,
                align: TextAlign.start,
                color: Color(0xff777777),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  gramTextField(simulasiBloc),
                  karatTextField(simulasiBloc),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: hitungButton(simulasiBloc),
              ),
              const SizedBox(height: 24),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffF0F0F0), width: 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 10.0,
                        offset: Offset(0, 4.0),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [nilaiPengajuanTextField(simulasiBloc)],
                ),
              ),
              const SizedBox(height: 16),
              detailSimulasiPinjaman(simulasiBloc),
              const SizedBox(height: 16),
              noticeAlertSimulasi(simulasiBloc),
            ],
          ),
        ),
      ),
    );
  }

  Stream<void> handleMessage(message) async* {
    final LocalStorage storage = new LocalStorage('todo_app.json');
    if (message is SimulasiPinjamanSuccess) {
      context.showSnackBar('Counting successfully');
      context.hideCurrentSnackBar();
      final simulasiState = storage.getItem('simulasiPinjaman');
      _batasMaximal = simulasiState['maxPinjaman'];
      _biayaAdmin = simulasiState['biayaAdmin'];
      _pencairanPinjaman = simulasiState['totalDiterima'];
      _bunga = simulasiState['bunga'];
      _pokok = simulasiState['pokok'];
      _jasaSimpan = simulasiState['jasaMitra'];
      _totalPelunasan = simulasiState['totalPengembalian'];
      _ratePerBulan = simulasiState['ekuRateBulan'];
      _ratePerTahun = simulasiState['ekuRateTahun'];
      print(
          "=================================== Response handle Message on page simulasi ==============================");
      print(storage.getItem('simulasiPinjaman'));
      print(
          "=================================== Response handle Message on page simulasi ==============================");

      return;
    }
  }

  Stream<void> handleGram(response) async* {
    print(
        "=================================== Response handle gram on page Simulasi ==============================");
    print(response);
    print(
        "=================================== Response handle gram on page Simulasi ==============================");
    return;
  }

  Stream<void> handleKarat(response) async* {
    print(
        "=================================== Response handle karat on page Simulasi ==============================");
    print(response);
    print(
        "=================================== Response handle karat on page Simulasi ==============================");
    return;
  }

  Stream<void> handleIsvalid(response) async* {
    print(
        "=================================== Response handle is Valid on page Simulasi ==============================");
    print(response);
    print(
        "=================================== Response handle is Valid on page Simulasi ==============================");
    return;
  }

  Stream<void> handleJangkaWaktu(response) async* {
    print(
        "=================================== Response handle Jangka Waktu on page Simulasi ==============================");
    print(response);
    print(
        "=================================== Response handle Jangka Waktu on page Simulasi ==============================");
    return;
  }

  Widget hitungButton(SimulasiPinjamanBloc simulasiBloc) {
    return StreamBuilder<SimulasiPinjamanMessage>(
        stream: simulasiBloc.message$,
        builder: (context, snapshot) {
          return Button1(
            btntext: count,
            color: _gram > 0 && _karat > 0 ? null : const Color(0xffADB3BC),
            action: _gram > 0 && _karat > 0
                ? () {
                    print(
                        "==================================== Action Button Hitung Simulasi ======================================");
                    print(snapshot.data);
                    print(
                        "==================================== Action Button Hitung Simulasi ======================================");
                    simulasiBloc.postPinjaman();
                  }
                : null,
          );
        });
  }

  Widget detailSimulasiPinjaman(SimulasiPinjamanBloc simulasiBloc) {
    return StreamBuilder<SimulasiPinjamanMessage>(
      stream: simulasiBloc.message$,
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
            color: const Color(0xFFF9FFFA),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0xFFE9F6EB)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              frameCounting(
                context,
                biayaAdmin,
                rupiahFormat(_biayaAdmin),
              ),
              const SizedBox(height: 8),
              frameCounting(
                context,
                pencairan,
                rupiahFormat(_pencairanPinjaman),
              ),
              const SizedBox(height: 24),
              const Headline5(text: 'Pelunasan Pinjaman'),
              const SizedBox(height: 16),
              frameCounting(
                context,
                bunga,
                rupiahFormat(_bunga),
              ),
              const SizedBox(height: 8),
              frameCounting(
                context,
                jasaMitra,
                rupiahFormat(_jasaSimpan),
              ),
              const SizedBox(height: 8),
              frameCounting(
                context,
                pokok,
                rupiahFormat(_pokok),
              ),
              const SizedBox(height: 12),
              DashedDivider(
                height: 1.0,
                dashWidth: 5.0,
                color: Colors.grey,
              ),
              const SizedBox(height: 12),
              frameCounting(
                context,
                totalPelunasanText,
                rupiahFormat(_totalPelunasan),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: HexColor('#E9F6EB'),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    frameCounting(
                      context,
                      ratePertahun,
                      _ratePerTahun,
                    ),
                    const SizedBox(height: 8),
                    frameCounting(
                      context,
                      ratePerbulan,
                      _ratePerBulan,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget nilaiPengajuanTextField(SimulasiPinjamanBloc simulasiBloc) {
    return StreamBuilder<SimulasiPinjamanMessage?>(
        stream: simulasiBloc.message$,
        builder: (context, snapshot) {
          return Container(
            // Batas Maximal Pinjaman
            //
            //
            //
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Adjust as needed
              children: [
                const Center(child: Subtitle2(text: batasMaksimal)),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    NumberFormat.currency(
                            symbol: 'Rp ', locale: 'id_ID', decimalDigits: 0)
                        .format(_batasMaximal),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                OnlyNumberForm40(
                  label: nilaiPengajuanLabel,
                  controller: nilaiPengajuanController,
                  changeResponse: (value) {
                    setState(() {
                      final data =
                          value!.replaceAll('Rp ', '').replaceAll('.', '');
                      _nilaiPengajuan = int.tryParse(data) ?? 0;
                    });
                    simulasiBloc.nilaiPinjamanChange(_nilaiPengajuan);
                    simulasiBloc.postPinjaman();
                  },
                  maxValue: _batasMaximal,
                  placeHolder: 'Rp 0',
                  focusNode: nilaiPinjamanFocus,
                ),
                const SizedBox(height: 24),

                // jangka waktu pelunasan
                //
                //
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Subtitle2(
                      text: jangkaWaktuLabel,
                      color: Color(0xff777777),
                    ),
                    Headline5(text: _jangkaWaktu),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: FractionallySizedBox(
                    widthFactor: 1.1,
                    child: Slider(
                      value: _currentSliderValue,
                      max: 150,
                      min: 1,
                      label: _currentSliderValue.round().toString(),
                      activeColor: const Color(0xff288C50),
                      inactiveColor: const Color(0xffEDEDED),
                      thumbColor: const Color(0xff24663F),
                      onChanged: (double value) {
                        _debounceController.add(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Subtitle4(text: minJangka, color: Color(0xffBBBBBB)),
                    Subtitle4(text: maxJangka, color: Color(0xffBBBBBB)),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget noticeAlertSimulasi(SimulasiPinjamanBloc simulasiBloc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF5F2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0xFFFDE8CF)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 16, color: Colors.orange),
          SizedBox(width: 8),
          Flexible(
            child: Subtitle3(
              text: alertSimulasi,
              color: Color(0xff777777),
              align: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }

  Widget gramTextField(SimulasiPinjamanBloc simulasiBloc) {
    return StreamBuilder<String?>(
        stream: simulasiBloc.gramError$,
        builder: (context, snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width / 2.4,
            height: 40,
            alignment: Alignment.bottomCenter,
            child: Center(
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: gramController,
                onChanged: (value) {
                  print(
                      "==================================== gram typing on paging ==============================");
                  print(value);
                  print(
                      "==================================== gram typing on paging ==============================");
                  setState(() {
                    _gram = int.tryParse(value) ?? 0;
                  });
                  int intValue = int.tryParse(value) ?? 0; // C
                  simulasiBloc.gramChange(intValue);
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(),
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixStyle: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  suffixText: 'gram',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffDDDDDD),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff288C50),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget karatTextField(SimulasiPinjamanBloc simulasiBloc) {
    return StreamBuilder<String?>(
        stream: simulasiBloc.karatError$,
        builder: (context, snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width / 2.4,
            height: 40,
            child: TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              controller: karatController,
              onChanged: (value) {
                print(
                    "==================================== karat typing on paging ==============================");
                print(value);
                print(
                    "==================================== karat typing on paging ==============================");
                setState(() {
                  _karat = int.tryParse(value) ?? 0;
                });
                int intValue = int.tryParse(value) ?? 0; // C
                simulasiBloc.karatChange(intValue);
              },
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                border: OutlineInputBorder(),
                hintText: '0',
                hintStyle: TextStyle(color: Colors.grey),
                suffixStyle: TextStyle(color: Colors.black),
                suffixText: 'karat',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffDDDDDD),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff288C50),
                    width: 1.0,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

Widget frameCounting(BuildContext context, String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Subtitle2(text: label, color: const Color(0xff777777)),
      Subtitle2(
        text: value,
        color: const Color(0xff333333),
      )
    ],
  );
}

class DashedDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;

  DashedDivider({
    this.height = 1.0,
    this.dashWidth = 5.0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (index) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
