import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../utils/utils.dart';
import '../../../../../widgets/button/button.dart';
import '../../../../../widgets/divider/divider.dart';
import '../../../../../widgets/form/keyVal.dart';
import '../../../../../widgets/rupiah_format.dart';
import '../../../../../widgets/text/headline.dart';
import '../../../../../widgets/text/subtitle.dart';
import '../../../home/home_page.dart';
import 'detail_pencairan_bloc.dart';

class DetailPencairanPage extends StatefulWidget {
  static const routeName = '/detail_pencairan_page';
  final int? idjaminan;
  final int? idproduk;
  const DetailPencairanPage({super.key, this.idjaminan, this.idproduk});

  @override
  State<DetailPencairanPage> createState() => _DetailPencairanPageState();
}

class _DetailPencairanPageState extends State<DetailPencairanPage>
    with DidChangeDependenciesStream, DisposeBagMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as DetailPencairanPage?;
    if (args != null) {
      context
          .bloc<DetailPencairanBloc>()
          .getPinjamanControl(args.idjaminan!, args.idproduk!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DetailPencairanBloc>(context);
    return bodyBuilder(context, bloc);
  }

  Widget bodyBuilder(BuildContext context, DetailPencairanBloc bloc) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/process.svg'),
          const SizedBox(height: 32),
          const Headline1(text: 'Sedang Diproses'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Subtitle2(
              text:
                  'Mohon ditunggu ya, pencairan dana ke rekening Anda sedang diproses',
              color: HexColor('#777777'),
              align: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          dividerFull(context),
          const SizedBox(height: 8),
          StreamBuilder<Map<String, dynamic>>(
            stream: bloc.dataPinjamanStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data ?? {};
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: pinjamanDetail(data),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Headline3500(text: 'Detail Pencairan Pinjaman'),
                    const SizedBox(height: 16),
                    keyValLoading(context),
                    const SizedBox(height: 8),
                    keyValLoading(context),
                    const SizedBox(height: 8),
                    keyValLoading(context),
                    const SizedBox(height: 8),
                    keyValLoading(context),
                    const SizedBox(height: 8),
                    keyValLoading(context),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 94,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Button1(
            btntext: 'Kembali Ke Beranda',
            action: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePage.routeName, (Route<dynamic> route) => false);
            },
          ),
        ),
      ),
    );
  }

  Widget pinjamanDetail(Map<String, dynamic> data) {
    final double biayaAdmin = data['biaya_admin'].toDouble();
    final double totalPencairan = data['total_pencairan'].toDouble();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline3500(text: 'Detail Pencairan Pinjaman'),
        const SizedBox(height: 16),
        keyVal('Pinjaman', rupiahFormat(data['pinjaman_nominal'])),
        const SizedBox(height: 8),
        keyVal2Modified('Rekening Tujuan', data['rekening_tujuan']),
        const SizedBox(height: 8),
        keyVal('Biaya Administrasi', rupiahFormat(biayaAdmin.toInt())),
        const SizedBox(height: 8),
        keyVal2('Total Pencairan', rupiahFormat(totalPencairan.toInt())),
        const SizedBox(height: 8),
        keyVal('Waktu Pengajuan', formatDateFull2(data['waktu'])),
      ],
    );
  }
}
