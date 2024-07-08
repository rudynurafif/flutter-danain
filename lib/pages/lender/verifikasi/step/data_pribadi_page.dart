import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/checkbox/checkbox_widget.dart';
import 'package:flutter_danain/widgets/form/listItemForm.dart';
import 'package:flutter_danain/widgets/form/selectForm.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../../../data/constants.dart';
import '../../../../layout/appBar_previousTitleCustom.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/form/input_decoration.dart';
import '../../../../widgets/text/headline.dart';
import '../../../../widgets/text/subtitle.dart';
import '../verifikasi_bloc.dart';

class DataPribadiPage extends StatefulWidget {
  final VerifikasiBloc verifBloc;
  const DataPribadiPage({super.key, required this.verifBloc});

  @override
  State<DataPribadiPage> createState() => _DataPribadiPageState();
}

class _DataPribadiPageState extends State<DataPribadiPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noKtpController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirDisplay = TextEditingController();
  final TextEditingController namaIbuController = TextEditingController();
  final TextEditingController npwpController = TextEditingController();
  DateTime tglLahir = DateTime.now().subtract(const Duration(days: 18 * 365));
  String? gender;
  String npwpString = '';
  @override
  void initState() {
    // print('name value ku${widget.verifBloc.nameValue.value}');
    _nameController.text = widget.verifBloc.nameValue.hasValue
        ? widget.verifBloc.nameValue.value
        : '';
    _noKtpController.text = widget.verifBloc.noKtpValue.hasValue
        ? widget.verifBloc.noKtpValue.value
        : '';
    _tempatLahirController.text = widget.verifBloc.tempatLahirValue.hasValue
        ? widget.verifBloc.tempatLahirValue.value
        : '';
    if (widget.verifBloc.namaIbuValue.hasValue) {
      namaIbuController.text = widget.verifBloc.namaIbuValue.value!;
    }
    if (widget.verifBloc.npwpValue.hasValue) {
      npwpController.text = widget.verifBloc.npwpValue.value!;
      setState(() {
        npwpString = widget.verifBloc.npwpValue.value!;
      });
    }

    if (widget.verifBloc.tanggalLahirValue.hasValue) {
      final val = widget.verifBloc.tanggalLahirValue.value;
      setState(() {
        tglLahir = val;
      });
      tanggalLahirDisplay.text = dateFormat(val.toString());
    }
    setState(() {
      gender = widget.verifBloc.genderValue.hasValue
          ? widget.verifBloc.genderValue.value
          : '';
    });

    npwpController.addListener(() {
      final data = npwpController.text;
      setState(() {
        npwpString = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: previousTitleCustom(context, 'Data Pribadi', () {
          widget.verifBloc.stepControl(1);
        }),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                alertDataAman(context),
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
                statusPerkawinanForm(widget.verifBloc),
                const SizedBox(height: 16),
                agamaForm(widget.verifBloc),
                const SizedBox(height: 16),
                pendidikanForm(widget.verifBloc),
                const SizedBox(height: 16),
                namaIbuForm(widget.verifBloc),
                const SizedBox(height: 16),
                pekerjaanForm(widget.verifBloc),
                const SizedBox(height: 16),
                npwpForm(widget.verifBloc),
                const SizedBox(height: 16),
                penghasilanForm(widget.verifBloc),
                const SizedBox(height: 16),
                sumberPenghasilanForm(widget.verifBloc),
                const SizedBox(height: 16),
                tujuanForm(widget.verifBloc),
                const SizedBox(height: 16),
                buttonNext(widget.verifBloc),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ));
  }

  Widget alertDataAman(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffE9F6EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/icons/data_pribadi_lender.svg',
            width: 16,
            height: 16,
            color: HexColor(primaryColorHex),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Subtitle3(
                  text:
                      'Danain menjamin data Anda akan selalu aman pada sistem. Data akan digunakan sesuai dengan aturan',
                  color: HexColor('#777777'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget formNameKtp() {
    return StreamBuilder<String?>(
        stream: widget.verifBloc.nameErrorStream,
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: inputDecorLender(
                        context,
                        'Contoh: Jhon Dhoe',
                        snapshot.hasData,
                      ),
                      controller: _nameController,
                      onChanged: (value) => widget.verifBloc.nameChange(value),
                    ),
                    if (snapshot.hasData)
                      Padding(
                        padding: const EdgeInsets.only(top: 68),
                        child: Subtitle2(
                          text: snapshot.data!,
                          color: Colors.red,
                        ),
                      )
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget formKtp() {
    return StreamBuilder<String?>(
      stream: widget.verifBloc.ktpErrorStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nomor KTP'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: inputDecorLender(
                        context, 'Contoh: 120312312312312', snapshot.hasData),
                    controller: _noKtpController,
                    onChanged: (value) => widget.verifBloc.ktpChange(value),
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.data!,
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
      stream: widget.verifBloc.tempatLahirErrorStream,
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: inputDecorLender(
                      context,
                      'Contoh: Kebumen',
                      snapshot.hasData,
                    ),
                    controller: _tempatLahirController,
                    onChanged: (value) =>
                        widget.verifBloc.tempatLahirChange(value),
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.data!,
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

  void showTglLahir(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => modalTglLahir(context),
    );
  }

  Widget formTglLahir(BuildContext context) {
    return StreamBuilder<String?>(
      stream: widget.verifBloc.tanggalLahirErrorStream,
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
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: inputDecorWithIcon(
                          context,
                          'Pilih Tanggal Lahir',
                          snapshot.hasData,
                          Icons.calendar_today_outlined,
                        ),
                        controller: tanggalLahirDisplay,
                      ),
                    ),
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.data!,
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
                widget.verifBloc.tanggalLahirChange(tglLahir);
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
    return StreamBuilder<String?>(
      stream: widget.verifBloc.genderErrorStream,
      builder: (context, snapshot) {
        final hasError = snapshot.hasData;
        print('has errpr $hasError');
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(
              color: HexColor('#AAAAAA'),
              text: 'Jenis Kelamin',
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.verifBloc.genderChange('L');
                    print('l bang');
                  },
                  child: radioContent('Laki-laki', 'L', hasError),
                ),
                GestureDetector(
                  onTap: () {
                    widget.verifBloc.genderChange('P');
                    print('p bang');
                  },
                  child: radioContent('Perempuan', 'P', hasError),
                )
              ],
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Subtitle2(
                  text: snapshot.data!,
                  color: Colors.red,
                ),
              )
          ],
        );
      },
    );
  }

  Widget radioContent(String title, String value, bool hasError) {
    return StreamBuilder<String>(
      stream: widget.verifBloc.genderStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 't';
        return Container(
          width: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: hasError ? Colors.red : HexColor('#D8D8D8'),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: OvalBorder(
                    side: BorderSide(
                      width: data == value ? 4 : 1,
                      color:
                          data == value ? const Color(0xFF27AE60) : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SubtitleExtra(
                text: title,
                color: data == value ? Colors.black : HexColor('#BEBEBE'),
              )
            ],
          ),
        );
      },
    );
  }

  Widget statusPerkawinanForm(VerifikasiBloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.statusKawinStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalBottomListItemObject(
                  dataSelected: snapshot.data,
                  dataVal: statusKawinList,
                  label: 'Status Perkawinan',
                  actionSelect: (val) {
                    bloc.statusKawinChange(val);
                  },
                );
              },
            );
          },
          child: SelectFormContent(
            placeHolder: 'Pilih status perkawinan',
            dataSelected: snapshot.data,
            label: 'Status Perkawinan',
          ),
        );
      },
    );
  }

  Widget agamaForm(VerifikasiBloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.agamaStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalBottomListItemObject(
                  dataSelected: snapshot.data,
                  dataVal: agamaList,
                  label: 'Agama',
                  actionSelect: (val) {
                    bloc.agamaChange(val);
                  },
                );
              },
            );
          },
          child: SelectFormContent(
            placeHolder: 'Pilih Agama',
            dataSelected: snapshot.data,
            label: 'Agama',
          ),
        );
      },
    );
  }

  Widget pendidikanForm(VerifikasiBloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.pendidikanStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalBottomListItemObject(
                  dataSelected: snapshot.data,
                  dataVal: pendidikanList,
                  label: 'Pendidikan Terakhir',
                  actionSelect: (val) {
                    bloc.pendidikanChange(val);
                  },
                );
              },
            );
          },
          child: SelectFormContent(
            placeHolder: 'Pilih Pendidikan Terakhir',
            dataSelected: snapshot.data,
            label: 'Pendidikan Terakhir',
          ),
        );
      },
    );
  }

  Widget namaIbuForm(VerifikasiBloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Nama Asli Ibu Kandung'),
        const SizedBox(height: 4),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: inputDecorNoErrorLender(
                  context,
                  'Contoh: Ibu Jhon Doe',
                ),
                controller: namaIbuController,
                onChanged: (value) => bloc.namaIbuChange(value),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget pekerjaanForm(VerifikasiBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.pekerjaanList,
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>>(
          stream: bloc.pekerjaanStream,
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ModalBottomListItemObjectCustom(
                      dataSelected: snapshot.data,
                      dataVal: list,
                      label: 'Pekerjaan',
                      actionSelect: (val) {
                        bloc.pekerjaanChange(val);
                      },
                      idKey: 'idPekerjaan',
                    );
                  },
                );
              },
              child: SelectFormContentCustom(
                placeHolder: 'Pilih Pekerjaan',
                dataSelected: snapshot.data,
                label: 'Pekerjaan',
              ),
            );
          },
        );
      },
    );
  }

  Widget npwpForm(VerifikasiBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.npwpHideStream,
      builder: (context, snapshot) {
        final isHide = snapshot.data ?? false;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: !isHide,
              child: StreamBuilder<String?>(
                stream: bloc.npwpErrorStream,
                builder: (context, snapshot) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle3(color: HexColor('#AAAAAA'), text: 'NPWP'),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: inputDecorLender(
                                context,
                                'Contoh: 123456789012345',
                                snapshot.hasData,
                              ),
                              controller: npwpController,
                              onChanged: (value) => bloc.npwpChange(value),
                            ),
                            if (snapshot.hasData)
                              Padding(
                                padding: const EdgeInsets.only(top: 68),
                                child: Subtitle2(
                                  text: snapshot.data!,
                                  color: Colors.red,
                                ),
                              )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                bloc.npwpHideChange(!isHide);
              },
              child: checkBoxLender(
                isHide,
                Subtitle3(
                  text: 'Saya tidak memiliki NPWP',
                  color: HexColor('#777777'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget penghasilanForm(VerifikasiBloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.penghasilanStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalBottomListItemObject(
                  dataSelected: snapshot.data,
                  dataVal: penghasilanBulananList,
                  label: 'Besar Penghasilan',
                  actionSelect: (val) {
                    bloc.penghasilanChange(val);
                  },
                );
              },
            );
          },
          child: SelectFormContent(
            placeHolder: 'Pilih besar penghasilan',
            dataSelected: snapshot.data,
            label: 'Besar Penghasilan',
          ),
        );
      },
    );
  }

  Widget sumberPenghasilanForm(VerifikasiBloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.sumberPenghasilanStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalBottomListItemObject(
                  dataSelected: snapshot.data,
                  dataVal: sumberDanaList,
                  label: 'Sumber Penghasilan',
                  actionSelect: (val) {
                    bloc.sumberPenghasilanChange(val);
                  },
                );
              },
            );
          },
          child: SelectFormContent(
            placeHolder: 'Pilih sumber penghasilan',
            dataSelected: snapshot.data,
            label: 'Sumber Penghasilan',
          ),
        );
      },
    );
  }

  Widget tujuanForm(VerifikasiBloc bloc) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.tujuanStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalBottomListItemObject(
                  dataSelected: snapshot.data,
                  dataVal: tujuanPendanaanList,
                  label: 'Tujuan Pendanaan',
                  actionSelect: (val) {
                    bloc.tujuanChange(val);
                  },
                );
              },
            );
          },
          child: SelectFormContent(
            placeHolder: 'Pilih tujuan pendanaan',
            dataSelected: snapshot.data,
            label: 'Tujuan Pendanaan',
          ),
        );
      },
    );
  }

  Widget buttonNext(VerifikasiBloc bloc) {
    return StreamBuilder(
      stream: bloc.npwpHideStream,
      builder: (context, snapshot) {
        final isHide = snapshot.data ?? false;
        return StreamBuilder<bool>(
          stream: bloc.buttonDataPribadi,
          builder: (context, snapshot) {
            final isValid = snapshot.data ?? false;
            if (isValid == true && isHide == true) {
              return ButtonNormal(
                btntext: 'Lanjut',
                textcolor: Colors.white,
                action: () {
                  bloc.stepControl(3);
                },
              );
            } else if (isValid == true &&
                isHide == false &&
                npwpString.length == 15) {
              return ButtonNormal(
                btntext: 'Lanjut',
                textcolor: Colors.white,
                action: () {
                  bloc.stepControl(3);
                },
              );
            } else {
              return const ButtonNormal(
                btntext: 'Lanjut',
                color: Colors.grey,
                textcolor: Colors.white,
              );
            }
          },
        );
      },
    );
  }
}
