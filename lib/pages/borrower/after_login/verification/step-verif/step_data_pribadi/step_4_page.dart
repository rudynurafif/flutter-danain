import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/verif_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_danain/component/verification/verification_component.dart';
import 'package:hexcolor/hexcolor.dart';

class Step4Verif extends StatefulWidget {
  final StepVerifBloc stepBloc;
  const Step4Verif({super.key, required this.stepBloc});

  @override
  State<Step4Verif> createState() => _Step4VerifState();
}

class _Step4VerifState extends State<Step4Verif>
    with AutomaticKeepAliveClientMixin {
  //controller for store
  TextEditingController alamatController = TextEditingController();
  TextEditingController provinsiController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController kecamatanController = TextEditingController();
  TextEditingController kelurahanController = TextEditingController();
  TextEditingController kodePosController = TextEditingController();

  //controller forDisplay
  TextEditingController provinsiDisplay = TextEditingController();
  TextEditingController kotaDisplay = TextEditingController();
  TextEditingController kecamatanDisplay = TextEditingController();
  TextEditingController kelurahanDisplay = TextEditingController();

  List<Map<String, dynamic>> provinsiList = [];
  List<Map<String, dynamic>> kotaList = [];
  List<Map<String, dynamic>> kecamatanList = [];
  List<Map<String, dynamic>> kelurahanList = [];

  void getKota(int provinsi) {
    widget.stepBloc.getKotaByIdProvinsi(provinsi);
  }

  void showAlert() {
    showDialog(
      context: context,
      builder: (context) => ModalPopUp(
        icon: 'assets/images/icons/check.svg',
        title: 'Verifikasi Data Diri',
        message:
            'Untuk tahap verifikasi, kami akan mengirimkan data pribadi Anda ke badan verifikasi sesuai dengan ketentuan perundang-undangan.',
        actions: [
          Button2(
            btntext: 'Kirim',
            action: () {
              Navigator.pop(context);
              widget.stepBloc.postToPrivy(context);
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    //provinsi listener
    provinsiController.addListener(() {
      final data = int.tryParse(provinsiController.text);
      kotaController.clear();
      kotaDisplay.clear();
      widget.stepBloc.changeProvinsi(data!);
      getKota(data);
    });

    //kota listener
    kotaController.addListener(() {
      final data = int.tryParse(kotaController.text);
      widget.stepBloc.changeKota(data!);
    });

    super.initState();
    final stepBloc = widget.stepBloc;
    alamatController.text = stepBloc.alamatController.hasValue
        ? stepBloc.alamatController.value
        : '';
    kodePosController.text = stepBloc.kodePosController.hasValue
        ? stepBloc.kodePosController.value
        : '';
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              alertDataAman(context),
              const SizedBox(height: 24),
              const Headline3500(text: 'Data Alamat'),
              const SizedBox(height: 8),
              Subtitle2(
                text: 'Pastikan pengisian alamat sesuai dengan KTP',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              formAlamat(context),
              const SizedBox(height: 16),
              formProvinsi(context),
              const SizedBox(height: 16),
              formKota(context),
              const SizedBox(height: 16),
              formKecamatan(context),
              const SizedBox(height: 16),
              formKelurahan(context),
              const SizedBox(height: 16),
              formKodePos(context),
              const SizedBox(height: 32),
              StreamBuilder<bool>(
                stream: widget.stepBloc.step4Button,
                builder: (context, snapshot) {
                  final bool isValid = snapshot.data ?? false;
                  return StreamBuilder<bool>(
                      stream: widget.stepBloc.isLoadingStream,
                      builder: (context, snapshot) {
                        final isLoading = snapshot.data ?? false;
                        if (isLoading == true) {
                          return const ButtonLoadingNormal();
                        }
                        return ButtonNormal(
                          btntext: 'Lanjut',
                          color: isValid ? null : Colors.grey,
                          action: isValid
                              ? () {
                                  showAlert();
                                }
                              : null,
                        );
                      });
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget formAlamat(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.stepBloc.alamatStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Alamat'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: Jalan Danain No 24',
                      snapshot.hasError,
                    ),
                    controller: alamatController,
                    onChanged: (value) => widget.stepBloc.changeAlamat(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.error.toString(),
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget formProvinsi(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.stepBloc.provinsiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (var prov in widget.stepBloc.provinsiList.value) {
            if (prov['id'].toString() == snapshot.data.toString()) {
              provinsiController.text = prov['id'].toString();
              provinsiDisplay.text = prov['nama'];
              break;
            }
          }
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(text: 'Provinsi', color: HexColor('#AAAAAA')),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) =>
                            ModalBottomListItemWithSearch(
                          provinsiController,
                          provinsiDisplay,
                          widget.stepBloc.provinsiList.value,
                          'Pilih Provinsi',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: provinsiDisplay,
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
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.error.toString(),
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget formKota(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.stepBloc.kotaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (var temp in widget.stepBloc.kotaList.value!) {
            if (temp['id'].toString() == snapshot.data.toString()) {
              kotaController.text = temp['id'].toString();
              kotaDisplay.text = temp['nama'];
              break;
            }
          }
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(text: 'Kota/Kabupaten', color: HexColor('#AAAAAA')),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (BuildContext context) =>
                      ModalBottomListItemWithSearch(
                    kotaController,
                    kotaDisplay,
                    widget.stepBloc.kotaList.value ?? [],
                    'Pilih Kota/Kabupaten',
                  ),
                );
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: kotaDisplay,
                  style: const TextStyle(color: Colors.black),
                  decoration: inputDecorWithIconSvg(
                    context,
                    'Pilih Kota/Kabupaten',
                    snapshot.hasError,
                    'assets/images/icons/dropdown.svg',
                  ),
                ),
              ),
            ),
            if (snapshot.hasError)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Subtitle2(
                    text: snapshot.error! as String,
                    color: Colors.red,
                  ),
                ],
              )
          ],
        );
      },
    );
  }

  Widget formKecamatan(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.stepBloc.kecamatanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          kecamatanController.text = snapshot.data!;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kecamatan'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: Bogor Selatan',
                      snapshot.hasError,
                    ),
                    controller: kecamatanController,
                    onChanged: (value) =>
                        widget.stepBloc.changeKecamatan(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.error.toString(),
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // Widget formKecamatan(BuildContext context) {
  //   return StreamBuilder<String>(
  //     stream: widget.stepBloc.kecamatanStream,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         for (var temp in loremList) {
  //           if (temp['id'] == snapshot.data.toString()) {
  //             kecamatanController.text = temp['id'];
  //             kecamatanDisplay.text = temp['display'];
  //             break;
  //           }
  //         }
  //       }
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Subtitle3(text: 'Kecamatan', color: HexColor('#AAAAAA')),
  //           const SizedBox(height: 4),
  //           GestureDetector(
  //             onTap: () {
  //               showModalBottomSheet(
  //                 backgroundColor: Colors.transparent,
  //                 context: context,
  //                 builder: (BuildContext context) => ModalBottomListItem(
  //                   kecamatanController,
  //                   kecamatanDisplay,
  //                   kecamatanList,
  //                   'Pilih Kecamatan',
  //                 ),
  //               );
  //             },
  //             child: AbsorbPointer(
  //               child: TextFormField(
  //                 controller: kecamatanDisplay,
  //                 style: const TextStyle(color: Colors.black),
  //                 decoration: inputDecorWithIconSvg(
  //                   context,
  //                   'Pilih Kecamatan',
  //                   snapshot.hasError,
  //                   'assets/images/icons/dropdown.svg',
  //                 ),
  //               ),
  //             ),
  //           ),
  //           if (snapshot.hasError)
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Subtitle2(
  //                   text: snapshot.error! as String,
  //                   color: Colors.red,
  //                 ),
  //               ],
  //             )
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget formKelurahan(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.stepBloc.kelurahanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          kelurahanController.text = snapshot.data!;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kelurahan'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: Empang',
                      snapshot.hasError,
                    ),
                    controller: kelurahanController,
                    onChanged: (value) =>
                        widget.stepBloc.changeKelurahan(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.error.toString(),
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // Widget formKelurahan(BuildContext context) {
  //   return StreamBuilder<int>(
  //     stream: widget.stepBloc.kelurahanStream,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         for (var temp in loremList) {
  //           if (temp['id'] == snapshot.data.toString()) {
  //             kelurahanController.text = temp['id'];
  //             kelurahanDisplay.text = temp['display'];
  //             break;
  //           }
  //         }
  //       }
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Subtitle3(text: 'kelurahan', color: HexColor('#AAAAAA')),
  //           const SizedBox(height: 4),
  //           GestureDetector(
  //             onTap: () {
  //               showModalBottomSheet(
  //                 backgroundColor: Colors.transparent,
  //                 context: context,
  //                 builder: (BuildContext context) => ModalBottomListItem(
  //                   kelurahanController,
  //                   kelurahanDisplay,
  //                   kelurahanList,
  //                   'Pilih kelurahan',
  //                 ),
  //               );
  //             },
  //             child: AbsorbPointer(
  //               child: TextFormField(
  //                 controller: kelurahanDisplay,
  //                 style: const TextStyle(color: Colors.black),
  //                 decoration: inputDecorWithIconSvg(
  //                   context,
  //                   'Pilih kelurahan',
  //                   snapshot.hasError,
  //                   'assets/images/icons/dropdown.svg',
  //                 ),
  //               ),
  //             ),
  //           ),
  //           if (snapshot.hasError)
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Subtitle2(
  //                   text: snapshot.error! as String,
  //                   color: Colors.red,
  //                 ),
  //               ],
  //             )
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget formKodePos(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.stepBloc.kodePosStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kode Pos'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: inputDecor(
                      context,
                      'Contoh: 12345',
                      snapshot.hasError,
                    ),
                    controller: kodePosController,
                    onChanged: (value) => widget.stepBloc.changeKodePos(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.error.toString(),
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // Widget formKodePos(BuildContext context) {
  //   return StreamBuilder<String>(
  //     stream: widget.stepBloc.kodePosStream,
  //     builder: (context, snapshot) {
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Subtitle3(color: HexColor('#AAAAAA'), text: 'Kode Pos'),
  //           const SizedBox(height: 4),
  //           TextFormField(
  //             style: const TextStyle(color: Colors.black),
  //             keyboardType: TextInputType.number,
  //             decoration: inputDecor(
  //               context,
  //               'Contoh: 12345',
  //               snapshot.hasError,
  //             ),
  //             controller: kodePosController,
  //             onChanged: (value) => widget.stepBloc.changeKodePos(value),
  //           ),
  //           if (snapshot.hasError)
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Subtitle2(
  //                   text: snapshot.error! as String,
  //                   color: Colors.red,
  //                 ),
  //               ],
  //             )
  //         ],
  //       );
  //     },
  //   );
  // }
}
