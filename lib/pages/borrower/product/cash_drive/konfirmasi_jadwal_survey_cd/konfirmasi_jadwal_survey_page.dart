import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_jadwal_survey_cd/konfirmasi_jadwal_survey_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_jadwal_survey_cd/konfirmasi_jadwal_survey_state.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/Cnd_component.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/devider.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';

class KonfirmasJadwalSurveyPage extends StatefulWidget {
  static const routeName = '/konfirmasi_jadwal_survey_page';
  final int idTaskPengajuan;
  final int idPengajuan;

  const KonfirmasJadwalSurveyPage({
    super.key,
    required this.idTaskPengajuan,
    required this.idPengajuan,
  });

  @override
  State<KonfirmasJadwalSurveyPage> createState() =>
      _KonfirmasJadwalSurveyPageState();
}

class _KonfirmasJadwalSurveyPageState extends State<KonfirmasJadwalSurveyPage>
    with DidChangeDependenciesStream, DisposeBagMixin {
  String valuePengajuan = '';
  bool isBack = false;

  @override
  void initState() {
    super.initState();
    context.bloc<KonfirmasiJadwalSurveyBloc>().getDataDetail(
          widget.idTaskPengajuan,
          widget.idPengajuan,
        );
    didChangeDependencies$
        .exhaustMap(
            (_) => context.bloc<KonfirmasiJadwalSurveyBloc>().messagePostDetail)
        .exhaustMap(handleMessagePostDetail)
        .collect()
        .disposedBy(bag);
  }

  Stream<void> handleMessagePostDetail(message) async* {
    if (message is KonfirmasiJadwalSurveySuccessMessage) {
      BuildContext? dialogContext;

      unawaited(
        showDialog(
          context: context,
          builder: (context) {
            dialogContext = context;
            return const ModalPopUpNoClose(
              icon: 'assets/images/icons/check.svg',
              title: 'Berhasil Konfirmasi',
              message: 'Berhasil konfirmasi jadwal survey',
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
    }

    if (message is KonfirmasiJadwalSurveyErrorMessage) {
      // ignore: use_build_context_synchronously
      context.showSnackBarError(message.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<KonfirmasiJadwalSurveyBloc>();
    return StreamBuilder<Map<String, dynamic>>(
      stream: bloc.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: previousTitleCustom(context, 'Detail Konfirmasi', () {
              Navigator.pop(context);
            }),
            body: Center(
              child: TextWidget(
                text: snapshot.error.toString(),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          final dataDetail = snapshot.data ?? {};
          return detailSurvey(dataDetail, bloc);
        }
        return Scaffold(
          appBar: previousTitleCustom(context, '', () {
            print(isBack);
            Navigator.pop(context);
          }),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget detailSurvey(
    Map<String, dynamic> dataDetail,
    KonfirmasiJadwalSurveyBloc bloc,
  ) {
    final int isStatus = dataDetail['isStatus'] ?? 0;
    if (isStatus == 2) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarWidget(
            context: context,
            isLeading: true,
            title: 'Detail Konfirmasi',
          ),
        ),
        body: SurveyConfirmationWidget(
          address: dataDetail['detailSurvey']['alamat'] ?? '',
          surveyTitle: '',
          contactName: dataDetail['detailSurvey']['namaSurveyor'] ?? '',
          contactNumber: dataDetail['detailSurvey']['tlpSurveyor'] ?? '',
          addressDetail: dataDetail['detailSurvey']['detailAlamat'] ?? '',
          surveyDate: dataDetail['detailSurvey']['date'] ?? '',
          isStatus: dataDetail['isStatus'] ?? 0,
          valuePengajuan: valuePengajuan,
        ),
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  bloc.postDataDetail();
                },
                child: const Button1(
                  btntext: 'Konfirmasi',
                ),
              ),
            ),
            const SpacerV(value: 24),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Pengajuan Pinjaman',
        ),
      ),
      body: PengajuanPinjamanCNDWidget(
        address: dataDetail['detailSurvey']['alamat'],
        surveyTitle: '',
        contactName: dataDetail['detailSurvey']['namaSurveyor'],
        contactNumber: dataDetail['detailSurvey']['tlpSurveyor'],
        addressDetail: dataDetail['detailSurvey']['detailAlamat'],
        surveyDate: dataDetail['detailSurvey']['date'],
        merk: dataDetail['detailKendaraan']['merek'],
        jenis: dataDetail['detailKendaraan']['jenisKendaraan'],
        tipe: dataDetail['detailKendaraan']['type'],
        valuePengajuan: dataDetail['detailSurvey']['nilaiPengajuan'],
        Qr: dataDetail['Qr'],
        noBPKB: dataDetail['detailKendaraan']['noBPKB'],
        noPolisi: dataDetail['detailKendaraan']['noPolisi'],
        tahunProduksi: dataDetail['detailKendaraan']['tahunProduksi'],
        cc: dataDetail['detailKendaraan']['cc'],
        model: dataDetail['detailKendaraan']['model'],
        noStnk: dataDetail['detailKendaraan']['stnk'],
        isStatus: isStatus,
        jenisKendaraan:
            dataDetail['detailKendaraan']['jenisKendaraan'] == 'Mobil' ? 1 : 2,
        imgSurveyor: dataDetail['detailSurvey']['imgSurveyor'],
      ),
    );
  }
}

Widget btmSheetPenyerahan(
  BuildContext context,
  String valueQr,
  String contactName,
  String imgSurveyor,
) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 42,
            height: 4,
            color: HexColor('#DDDDDD'),
          ),
        ),
        const SizedBox(height: 24),
        const Headline2500(text: 'Verifikasi Kunjungan'),
        const SizedBox(height: 8),
        Headline4500(
          text: 'Tunjukkan QR Code ini pada surveyor',
          color: HexColor('#777777'),
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QrImageView(
                data: valueQr,
                embeddedImage: const AssetImage(
                  'assets/images/logo/logo_splash.png',
                ),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(35, 35),
                ),
                size: 260,
              ),
              const SizedBox(height: 24),
              const DividerWidget(height: 1),
              const SizedBox(height: 24),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFDAF1DE), width: 1),
            color: const Color(0xFFF9FFFA),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgSurveyor,
                  fit: BoxFit.cover,
                  width: 65,
                  height: 65,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Subtitle2(
                    text: 'Nama Surveyor',
                    color: Color(0xFFAAAAAA),
                  ),
                  const SpacerV(value: 6),
                  TextWidget(
                    text: contactName,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget detailAgunan(
  BuildContext context,
  String valueQr,
  String contactName,
  String cc,
  String noBPKB,
  String noPolisi,
  String tahunProduksi,
  String merk,
  String jenis,
  String tipe,
  String model,
) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                color: HexColor('#DDDDDD'),
              ),
            ),
            const SizedBox(height: 24),
            const Headline2500(text: 'Detail Agunan'),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    jenis == 'Mobil'
                        ? 'assets/images/icons/square_icCar.svg'
                        : 'assets/images/icons/square_icMotor.svg',
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
                  const SpacerH(value: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Subtitle16500(
                        text: merk,
                      ),
                      const SpacerV(value: 6),
                      SubtitleExtra(
                        text: model,
                        color: HexColor('#333333'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Adjust padding as needed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailData('Jenis Kendaraan', jenis),
                        const SizedBox(height: 24),
                        detailData('Tahun Produksi', tahunProduksi),
                        const SizedBox(height: 24),
                        detailData('CC Kendaraan', cc),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Adjust padding as needed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailData('Nomor Polisi', noPolisi),
                        const SizedBox(height: 24),
                        detailData('Nomor STNK', '1.500'),
                        const SizedBox(height: 24),
                        detailData('Nomor BPKB', noBPKB),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget announcementNotice(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: HexColor('#FFF5F2'),
      borderRadius: BorderRadius.circular(8),
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
                'Pastikan Anda berada di lokasi sesuai dengan jadwal yang telah ditentukan ',
            color: Color(0xff5F5F5F),
            align: TextAlign.start,
          ),
        )
      ],
    ),
  );
}

