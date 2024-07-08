import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/component/complete_data/complete_data_component.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi_akun_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/list_page.dart/component.dart';
import 'package:flutter_danain/utils/input_formatter.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class Step1Aktivasi extends StatefulWidget {
  final AktivasiAkunBloc aktivasiBloc;
  const Step1Aktivasi({super.key, required this.aktivasiBloc});

  @override
  State<Step1Aktivasi> createState() => _Step1AktivasiState();
}

class _Step1AktivasiState extends State<Step1Aktivasi> {
  final namaPerusahaanController = TextEditingController();
  final alamatPerusahaanController = TextEditingController();
  final kodePosController = TextEditingController();
  final lamaKerjaController = TextEditingController();
  final penghasilanController = TextEditingController();
  final biayaHidupController = TextEditingController();

  //error text
  String? errorNamaPerusahaan;
  String? errorAlamatPerusahaan;
  String? errorKodePos;
  String? errorLamaKerja;
  String? errorPenghasilanBulanan;
  String? errorBiayaHidup;

  @override
  void initState() {
    super.initState();
    final bloc = widget.aktivasiBloc;
    if (bloc.namaPerusahaan.hasValue) {
      namaPerusahaanController.text = bloc.namaPerusahaan.value!;
    }
    if (bloc.alamatPerusahaan.hasValue) {
      alamatPerusahaanController.text = bloc.alamatPerusahaan.value!;
    }
    if (bloc.kodePos.hasValue) {
      kodePosController.text = bloc.kodePos.value!;
    }
    if (bloc.lamaKerja.hasValue) {
      lamaKerjaController.text = bloc.lamaKerja.value!;
    }
    if (bloc.penghasilan.hasValue) {
      final penghasilan = bloc.penghasilan.valueOrNull ?? 0;
      penghasilanController.text = rupiahFormat(penghasilan);
    }
    if (bloc.biayaHidup.hasValue) {
      final biayaHidup = bloc.biayaHidup.valueOrNull ?? 0;
      biayaHidupController.text = rupiahFormat(biayaHidup);
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
          title: 'Informasi Pekerjaan',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerV(value: 24),
              const AlertDataAman(
                title: 'Data Anda Dijamin Aman',
                subtitle:
                    'Kami meminta data sesuai dengan peraturan OJK. Data tidak akan diberikan kepada siapapun tanpa persetujuan Anda.',
              ),
              const SpacerV(value: 16),
              formSumberPengasilan(bloc),
              const SpacerV(value: 16),
              formJenisKerja(bloc),
              const SpacerV(value: 16),
              formJabatan(bloc),
              const SpacerV(value: 16),
              formBidangUsaha(bloc),
              const SpacerV(value: 16),
              formNamaPerusahaan(bloc),
              const SpacerV(value: 16),
              formAlamatPerusahaan(bloc),
              const SpacerV(value: 16),
              formProvinsi(bloc),
              const SpacerV(value: 16),
              formKota(bloc),
              const SpacerV(value: 16),
              formKodePos(bloc),
              const SpacerV(value: 16),
              formLamaKerja(bloc),
              const SpacerV(value: 16),
              formPenghasilanbulana(bloc),
              const SpacerV(value: 16),
              formBiayaHidup(bloc),
              const SpacerV(value: 16),
              buttonWidget(bloc),
              const SpacerV(value: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonWidget(AktivasiAkunBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.buttonStep1,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        return ButtonWidget(
          title: 'Lanjut',
          color: isValid ? null : HexColor('#ADB3BC'),
          onPressed: () {
            if (isValid) {
              bloc.step.add(2);
            }
          },
        );
      },
    );
  }

  Widget formSumberPengasilan(AktivasiAkunBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.sumberDanaList,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.sumberDana.stream,
          builder: (context, snapshot) {
            return TextFormSelect(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih sumber dana',
              label: 'Sumber Dana',
              idDisplay: 'id',
              listData: listData,
              onSelect: (value) {
                bloc.sumberDana.add(value);
              },
            );
          },
        );
      },
    );
  }

  Widget formJenisKerja(AktivasiAkunBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.jenisPekerjaanList,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.jenisKerja.stream,
          builder: (context, snapshot) {
            return TextFormSelect(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih Jenis Pekerjaan',
              label: 'Jenis Pekerjaan',
              idDisplay: 'id',
              listData: listData,
              onSelect: (value) {
                bloc.jenisKerja.add(value);
              },
            );
          },
        );
      },
    );
  }

  Widget formJabatan(AktivasiAkunBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.jabatanList,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.jabatan.stream,
          builder: (context, snapshot) {
            return TextFormSelect(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih Jabatan',
              label: 'Jabatan',
              idDisplay: 'id',
              listData: listData,
              onSelect: (value) {
                bloc.jabatan.add(value);
              },
            );
          },
        );
      },
    );
  }

  Widget formBidangUsaha(AktivasiAkunBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.bidangUsahaList,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.bidangUsaha.stream,
          builder: (context, snapshot) {
            return TextFormSelect(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih bidang usaha',
              label: 'Bidang Usaha',
              idDisplay: 'id',
              listData: listData,
              onSelect: (value) {
                bloc.bidangUsaha.add(value);
              },
            );
          },
        );
      },
    );
  }

  Widget formNamaPerusahaan(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: namaPerusahaanController,
          hintText: 'Contoh: Serba mulia grup',
          hint: 'Nama Perusahaan',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorNamaPerusahaan = 'Nama perusahaan tidak valid';
              });
              bloc.namaPerusahaan.add(null);
            } else {
              setState(() {
                errorNamaPerusahaan = null;
              });
              bloc.namaPerusahaan.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorNamaPerusahaan),
      ],
    );
  }

  Widget formAlamatPerusahaan(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: alamatPerusahaanController,
          hintText: 'Contoh: Jakarta selatan',
          hint: 'Alamat Perusahaan',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorAlamatPerusahaan = 'Alamat perusahaan tidak valid';
              });
              bloc.alamatPerusahaan.add(null);
            } else {
              setState(() {
                errorAlamatPerusahaan = null;
              });
              bloc.alamatPerusahaan.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorAlamatPerusahaan),
      ],
    );
  }

  Widget formProvinsi(AktivasiAkunBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.provinsiList,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.provinsi.stream,
          builder: (context, snapshot) {
            return TextFormSelectSearch(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih provinsi',
              label: 'Provinsi',
              idDisplay: 'id',
              listData: listData,
              searchPlaceholder: 'Cari provinsi',
              onSelect: (value) {
                bloc.provinsi.add(value);
                bloc.getKota(
                  value['id'],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget formKota(AktivasiAkunBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.kotaList,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.kota.stream,
          builder: (context, snapshot) {
            return TextFormSelectSearch(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih kabupaten/kota',
              label: 'Kabupaten/Kota',
              idDisplay: 'id',
              listData: listData,
              searchPlaceholder: 'Cari kabupaten/kota',
              onSelect: (value) {
                bloc.kota.add(value);
              },
            );
          },
        );
      },
    );
  }

  Widget formKodePos(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: kodePosController,
          hintText: 'Contoh: 11435',
          hint: 'Kode Pos',
          keyboardType: TextInputType.number,
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.length != 5) {
              setState(() {
                errorKodePos = 'Kode pos tidak valid';
              });
              bloc.kodePos.add(null);
            } else {
              setState(() {
                errorKodePos = null;
              });
              bloc.kodePos.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length != 5) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorKodePos),
      ],
    );
  }

  Widget formLamaKerja(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: lamaKerjaController,
          hintText: 'Contoh: 1',
          hint: 'Lama Bekerja (tahun)',
          keyboardType: TextInputType.number,
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorLamaKerja = 'Lama bekerja tidak valid';
              });
              bloc.lamaKerja.add(null);
            } else {
              setState(() {
                errorLamaKerja = null;
              });
              bloc.lamaKerja.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorLamaKerja),
      ],
    );
  }

  Widget formPenghasilanbulana(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: penghasilanController,
          hintText: 'Contoh: Rp.5.000.000',
          hint: 'Penghasilan Per Bulan',
          keyboardType: TextInputType.number,
          inputFormatter: [
            NumberTextInputFormatter(),
          ],
          onChanged: (value) {
            if (value.length <= 3) {
              penghasilanController.clear();
              bloc.penghasilan.add(null);
            } else {
              final val = value.replaceAll('Rp ', '').replaceAll('.', '');
              bloc.penghasilan.add(int.tryParse(val));
            }
          },
        ),
      ],
    );
  }

  Widget formBiayaHidup(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: biayaHidupController,
          hintText: 'Contoh: Rp.3.000.000',
          hint: 'Biaya Hidupt Per Bulan',
          keyboardType: TextInputType.number,
          inputFormatter: [
            NumberTextInputFormatter(),
          ],
          onChanged: (value) {
            if (value.length <= 3) {
              biayaHidupController.clear();
              bloc.biayaHidup.add(null);
            } else {
              final val = value.replaceAll('Rp ', '').replaceAll('.', '');
              bloc.biayaHidup.add(int.tryParse(val));
            }
          },
        ),
      ],
    );
  }
}
