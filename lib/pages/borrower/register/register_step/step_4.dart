import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/pages/borrower/register/register_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import '../../../auxpage/preference.dart';

class Step4Regis extends StatefulWidget {
  final RegisterBloc regisBloc;
  const Step4Regis({super.key, required this.regisBloc});

  @override
  State<Step4Regis> createState() => _Step4RegisState();
}

class _Step4RegisState extends State<Step4Regis> {
  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
  TextEditingController provinsiController = TextEditingController();
  TextEditingController kotaController = TextEditingController();

  //display
  TextEditingController provisiDisplay = TextEditingController();
  TextEditingController kotaDisplay = TextEditingController();

  //error
  String? provinsiError;
  String? kotaError;
  List<Map<String, dynamic>> provinsiList = [];
  List<Map<String, dynamic>> kotaList = [];

  void getProvince() async {
    List<Map<String, dynamic>> result = await _apiService.fetchProvince();
    try {
      for (var i = 0; i < result.length; i++) {
        provinsiList.add({
          "id": result[i]['id_provinsi'],
          "display": result[i]['nama_provinsi']
        });
      }
      int? valProv = widget.regisBloc.provinsiController.value;
      if (widget.regisBloc.provinsiController.hasValue) {
        getKota(valProv!);
        provinsiController.text = valProv.toString();
        for (var i = 0; i < result.length; i++) {
          if (result[i]['id_provinsi'] == valProv) {
            provisiDisplay.text = result[i]['nama_provinsi'];
          }
        }
      }

      if (widget.regisBloc.kotaController.hasValue) {
        int? valKota = widget.regisBloc.kotaController.value;
        List<Map<String, dynamic>> kotaRes =
            await _apiService.fetchCity(valProv!);
        print(kotaRes.toString());
        print('kota iyah: ${widget.regisBloc.kotaController.value}');
        for (var i = 0; i < kotaRes.length; i++) {
          if (kotaRes[i]['id_kabupaten'] == valKota) {
            print('sip bang dapet');
            kotaDisplay.text = kotaRes[i]['nama_kabupaten'];
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getKota(int provinsi) async {
    try {
      List<Map<String, dynamic>> resultKota =
          await _apiService.fetchCity(provinsi);
      kotaList.clear();
      for (var i = 0; i < resultKota.length; i++) {
        kotaList.add({
          "id": resultKota[i]['id_kabupaten'],
          "display": resultKota[i]['nama_kabupaten'],
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    provinsiController.addListener(() {
      int? data;
      if (provinsiController.text.length > 0) {
        data = int.tryParse(provinsiController.text);
      } else {
        data = null;
      }
      getKota(data!);
      kotaController.clear();
      kotaDisplay.clear();
      widget.regisBloc.changeProvinsi(data);
    });

    //kota listener
    kotaController.addListener(() {
      int? data;
      if (kotaController.text.length > 0) {
        data = int.tryParse(kotaController.text);
      } else {
        data = null;
      }
      widget.regisBloc.changeKota(data);
    });
    super.initState();
    getProvince();
    print('kota: ${widget.regisBloc.kotaController.valueOrNull}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline1(
              text: nearestLocationTitle,
              align: TextAlign.start,
            ),
            SizedBox(height: 8),
            Subtitle2(
              text: nearestLocationSub,
              color: Color(0xff777777),
              align: TextAlign.start,
            ),
            SizedBox(height: 24),
            provisiForm(widget.regisBloc),
            SizedBox(height: 16),
            kotaForm(widget.regisBloc)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 150,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<bool>(
              stream: widget.regisBloc.locationButtonStream,
              builder: ((context, snapshot) {
                final isValid = snapshot.data ?? false;
                return Button1(
                  btntext: 'Lanjut Daftar',
                  color: isValid ? null : Colors.grey,
                  action: isValid? () {
                    widget.regisBloc.addMitra(context);
                    widget.regisBloc.resendEmail(context, 1);
                  }
                  : null
                );
              }),
            ),
            SizedBox(height: 8),
            TextButton(
              child: Headline3(
                text: cancelText,
                color: Color(0xff288C50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, PreferencePage.routeName);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget provisiForm(RegisterBloc rgBloc) {
    return StreamBuilder<int?>(
      stream: rgBloc.provinsiStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          provinsiError = snapshot.error.toString();
        } else {
          provinsiError = null;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Provinsi',
              color: HexColor('#AAAAAA'),
            ),
            SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) => ModalBottomListItem(
                          provinsiController,
                          provisiDisplay,
                          provinsiList,
                          'Pilih Provinsi',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: provisiDisplay,
                        style: TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Provinsi',
                          snapshot.hasError,
                          'assets/images/icons/dropdown.svg',
                        ),
                      ),
                    ),
                  ),
                  if (provinsiError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: provinsiError! as String,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget kotaForm(RegisterBloc rgBloc) {
    return StreamBuilder<int?>(
      stream: rgBloc.kotaStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          kotaError = snapshot.error.toString();
        } else {
          kotaError = null;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Kota',
              color: HexColor('#AAAAAA'),
            ),
            SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) => ModalBottomListItem(
                          kotaController,
                          kotaDisplay,
                          kotaList,
                          'Pilih Kota',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: kotaDisplay,
                        style: TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Kota',
                          snapshot.hasError,
                          'assets/images/icons/dropdown.svg',
                        ),
                      ),
                    ),
                  ),
                  if (kotaError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: provinsiError! as String,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}


