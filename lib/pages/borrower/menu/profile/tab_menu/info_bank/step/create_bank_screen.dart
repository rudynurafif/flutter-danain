import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_bloc.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../../../../../data/constants.dart';

class CreateInfoBankPage extends StatefulWidget {
  static const routeName = '/create_bank_borrower';

  const CreateInfoBankPage({super.key});

  @override
  State<CreateInfoBankPage> createState() => _CreateInfoBankPageState();
}

class _CreateInfoBankPageState extends State<CreateInfoBankPage> {
  late InformasiBankBloc bankBloc;

  late Map<String, dynamic>? bankSelected;
  final noRekController = TextEditingController();
  final kotaController = TextEditingController();
  final namaController = TextEditingController();
  bool isValidRekening = true;
  bool isValidKota = true;
  bool isValidNama = true;
  @override
  void initState() {
    super.initState();
    bankBloc = BlocProvider.of<InformasiBankBloc>(context, listen: false);
    context.bloc<InformasiBankBloc>().getDataBank();
    final listBank = bankBloc.listBank.valueOrNull ?? [];
    final bankData = bankBloc.bank.valueOrNull ?? {};
    noRekController.text = bankData['no_rekening'] ?? '';
    kotaController.text = bankData['kota_bank'] ?? '';
    namaController.text = bankData['nama_pemilik_rekening'] ?? '';
    final Map<String, dynamic>? selected = listBank.firstWhereOrNull(
      (e) => e['id'] == bankData['id_bank'],
    );
    if (selected != null) {
      bankSelected = selected;
    } else {
      bankSelected = null;
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(
          text: message,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        backgroundColor: HexColor(borrowerColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isValid = isValidRekening && isValidKota && bankSelected != null;
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Informasi Akun Bank',
          leadingAction: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigation: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Button(
              title: 'Simpan',
              color: isValid ? null : const Color(0xffADB3BC),
              onPressed: () {
                if (isValid) {
                  bankBloc.createBank(
                    idBank: bankSelected!['id'] ?? 0,
                    kota: kotaController.text,
                    noRek: noRekController.text,
                    namaPemilik: namaController.text,
                  );
                  Navigator.pop(context);
                  showSnackbar(context, 'Berhasil menambahkan data bank!');
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
                text: 'Informasi rekening diperlukan untuk melakukan pencairan pinjaman di Danain',
                color: HexColor('#777777'),
              ),
              const SpacerV(value: 24),
              StreamBuilder<List<dynamic>>(
                stream: bankBloc.listBank.stream,
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
                    error: isValidRekening ? null : 'Nomor rekening tidak valid',
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
              const SpacerV(value: 16),
              Stack(
                children: [
                  TextF(
                    controller: namaController,
                    hint: 'Nama Pemilik Rekening',
                    hintText: 'Contoh: John Doe',
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
                    error: isValidNama ? null : 'Nama tidak valid',
                  ),
                ],
              ),
              const SpacerV(value: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: HexColor('#FFF5F2'),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: HexColor('FDE8CF'),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, size: 16, color: HexColor('#FF8829')),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Subtitle3(
                        text:
                            'Pastikan rekening bank sudah sesuai. Danain tidak bertanggung jawab atas kesalahan transfer karena ketidaksesuaian rekening bank.',
                        color: Color(0xff5F5F5F),
                        align: TextAlign.start,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
