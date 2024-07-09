import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_bloc.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/utils/constants.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class StepRegistrasiLokasi extends StatefulWidget {
  final NewRegisterBloc regisBloc;
  const StepRegistrasiLokasi({super.key, required this.regisBloc});

  @override
  State<StepRegistrasiLokasi> createState() => _StepRegistrasiLokasiState();
}

class _StepRegistrasiLokasiState extends State<StepRegistrasiLokasi> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.regisBloc;
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          leadingAction: () {
            bloc.step.add(2);
          },
          context: context,
          isLeading: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    HelpTemporary.routeName,
                  );
                },
                child: TextWidget(
                  text: 'Bantuan',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Constants.get.borrowerColor,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigation: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                StreamBuilder<bool>(
                  stream: bloc.buttonStep3,
                  builder: (context, snapshot) {
                    final isValid = snapshot.data ?? false;
                    return ButtonWidget(
                      title: 'Lanjut Daftar',
                      color: isValid ? null : const Color(0xffADB3BC),
                      onPressed: () {
                        if (isValid) {
                          bloc.submit();
                        }
                      },
                    );
                  },
                ),
                const SpacerV(value: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: InkWell(
                    child: TextWidget(
                      text: 'Batal Daftar',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Constants.get.borrowerColor,
                    ),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        PreferencePage.routeName,
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpacerV(value: 24),
            const TextWidget(
              text: 'Pilih Wilayah Terdekat',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SpacerV(),
            const TextWidget(
              text:
                  'Pilih cakupan layanan Danain yang terdekat dengan lokasi Anda',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff777777),
            ),
            const SpacerV(value: 24),
            provinsiWidget(bloc),
            const SpacerV(value: 16),
            kotaWidget(bloc),
          ],
        ),
      ),
    );
  }

  Widget provinsiWidget(NewRegisterBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.listProvinsi,
      builder: (context, snapshot) {
        final listProvinsi = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.provinsi,
          builder: (context, snapshot) {
            return TextFormSelectSearch(
              dataSelected: snapshot.data,
              textDisplay: 'nama_provinsi',
              placeHolder: 'Pilih Provinsi',
              idDisplay: 'id_provinsi',
              listData: listProvinsi,
              searchPlaceholder: 'Cari Wilayah',
              onSelect: (value) {
                print(value);
                bloc.changeProvinsi(value);
              },
            );
          },
        );
      },
    );
  }

  Widget kotaWidget(NewRegisterBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.listKota,
      builder: (context, snapshot) {
        final listKota = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.kota.stream,
          builder: (context, snapshot) {
            return TextFormSelectSearch(
              dataSelected: snapshot.data,
              textDisplay: 'nama_kabupaten',
              placeHolder: 'Pilih Provinsi',
              idDisplay: 'id_kabupaten',
              listData: listKota,
              searchPlaceholder: 'Cari Kota',
              onSelect: (value) {
                bloc.kota.add(value);
              },
            );
          },
        );
      },
    );
  }
}
