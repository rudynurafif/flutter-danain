import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/list_page.dart/component.dart';
import 'package:flutter_danain/utils/input_formatter.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/form/select_form.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/space_v.dart';
import 'package:flutter_danain/widgets/template/app_bar.dart';
import 'package:flutter_danain/widgets/template/parent.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:hexcolor/hexcolor.dart';

class Step3Aktivasi extends StatefulWidget {
  final AktivasiAkunBloc aktivasiBloc;
  const Step3Aktivasi({
    super.key,
    required this.aktivasiBloc,
  });

  @override
  State<Step3Aktivasi> createState() => _Step3AktivasiState();
}

class _Step3AktivasiState extends State<Step3Aktivasi> {
  final noRekController = TextEditingController();
  final kotaBankController = TextEditingController();
  String? errorNoRek;
  String? errorKotaBank;
  @override
  Widget build(BuildContext context) {
    final bloc = widget.aktivasiBloc;
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Informasi Akun Bank',
          leadingAction: () {
            bloc.step.add(1);
          },
        ),
      ),
      bottomNavigation: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StreamBuilder<bool>(
              stream: bloc.buttonStep3,
              builder: (context, snapshot) {
                final isValid = snapshot.data ?? false;
                return ButtonWidget(
                  title: 'Verifikasi',
                  color: isValid ? null : HexColor('#ADB3BC'),
                  onPressed: () {
                    if (isValid) {
                      bloc.getBankData();
                    }
                  },
                );
              },
            ),
          ),
          const SpacerV(value: 24),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerV(value: 24),
              const TextWidget(
                text: 'Informasi Akun Bank',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SpacerV(),
              TextWidget(
                text:
                    'Informasi rekening diperlukan untuk melakukan pencairan pinjaman di Danain',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: HexColor('#777777'),
              ),
              const SpacerV(value: 24),
              formNamaBank(bloc),
              const SpacerV(value: 16),
              formNoRek(bloc),
              const SpacerV(value: 16),
              formKotaBank(bloc),
              const SpacerV(value: 24),
              AlertComponent(
                message:
                    'Pastikan rekening bank Anda sudah sesuai. Danain tidak bertanggung jawab atas kesalahan transfer dana karena ketidaksesuaian rekening bank.',
                icon: Icon(
                  Icons.error_outline,
                  size: 16,
                  color: HexColor(primaryColorHex),
                ),
                borderColor: HexColor('#E9F6EB'),
                color: HexColor('#F9FFFA'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formNamaBank(AktivasiAkunBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.bankList,
      builder: (context, snapshot) {
        final listData = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.namaBank.stream,
          builder: (context, snapshot) {
            return TextFormSelectSearch(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih Bank',
              label: 'Nama Bank',
              idDisplay: 'id',
              listData: listData,
              searchPlaceholder: 'Cari Bank',
              onSelect: (value) {
                bloc.namaBank.add(value);
              },
            );
          },
        );
      },
    );
  }

  Widget formNoRek(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: noRekController,
          hintText: 'Contoh: 123123123',
          hint: 'Nomor Rekening',
          keyboardType: TextInputType.number,
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorNoRek = 'Nomor Rekening tidak valid';
              });
              bloc.noRekening.add(null);
            } else {
              setState(() {
                errorNoRek = null;
              });
              bloc.noRekening.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorNoRek),
      ],
    );
  }

  Widget formKotaBank(AktivasiAkunBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: kotaBankController,
          hintText: 'Contoh: Jakarta',
          hint: 'Kota Bank',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                errorKotaBank = 'Kota bank tidak valid';
              });
              bloc.kotaBank.add(null);
            } else {
              setState(() {
                errorKotaBank = null;
              });
              bloc.kotaBank.add(value);
            }
          },
          validator: (String? value) {
            if (value!.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(error: errorKotaBank),
      ],
    );
  }
}
