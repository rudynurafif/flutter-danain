import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/bloc/pengajuan_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/pengajuan_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class StepDetailKendaraan extends StatefulWidget {
  final PengajuanCashDriveBloc pengajuanBloc;
  const StepDetailKendaraan({
    super.key,
    required this.pengajuanBloc,
  });

  @override
  State<StepDetailKendaraan> createState() => _StepDetailKendaraanState();
}

class _StepDetailKendaraanState extends State<StepDetailKendaraan> {
  //controller
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final platController = TextEditingController();
  final stnkController = TextEditingController();
  final bpkbController = TextEditingController();

  bool validPlat = true;
  bool validStnk = true;
  bool validBpkb = true;

  @override
  void initState() {
    super.initState();
    final bloc = widget.pengajuanBloc;
    if (bloc.plat.hasValue) {
      platController.text = bloc.plat.value!;
    }
    if (bloc.noStnk.hasValue) {
      stnkController.text = bloc.noStnk.value!;
    }
    if (bloc.noBpkb.hasValue) {
      bpkbController.text = bloc.noBpkb.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Pengajuan Pinjaman',
          leadingAction: () async {
            await alertBack(context);
          },
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerV(value: 24),
                const TextWidget(
                  text: 'Detail Kendaraan',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SpacerV(),
                TextWidget(
                  text:
                      'Masukkan detail data kendaraan dibawah ini. Semua data wajib diisi.',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: HexColor('#777777'),
                ),
                const SpacerV(value: 16),
                anWidget(widget.pengajuanBloc),
                const SpacerV(value: 16),
                noPolForm(widget.pengajuanBloc),
                const SpacerV(value: 16),
                noStnkForm(widget.pengajuanBloc),
                const SpacerV(value: 16),
                fotoStnk(widget.pengajuanBloc),
                const SpacerV(value: 16),
                noBpkbForm(widget.pengajuanBloc),
                const SpacerV(value: 16),
                fotoBpkb(widget.pengajuanBloc),
                const SpacerV(value: 24),
                StreamBuilder<bool>(
                  stream: widget.pengajuanBloc.buttonKendaraan,
                  builder: (context, snapshot) {
                    final isValid = snapshot.data ?? false;
                    return ButtonWidget(
                      title: 'Lanjut',
                      color: isValid ? null : HexColor('#ADB3BC'),
                      onPressed: () {
                        if (isValid) {
                          widget.pengajuanBloc.step.add(2);
                        }
                      },
                    );
                  },
                ),
                const SpacerV(value: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget anWidget(PengajuanCashDriveBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: 'A.n. Kendaraan',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: HexColor('#AAAAAA'),
        ),
        const SpacerV(value: 4),
        StreamBuilder<int>(
          stream: bloc.anKendaraan.stream,
          builder: (context, snapshot) {
            final currentAn = snapshot.data ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnKendaraanComponent(
                      an: 'Milik Sendiri',
                      currentAn: currentAn,
                      idAn: 1,
                      onTap: () {
                        bloc.anKendaraan.add(1);
                      },
                    ),
                    StreamBuilder<Map<String, dynamic>?>(
                      stream: bloc.pasangan,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AnKendaraanComponent(
                            an: 'Milik Pasangan',
                            currentAn: currentAn,
                            idAn: 2,
                            onTap: () {
                              bloc.anKendaraan.add(2);
                            },
                          );
                        }
                        return const AnKendaraanDisable(
                          an: 'Milik Pasangan',
                        );
                      },
                    ),
                  ],
                ),
                StreamBuilder<Map<String, dynamic>?>(
                  stream: bloc.pasangan,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data ?? {};
                      if (currentAn == 2) {
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: HexColor('#F5F6F7'),
                          ),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          child: TextWidget(
                            text: data['namaLengkap'],
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HexColor('#999999'),
                          ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        )
      ],
    );
  }

  Widget noPolForm(PengajuanCashDriveBloc bloc) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                TextF(
                  hintText: 'Contoh: B 1996 YZ',
                  controller: platController,
                  hint: 'Nomor Polisi',
                  onChanged: (val) {
                    final valid = Validator.isValidPlat(val);
                    setState(() {
                      validPlat = valid;
                    });
                    bloc.plat.add(val);
                  },
                  inputFormatter: [UpperCaseTextFormatter()],
                  validator: (String? val) {
                    final valid = Validator.isValidPlat(val);

                    return valid ? null : '';
                  },
                ),
                if (!validPlat)
                  const ErrorText(error: 'Nomor polisi tidak valid'),
              ],
            ),
            const SpacerV(value: 4),
            TextWidget(
              text: 'Contoh : B 1996 YZ (menggunakan spasi)',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: HexColor('#777777'),
            )
          ],
        );
      },
    );
  }

  Widget noStnkForm(PengajuanCashDriveBloc bloc) {
    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        children: [
          TextF(
            hintText: 'Contoh: 12345678',
            controller: stnkController,
            hint: 'Nomor STNK',
            onChanged: (val) {
              final valid = Validator.isValidLength(val, 8);
              setState(() {
                validStnk = valid;
              });
              bloc.noStnk.add(val);
            },
            keyboardType: TextInputType.number,
            inputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (String? val) {
              final valid = Validator.isValidLength(val, 8);
              return valid ? null : '';
            },
          ),
          if (!validStnk) const ErrorText(error: 'Nomor STNK tidak valid'),
        ],
      );
    });
  }

  Widget fotoStnk(PengajuanCashDriveBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.fotoStnk.stream,
      builder: (context, snapshot) {
        return TextFormFile(
          label: 'Foto STNK',
          isCheck: snapshot.hasData,
          onTap: () async {
            final cameras = await availableCameras();
            final firstCamera = cameras.first;
            final picturePath = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraWidget(
                  camera: firstCamera,
                  typeCamera: 'STNK',
                ),
              ),
            );
            if (picturePath != null) {
              bloc.postFile(TypeFile.stnk, picturePath.toString());
            }
          },
        );
      },
    );
  }

  Widget noBpkbForm(PengajuanCashDriveBloc bloc) {
    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        children: [
          TextF(
            hintText: 'Contoh: 12345678',
            controller: bpkbController,
            hint: 'Nomor BPKB',
            onChanged: (val) {
              final valid = Validator.isValidLength(val, 8);
              setState(() {
                validBpkb = valid;
              });
              bloc.noBpkb.add(val);
            },
            keyboardType: TextInputType.number,
            inputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (String? val) {
              final valid = Validator.isValidLength(val, 8);
              return valid ? null : '';
            },
          ),
          if (!validBpkb) const ErrorText(error: 'Nomor BPKB tidak valid'),
        ],
      );
    });
  }

  Widget fotoBpkb(PengajuanCashDriveBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.fotoBpkb.stream,
      builder: (context, snapshot) {
        return TextFormFile(
          label: 'Foto BPKB',
          isCheck: snapshot.hasData,
          onTap: () async {
            final cameras = await availableCameras();
            final firstCamera = cameras.first;
            final picturePath = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraWidget(
                  camera: firstCamera,
                  typeCamera: 'BPKB',
                ),
              ),
            );
            if (picturePath != null) {
              bloc.postFile(TypeFile.bpkb, picturePath.toString());
            }
          },
        );
      },
    );
  }
}
