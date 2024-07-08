import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

import 'bloc/info_product_bloc.dart';

class InfoProduct extends StatefulWidget {
  static const routeName = '/info_product';
  const InfoProduct({super.key});

  @override
  State<InfoProduct> createState() => _InfoProductState();
}

class _InfoProductState extends State<InfoProduct> {
  @override
  void initState() {
    super.initState();
    context.bloc<InfoProductBloc>().getInfoProduct();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<InfoProductBloc>();
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Produk',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              StreamBuilder<List<dynamic>?>(
                stream: bloc.listProduct,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: TextWidget(
                        text: snapshot.error.toString(),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        align: TextAlign.center,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final data = snapshot.data ?? [];
                    return Column(
                      children: data
                          .map(
                            (e) => ProductDetail(
                              idProduk: e['idProduk'],
                              image: e['image'] ?? 'httpsadsda/sadas.com',
                              keterangan: e['keterangan'],
                            ),
                          )
                          .toList(),
                    );
                  }
                  return const Column(
                    children: [
                      ProdukDetailLoading(),
                      ProdukDetailLoading(),
                      ProdukDetailLoading(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  final int idProduk;
  final String image;
  final String keterangan;
  const ProductDetail({
    super.key,
    required this.idProduk,
    required this.image,
    required this.keterangan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: HexColor('#EEEEEE')),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            image,
            height: 101,
            width: 75,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ShimmerLong4(
                height: 101,
                width: 75,
              );
            },
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: keterangan,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: HexColor('#777777'),
                ),
                const SizedBox(height: 8),
                ButtonWidget(
                  title: 'Selengkapnya',
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width / 2.5,
                  titleColor: HexColor(primaryColorHex),
                  borderColor: HexColor(primaryColorHex),
                  paddingY: 7,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    print(idProduk);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProdukDetailLoading extends StatelessWidget {
  const ProdukDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: HexColor('#EEEEEE')),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ShimmerLong4(
            height: 101,
            width: 75,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLong4(
                height: 60,
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 8),
              ShimmerLong4(
                height: 32,
                width: MediaQuery.of(context).size.width / 2.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
