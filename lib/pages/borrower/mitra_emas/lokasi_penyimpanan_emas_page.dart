import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/response/mitra_terdekat_response.dart';
import 'package:flutter_danain/layout/appBar_PreviousTitle.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'lokasi_emas_bloc.dart';

int getIndexProvince(
  List<Map<String, dynamic>> provinceList,
  String provinceName,
) {
  int result = -1;
  for (var i = 0; i < provinceList.length; i++) {
    if (provinceList[i]['nama_provinsi']
        .toString()
        .toLowerCase()
        .contains(provinceName.toLowerCase())) {
      result = provinceList[i]['id_provinsi'];
      break;
    }
  }
  return result;
}

int getIndexKota(
  List<Map<String, dynamic>> kotaList,
  String kotaName,
) {
  int result = -1;
  for (var i = 0; i < kotaList.length; i++) {
    if (kotaList[i]['nama_kabupaten']
        .toString()
        .toLowerCase()
        .contains(kotaName.toLowerCase())) {
      result = kotaList[i]['id_kabupaten'];
      break;
    }
  }
  return result;
}

class PenyimpananEmas extends StatefulWidget {
  static const routeName = '/lokasi_penyimpanan_emas';
  final String? provinceName;
  const PenyimpananEmas({super.key, this.provinceName});

  @override
  State<PenyimpananEmas> createState() => _PenyimpananEmasState();
}

class _PenyimpananEmasState extends State<PenyimpananEmas> {
  final bloc = PenyimpanEmasBloc();

  String provinsiNama = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as PenyimpananEmas?;
    if (args != null) {
      print('provinsi gan: ${args.provinceName}');
      bloc.initGetData(args.provinceName);
    }
  }

  TextEditingController provinsiController = TextEditingController();
  TextEditingController kotaController = TextEditingController();

  //display
  TextEditingController provisiDisplay = TextEditingController();
  TextEditingController kotaDisplay = TextEditingController();

  List<Map<String, dynamic>> provinsiList = [];
  List<Map<String, dynamic>> kotaList = [];

  String? provinsiStr;
  String? kotaStr;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    provinsiController.addListener(() {
      int? data;
      if (provinsiController.text.length > 0) {
        data = int.tryParse(provinsiController.text);
      }
      kotaController.clear();
      kotaDisplay.clear();

      bloc.changeProvinsi(data!);
    });

    //kota listener
    kotaController.addListener(() {
      int? data;
      if (kotaController.text.length > 0) {
        data = int.tryParse(kotaController.text);
      } else {
        data = null;
      }

      bloc.changeKota(data!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: previousTitle(context, 'Lokasi Penyimpanan Emas'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formLayout(bloc),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xffEEEEEE),
              ),
            ),
            const SizedBox(height: 24),
            mitraPenyimpanWidget(context),
          ],
        ),
      ),
    );
  }

  Widget formLayout(PenyimpanEmasBloc peBloc) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3(
            text: glTitle,
            align: TextAlign.start,
          ),
          const SizedBox(height: 8),
          const Subtitle2(
            text: glSub,
            color: Color(0xff777777),
            align: TextAlign.start,
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              provisiForm(peBloc),
              const SizedBox(height: 16),
              kotaForm(peBloc),
              const SizedBox(height: 24),
              StreamBuilder<bool>(
                stream: bloc.buttonSearchStream,
                builder: (context, snapshot) {
                  bool isValid = snapshot.data ?? false;
                  return Button1(
                    btntext: searchText,
                    color: isValid ? null : HexColor('#ADB3BC'),
                    action: isValid
                        ? () {
                            peBloc.getMitra(context);
                            setState(() {
                              provinsiStr = provisiDisplay.text;
                              kotaStr = kotaDisplay.text;
                            });
                          }
                        : null,
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget provisiForm(PenyimpanEmasBloc peBloc) {
    return StreamBuilder<int?>(
      stream: peBloc.provinsiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Map<String, dynamic> data =
              peBloc.listProvinsi.value.firstWhere(
            (message) => message['id'] == snapshot.data,
            orElse: () => {},
          );
          provinsiController.text = data['id'].toString();
          provisiDisplay.text = data['display'];
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          peBloc.listProvinsi.value,
                          'Pilih Provinsi',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: provisiDisplay,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Provinsi',
                          snapshot.hasError,
                          'assets/images/icons/dropdown.svg',
                        ),
                      ),
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

  Widget kotaForm(PenyimpanEmasBloc peBloc) {
    return StreamBuilder<int?>(
      stream: peBloc.kotaStream,
      builder: (context, snapshot) {
        final listKota = peBloc.listKota.valueOrNull ?? [];
        if (snapshot.hasData) {
          final Map<String, dynamic> data = listKota.firstWhere(
            (message) => message['id'] == snapshot.data,
            orElse: () => {},
          );
          kotaController.text = data['id'].toString();
          kotaDisplay.text = data['display'];
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          peBloc.listKota.value,
                          'Pilih Kota',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: kotaDisplay,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Kota',
                          snapshot.hasError,
                          'assets/images/icons/dropdown.svg',
                        ),
                      ),
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

  Widget mitraPenyimpanWidget(BuildContext context) {
    String result = 'Daftar mitra di...';
    if (kotaStr != null && provinsiStr != null) {
      result = 'Daftar mitra di ${kotaStr ?? ''}, ${provinsiStr ?? ''}';
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Headline3(
            text: 'Mitra Penyimpanan Emas Terdekat',
            align: TextAlign.start,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text: result,
            align: TextAlign.start,
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<MitraTerdekatResponse>>(
            stream: bloc.mitraStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              List<MitraTerdekatResponse> data = snapshot.data!;
              if (data.isEmpty) {
                return Container();
              } else {
                return ListView.builder(
                  shrinkWrap: true, // Add this line
                  physics:
                      const NeverScrollableScrollPhysics(), // Add this line
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final mitraItem = data[index];
                    return MitraPenyimpanan(
                      mitra: mitraItem.nama_branch,
                      address: mitraItem.alamat_branch,
                      maps: 'https:///',
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class MitraPenyimpanan extends StatelessWidget {
  final String mitra;
  final String address;
  final String? maps;
  const MitraPenyimpanan({
    super.key,
    required this.mitra,
    required this.address,
    required this.maps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: const Color(0xffF9FFFA),
          border: Border.all(
            width: 1,
            color: HexColor('#DAF1DE'),
          ),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Headline5(
            text: mitra,
            align: TextAlign.start,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text: address,
            align: TextAlign.start,
          ),
          const SizedBox(height: 16),
          // Button2(
          //   btntext: 'Maps',
          //   color: Color(0xffF9FFFA),
          //   textcolor: Color(0xff24663F),
          //   action: () async {
          //     if (await canLaunch(maps!)) {
          //       await launch(maps!);
          //     } else {
          //       context.showSnackBarError('Maaf sepertinya terjadi kesalahan');
          //     }
          //   },
          // )
        ],
      ),
    );
  }
}
