import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/component/verification/verification_component.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/verif_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class StatusList {
  final int id;
  final String display;

  StatusList({required this.id, required this.display});
}

class Step3Verif extends StatefulWidget {
  final StepVerifBloc stepBloc;
  const Step3Verif({Key? key, required this.stepBloc}) : super(key: key);

  @override
  State<Step3Verif> createState() => _Step3VerifState();
}

class _Step3VerifState extends State<Step3Verif>
    with AutomaticKeepAliveClientMixin {
  //controller to store data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noKtpController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  DateTime tglLahir = DateTime.now().subtract(const Duration(days: 18 * 365));
  int? gender;
  TextEditingController statusPerkawinanController = TextEditingController();
  TextEditingController pendidikanTerakhirController = TextEditingController();
  TextEditingController agamaController = TextEditingController();
  TextEditingController npwpController = TextEditingController();
  TextEditingController namaPasanganController = TextEditingController();
  TextEditingController ibuKandungController = TextEditingController();
  TextEditingController statusRumahController = TextEditingController();
  TextEditingController lamaTinggalController = TextEditingController();

  //controller penghias or for display
  TextEditingController tanggalLahirDisplay = TextEditingController();
  TextEditingController statusPerkawinanDisplay = TextEditingController();
  TextEditingController pendidikanTerakhirDisplay = TextEditingController();
  TextEditingController agamaDisplay = TextEditingController();
  TextEditingController statusRumahDisplay = TextEditingController();
  String? npwpHistory;

  //visible
  bool notHaveNpwp = false;

  void showTglLahir(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => modalTglLahir(context),
    );
  }

  @override
  void initState() {
    //agama change for validation
    agamaController.addListener(() {
      final data = int.tryParse(agamaController.text);
      widget.stepBloc.changeAgama(data!);
    });

    //pend terakhir change for validation
    pendidikanTerakhirController.addListener(() {
      final data = int.tryParse(pendidikanTerakhirController.text);
      widget.stepBloc.changePendTerakhir(data!);
    });

    //status kawin for validation
    statusPerkawinanController.addListener(() {
      final data = int.tryParse(statusPerkawinanController.text);
      widget.stepBloc.changeStatusKawin(data!);
    });

    //gender
    if (widget.stepBloc.genderController.hasValue) {
      setState(() {
        gender = widget.stepBloc.genderController.value;
      });
    }
    //status rumah for validation
    statusRumahController.addListener(() {
      final data = int.tryParse(statusRumahController.text);
      widget.stepBloc.changeStatusRumah(data!);
    });
    super.initState();
    initializeDateFormatting('id');
    final bloc = widget.stepBloc;

    //name
    _nameController.text =
        bloc.nameController.hasValue ? bloc.nameController.value : '';

    //ktp
    _noKtpController.text =
        bloc.noKtpController.hasValue ? bloc.noKtpController.value : '';
    _tempatLahirController.text = bloc.tempatLahirController.hasValue
        ? bloc.tempatLahirController.value
        : '';

    //npwp
    npwpController.text =
        bloc.npwpController.hasValue ? bloc.npwpController.value! : '';

    //nama pasangan
    namaPasanganController.text = bloc.namaPasanganController.hasValue
        ? bloc.namaPasanganController.value!
        : '';

    //ibu kandung
    ibuKandungController.text = bloc.ibuKandungController.hasValue
        ? bloc.ibuKandungController.value
        : '';

    //lama tinggal
    lamaTinggalController.text = bloc.lamaTinggalController.hasValue
        ? bloc.lamaTinggalController.value.toString()
        : '';

    setState(() {
      tglLahir = bloc.tglLahirController.hasValue
          ? bloc.tglLahirController.value
          : DateTime.now().subtract(const Duration(days: 18 * 365));
      gender = bloc.genderController.hasValue ? bloc.genderController.value : 0;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _nameController.dispose();
    _noKtpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            alertDataAman(context),
            const SizedBox(height: 24),
            headingPage(context),
            const SizedBox(height: 16),
            formNameKtp(),
            const SizedBox(height: 16),
            formKtp(),
            const SizedBox(height: 16),
            tempatLahirForm(),
            const SizedBox(height: 16),
            formTglLahir(context),
            const SizedBox(height: 16),
            formGender(context),
            const SizedBox(height: 16),
            formStatusPerkawinan(context),
            const SizedBox(height: 16),
            formPendTerakhir(context),
            const SizedBox(height: 16),
            formAgama(context),
            const SizedBox(height: 16),
            formNpwp(context),
            checkBoxNoNpwp(context),
            const SizedBox(height: 16),
            const Headline3500(text: 'Informasi Tambahan'),
            const SizedBox(height: 16),
            formNamaPasangan(context),
            const SizedBox(height: 16),
            formIbuKandung(context),
            const SizedBox(height: 16),
            formStatusRumah(context),
            const SizedBox(height: 16),
            formLamaTinggal(context),
            const SizedBox(height: 16),
            buttonNext(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget headingPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Data Diri'),
        const SizedBox(height: 8),
        Subtitle2(
          text:
              'Periksa kembali data KTP Anda, pastikan data yang dimasukkan sudah benar',
          color: HexColor('#777777'),
        ),
      ],
    );
  }

  Widget buttonNext(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.stepBloc.step3Button,
      builder: (context, snapshot) {
        final bool isValid = snapshot.data ?? false;
        return ButtonNormal(
          btntext: 'Lanjut',
          color: isValid ? null : Colors.grey,
          action: isValid
              ? () {
                  widget.stepBloc.stepController.add(3);
                }
              : null,
        );
      },
    );
  }

  Widget formNameKtp() {
    return StreamBuilder<String?>(
      stream: widget.stepBloc.nameStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nama Sesuai KTP'),
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
                      'Contoh: Jhon Dhoe',
                      snapshot.hasError,
                    ),
                    controller: _nameController,
                    onChanged: (value) => widget.stepBloc.changeName(value),
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

  Widget formKtp() {
    return StreamBuilder<String?>(
      stream: widget.stepBloc.ktpStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              color: HexColor('#AAAAAA'),
              text: 'Nomor KTP',
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecor(
                        context, 'Contoh: 120312312312312', snapshot.hasError),
                    controller: _noKtpController,
                    onChanged: (value) => widget.stepBloc.changenoKtp(value),
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

  Widget tempatLahirForm() {
    return StreamBuilder<String?>(
      stream: widget.stepBloc.tempatLahirStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Tempat Lahir'),
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
                      'Contoh: Kebumen',
                      snapshot.hasError,
                    ),
                    controller: _tempatLahirController,
                    onChanged: (value) =>
                        widget.stepBloc.changeTempatLahir(value),
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

  Widget formTglLahir(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: widget.stepBloc.tglLahirStream,
      builder: ((context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Tanggal Lahir'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      showTglLahir(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: inputDecorWithIcon(
                          context,
                          'Pilih Tanggal Lahir',
                          snapshot.hasError,
                          Icons.calendar_today_outlined,
                        ),
                        controller: tanggalLahirDisplay,
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
      }),
    );
  }

  Widget modalTglLahir(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Headline2500(
                    text: 'Tanggal Lahir',
                    align: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: HexColor('#AAAAAA'),
                  size: 16,
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.blue,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle:
                      TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (date) {
                    setState(() {
                      tglLahir = date;
                    });
                  },
                  initialDateTime: tglLahir,
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year - 17,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: ButtonNormal(
              btntext: 'Pilih',
              action: () {
                widget.stepBloc.changeTglLahir(tglLahir);
                tanggalLahirDisplay.text = DateFormat('dd MMMM yyyy', 'id')
                    .format(tglLahir)
                    .toString();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget formGender(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.stepBloc.genderStream,
      builder: (context, snapshot) {
        final hasError = snapshot.hasError;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Tanggal Lahir'),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                radioContent('Laki-laki', 1, hasError),
                radioContent('Perempuan', 2, hasError),
              ],
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Subtitle2(
                  text: snapshot.error! as String,
                  color: Colors.red,
                ),
              )
          ],
        );
      },
    );
  }

  Widget radioContent(String title, int value, bool hasError) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: hasError ? Colors.red : HexColor('#D8D8D8'),
        ),
      ),
      child: RadioListTile(
        fillColor: MaterialStatePropertyAll(HexColor(primaryColorHex)),
        activeColor: HexColor(primaryColorHex),
        contentPadding: const EdgeInsets.all(0),
        title: Subtitle2(text: title),
        value: value,
        groupValue: gender,
        onChanged: (value) {
          setState(() {
            gender = value;
          });
          widget.stepBloc.changegender(gender!);
        },
      ),
    );
  }

  Widget formStatusPerkawinan(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.stepBloc.statusKawinStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (var status in widget.stepBloc.statusPerkawinanList.value) {
            if (status['id'].toString() == snapshot.data.toString()) {
              statusPerkawinanController.text = status['id'].toString();
              statusPerkawinanDisplay.text = status['nama'];
              break;
            }
          }
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Status Perkawinan',
              color: HexColor('#AAAAAA'),
            ),
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
                          statusPerkawinanController,
                          statusPerkawinanDisplay,
                          widget.stepBloc.statusPerkawinanList.value,
                          'Pilih Status Perkawinan',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: statusPerkawinanDisplay,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Status Perkawinan',
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

  Widget formPendTerakhir(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.stepBloc.pendTerakhirStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (var pend in widget.stepBloc.pendTerakhirList.value) {
            if (pend['id'].toString() == snapshot.data.toString()) {
              pendidikanTerakhirController.text = pend['id'].toString();
              pendidikanTerakhirDisplay.text = pend['nama'];
              break;
            }
          }
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Pendidikan Terakhir',
              color: HexColor('#AAAAAA'),
            ),
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
                          pendidikanTerakhirController,
                          pendidikanTerakhirDisplay,
                          widget.stepBloc.pendTerakhirList.value,
                          'Pilih Pendidikan Terakhir',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: pendidikanTerakhirDisplay,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Pendidikan Terakhir',
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

  Widget formAgama(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.stepBloc.agamaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (var agama in widget.stepBloc.agamaList.value) {
            if (agama['id'].toString() == snapshot.data.toString()) {
              agamaController.text = agama['id'].toString();
              agamaDisplay.text = agama['nama'];
              break;
            }
          }
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Agama',
              color: HexColor('#AAAAAA'),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) => ModalBottomListItem2(
                    agamaController,
                    agamaDisplay,
                    widget.stepBloc.agamaList.value,
                    'Pilih Agama',
                  ),
                );
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: agamaDisplay,
                  style: const TextStyle(color: Colors.black),
                  decoration: inputDecorWithIconSvg(
                    context,
                    'Pilih Agama',
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
        );
      },
    );
  }

  Widget formNpwp(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.stepBloc.notHaveNpwpStream,
      builder: (context, snapshot) {
        final isShow = snapshot.data ?? false;
        return Visibility(
          visible: !isShow,
          child: StreamBuilder<String?>(
            stream: widget.stepBloc.npwpStream,
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle3(
                    text: 'NPWP',
                    color: HexColor('#AAAAAA'),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              widget.stepBloc.changeNpwp(value),
                          controller: npwpController,
                          decoration: inputDecor(
                            context,
                            'Contoh: 123456789012345',
                            snapshot.hasError,
                          ),
                        ),
                        if (snapshot.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 68),
                            child: Subtitle2(
                              text: snapshot.error! as String,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget checkBoxNoNpwp(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.stepBloc.notHaveNpwpStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? false;
        return GestureDetector(
          onTap: () {
            widget.stepBloc.changeNotHaveNpwp(!data);
          },
          behavior: HitTestBehavior.opaque,
          child: checkBoxBorrower(
            data,
            Subtitle3(
              text: 'Saya Tidak Memiliki NPWP',
              color: HexColor('#777777'),
            ),
          ),
        );
      },
    );
  }

  Widget formNamaPasangan(BuildContext context) {
    return StreamBuilder<String?>(
      stream: widget.stepBloc.namaPasanganStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
                color: HexColor('#AAAAAA'), text: 'Nama Pasangan(opsional)'),
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
                      'Contoh: Jhon Dhoe',
                      snapshot.hasError,
                    ),
                    controller: namaPasanganController,
                    onChanged: (value) =>
                        widget.stepBloc.changeNamaPasangan(value),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget formIbuKandung(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.stepBloc.ibuKandungStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nama Ibu Kandung'),
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
                      'Contoh: Alexandra',
                      snapshot.hasError,
                    ),
                    controller: ibuKandungController,
                    onChanged: (value) =>
                        widget.stepBloc.changeIbuKandung(value),
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

  Widget formStatusRumah(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.stepBloc.statusRumahStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('ada bang');
          print(snapshot.data);
        }
        for (var status in widget.stepBloc.statusRumahList.value) {
          if (status['id'].toString() == snapshot.data.toString()) {
            statusRumahController.text = status['id'].toString();
            statusRumahDisplay.text = status['nama'];
          }
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              text: 'Status Rumah',
              color: HexColor('#AAAAAA'),
            ),
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
                          statusRumahController,
                          statusRumahDisplay,
                          widget.stepBloc.statusRumahList.value,
                          'Pilih Status Rumah',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: statusRumahDisplay,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Status Rumah',
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

  Widget formLamaTinggal(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.stepBloc.lamaTinggalStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Lama Tinggal'),
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
                      'Contoh: 1',
                      snapshot.hasError,
                    ),
                    controller: lamaTinggalController,
                    onChanged: (value) {
                      final data = int.tryParse(value);
                      widget.stepBloc.changeLamaTinggal(data!);
                    },
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
