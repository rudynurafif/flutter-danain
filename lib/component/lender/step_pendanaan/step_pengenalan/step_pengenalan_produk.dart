import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_prevCustom.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengenalanProduk extends StatefulWidget {
  final PendanaanBloc pBloc;
  const PengenalanProduk({super.key, required this.pBloc});

  @override
  State<PengenalanProduk> createState() => _PengenalanProdukState();
}

class _PengenalanProdukState extends State<PengenalanProduk> {
  @override
  void initState() {
    widget.pBloc.getProduct();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    final bloc = widget.pBloc;
    return WillPopScope(
      child: Scaffold(
        appBar: previousCustomWidget(
          context,
          () async {
            Navigator.pop(context);
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('pendanaan', 1);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProdukDetail(bloc: bloc),
              // dividerFull(context),
              // const SizedBox(height: 8),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24),
              //   child: ContentMenu(
              //     image: 'assets/lender/portofolio/calculator.svg',
              //     title: 'Simulasi Pendanaan',
              //     subtitle:
              //         'Cek potensi bunga yang bisa Anda dapatkan di Danain',
              //     icon: true,
              //   ),
              // ),
              // dividerFull24(context),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Button1(
                  btntext: 'Mulai Mendanai',
                  color: HexColor(lenderColor),
                  action: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('pendanaan', 1);
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('pendanaan', 1);
        return false;
      },
    );
  }
}

class ProdukDetail extends StatelessWidget {
  final PendanaanBloc bloc;
  const ProdukDetail({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          produkPertama(),
          const SizedBox(height: 24),
          produkList(bloc),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget produkPertama() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/lender/pendanaan/produk.svg'),
          const SizedBox(height: 16),
          Headline1(
            text: 'Ada Produk Baru Nih!',
            color: HexColor(lenderColor),
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text:
                'Kini tersedia berbagai produk pendanaan yang menarik dengan tenor dan bunga yang bervariasi.',
            color: HexColor('#777777'),
            align: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget produkList(PendanaanBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<List<dynamic>>(
        stream: bloc.jenisProductStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            print('check response produck list $data');
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.asMap().entries.map((entry) {
                final index = entry.key;
                final reversedIndex = data.length - index - 1;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: reversedIndex == 0 ? 0 : 16,
                  ),
                  child: ProdukContent(
                    image: data[reversedIndex]['img'],
                    productName: data[reversedIndex]['namaProduk'],
                    ratePendana: data[reversedIndex]['ratePendana'].toDouble(),
                    tenor: data[reversedIndex]['namaProduk']
                            .toString()
                            .startsWith('C')
                        ? '${data[reversedIndex]['tenorDari']} - ${data[reversedIndex]['tenorSampai']}  bulan'
                        : '${data[reversedIndex]['tenorSampai']} hari',
                    agunan: data[reversedIndex]['jenisAgunan'],
                  ),
                );
              }).toList(),
            );
          }

          return const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: ProdukLoading(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: ProdukLoading(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: ProdukLoading(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProdukLoading extends StatelessWidget {
  const ProdukLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    ShimmerLong(height: 48, width: 48),
                    SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLong(height: 14, width: 120),
                        SizedBox(height: 8),
                        ShimmerLong(height: 12, width: 120),
                      ],
                    ),
                  ],
                ),
              ),
              SvgPicture.asset('assets/images/preference/bubble.svg'),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 0,
              right: 16,
              left: 16,
              bottom: 16,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.3,
                      color: const Color.fromARGB(142, 208, 208, 208),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLong(height: 11, width: 100),
                          SizedBox(height: 4),
                          ShimmerLong(height: 11, width: 100),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLong(height: 11, width: 100),
                        SizedBox(height: 4),
                        ShimmerLong(height: 11, width: 100),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProdukContent extends StatelessWidget {
  final String image;
  final String productName;
  final double ratePendana;
  final String tenor;
  final String agunan;
  const ProdukContent({
    super.key,
    required this.image,
    required this.productName,
    required this.ratePendana,
    required this.tenor,
    required this.agunan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    image.endsWith('.svg')
                        ? SvgPicture.network(
                            image,
                            width: 48,
                            height: 48,
                            placeholderBuilder: ((context) {
                              return Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey,
                                ),
                              );
                            }),
                          )
                        : Image.network(
                            image,
                            width: 48,
                            height: 48,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Headline4(text: productName),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: HexColor('#F1FCF4')),
                              child: Subtitle2Extra(
                                text: '$ratePendana%',
                                color: HexColor(lenderColor),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Subtitle2(
                              text: 'per annum',
                              color: Color(0xFFAAAAAA),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(productName.startsWith('C')
                  ? 'assets/lender/pendanaan/bubble_merah.svg'
                  : 'assets/images/preference/bubble.svg')
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 0,
              right: 16,
              left: 16,
              bottom: 16,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.3,
                      color: const Color.fromARGB(142, 208, 208, 208),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Subtitle3(
                            text: 'Tenor',
                            color: HexColor('#AAAAAA'),
                          ),
                          const SizedBox(height: 4),
                          Headline5(
                            text: tenor,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Subtitle3(
                          text: 'Agunan',
                          color: HexColor('#AAAAAA'),
                        ),
                        const SizedBox(height: 4),
                        Headline5(text: agunan)
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
