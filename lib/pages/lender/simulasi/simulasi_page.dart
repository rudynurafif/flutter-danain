import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/component/complete_data/textfield_withMoney_component.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan.dart';
import 'package:flutter_danain/pages/lender/simulasi/cicilan.dart';
import 'package:flutter_danain/pages/lender/simulasi/maxi.dart';
import 'package:flutter_danain/pages/lender/simulasi/simulasi_bloc.dart';
import 'package:flutter_danain/pages/lender/simulasi/simulasi_loading.dart';
import 'package:flutter_danain/pages/lender/simulasi/simulasi_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localstorage/localstorage.dart';

class SimulasiPendanaanPage extends StatefulWidget {
  static const routeName = '/simulasi_pendanaan_page';
  const SimulasiPendanaanPage({super.key});

  @override
  State<SimulasiPendanaanPage> createState() => _SimulasiPendanaanPageState();
}

class _SimulasiPendanaanPageState extends State<SimulasiPendanaanPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  TextEditingController nominalController = TextEditingController();
  int indexProduk = 1;
  final StreamController<dynamic> debounceController =
      StreamController<dynamic>.broadcast();
  Stream<dynamic> get _debouncedValue => debounceController.stream.debounceTime(
        Duration(milliseconds: 50),
      );
  @override
  void initState() {
    super.initState();
    context.bloc<SimulasiPendanaanBloc>().getMaster();
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<SimulasiPendanaanBloc>().messageMaxi)
        .exhaustMap(handleMaxiMessage)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<SimulasiPendanaanBloc>().messageCicilan)
        .exhaustMap(handleCicilanMessage)
        .collect()
        .disposedBy(bag);
    _debouncedValue.listen((dynamic value) {
      context.bloc<SimulasiPendanaanBloc>().postCicilan();
      context.bloc<SimulasiPendanaanBloc>().postMaxi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SimulasiPendanaanBloc>(context);
    return StreamBuilder<List<ListProductResponse>>(
      stream: bloc.listProdukStream,
      builder: (context, snapshot) {
        // return const SimulasiLoading();
        if (snapshot.hasData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: previousTitle(context, 'Simulasi Pendanaan'),
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const Headline3500(text: 'Jumlah Pendanaan'),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: inputDecorNoErrorLender(
                              context,
                              'Rp 0',
                            ),
                            controller: nominalController,
                            onChanged: (value) {
                              if (value.length <= 3) {
                                nominalController.clear();
                                bloc.nominalChange(0);
                              } else {
                                final data = value
                                    .replaceAll('Rp ', '')
                                    .replaceAll('.', '');
                                final result = int.tryParse(data) ?? 0;
                                bloc.nominalChange(result);
                              }
                              bloc.isLoadingChange(true);
                              debounceController.add(value);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              NumberTextInputFormatter(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Headline3500(text: 'Pilih Produk Pendanaan'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  indexProduk = 1;
                                });
                              },
                              child: produkContent(1, indexProduk, 'Maxi'),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  indexProduk = 2;
                                });
                              },
                              child:
                                  produkContent(2, indexProduk, 'Cicil Emas'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        contentSelected(indexProduk, bloc),
                        const SizedBox(height: 40),
                        ButtonNormal(
                          btntext: 'Danain Sekarang',
                          action: () {
                            Navigator.pushNamed(
                                context, PendanaanPage.routeName);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              StreamBuilder<bool>(
                stream: bloc.isLoading,
                builder: (context, snapshot) {
                  final isLoading = snapshot.data ?? false;
                  if (isLoading == true) {
                    print('true bang');
                    return const LoadingModal();
                  }
                  print('false bang bang');
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        }
        return const SimulasiLoading();
      },
    );
  }

  Stream<void> handleMaxiMessage(SimulasiMessage? message) async* {
    final bloc = BlocProvider.of<SimulasiPendanaanBloc>(context);
    final LocalStorage storage = LocalStorage('todo_app.json');
    if (message is SimulasiSuccess) {
      final Map<String, dynamic> response = storage.getItem('simulasi_maxi');
      bloc.responseMaxiChange(response);
    }

    if (message is SimulasiError) {
      print('ini messagenya maxi bangggg : ${message}');
      context.showSnackBarError(message.message);
    }
    bloc.isLoadingChange(false);
  }

  Stream<void> handleCicilanMessage(SimulasiMessage? message) async* {
    final bloc = BlocProvider.of<SimulasiPendanaanBloc>(context);
    final LocalStorage storage = LocalStorage('todo_app.json');
    if (message is SimulasiSuccess) {
      final Map<String, dynamic> response =
          storage.getItem('calculate_cicilan');
      final Map<String, dynamic> responseLender = response['lender'];
      bloc.responseCicilanChange(responseLender);
    }

    if (message is SimulasiError) {
      print('ini messagenya cicilan bangggg : ${message}');
      // context.showSnackBarError(message.message);
    }
    bloc.isLoadingChange(false);
  }

  Widget contentSelected(int currentIndex, SimulasiPendanaanBloc bloc) {
    if (currentIndex == 2) {
      return SimulasiCicilanLender(sBloc: bloc);
    }
    return SimulasiMaxiLender(sBloc: bloc);
  }

  Widget produkContent(int index, int currentIndex, String content) {
    final Color bgColor =
        index == currentIndex ? HexColor('#F4FEF5') : HexColor('#FFFFFF');
    final Color borderColor =
        index == currentIndex ? HexColor('#BDDCCA') : HexColor('#DDDDDD');
    final Color colorIndex =
        index == currentIndex ? HexColor(lenderColor) : HexColor('#777777');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: MediaQuery.of(context).size.width / 2.35,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Subtitle2(
        text: content,
        color: colorIndex,
      ),
    );
  }
}
