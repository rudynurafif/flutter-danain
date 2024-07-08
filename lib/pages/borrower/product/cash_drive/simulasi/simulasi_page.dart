import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/component/complete_data/textfield_withMoney_component.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/pengajuan_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/simulasi/bloc/simulasi_bloc.dart';
import 'package:flutter_danain/utils/loading.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class SimulasiCashDriveParams {
  final bool isPengajuan;

  SimulasiCashDriveParams({required this.isPengajuan});
}

class SimulasiCashDrivePage extends StatefulWidget {
  static const routeName = '/simulasi_cash_drive';
  final bool isPengajuan;
  const SimulasiCashDrivePage({
    super.key,
    required this.isPengajuan,
  });

  @override
  State<SimulasiCashDrivePage> createState() => _SimulasiCashDrivePageState();
}

class _SimulasiCashDrivePageState extends State<SimulasiCashDrivePage> {
  final pengajuanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.bloc<SimulasiCashDriveBLoc>().getMaster();
    context.bloc<SimulasiCashDriveBLoc>().getBeranda();
    context.bloc<SimulasiCashDriveBLoc>().errorMessage.listen(
      (value) {
        context.showSnackBarError(value!);
      },
    );
    context.bloc<SimulasiCashDriveBLoc>().errorSimulasi.listen(
      (value) {
        if (value == Constants.get.errorServer) {
          context.showSnackBarError(value!);
        } else {
          setState(() {
            errorSimulasi = value;
          });
        }
      },
    );
    context.bloc<SimulasiCashDriveBLoc>().isLoading.listen(
      (value) {
        try {
          if (value == true) {
            context.showLoading();
          } else {
            context.dismiss();
          }
          print('valuenya bang $value');
        } catch (e) {
          context.dismiss();
        }
      },
    );
    Stream<int> debouncedStream(Stream<int> stream) {
      return stream.debounceTime(const Duration(milliseconds: 300));
    }