class SurveyConfirmationWidget extends StatelessWidget {
  final String surveyTitle;
  final String contactName;
  final String contactNumber;
  final String address;
  final String addressDetail;
  final String surveyDate;
  final int isStatus;
  final String valuePengajuan;
  const SurveyConfirmationWidget({
    super.key,
    required this.surveyTitle,
    required this.contactName,
    required this.contactNumber,
    required this.address,
    required this.addressDetail,
    required this.surveyDate,
    required this.isStatus,
    required this.valuePengajuan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              text: 'Konfirmasi Jadwal Survey',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              align: TextAlign.center,
            ),
            const SpacerV(value: 16),
            KontakComponent(
              nasabahUtama: contactName,
              kontakUtama: contactNumber,
            ),
            const SpacerV(value: 16),
            LokasiComponent(
              alamatUtama: address,
              alamatDetail: addressDetail,
              tanggalSurvey: surveyDate,
              maps: '',
            ),
            const SpacerV(value: 16),
            announcementNotice(context),
          ],
        ),
      ),
    );
  }
}

class PengajuanPinjamanCNDWidget extends StatefulWidget {
  final String surveyTitle;
  final String contactName;
  final String contactNumber;
  final String address;
  final String addressDetail;
  final String surveyDate;
  final String merk;
  final String jenis;
  final String tipe;
  final num valuePengajuan;
  final String Qr;
  final String noBPKB;
  final String noPolisi;
  final String tahunProduksi;
  final String cc;
  final String model;
  final String noStnk;
  final int isStatus;
  final int jenisKendaraan;
  final String imgSurveyor;
  const PengajuanPinjamanCNDWidget({
    super.key,
    required this.surveyTitle,
    required this.contactName,
    required this.contactNumber,
    required this.address,
    required this.addressDetail,
    required this.surveyDate,
    required this.merk,
    required this.jenis,
    required this.tipe,
    required this.valuePengajuan,
    required this.Qr,
    required this.noBPKB,
    required this.noPolisi,
    required this.tahunProduksi,
    required this.cc,
    required this.model,
    required this.noStnk,
    required this.jenisKendaraan,
    required this.imgSurveyor,
    this.isStatus = 0,
  });

