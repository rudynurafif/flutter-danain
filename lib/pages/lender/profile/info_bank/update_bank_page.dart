import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'info_bank_lender_bloc.dart';

class UpdateBankPage extends StatefulWidget {
  final InfoLenderBankBloc bBloc;
  const UpdateBankPage({
    super.key,
    required this.bBloc,
  });

  @override
  State<UpdateBankPage> createState() => _UpdateBankPageState();
}

class _UpdateBankPageState extends State<UpdateBankPage> {
  TextEditingController bankController = TextEditingController();
  TextEditingController bankDisplay = TextEditingController();

  TextEditingController noRekController = TextEditingController();
  TextEditingController kotaBankController = TextEditingController();
  bool isValidKota = true;
  bool isValidNoRek = true;
  @override
  void initState() {
    super.initState();
    final bloc = widget.bBloc;
    final listBank = bloc.listBank.valueOrNull ?? [];
    if (bloc.bankSelected.valueOrNull == null &&
        bloc.bankData.valueOrNull != null) {
      final bankData = bloc.bankData.valueOrNull ?? {};
      final select = listBank.firstWhereOrNull(
        (e) => e['id'] == bankData['idRekening'],
      );
      bloc.bankSelected.add(select);
    }

    if (bloc.cabang.valueOrNull != null) {
      kotaBankController.text = bloc.cabang.valueOrNull ?? '';
    }
    if (bloc.nomorRekening.valueOrNull != null) {
      noRekController.text = bloc.nomorRekening.valueOrNull ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Informasi Akun Bank', () {
        Navigator.pop(context);
      }),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: akunBankWidget(bloc),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // StreamBuilder<bool>(
            //   stream: bloc.buttonEditStream,
            //   builder: (context, snapshot) {
            //     final isValid = snapshot.data ?? false;
            //     return ButtonNormal(
            //       btntext:
            //           widget.action == 'Ubah' ? 'Ubah Akun Bank' : 'Simpan',
            //       color: isValid ? HexColor(lenderColor) : Colors.grey,
            //       action: isValid
            //           ? () {
            //               bloc.stepController.sink.add(2);
            //               //  bloc.updateBankLender();
            //             }
            //           : null,
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }

  Widget akunBankWidget(InfoLenderBankBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline1(text: 'Informasi Akun Bank'),
            const SizedBox(height: 4),
            const Subtitle1(
              text:
                  'Akun bank anda diperlukan untuk melakukan transaksi penarikan dana di aplikasi Danain',
              color: Color(0xff777777),
            ),
            const SizedBox(height: 24),
            bankFormWidget(bloc),
            const SizedBox(height: 16),
            formKotaBank(bloc),
            const SizedBox(height: 16),
            formNoRekening(bloc),
            const SizedBox(height: 16),
            formanRekening(bloc),
          ],
        ),
      ),
    );
  }

  Widget bankFormWidget(InfoLenderBankBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.listBank.stream,
      builder: (context, snapshot) {
        final listBank = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.bankSelected.stream,
          builder: (context, snapshot) {
            return TextFormSelectSearch(
              dataSelected: snapshot.data,
              textDisplay: 'nama',
              placeHolder: 'Pilih Bank',
              label: 'Nama Bank',
              idDisplay: 'id',
              listData: listBank,
              searchPlaceholder: 'Cari bank',
              onSelect: (value) {
                bloc.bankSelected.add(value);
              },
            );
          },
        );
      },
    );
  }

  Widget formKotaBank(InfoLenderBankBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: kotaBankController,
          hint: 'Cabang',
          hintText: 'Contoh: Jakarta Utara',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                isValidKota = false;
              });
            } else {
              setState(() {
                isValidKota = true;
              });
            }
            bloc.cabang.add(value);
          },
          validator: (String? v) {
            final value = v ?? '';
            if (value.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(
          error: isValidKota ? null : 'Cabang tidak valid',
        ),
      ],
    );
  }

  Widget formNoRekening(InfoLenderBankBloc bloc) {
    return Stack(
      children: [
        TextF(
          controller: noRekController,
          hint: 'Nomor Rekening',
          hintText: 'Contoh: 0981237123',
          onChanged: (value) {
            if (value.length < 1) {
              setState(() {
                isValidNoRek = false;
              });
            } else {
              setState(() {
                isValidNoRek = true;
              });
            }
            bloc.nomorRekening.add(value);
          },
          validator: (String? v) {
            final value = v ?? '';
            if (value.length < 1) {
              return '';
            }
            return null;
          },
        ),
        ErrorText(
          error: isValidNoRek ? null : 'Nomor rekening tidak valid',
        ),
      ],
    );
  }

  Widget formanRekening(InfoLenderBankBloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Nama Pemilik Rekening'),
        const SizedBox(height: 4),
        StreamBuilder<String?>(
          stream: bloc.anRekening,
          builder: (context, snapshot) {
            final data = snapshot.data ?? '';
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: const Color(0xffD8D8D8),
                ),
                borderRadius: BorderRadius.circular(3),
                color: const Color(0xffF5F6F7),
              ),
              child: TextWidget(
                text: data.toUpperCase(),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff999999),
              ),
            );
          },
        )
      ],
    );
  }
}
