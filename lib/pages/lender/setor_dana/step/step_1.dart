import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/lender/setor_dana/setor_dana_bloc.dart';
import 'package:flutter_danain/pages/lender/setor_dana/setor_dana_loading.dart';
import 'package:flutter_danain/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class Step1SetorDana extends StatefulWidget {
  final SetorDanaBloc setorBloc;
  const Step1SetorDana({super.key, required this.setorBloc});

  @override
  State<Step1SetorDana> createState() => _Step1SetorDanaState();
}

class _Step1SetorDanaState extends State<Step1SetorDana> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.setorBloc;
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        isLeading: true,
        title: 'Setor Dana',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Headline3500(text: 'Metode Setor Dana'),
              const SizedBox(height: 16),
              bankListWidget(bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget bankListWidget(SetorDanaBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.listBank,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Subtitle2(text: snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final data = snapshot.data ?? [];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.map((entry) {
              return GestureDetector(
                onTap: () {
                  bloc.getTutorial(entry['idBank'] ?? 0);
                  bloc.step.add(2);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: HexColor('#EEEEEE'),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              entry['image'],
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const ShimmerLong(
                                  height: 42,
                                  width: 42,
                                  radius: 8,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Subtitle2Extra(
                            text: entry['namaBank'],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }

        return const SetorDanaLoading();
      },
    );
  }

  String getBankImage(String bank) {
    final name = bank.toLowerCase();
    switch (name) {
      case 'bca':
        return 'assets/lender/bank/bca.svg';
      case 'bni':
        return 'assets/lender/bank/bni.svg';
      case 'atmbersama':
        return 'assets/lender/bank/atm_bersama.svg';
      default:
        return 'assets/lender/bank/bca.svg';
    }
  }
}