  @override
  State<PengajuanPinjamanCNDWidget> createState() =>
      _PengajuanPinjamanCNDWidgetState();
}

class _PengajuanPinjamanCNDWidgetState
    extends State<PengajuanPinjamanCNDWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // No padding for imageDetail
            imageDetail(context),
            const SpacerV(value: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  TextWidget(
                    text: widget.isStatus == 3
                        ? 'Menunggu Proses Survey'
                        : 'Pengajuan Sedang Dalam Proses',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    align: TextAlign.center,
                  ),
                  const SpacerV(),
                  TextWidget(
                    text:
                        'Selanjutnya Anda akan dihuhubungi oleh tim kami dan pastikan berada di tempat sesuai dengan jadwal kedatangan survey dan menyiapkan beberapa dokumen di bawah ini.',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#777777'),
                    align: TextAlign.center,
                  ),
                  const SpacerV(value: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SuratComponent(text: 'STNK'),
                      SuratComponent(text: 'BPKB'),
                      SuratComponent(text: 'Faktur (opsional)'),
                    ],
                  ),
                  const SpacerV(value: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SuratComponent(text: 'KTP Pasangan (opsional)'),
                      SuratComponent(text: 'Buku Tabungan'),
                    ],
                  ),
                  const SpacerV(value: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SuratComponent(text: 'Bon/Nota'),
                      SuratComponent(
                        text: 'PBB / Slip Pembayaran Listrik',
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SpacerV(value: 24),
            dividerFull(context),
            const SpacerV(value: 8),
            // Padding for the rest of the content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PinjamanComponent(
                    pengajuan: widget.valuePengajuan,
                    jenis: widget.jenis,
                    merk: widget.merk,
                    tipe: widget.tipe,
                    plat: widget.noPolisi,
                    model: widget.model,
                    tahun: widget.tahunProduksi,
                    cc: widget.cc,
                    noStnk: widget.noStnk,
                    noBpkb: widget.noBPKB,
                    jenisKendaraan: widget.jenisKendaraan,
                  ),
                  const SpacerV(value: 16),
                  LokasiComponent(
                    alamatUtama: widget.address,
                    alamatDetail: widget.addressDetail,
                    tanggalSurvey: widget.surveyDate,
                    maps: '',
                  ),
                  const SpacerV(value: 40),
                  buttonWidget(widget.isStatus),
                  const SpacerV(value: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(int status) {
    if (status >= 3 && status <= 4) {
      return Column(
        children: [
          ButtonWidgetCustom(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/transaction/icon_barcode.svg',
                ),
                const SpacerH(value: 10),
                const TextWidget(
                  text: 'Tampilkan QR Code',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (context) => btmSheetPenyerahan(
                    context, widget.Qr, widget.contactName, widget.imgSurveyor),
              );
            },
          ),
          const SpacerV(value: 16),
          ButtonWidget(
            color: HexColor('#FFFFFF'),
            borderColor: HexColor(borrowerColor),
            titleColor: HexColor(borrowerColor),
            title: 'Kembali ke Beranda',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.routeName,
                (route) => false,
              );
            },
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

Widget imageDetail(BuildContext context) {
  return LayoutBuilder(
    builder: (context, BoxConstraints constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        child: Image.asset(
          'assets/images/transaction/default_background.png',
          fit: BoxFit.fitWidth,
        ),
      );
    },
  );
}