    final debouncedTnrStream = debouncedStream(
      context.bloc<SimulasiCashDriveBLoc>().tenor,
    );
    debouncedTnrStream.listen(
      (tnr) {
        context.bloc<SimulasiCashDriveBLoc>().postSimulasi(
              tnr: tnr,
            );
      },
    );
  }

  Timer? _debounce;

  void nilaiPinjamanChanged(String value) {
    setState(() {
      errorSimulasi = null;
    });
    final bloc = context.bloc<SimulasiCashDriveBLoc>();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (value.length >= 4) {
        final val = value.replaceAll('Rp ', '').replaceAll('.', '');
        bloc.nilaiPinjamanChange(int.tryParse(val)!);
      } else {
        bloc.nilaiPinjamanChange(0);
      }
    });
  }

  String? errorSimulasi;

  @override
  void dispose() {
    context.bloc<SimulasiCashDriveBLoc>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<SimulasiCashDriveBLoc>();
    return StreamBuilder<num>(
      stream: bloc.maksimalPinjaman,
      builder: (context, snapshot) {
        final maks = snapshot.data ?? 0;
        return WillPopScope(
          onWillPop: () async {
            if (maks > 0) {
              if (widget.isPengajuan) {
                await backAlert(context);
              } else {
                Navigator.pop(context);
              }
            } else {
              Navigator.pop(context);
            }
            return false;
          },
          child: Parent(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarWidget(
                context: context,
                isLeading: true,
                title: widget.isPengajuan
                    ? 'Pengajuan Pinjaman'
                    : 'Simulasi Pinjaman',
                leadingAction: () async {
                  if (maks > 0) {
                    if (widget.isPengajuan) {
                      await backAlert(context);
                    } else {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
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
                    pengajuanKendaraan(bloc),
                    const SpacerV(value: 24),
                    simulasiWidget(bloc),
                    const SpacerV(value: 16),
                    calculateWidget(bloc),
                    const SpacerV(value: 16),
                    alert(context),
                    const SpacerV(value: 24),
                    StreamBuilder(
                      stream: bloc.isValidButton,
                      builder: (context, snapshot) {
                        final isValid = snapshot.data ?? false;
                        return buttonKonfirmasi(bloc, isValid);
                      },
                    ),
                    const SpacerV(value: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> backAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ModalPopUpNoClose(
          icon: 'assets/images/icons/warning_red.svg',
          title: 'Batalkan Pengajuan',
          message: 'Data pengajuan yang sudah Anda isikan akan hilang.',
          actions: [
            ButtonWidget(
              paddingY: 9,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              titleColor: Colors.white,
              title: 'Lanjutkan Pengajuan',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SpacerV(value: 8),
            ButtonWidget(
              paddingY: 9,
              fontSize: 12,
              titleColor: HexColor(primaryColorHex),
              color: Colors.white,
              fontWeight: FontWeight.w500,
              title: 'Batal',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget pengajuanKendaraan(SimulasiCashDriveBLoc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<int>(
          stream: bloc.jenisKendaraan,
          builder: (context, snapshot) {
            final kendaraan = snapshot.data ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget(
                  text: 'Pilih Jenis Jaminan',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SpacerV(value: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KendaraanComponent(
                      current: kendaraan,
                      index: 1,
                      title: 'Mobil',
                      image: 'assets/images/icons/car.svg',
                      onTap: () {
                        if (kendaraan != 1) {
                          bloc.kendaraanChange(1);
                        }
                      },
                    ),
                    KendaraanComponent(
                      current: kendaraan,
                      index: 2,
                      title: 'Sepeda Motor',
                      image: 'assets/images/icons/motor.svg',
                      onTap: () {
                        if (kendaraan != 2) {
                          bloc.kendaraanChange(2);
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SpacerV(value: 24),
        const TextWidget(
          text: 'Data Aset',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SpacerV(),
        TextWidget(
          text:
              'Masukkan detail data aset dibawah ini. Semua data wajib diisi.',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: HexColor('#777777'),
        ),
        const SpacerV(value: 12),
        StreamBuilder<List<dynamic>>(
          stream: bloc.provinsiList,
          builder: (context, snapshot) {
            final listData = snapshot.data ?? [];
            return StreamBuilder<Map<String, dynamic>?>(
              stream: bloc.provinsi,
              builder: (context, snapshot) {
                return TextFormSelectSearch(
                  dataSelected: snapshot.data,
                  textDisplay: 'namaWilayah',
                  placeHolder: 'Pilih wilayah domisili',
                  modalTitle: 'Wilayah Anda',
                  label: 'Wilayah Domisili',
                  idDisplay: 'idWilayah',
                  listData: listData,
                  searchPlaceholder: 'Cari wilayah',
                  onSelect: (value) {
                    bloc.provinsiChange(value as Map<String, dynamic>);
                  },
                );
              },
            );
          },
        ),
        const SpacerV(value: 16),
        StreamBuilder<List<dynamic>>(
          stream: bloc.merekList,
          builder: (context, snapshot) {
            final list = snapshot.data ?? [];
            return StreamBuilder<Map<String, dynamic>?>(
              stream: bloc.merek,
              builder: (context, snapshot) {
                return TextFormSelectSearch(
                  dataSelected: snapshot.data,
                  textDisplay: 'namaMerek',
                  placeHolder: 'Pilih merek kendaraan',
                  label: 'Merek Kendaraan',
                  idDisplay: 'idMerek',
                  listData: list,
                  searchPlaceholder: 'Cari merek kendaraan',
                  onSelect: (value) {
                    bloc.merekChange(value as Map<String, dynamic>);
                  },
                );
              },
            );
          },
        ),
        const SpacerV(value: 16),
        StreamBuilder<List<dynamic>>(
          stream: bloc.tipeList,
          builder: (context, snapshot) {
            final list = snapshot.data ?? [];
            return StreamBuilder<Map<String, dynamic>?>(
              stream: bloc.tipe,
              builder: (context, snapshot) {
                return TextFormSelectSearch(
                  dataSelected: snapshot.data,
                  textDisplay: 'namaType',
                  placeHolder: 'Pilih tipe kendaraan',
                  label: 'Tipe Kendaraan',
                  idDisplay: 'idType',
                  listData: list,
                  searchPlaceholder: 'Cari tipe kendaraan',
                  onSelect: (value) {
                    bloc.tipeChange(value as Map<String, dynamic>);
                  },
                );
              },
            );
          },
        ),
        const SpacerV(value: 16),
        StreamBuilder<List<dynamic>>(
          stream: bloc.modelList,
          builder: (context, snapshot) {
            final list = snapshot.data ?? [];
            return StreamBuilder<Map<String, dynamic>?>(
              stream: bloc.model,
              builder: (context, snapshot) {
                return TextFormSelectSearch(
                  dataSelected: snapshot.data,
                  textDisplay: 'namaModel',
                  placeHolder: 'Pilih model kendaraan',
                  label: 'Model Kendaraan',
                  idDisplay: 'idModel',
                  listData: list,
                  searchPlaceholder: 'Cari model kendaraan',
                  onSelect: (value) {
                    bloc.modelChange(value as Map<String, dynamic>);
                  },
                );
              },
            );
          },
        ),
        const SpacerV(value: 16),
        StreamBuilder<List<dynamic>>(
          stream: bloc.tahunList,
          builder: (context, snapshot) {
            final list = snapshot.data ?? [];
            return StreamBuilder<Map<String, dynamic>?>(
              stream: bloc.tahun,
              builder: (context, snapshot) {
                return TextFormSelectSearch(
                  dataSelected: snapshot.data,
                  textDisplay: 'tahunProduksi',
                  placeHolder: 'Pilih tahun kendaraan',
                  label: 'Tahun Kendaraan',
                  idDisplay: 'tahunProduksi',
                  listData: list,
                  modalTitle: 'Tahun Kendaraan',
                  searchPlaceholder: 'Cari tahun Kendaraan',
                  onSelect: (value) {
                    bloc.tahunChange(value as Map<String, dynamic>);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget simulasiWidget(SimulasiCashDriveBLoc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          text: 'Simulasi Pinjaman',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SpacerV(value: 12),
        StreamBuilder<num>(
            stream: bloc.maksimalPinjaman,
            builder: (context, snapshot) {
              final maksPinjaman = snapshot.data ?? 0;
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: HexColor('#E9F6EB')),
                  color: HexColor('#F9FFFA'),
                ),
                child: Column(
                  children: [
                    const TextWidget(
                      text: 'Maksimal Pinjaman',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    const SpacerV(value: 4),
                    TextWidget(
                      text: rupiahFormat(maksPinjaman),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              );
            }),
        const SpacerV(value: 16),
        StreamBuilder<num>(
          stream: bloc.maksimalPinjaman,
          builder: (context, snapshot) {
            final maks = snapshot.data ?? 0;
            return Stack(
              children: [
                TextF(
                  hint: 'Nilai Pengajuan Pinjaman',
                  controller: pengajuanController,
                  keyboardType: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumberTextInputFormatterWithMax(maks),
                  ],
                  onChanged: nilaiPinjamanChanged,
                  hintColor: HexColor('#333333'),
                  hintText: 'Rp.0',
                  validator: (String? value) {
                    if (errorSimulasi != null) {
                      return '';
                    }
                    return null;
                  },
                ),
                ErrorText(error: errorSimulasi),
              ],
            );
          },
        ),
        const SpacerV(value: 16),
        const TextWidget(
          text: 'Lama Pinjaman',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        const SpacerV(),
        StreamBuilder<int>(
          stream: bloc.tenor,
          builder: (context, snapshot) {
            final tenorr = snapshot.data ?? 0;
            return StreamBuilder<List<dynamic>>(
              stream: bloc.tenorList,
              builder: (context, snapshot) {
                final listTenor = snapshot.data ?? [];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listTenor.map((e) {
                    return TenorComponent(
                      tenor: e['tenor'],
                      currentTenor: tenorr,
                      idTenor: e['idTenor'],
                      onSelect: (int tenor) {
                        if (tenor != tenorr) {
                          setState(() {
                            errorSimulasi = null;
                          });
                          bloc.nilaiPinjamanChange(0);
                          pengajuanController.clear();
                          bloc.tenorChange(tenor);
                        }
                      },
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget calculateWidget(SimulasiCashDriveBLoc bloc) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffF9FFFA),
        border: Border.all(
          color: HexColor('#E9F6EB'),
        ),
      ),
      child: StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.responseSimulasi,
          builder: (context, snapshot) {
            final data = snapshot.data ?? {};
            final bulanan = data['angsuranBulanan'] ?? {};
            final pelunasan = data['pelunasanAkhir'] ?? {};
            final pencairan = data['pencairan'] ?? {};
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DataPinjamanWidget(
                  title: 'Pencairan',
                  total: pencairan['total'] ?? 0,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ModalCloseIcon(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                text: 'Pencairan',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              const SpacerV(value: 16),
                              KeyValGeneral(
                                title: 'Pokok Pinjaman',
                                value: rupiahFormat(
                                    pencairan['pokokPinjaman'] ?? 0),
                              ),
                              const SpacerV(),
                              KeyValGeneral(
                                title: 'Biaya Administrasi',
                                value:
                                    rupiahFormat(pencairan['biayaAdmin'] ?? 0),
                              ),
                              const SpacerV(),
                              KeyValGeneral(
                                title: 'Biaya Asuransi',
                                value: rupiahFormat(
                                    pencairan['biayaAsuransi'] ?? 0),
                              ),
                              const SpacerV(),
                              KeyValGeneral(
                                title: 'Biaya Fiducia',
                                value: rupiahFormat(
                                    pencairan['biayaFiducia'] ?? 0),
                              ),
                              const SpacerV(),
                              const DividerWidget(height: 1, isDashed: true),
                              const SpacerV(),
                              KeyValTitle(
                                title: 'Total',
                                value: rupiahFormat(pencairan['total'] ?? 0),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SpacerV(value: 12),
                const DividerWidget(height: 1),
                const SpacerV(value: 12),
                DataPinjamanWidget(
                  title: 'Angsuran Bulanan',
                  total: bulanan['total'] ?? 0,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ModalCloseIcon(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                text: 'Angsuran Bulanan',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              const SpacerV(value: 16),
                              KeyValGeneral(
                                title: 'Bunga',
                                value: rupiahFormat(bulanan['bunga'] ?? 0),
                              ),
                              const SpacerV(),
                              KeyValGeneral(
                                title: 'Fee Jasa Mitra',
                                value:
                                    rupiahFormat(bulanan['feeJasaMitra'] ?? 0),
                              ),
                              const SpacerV(),
                              const DividerWidget(height: 1, isDashed: true),
                              const SpacerV(),
                              KeyValTitle(
                                title: 'Total',
                                value: rupiahFormat(
                                  bulanan['total'] ?? 0,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SpacerV(value: 12),
                const DividerWidget(height: 1),
                const SpacerV(value: 12),
                DataPinjamanWidget(
                  title: 'Pelunasan Akhir',
                  total: pelunasan['total'] ?? 0,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ModalCloseIcon(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                text: 'Pelunasan Akhir',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              const SpacerV(value: 16),
                              KeyValGeneral(
                                title: 'Pokok Pinjaman',
                                value: rupiahFormat(
                                  pelunasan['pokokPinjaman'] ?? 0,
                                ),
                              ),
                              const SpacerV(),
                              KeyValGeneral(
                                title: 'Bunga',
                                value: rupiahFormat(
                                  pelunasan['bunga'] ?? 0,
                                ),
                              ),
                              const SpacerV(),
                              KeyValGeneral(
                                title: 'Fee Jasa Mitra',
                                value: rupiahFormat(
                                  pelunasan['feeJasaMitra'] ?? 0,
                                ),
                              ),
                              const SpacerV(),
                              const DividerWidget(height: 1, isDashed: true),
                              const SpacerV(),
                              KeyValTitle(
                                title: 'Total',
                                value: rupiahFormat(
                                  pelunasan['total'] ?? 0,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }),
    );
  }

  Widget alert(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor('#FFF5F2'),
        border: Border.all(color: HexColor('#FDE8CF')),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: HexColor('#FF8829'),
          ),
          const SpacerH(value: 8),
          Flexible(
            child: TextWidget(
              text:
                  'Estimasi perhitungan dapat berubah sesuai dengan hasil verifikasi kondisi fisik kendaraan serta kebijakan dari Danain.',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: HexColor('#777777'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonKonfirmasi(SimulasiCashDriveBLoc bloc, bool isValid) {
    if (widget.isPengajuan) {
      return StreamBuilder<PengajuanCashDriveParams>(
        stream: bloc.params,
        builder: (context, snapshot) {
          return ButtonWidget(
            title: 'Lanjut',
            color: isValid ? null : HexColor('#ADB3BC'),
            onPressed: () {
              if (isValid) {
                Navigator.pushNamed(
                  context,
                  PengajuanCashDrivePage.routeName,
                  arguments: snapshot.data!,
                );
              }
            },
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class TenorComponent extends StatelessWidget {
  final int currentTenor;
  final int idTenor;
  final int tenor;
  final Function1<int, void> onSelect;
  const TenorComponent({
    super.key,
    required this.tenor,
    required this.currentTenor,
    required this.idTenor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = idTenor == currentTenor;
    Color colorText = isSelected ? HexColor('#28AF60') : HexColor('#777777');
    return GestureDetector(
      onTap: () {
        onSelect(idTenor);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: MediaQuery.of(context).size.width / 2.4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: HexColor('#BDDCCA'))
              : Border.all(color: HexColor('#DDDDDD')),
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? HexColor('#F4FEF5') : Colors.white,
        ),
        child: Column(
          children: [
            TextWidget(
              text: '${tenor.toString()} bulan',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: colorText,
            ),
            const SpacerV(value: 2),
          ],
        ),
      ),
    );
  }
}

class KendaraanComponent extends StatelessWidget {
  final int current;
  final int index;
  final String title;
  final String image;
  final VoidCallback onTap;
  const KendaraanComponent({
    super.key,
    required this.current,
    required this.index,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSvg = image.endsWith('svg');
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.4,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFFF0FFFB), Color(0x00F0FFFB)],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: current == index
                  ? HexColor(primaryColorHex)
                  : const Color(0xFFF1FCF4),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSvg
                ? SvgPicture.asset(
                    image,
                    width: 56,
                    height: 56,
                  )
                : Image.asset(
                    image,
                    width: 56,
                    height: 56,
                  ),
            const SpacerV(value: 6),
            TextWidget(
              text: title,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              align: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class DataPinjamanWidget extends StatelessWidget {
  final String title;
  final num total;
  final VoidCallback onTap;
  const DataPinjamanWidget({
    super.key,
    required this.title,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            const SpacerV(value: 4),
            InkWell(
              onTap: onTap,
              child: TextWidget(
                text: 'Lihat Detail >',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: HexColor(primaryColorHex),
              ),
            ),
          ],
        ),
        TextWidget(
          text: rupiahFormat(total),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }
}
