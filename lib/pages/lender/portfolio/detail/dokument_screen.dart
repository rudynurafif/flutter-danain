import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/detail_portofolio_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DokumentPerjanjianScreen extends StatefulWidget {
  final DetailPortoBloc dpBloc;
  const DokumentPerjanjianScreen({
    super.key,
    required this.dpBloc,
  });

  @override
  State<DokumentPerjanjianScreen> createState() =>
      _DokumentPerjanjianScreenState();
}

class _DokumentPerjanjianScreenState extends State<DokumentPerjanjianScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.dpBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Dokumen Perjanjian', () {
        bloc.stepChange(1);
      }),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: bloc.detailDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? {};
            if (data.containsKey('dokumen_perjanjian_lender')) {
              return PDF(
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: false,
                onError: (error) {
                  print(error.toString());
                },
                onPageError: (page, error) {
                  print('$page: ${error.toString()}');
                },
              ).fromUrl(
                data['dokumen_perjanjian_lender'],
              );
            }
            return const Center(
              child: Subtitle2(text: 'Maaf dokumen tidak tersedia'),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/lender/loading/danain.png'),
              const SizedBox(height: 16),
              const Subtitle2(text: 'Mohon Menunggu'),
            ],
          );
        },
      ),
    );
  }
}
