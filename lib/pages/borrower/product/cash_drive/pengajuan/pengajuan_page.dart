import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/bloc/pengajuan_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/list_screen/step_alamat_borrower.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/list_screen/step_detail_kendaraan.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/list_screen/step_proses.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/proses/proses_pengajuan_page.dart';
import 'package:flutter_danain/utils/loading.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class PengajuanCashDriveParams {
  final int idJenisJaminan;
  final int idWilayah;
  final int idMerk;
  final String namaMerek;
  final int idType;
  final String namaType;
  final int idModel;
  final String namaModel;
  final String tahun;
  final num maksPinjaman;
  final int nilaiPengajuan;
  final int idTenor;
  final Map<String, dynamic> responseSimulasi;
  PengajuanCashDriveParams({
    required this.idJenisJaminan,
    required this.idWilayah,
    required this.idMerk,
    required this.namaMerek,
    required this.namaModel,
    required this.namaType,
    required this.idType,
    required this.idModel,
    required this.tahun,
    required this.maksPinjaman,
    required this.nilaiPengajuan,
    required this.idTenor,
    required this.responseSimulasi,
  });
}

class PengajuanCashDrivePage extends StatefulWidget {
  static const routeName = '/pengajuan_cash_drive';
  final PengajuanCashDriveParams params;
  const PengajuanCashDrivePage({
    super.key,
    required this.params,
  });

  @override
  State<PengajuanCashDrivePage> createState() => _PengajuanCashDrivePageState();
}

class _PengajuanCashDrivePageState extends State<PengajuanCashDrivePage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.bloc<PengajuanCashDriveBloc>();
    bloc.getProvinsi();
    bloc.getPasangan();
    bloc.paramsSimulasi.add(widget.params);
    bloc.isPostDone.listen(
      (value) async {
        await checkPengajuan(value);
      },
    );
    bloc.errorMessage.listen(
      (value) {
        if (value != null) {
          value.toToastError(context);
        }
      },
    );
    bloc.isLoading.listen(
      (value) {
        try {
          if (value == true) {
            context.showLoading();
          } else {
            context.dismiss();
          }
        } catch (e) {
          context.dismiss();
        }
      },
    );
  }

  Future<void> checkPengajuan(bool isDone) async {
    print('oke duluan');
    final bloc = context.bloc<PengajuanCashDriveBloc>();
    if (isDone == true) {
      bloc.step.add(3);
    } else {
      print('oke bang');
      await Future.delayed(Duration.zero);
      await showDialog(
        context: context,
        builder: (context) {
          return Builder(
            builder: (dialogContext) {
              return ModalPopUp(
                icon: 'assets/images/icons/warning_red.svg',
                title: 'Pengajuan Tidak Dapat Diproses',
                message:
                    'Saat ini terdapat pinjaman yang sedang dalam proses, harap tunggu hingga proses tersebut selesai sebelum mengajukan pinjaman baru.',
                actions: [
                  ButtonWidget(
                    title: 'Cek Pengajuan',
                    paddingY: 7,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    onPressed: () {
                      Navigator.popAndPushNamed(
                        dialogContext,
                        ProsesPengajuanPage.routeName,
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<PengajuanCashDriveBloc>();
    final listWidget = [
      StepDetailKendaraan(pengajuanBloc: bloc),
      StepAlamatBorrower(pengajuanBloc: bloc),
      StepProses(pengajuanBloc: bloc),
    ];
    return StreamBuilder<int>(
      stream: bloc.step.stream,
      builder: (context, snapshot) {
        final step = snapshot.data ?? 1;
        return WillPopScope(
          onWillPop: () async {
            if (step == 1) {
              await alertBack(context);
            }
            if (step == 2) {
              bloc.step.add(1);
            }
            if (step == 3) {
              await Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.routeName,
                (route) => false,
              );
            }
            return false;
          },
          child: listWidget[step - 1],
        );
      },
    );
  }
}

Future<void> alertBack(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return ModalPopUpNoClose(
        icon: 'assets/images/icons/warning_red.svg',
        title: 'Batalkan Pengisian Data',
        message: 'Data yang sudah Anda isikan akan hilang.',
        actions: [
          ButtonWidget(
            paddingY: 9,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            titleColor: Colors.white,
            title: 'Lanjutkan Pengisian',
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

class AnKendaraanComponent extends StatelessWidget {
  final int currentAn;
  final int idAn;
  final String an;
  final VoidCallback onTap;
  const AnKendaraanComponent({
    super.key,
    required this.an,
    required this.currentAn,
    required this.idAn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = idAn == currentAn;
    final Color colorText =
        isSelected ? HexColor('#28AF60') : HexColor('#777777');
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width / 2.4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: HexColor('#BDDCCA'))
              : Border.all(color: HexColor('#DDDDDD')),
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? HexColor('#F4FEF5') : Colors.white,
        ),
        child: TextWidget(
          text: an.toString(),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colorText,
        ),
      ),
    );
  }
}

class AnKendaraanDisable extends StatelessWidget {
  final String an;
  const AnKendaraanDisable({
    super.key,
    required this.an,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width / 2.4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: HexColor('#F5F6F7'),
      ),
      child: TextWidget(
        text: an.toString(),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: HexColor('#999999'),
      ),
    );
  }
}
