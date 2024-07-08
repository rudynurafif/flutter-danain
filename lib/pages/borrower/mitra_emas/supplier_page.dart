import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/supplier_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class SupplierEmasPage extends StatefulWidget {
  static const routeName = '/lokasi_supplier_emas';
  const SupplierEmasPage({super.key});

  @override
  State<SupplierEmasPage> createState() => _SupplierEmasPageState();
}

class _SupplierEmasPageState extends State<SupplierEmasPage> {
  @override
  void initState() {
    super.initState();
    context.bloc<GetSupplierBloc>().getSupplier();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<GetSupplierBloc>();
    return Scaffold(
      appBar: previousTitle(context, 'Lokasi Supplier Emas'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline3500(text: 'Mitra Supplier Emas'),
            const SizedBox(height: 8),
            Subtitle2(
              text: 'Mitra supplier emas saat ini baru tersedia di DKI Jakarta',
              color: HexColor('#555555'),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<dynamic>>(
              stream: bloc.dataStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Subtitle2(text: snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  final data = snapshot.data ?? {};
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.map((e) {
                      return MitraPenyimpananSupplier(
                        mitra: e['namaSupplier'],
                        address: e['alamatSupplier'],
                        maps: e['linkMaps'],
                      );
                    }).toList(),
                  );
                }
                return const MitraPenyempananLoading();
              },
            )
          ],
        ),
      ),
    );
  }
}

class MitraPenyimpananSupplier extends StatelessWidget {
  final String mitra;
  final String address;
  final String? maps;
  const MitraPenyimpananSupplier({
    super.key,
    required this.mitra,
    required this.address,
    required this.maps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: const Color(0xffF9FFFA),
          border: Border.all(
            width: 1,
            color: HexColor('#DAF1DE'),
          ),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Headline5(
            text: mitra,
            align: TextAlign.start,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text: address,
            align: TextAlign.start,
          ),
          const SizedBox(height: 16),
          Button2(
            btntext: 'Maps',
            color: Color(0xffF9FFFA),
            textcolor: Color(0xff24663F),
            action: () async {
              if (await canLaunch(maps!)) {
                await launch(maps!);
              } else {
                context.showSnackBarError('Maaf sepertinya terjadi kesalahan');
              }
            },
          )
        ],
      ),
    );
  }
}

class MitraPenyempananLoading extends StatelessWidget {
  const MitraPenyempananLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xffF9FFFA),
        border: Border.all(
          width: 1,
          color: HexColor('#DAF1DE'),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLong(height: 12, width: MediaQuery.of(context).size.width / 2),
          const SizedBox(height: 16),
          ShimmerLong(height: 32, width: MediaQuery.of(context).size.width),
          const SizedBox(height: 24),
          ShimmerLong4(height: 32, width: MediaQuery.of(context).size.width)
        ],
      ),
    );
  }
}
