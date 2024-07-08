import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/bloc/pengajuan_bloc.dart';
import 'package:flutter_danain/utils/dimens.dart';
import 'package:flutter_danain/utils/input_formatter.dart';
import 'package:flutter_danain/widgets/form/date_form.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class StepAlamatBorrower extends StatefulWidget {
  final PengajuanCashDriveBloc pengajuanBloc;
  const StepAlamatBorrower({super.key, required this.pengajuanBloc});

  @override
  State<StepAlamatBorrower> createState() => _StepAlamatBorrowerState();
}

class _StepAlamatBorrowerState extends State<StepAlamatBorrower> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final alamatController = TextEditingController();
  final detailAlamatController = TextEditingController();

  bool alamatValid = true;
  bool detailAlamatValid = true;

  @override
  void initState() {
    super.initState();
    final bloc = widget.pengajuanBloc;
    if (bloc.alamat.hasValue) {
      alamatController.text = bloc.alamat.value!;
    }
    if (bloc.alamatDetail.hasValue) {
      detailAlamatController.text = bloc.alamatDetail.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.pengajuanBloc;
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          leadingAction: () {
            bloc.step.add(1);
          },
          title: 'Pengajuan Pinjaman',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerV(value: 24),
                const TextWidget(
                  text: 'Alamat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SpacerV(),
                TextWidget(
                  text: 'Masukan alamat tinggal saat ini.',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: HexColor('#777777'),
                ),
                const SpacerV(value: 16),
                StreamBuilder<List<dynamic>>(
                  stream: bloc.masterProvinsi,
                  builder: (context, snapshot) {
                    final listData = snapshot.data ?? [];
                    return StreamBuilder<Map<String, dynamic>?>(
                      stream: bloc.provinsi,
                      builder: (context, snapshot) {
                        return TextFormSelectSearch(
                          dataSelected: snapshot.data,
                          textDisplay: 'namaProvinsi',
                          placeHolder: 'Pilih provinsi',
                          label: 'Provinsi',
                          idDisplay: 'idProvinsi',
                          listData: listData,
                          searchPlaceholder: 'Cari provinsi',
                          onSelect: (value) {
                            bloc.provinsi.add(value as Map<String, dynamic>);
                          },
                        );
                      },
                    );
                  },
                ),
                const SpacerV(value: 16),
                StreamBuilder<List<dynamic>>(
                  stream: bloc.masterKota,
                  builder: (context, snapshot) {
                    final listData = snapshot.data ?? [];
                    return StreamBuilder<Map<String, dynamic>?>(
                      stream: bloc.kota,
                      builder: (context, snapshot) {
                        return TextFormSelectSearch(
                          dataSelected: snapshot.data,
                          textDisplay: 'namaKabupaten',
                          placeHolder: 'Pilih Kota/Kabupaten',
                          label: 'Kabupaten',
                          idDisplay: 'idKabupaten',
                          listData: listData,
                          searchPlaceholder: 'Cari Kota/Kabupaten',
                          onSelect: (value) {
                            bloc.kota.add(value as Map<String, dynamic>);
                          },
                        );
                      },
                    );
                  },
                ),
                const SpacerV(value: 16),
                alamatLengkapForm(bloc),
                const SpacerV(value: 16),
                detailLainnya(bloc),
                const SpacerV(value: 24),
                tglSurveyWidget(bloc),
                const SpacerV(value: 24),
                buttonSimpan(bloc),
                const SpacerV(value: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonSimpan(PengajuanCashDriveBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.buttonAlamat,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        return ButtonWidget(
          title: 'Simpan',
          color: isValid ? null : HexColor('#ADB3BC'),
          onPressed: () {
            if (isValid) {
              showDialog(
                context: context,
                builder: (context) {
                  return Builder(
                    builder: (dialogContext) {
                      return ModalPopUpNoClose2(
                        icon: 'assets/images/icons/warning_red.svg',
                        title: 'Konfirmasi Pengajuan',
                        message:
                            'Pastikan data yang Anda masukkan sudah sesuai',
                        actions: [
                          ButtonWidget(
                            title: 'Lanjutkan',
                            paddingY: 7,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            titleColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              bloc.postPengajuan();
                            },
                          ),
                          const SpacerV(value: 4),
                          ButtonWidget(
                            title: 'Cek Ulang Data',
                            paddingY: 7,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            titleColor: HexColor(primaryColorHex),
                            onPressed: () => Navigator.pop(dialogContext),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Widget alamatLengkapForm(PengajuanCashDriveBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: 'Alamat Lengkap',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: HexColor('#AAAAAA'),
        ),
        const SpacerV(),
        Stack(
          children: [
            SizedBox(
              height: 100,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: alamatController,
                style: TextStyle(
                  fontSize: Dimens.bodyMedium,
                  color: HexColor('#333333'),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
                onChanged: (value) {
                  if (value.length < 1) {
                    setState(() {
                      alamatValid = false;
                    });
                  } else {
                    setState(() {
                      alamatValid = true;
                    });
                  }
                  bloc.alamat.add(value);
                },
                validator: (String? value) {
                  if (value!.length < 1) {
                    return '';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat lengkap',
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                  ),
                  alignLabelWithHint: true,
                  isDense: true,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HexColor('#AAAAAA'),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Dimens.space12,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffDDDDDD),
                      width: 1.0,
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 247, 4, 4),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff288C50),
                      width: 1.0,
                    ),
                  ),
                  fillColor: Colors.grey,
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            if (alamatValid == false)
              const ErrorText(error: 'Alamat tidak valid')
          ],
        ),
      ],
    );
  }

  Widget alert(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF5F2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFFDE8CF)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: HexColor('#FF8829'),
            size: 16,
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Waktu survey mengikuti jam operasional Danain pada pukul ',
                    style: TextStyle(
                      color: Color(0xff777777),
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: '08.30 - 17.00 WIB',
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailLainnya(PengajuanCashDriveBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: detailAlamatController,
          hint: 'Detail Lainnya',
          hintText: 'Contoh: Warna rumah, patokan, dll',
          onChanged: (value) {
            bloc.alamatDetail.add(value);
            if (value.length < 1) {
              setState(() {
                detailAlamatValid = false;
              });
            } else {
              setState(() {
                detailAlamatValid = true;
              });
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        if (detailAlamatValid == false)
          const ErrorText(error: 'Alamat detail tidak valid')
      ],
    );
  }

  Widget tglSurveyWidget(PengajuanCashDriveBloc bloc) {
    return Column(
      children: [
        Row(
          children: [
            const TextWidget(
              text: 'Pengajuan Kedatangan Survey',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SpacerH(),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ModalCloseIcon(
                      child: TextWidget(
                        text:
                            'Tentukan waktu yang sesuai untuk kedatangan tim survey kami guna mengidentifikasi profil dan mengukur nilai kendaraan Anda.',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: HexColor('#AAAAAA'),
              ),
            )
          ],
        ),
        const SpacerV(value: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.4,
              child: StreamBuilder<String?>(
                stream: bloc.tglSurvey.stream,
                builder: (context, snapshot) {
                  return DateForm(
                    data: snapshot.data,
                    onSelect: (value) {
                      bloc.tglSurvey.add(value.toString());
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.4,
              child: StreamBuilder<String?>(
                stream: bloc.jamSurvey.stream,
                builder: (context, snapshot) {
                  return TimeForm(
                    data: snapshot.data,
                    onSelect: (value) {
                      bloc.jamSurvey.add(value.toString());
                    },
                  );
                },
              ),
            )
          ],
        ),
        const SpacerV(value: 16),
        alert(context),
      ],
    );
  }
}
