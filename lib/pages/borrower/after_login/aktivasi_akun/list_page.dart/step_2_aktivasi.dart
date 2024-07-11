import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi.dart';
import 'package:flutter_danain/widgets/space_v.dart';
import 'package:flutter_danain/widgets/template/parent.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../utils/input_formatter.dart';
import '../../../../../widgets/button/button.dart';
import '../../../../../widgets/form/select_form.dart';
import '../../../../../widgets/form/text_field_widget.dart';
import '../../../../../widgets/template/app_bar.dart';

class Step2Aktivasi extends StatefulWidget {
  final AktivasiAkunBloc aktivasiBloc;
  const Step2Aktivasi({super.key, required this.aktivasiBloc});

  @override
  State<Step2Aktivasi> createState() => _Step2AktivasiState();
}

class _Step2AktivasiState extends State<Step2Aktivasi> {
  final namaLengkapKontakDaruratController = TextEditingController();
  final hubunganKontakDaruratController = TextEditingController();
  final noHandphoneKontakDaruratController = TextEditingController();
  final namaLengkapPasanganController = TextEditingController();
  final noKtpPasanganController = TextEditingController();
  final noHandphonePasanganController = TextEditingController();

  // error text
  String? errorNamaLengkapKontakDarurat;
  Map<String, dynamic>? errorHubunganKontakDarurat;
  String? errorNoHandphoneKontakDarurat;
  String? errorNamaLengkapPasangan;
  String? errorNoKtpPasangan;
  String? errorNoHandphonePasangan;

  @override
  void initState() {
    super.initState();
    final bloc = widget.aktivasiBloc;
    if (bloc.namaLengkapKontakDarurat.hasValue) {
      namaLengkapKontakDaruratController.text = bloc.namaLengkapKontakDarurat.value!;
    }
    // if (bloc.hubunganKontakDarurat.hasValue) {
    //   hubunganKontakDaruratController.value = bloc.hubunganKontakDarurat.value!;
    // }
    if (bloc.noHandphoneKontakDarurat.hasValue) {
      noHandphoneKontakDaruratController.text = bloc.noHandphoneKontakDarurat.value!;
    }
    if (bloc.namaLengkapPasangan.hasValue) {
      namaLengkapPasanganController.text = bloc.namaLengkapPasangan.value!;
    }
    if (bloc.noKtpPasangan.hasValue) {
      noKtpPasanganController.text = bloc.noKtpPasangan.value!;
    }
    if (bloc.noHandphonePasangan.hasValue) {
      noHandphonePasanganController.text = bloc.noHandphonePasangan.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.aktivasiBloc;
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Kontak Darurat',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerV(value: 28),
              const TextWidget(
                text: 'Kontak Darurat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SpacerV(value: 8),
              TextWidget(
                text: 'Masukkan detail data dibawah ini dengan benar. Semua data wajib diisi.',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: HexColor('#777777'),
              ),
              const SpacerV(value: 16),
              formNamaLengkapKontakDarurat(bloc),
              const SpacerV(value: 16),
              formHubunganKontakDarurat(bloc),
              const SpacerV(value: 16),
              formNoHandphoneKontakDarurat(bloc),
              const SpacerV(value: 24),
              const TextWidget(
                text: 'Data Pasangan',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SpacerV(value: 16),
              formNamaLengkapPasangan(bloc),
              const SpacerV(value: 16),
              formNoKtpPasangan(bloc),
              const SpacerV(value: 16),
              formNoHandphonePasangan(bloc),
              const SpacerV(value: 24),
              buttonWidget(bloc),
              const SpacerV(value: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget formNamaLengkapKontakDarurat(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: namaLengkapKontakDaruratController,
          hintText: 'Contoh: Siti',
          hint: 'Nama Lengkap',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorNamaLengkapKontakDarurat = 'Nama lengkap tidak valid';
              });
              bloc.namaLengkapKontakDarurat.add(null);
            } else {
              setState(() {
                errorNamaLengkapKontakDarurat = null;
              });
              bloc.namaLengkapKontakDarurat.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorNamaLengkapKontakDarurat),
      ],
    );
  }

  Widget formHubunganKontakDarurat(AktivasiAkunBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.hubunganList,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.hubunganKontakDarurat.stream,
          builder: (context, snapshot) {
            return TextFormSelect(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih hubungan',
              label: 'Hubungan',
              idDisplay: 'id',
              listData: listData,
              onSelect: (value) {
                bloc.hubunganKontakDarurat.add(value);
              },
            );
          },
        );
      },
    );
  }

  Widget formNoHandphoneKontakDarurat(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: noHandphoneKontakDaruratController,
          hintText: 'Contoh: 081234567890',
          hint: 'Nomor Handphone',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorNoHandphoneKontakDarurat = 'Nomor handphone tidak valid';
              });
              bloc.noHandphoneKontakDarurat.add(null);
            } else {
              setState(() {
                errorNoHandphoneKontakDarurat = null;
              });
              bloc.noHandphoneKontakDarurat.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorNoHandphoneKontakDarurat),
      ],
    );
  }

  Widget formNamaLengkapPasangan(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: namaLengkapPasanganController,
          hintText: 'Contoh: Putri Kusuma',
          hint: 'Nama Lengkap',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorNamaLengkapPasangan = 'Nama lengkap tidak valid';
              });
              bloc.namaLengkapPasangan.add(null);
            } else {
              setState(() {
                errorNamaLengkapPasangan = null;
              });
              bloc.namaLengkapPasangan.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorNamaLengkapPasangan),
      ],
    );
  }

  Widget formNoKtpPasangan(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: noKtpPasanganController,
          hintText: 'Contoh: 1123465768123456',
          hint: 'Nomor KTP',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorNoKtpPasangan = 'Nomor KTP tidak valid';
              });
              bloc.noKtpPasangan.add(null);
            } else {
              setState(() {
                errorNoKtpPasangan = null;
              });
              bloc.noKtpPasangan.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorNoKtpPasangan),
      ],
    );
  }

  Widget formNoHandphonePasangan(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: noHandphonePasanganController,
          hintText: 'Contoh: 081234567890',
          hint: 'Nomor Handphone',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorNoHandphonePasangan = 'Nomor handphone tidak valid';
              });
              bloc.noHandphonePasangan.add(null);
            } else {
              setState(() {
                errorNoHandphonePasangan = null;
              });
              bloc.noHandphonePasangan.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorNoHandphonePasangan),
      ],
    );
  }

  Widget buttonWidget(AktivasiAkunBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.buttonStep2,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        return ButtonWidget(
          title: 'Lanjut',
          color: isValid ? null : HexColor('#ADB3BC'),
          onPressed: () {
            if (isValid) {
              bloc.step.add(3);
            }
          },
        );
      },
    );
  }
}
