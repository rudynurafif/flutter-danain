import 'package:flutter/material.dart';
import 'package:flutter_danain/component/toko_emas/toko_emas_component.dart';
import 'package:flutter_danain/layout/appBar_Previous.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_bloc.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class TokoEmas extends StatelessWidget {
  final SupplierEmasBloc bloc;
  const TokoEmas({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousWidget(context),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.dataSupplier,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final toko = snapshot.data ?? {};
            final List<dynamic> listRating = toko['dataRating'];
            return Container(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Headline1(text: toko['namaSupplier']),
                    const SizedBox(height: 16),
                    Subtitle2(
                      text: toko['deskripsiSupplier'],
                      color: HexColor('#AAAAAA'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.fmd_good_outlined,
                          size: 16,
                          color: HexColor('#AAAAAA'),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Subtitle2(
                            text: toko['namaKota'],
                            color: HexColor('#AAAAAA'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Headline3500(text: 'Rating & Reviews'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 20,
                          color: HexColor('#FFC600'),
                        ),
                        const SizedBox(width: 8),
                        Headline2(text: toko['ratingSupplier'].toString()),
                        const SizedBox(width: 8),
                        Subtitle2(
                          text: '(${toko['totalRatingSupplier']} rating)',
                          color: HexColor('#AAAAAA'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    listReview(listRating),
                    const SizedBox(height: 16),
                    Center(
                      child: ButtonSmall1(
                        btntext: 'Lihat Semua',
                        action: () {
                          bloc.stepChange(2);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const TokoEmasLoading();
        },
      ),
    );
  }

  Widget listReview(List<dynamic> listData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listData.length < 2 ? listData.length : 2,
      itemBuilder: (context, index) {
        final dataUser = listData[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logoAndName(
                dataUser['InisialUser'] ?? '', dataUser['NamaBorrower'] ?? ''),
            const SizedBox(height: 8),
            RatingStar(rating: dataUser['Nilai']),
            const SizedBox(height: 8),
            SubtitleExtra(
              text: dataUser['Keterangan'],
              color: HexColor('#777777'),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        );
      },
    );
  }
}

class TokoEmasLoading extends StatelessWidget {
  const TokoEmasLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLong(
                height: 20, width: MediaQuery.of(context).size.width / 2),
            const SizedBox(height: 16),
            ShimmerLong(
              height: 12,
              width: MediaQuery.of(context).size.width,
            ),
            ShimmerLong(
              height: 12,
              width: MediaQuery.of(context).size.width,
            ),
            ShimmerLong(
              height: 12,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 12),
            ShimmerLong(
              height: 14,
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 24),
            ShimmerLong(
              height: 16,
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 16),
            ShimmerLong(
              height: 16,
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 24),
            listLoading(context),
            const SizedBox(height: 16),
            Center(
              child: ShimmerLong4(
                height: 24,
                width: MediaQuery.of(context).size.width / 3,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listLoading(BuildContext context) {
    final List<dynamic> data = [{}, {}, {}];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((e) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShimmerCircle(height: 32, width: 32),
                SizedBox(width: 8),
                ShimmerLong(height: 12, width: 66),
              ],
            ),
            SizedBox(height: 8),
            ShimmerLong(height: 12, width: 66),
            SizedBox(height: 8),
            ShimmerLong(height: 14, width: 66),
            SizedBox(height: 16)
          ],
        );
      }).toList(),
    );
  }
}
