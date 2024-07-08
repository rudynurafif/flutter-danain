import 'package:flutter/material.dart';
import 'package:flutter_danain/component/toko_emas/toko_emas_component.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TokoEmasReview extends StatefulWidget {
  final SupplierEmasBloc bloc;
  const TokoEmasReview({super.key, required this.bloc});

  @override
  State<TokoEmasReview> createState() => _TokoEmasReviewState();
}

class _TokoEmasReviewState extends State<TokoEmasReview> {
  List<int> ratingList = [5, 4, 3, 2, 1];

  @override
  Widget build(BuildContext context) {
    final spBloc = widget.bloc;
    return Scaffold(
      appBar: previousCustomWidget(context, () {
        spBloc.stepChange(1);
      }),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: spBloc.dataSupplier,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? {};
            final listRating = data['dataRating'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                section1(data),
                const SizedBox(height: 16),
                section2(spBloc, listRating),
                dividerFull(context),
                Expanded(
                  child: section3(spBloc),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget section1(Map<String, dynamic> tokoEmas) {
    return Container(
      color: HexColor('#E9F6EB'),
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tokoEmas['ratingSupplier'].toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Subtitle2(
                text: '${tokoEmas['totalRatingSupplier']} ulasan',
                color: HexColor('#999999'),
              )
            ],
          ),
          RatingStar(rating: tokoEmas['ratingSupplier'])
        ],
      ),
    );
  }

  Widget section2(SupplierEmasBloc spBloc, List<dynamic> reviews) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ratingList.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final item = entry.value;
            final total =
                reviews.where((review) => review['Nilai'] == item).length;
            final double leftMr = index == 0 ? 24 : 0;
            final double rightMr = index == ratingList.length - 1 ? 16 : 0;
            return StreamBuilder<int>(
              stream: spBloc.currentRating,
              builder: (context, snapshot) {
                final currentRating = snapshot.data ?? 0;
                return Container(
                  margin: EdgeInsets.only(left: leftMr, right: rightMr),
                  child: GestureDetector(
                    onTap: () {
                      spBloc.setCurrentRating(item);
                      spBloc.setCurrentList(
                        reviews
                            .where((review) => review['Nilai'] == item)
                            .toList(),
                      );
                    },
                    child: ratingBoxContent(
                      currentRating,
                      item,
                      total,
                    ),
                  ),
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }

  Widget ratingBoxContent(
    int current,
    int rating,
    int total,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 8),
      width: 86,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: current == rating
                  ? HexColor('#8EB69B')
                  : HexColor('#DDDDDD')),
          color: current == rating ? HexColor('#E9F6EB') : Colors.white,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: HexColor('#FFC600'),
            size: 16,
          ),
          const SizedBox(width: 5),
          SubtitleExtra(
            text: rating.toString(),
            color: HexColor('#333333'),
          ),
          const SizedBox(width: 2),
          Subtitle2Extra(
            text: '(${total.toString()})',
            color: HexColor('#999999'),
          )
        ],
      ),
    );
  }

  Widget section3(SupplierEmasBloc spBloc) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: StreamBuilder<List<dynamic>>(
        stream: spBloc.currentList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dataList = snapshot.data ?? [];
            if (dataList.length < 1) {
              return notFound();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final dataUser = dataList[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.3, color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          logoAndName(dataUser['InisialUser'] ?? '',
                              dataUser['NamaBorrower'] ?? ''),
                          Subtitle2(
                            text: dateFormat(dataUser['created_At']),
                            color: HexColor('#999999'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RatingStar(rating: dataUser['Nilai']),
                      const SizedBox(height: 8),
                      SubtitleExtra(
                        text: dataUser['Keterangan'],
                        color: HexColor('#777777'),
                      ),
                      const SizedBox(height: 17)
                    ],
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget notFound() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/empty_search.svg'),
          const SizedBox(height: 33),
          const Headline2(
            text: 'Belum Ada Ulasan',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text: 'Belum ada ulasan yang relevan untuk toko ini.',
            color: HexColor('#777777'),
            align: TextAlign.center,
          )
        ],
      ),
    );
  }
}
