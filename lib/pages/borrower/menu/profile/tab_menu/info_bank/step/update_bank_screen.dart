import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

class UpdateBankScreen extends StatefulWidget {
  final InformasiBankBloc bankBloc;
  const UpdateBankScreen({
    super.key,
    required this.bankBloc,
  });

  @override
  State<UpdateBankScreen> createState() => _UpdateBankScreenState();
}

class _UpdateBankScreenState extends State<UpdateBankScreen> {
  final noRekController = TextEditingController();
  final kotaController = TextEditingController();
  bool isValidRekening = true;
  bool isValidKota = true;
  late Map<String, dynamic>? bankSelected;
  @override
  void initState() {
    super.initState();
    final bloc = widget.bankBloc;
    final listBank = bloc.listBank.valueOrNull ?? [];
    final bankData = bloc.bank.valueOrNull ?? {};
    noRekController.text = bankData['no_rekening'] ?? '';
    kotaController.text = bankData['kota_bank'] ?? '';
    final Map<String, dynamic>? selected = listBank.firstWhereOrNull(
      (e) => e['id'] == bankData['id_bank'],
    );
    if (selected != null) {
      bankSelected = selected;
    } else {
      bankSelected = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bankBloc;
    bool isValid = isValidRekening && isValidKota && bankSelected != null;
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
            padding: const EdgeInsets.all(24),
            child: Button(
              title: 'Verifikasi',
              color: isValid ? null : const Color(0xffADB3BC),
              onPressed: () {
                if (isValid) {
                  bloc.updateBank(
                    idBank: bankSelected!['id'] ?? 0,
                    kota: kotaController.text,
                    noRek: noRekController.text,
                  );
                }
              },
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerV(value: 24),
              const Headline2(text: 'Informasi Akun Bank'),
              const SpacerV(value: 4),
              Subtitle2(
                text:
                    'Informasi rekening diperlukan untuk melakukan pencairan pinjaman di Danain',
                color: HexColor('#777777'),
              ),
              const SpacerV(value: 24),
              StreamBuilder<List<dynamic>>(
                stream: bloc.listBank.stream,
                builder: (context, snapshot) {
                  final list = snapshot.data ?? [];
                  return TextFormSelectSearch(
                    dataSelected: bankSelected,
                    searchPlaceholder: 'Cari Bank',
                    textDisplay: 'nama',
                    placeHolder: 'Pilih Bank',
                    label: 'Nama Bank',
                    onSelect: (value) {
                      setState(() {
                        bankSelected = value;
                      });
                    },
                    idDisplay: 'id',
                    listData: list,
                  );
                },
              ),
              const SpacerV(value: 16),
              Stack(
                children: [
                  TextF(
                    controller: noRekController,
                    hint: 'Nomor Rekening',
                    hintText: 'Nomor Rekening',
                    onChanged: (value) {
                      if (value.length < 1) {
                        setState(() {
                          isValidRekening = false;
                        });
                      } else {
                        setState(() {
                          isValidRekening = true;
                        });
                      }
                    },
                    validator: (String? value) {
                      final v = value ?? '';
                      if (v.length < 1) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  ErrorText(
                    error:
                        isValidRekening ? null : 'Nomor rekening tidak valid',
                  ),
                ],
              ),
              const SpacerV(value: 16),
              Stack(
                children: [
                  TextF(
                    controller: kotaController,
                    hint: 'Kota Bank',
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
                    },
                    validator: (String? value) {
                      final v = value ?? '';
                      if (v.length < 1) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  ErrorText(
                    error: isValidKota ? null : 'Kota bank tidak valid',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
