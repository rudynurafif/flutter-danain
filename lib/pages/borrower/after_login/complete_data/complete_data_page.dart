import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_PreviousTitle.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_danain/component/complete_data/complete_data_component.dart';
import 'package:hexcolor/hexcolor.dart';
import 'complete_data_bloc.dart';
import 'complete_data_state.dart';
import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

class CompleteDataPage extends StatefulWidget {
  static const routeName = '/complete_data';
  const CompleteDataPage({super.key});

  @override
  State<CompleteDataPage> createState() => _CompleteDataPageState();
}

class _CompleteDataPageState extends State<CompleteDataPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  int stepContent = 1;
  bool firstPress = false;
  //actual step one controller
  TextEditingController sumberDanaController = TextEditingController();
  TextEditingController jenisJobController = TextEditingController();
  TextEditingController jabatanController = TextEditingController();
  TextEditingController bidangUsahaController = TextEditingController();
  TextEditingController namaPerusahaanController = TextEditingController();
  TextEditingController alamatPerusahaanController = TextEditingController();
  TextEditingController provinsiController = TextEditingController();
  TextEditingController kabupatenKotaController = TextEditingController();
  TextEditingController kodePosController = TextEditingController();
  TextEditingController lamaKerjaController = TextEditingController();
  TextEditingController penghasilanBulananController = TextEditingController();
  TextEditingController biayaHidupController = TextEditingController();

  //display controller
  TextEditingController sumberDanaDisplay = TextEditingController();
  TextEditingController jenisJobDisplay = TextEditingController();
  TextEditingController jabatanDisplay = TextEditingController();
  TextEditingController bidangUsahaDisplay = TextEditingController();
  TextEditingController provinsiDisplay = TextEditingController();
  TextEditingController kabupatenKotaDisplay = TextEditingController();

  //display step two controller

  //step two controller
  TextEditingController bankController = TextEditingController();
  TextEditingController noRekController = TextEditingController();
  TextEditingController kotaBankController = TextEditingController();

  //
  TextEditingController bankDisplay = TextEditingController();

  //open modal to get a list
  final cdBloc = CompleteDataBloc();
  bool isLoading = true;

  @override
  void initState() {
    sumberDanaController.addListener(() {
      final data = sumberDanaController.text;
      final convert = int.tryParse(data);
      cdBloc.sumberDanaController.sink.add(convert!);
    });

    jenisJobController.addListener(() {
      final data = jenisJobController.text;
      cdBloc.jenisPekerjaanController.sink.add(data);
    });

    jabatanController.addListener(() {
      final data = jabatanController.text;
      cdBloc.jabatanController.sink.add(data);
    });
    bidangUsahaController.addListener(() {
      final data = bidangUsahaController.text;
      cdBloc.bidangUsahaController.sink.add(data);
    });

    provinsiController.addListener(() {
      final data = provinsiController.text;
      final convert = int.tryParse(data);
      kabupatenKotaController.clear();
      kabupatenKotaDisplay.clear();
      cdBloc.changeProvinsi(convert!);
    });

    kabupatenKotaController.addListener(() {
      final data = kabupatenKotaController.text;
      final convert = int.tryParse(data);
      cdBloc.kotaController.sink.add(convert!);
    });

    bankController.addListener(() {
      final data = bankController.text;
      final convert = int.tryParse(data);
      cdBloc.bankController.sink.add(convert!);
      cdBloc.bankNameController.sink.add(bankDisplay.text);
    });

    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => cdBloc.messageStream)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    cdBloc.initGetMasterData();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    cdBloc.dispose();
    super.dispose();
  }

  @override
  //main screen
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const LoadingDanain();
    }
    return stepContent == 2 ? formStepTwo(context) : formStepOne(context);
  }

  Widget formStepOne(BuildContext context) {
    return Scaffold(
        appBar: previousTitle(context, 'Informasi Pekerjaan'),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild?.unfocus();
            }
          },
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: stepOneBody(context),
          ),
        ));
  }

  //main body
  Widget stepOneBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          alertDataAman(context),
          const SizedBox(height: 16),
          formSumberPenghasilan(context),
          const SizedBox(height: 16),
          formJenisPekerjaan(context),
          const SizedBox(height: 16),
          formJabatan(context),
          const SizedBox(height: 16),
          formBidangUsaha(context),
          const SizedBox(height: 16),
          formNamaPerusahaan(context),
          const SizedBox(height: 16),
          formAlamatPerusahaan(context),
          const SizedBox(height: 16),
          formProvinsi(context),
          const SizedBox(height: 16),
          formKabupatenKota(context),
          const SizedBox(height: 16),
          formKodePos(context),
          const SizedBox(height: 16),
          formLamaKerja(context),
          const SizedBox(height: 16),
          formPenghasilanBulanan(context),
          const SizedBox(height: 16),
          formBiayaHidup(context),
          const SizedBox(height: 32),
          buttonStep1(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Stream<void> handleMessage(message) async* {
    if (message is CompleteDataSuccess) {
      BuildContext? dialogContext;

      unawaited(
        showDialog(
          context: context,
          builder: (context) {
            dialogContext = context;
            return const ModalPopUpNoClose(
              icon: 'assets/images/icons/check.svg',
              title: 'Data Pendukung Berhasil Disimpan',
              message:
                  'Mulai nikmati layanan lengkap kami dan  rasakan pengalaman terbaik Anda.',
            );
          },
        ),
      );
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (dialogContext != null) {
            Navigator.of(dialogContext!).pop();
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.routeName,
              (route) => false,
            );
          }
        },
      );
    } else if (message is CompleteDataError) {
      context.showSnackBarError(message.message);
    } else {
      context.showSnackBarError('Invalid information');
    }
  }

  Widget buttonStep1(BuildContext context) {
    return StreamBuilder<bool>(
      stream: cdBloc.step1Button,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        return ButtonNormal(
          btntext: 'Lanjut',
          color: isValid ? null : HexColor('#ADB3BC'),
          action: isValid
              ? () {
                  setState(() {
                    stepContent = 2;
                  });
                }
              : null,
        );
      },
    );
  }

  //text field form
  Widget formSumberPenghasilan(BuildContext context) {
    return StreamBuilder<int>(
      stream: cdBloc.sumberDanaStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Sumber Dana'),
            const SizedBox(height: 4),
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
                        builder: (BuildContext context) => ModalBottomListItem2(
                          sumberDanaController,
                          sumberDanaDisplay,
                          cdBloc.sumberDanaList.value,
                          'Pilih Sumber Dana',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: sumberDanaDisplay,
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Sumber Dana',
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
                        text: snapshot.error! as String,
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

  Widget formJenisPekerjaan(BuildContext context) {
    return StreamBuilder<String>(
      stream: cdBloc.jenisPekerjaanStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Jenis Pekerjaan'),
            const SizedBox(height: 4),
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
                        builder: (BuildContext context) => ModalBottomListItem2(
                          jenisJobController,
                          jenisJobDisplay,
                          cdBloc.jenisPekerjaanList.value,
                          'Pilih Jenis Pekerjaan',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: jenisJobDisplay,
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Jenis Pekerjaan',
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
                        text: snapshot.error! as String,
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

  Widget formJabatan(BuildContext context) {
    return StreamBuilder<String>(
      stream: cdBloc.jabatanStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Jabatan'),
            const SizedBox(height: 4),
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
                        builder: (BuildContext context) => ModalBottomListItem2(
                          jabatanController,
                          jabatanDisplay,
                          cdBloc.jabatanList.value,
                          'Pilih Jabatan',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: jabatanDisplay,
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Jabatan',
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
                        text: snapshot.error! as String,
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

  Widget formBidangUsaha(BuildContext context) {
    return StreamBuilder<String>(
      stream: cdBloc.bidangUsahaStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Bidang Usaha'),
            const SizedBox(height: 4),
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
                        builder: (BuildContext context) => ModalBottomListItem2(
                          bidangUsahaController,
                          bidangUsahaDisplay,
                          cdBloc.bidangUsahaList.value,
                          'Pilih Bidang Usaha',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: bidangUsahaDisplay,
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Bidang Usaha',
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
                        text: snapshot.error! as String,
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

  Widget formNamaPerusahaan(BuildContext context) {
    return StreamBuilder<String>(
      stream: cdBloc.namaPerusahaanStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nama Perusahaan'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                        fontFamily: 'Poppins', color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: Serba Mulya',
                      snapshot.hasError,
                    ),
                    controller: namaPerusahaanController,
                    onChanged: (value) => cdBloc.changePerusahaan(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
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

  Widget formAlamatPerusahaan(BuildContext context) {
    return StreamBuilder<String>(
      stream: cdBloc.alamatPerusahaanStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Alamat Perusahaan'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                        fontFamily: 'Poppins', color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: Kelapa Gading',
                      snapshot.hasError,
                    ),
                    controller: alamatPerusahaanController,
                    onChanged: (value) => cdBloc.changeCompanyAddress(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
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
      stream: cdBloc.provinsiStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Provinsi'),
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
                          cdBloc.provinsiList.value,
                          'Pilih Provinsi Perusahaan',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: provinsiDisplay,
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Provinsi Perusahaan',
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
                        text: snapshot.error! as String,
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

  Widget formKabupatenKota(BuildContext context) {
    return StreamBuilder<int?>(
      stream: cdBloc.kotaStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kabupaten/ Kota'),
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
                          kabupatenKotaController,
                          kabupatenKotaDisplay,
                          cdBloc.kotaList.valueOrNull ?? [],
                          'Pilih Kabupaten/Kota Perusahaan',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: kabupatenKotaDisplay,
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Kabupaten/Kota Perusahaan',
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
                        text: snapshot.error! as String,
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

  Widget formKodePos(BuildContext context) {
    return StreamBuilder<int>(
      stream: cdBloc.kodePosStream,
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
                    onChanged: (value) => cdBloc.changeKodePos(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
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

  Widget formLamaKerja(BuildContext context) {
    return StreamBuilder<int>(
      stream: cdBloc.lamaKerjaStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Lama Bekerja (tahun)'),
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
                      'Contoh: 2',
                      snapshot.hasError,
                    ),
                    controller: lamaKerjaController,
                    onChanged: (value) => cdBloc.changeLamaBekerja(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
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

  Widget formPenghasilanBulanan(BuildContext context) {
    return StreamBuilder<int>(
      stream: cdBloc.penghasilanBulananStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Penghasilan Perbulan'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumberTextInputFormatter()
                    ],
                    decoration: inputDecor(
                      context,
                      'Contoh: Rp 2.000.000',
                      snapshot.hasError,
                    ),
                    controller: penghasilanBulananController,
                    onChanged: (value) =>
                        cdBloc.changePenghasilanBulanan(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
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

  Widget formBiayaHidup(BuildContext context) {
    return StreamBuilder<int>(
      stream: cdBloc.biayaHidupStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Biaya Hidup Perbulan'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumberTextInputFormatter()
                    ],
                    decoration: inputDecor(
                      context,
                      'Contoh: Rp 2.000.000',
                      snapshot.hasError,
                    ),
                    controller: biayaHidupController,
                    onChanged: (value) => cdBloc.changeBiayaHidup(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
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

  //widget fro steptwo
  Widget formStepTwo(BuildContext context) {
    return Scaffold(
      appBar: previousTitleCustom(context, 'Informasi Akun Bank', () {
        setState(() {
          stepContent = 1;
        });
      }),
      body: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: stepTwoBody(context),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        height: 94,
        child: Column(
          children: [
            StreamBuilder<bool>(
              stream: cdBloc.buttonStep2,
              builder: (context, snapshot) {
                final isValid = snapshot.data ?? false;
                return ButtonNormal(
                  btntext: 'Verifikasi',
                  color: isValid ? null : Colors.grey,
                  action: isValid && !firstPress
                      ? () {
                          setState(() {
                            firstPress = !firstPress;
                          });
                          cdBloc.validateBank(context);
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              firstPress = !firstPress;
                            });
                          });
                        }
                      : null,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget stepTwoBody(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            alertStepTwo(context),
            const SizedBox(height: 24),
            formBank(context),
            const SizedBox(height: 16),
            formNoRekening(context),
            const SizedBox(height: 16),
            formKotaBank(context),
            const SizedBox(height: 36),
            annoutcementBank(context),
          ],
        ),
      ),
    );
  }

  Widget alertStepTwo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline2(text: 'Informasi Akun Bank'),
        const SizedBox(height: 8),
        Subtitle2(
          text:
              'Informasi rekening diperlukan untuk melakukan pencairan pinjaman di Danain',
          color: HexColor('#777777'),
        )
      ],
    );
  }

  Widget formBank(BuildContext context) {
    return StreamBuilder<int>(
      stream: cdBloc.bankStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nama Bank'),
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
                          bankController,
                          bankDisplay,
                          cdBloc.bankList.value,
                          'Pilih Bank',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: bankDisplay,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Bank',
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
                        text: snapshot.error! as String,
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

  Widget formNoRekening(BuildContext context) {
    return StreamBuilder<int>(
      stream: cdBloc.lamaKerjaStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nomor Rekening'),
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
                      'Contoh: 123123123123',
                      snapshot.hasError,
                    ),
                    controller: noRekController,
                    onChanged: (value) => cdBloc.changeNoRek(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
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

  Widget formKotaBank(BuildContext context) {
    return StreamBuilder<String>(
      stream: cdBloc.kotaBankStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kota Bank'),
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
                      'Contoh: Kelapa Gading',
                      snapshot.hasError,
                    ),
                    controller: kotaBankController,
                    onChanged: (value) => cdBloc.changeKotaBank(value),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
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

  Widget annoutcementBank(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HexColor('#FFF5F2'),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: HexColor('FDE8CF'),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 16, color: HexColor('#FF8829')),
          const SizedBox(width: 8),
          const Flexible(
            child: Subtitle3(
              text:
                  'Pastikan rekening bank Anda sudah sesuai. Danain tidak bertanggung jawab atas kesalahan transfer dana karena ketidaksesuaian rekening bank.',
              color: Color(0xff5F5F5F),
              align: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}
