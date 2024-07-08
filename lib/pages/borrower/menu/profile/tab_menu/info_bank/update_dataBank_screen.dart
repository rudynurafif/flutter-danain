import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/component/complete_data/textfield_withMoney_component.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/after_login/complete_data/component.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_state.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/update_bank_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class UpdateDataBank extends StatefulWidget {
  final InfoBankBloc bankBloc;
  const UpdateDataBank({super.key, required this.bankBloc});

  @override
  State<UpdateDataBank> createState() => _UpdateDataBankState();
}

class _UpdateDataBankState extends State<UpdateDataBank>
    with DisposeBagMixin, DidChangeDependenciesStream {
  TextEditingController bankController = TextEditingController();
  TextEditingController bankDisplay = TextEditingController();

  TextEditingController noRekController = TextEditingController();
  TextEditingController kotaBankController = TextEditingController();
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  void initState() {
    bankController.addListener(() {
      final data = int.tryParse(bankController.text);
      widget.bankBloc.bankSelected.sink.add(data!);
    });
    widget.bankBloc.validateBankStatus.sink.add(null);
    didChangeDependencies$
        .exhaustMap((_) => widget.bankBloc.validateBankStream)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => widget.bankBloc.updateBankMessageStream)
        .exhaustMap(handleMessageUpdate)
        .collect()
        .disposedBy(bag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bankBloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Informasi Akun Bank', () {
        bloc.stepController.sink.add(1);
        widget.bankBloc.getBankData();
      }),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline2(text: 'Informasi Akun Bank'),
              const SizedBox(height: 4),
              Subtitle2(
                text:
                    'Informasi rekening diperlukan untuk melakukan pencairan pinjaman di Danain',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 24),
              bankFormWidget(bloc),
              const SizedBox(height: 16),
              formNoRekening(bloc),
              const SizedBox(height: 16),
              formKotaBank(bloc),
              const SizedBox(height: 16),
              annoutcementBank(context)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder(
              stream: bloc.isLoadingStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data ?? false;
                  if (data == true) {
                    return const ButtonLoadingNormal();
                  }
                }
                return StreamBuilder<bool>(
                  stream: bloc.buttonEditStream,
                  builder: (context, snapshot) {
                    final isValid = snapshot.data ?? false;
                    return ButtonNormal(
                      btntext: 'Verifikasi',
                      color: isValid ? null : Colors.grey,
                      action: isValid
                          ? () {
                              bloc.isLoadingButton.add(true);
                              bloc.validateBank();
                            }
                          : null,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<void> handleMessage(message) async* {
    widget.bankBloc.isLoadingButton.add(false);
    if (message is InfoBankError) {
      widget.bankBloc.getBankData();
      widget.bankBloc.validateBankStatus.sink.add(null);
      context.showSnackBarError(message.message);
    }

    if (message is InfoBankErrorName) {
      await showModalBottomSheet(
        context: context,
        builder: (context) => CheckInfoBank(
          bankName: message.data['bankAccount'],
          nama: message.data['customerName'],
          kotaBank: widget.bankBloc.kotaBank.valueOrNull ?? '',
          noRek: message.data['accountNumber'],
          isValid: false,
          action: () {
            Navigator.pop(context);
            widget.bankBloc.validateBankStatus.sink.add(null);
            widget.bankBloc.getBankData();
          },
        ),
      );
    }
    if (message is InfoBankSuccess) {
      await showModalBottomSheet(
        context: context,
        builder: (context) => CheckInfoBank(
          bankName: message.data['bankAccount'],
          nama: message.data['customerName'],
          kotaBank: widget.bankBloc.kotaBank.valueOrNull ?? '',
          noRek: message.data['accountNumber'],
          isValid: true,
          action: () {
            Navigator.pop(context);
            widget.bankBloc.validateBankStatus.sink.add(null);
            widget.bankBloc.updateBank();
          },
        ),
      );
    }
  }

  Stream<void> handleMessageUpdate(message) async* {
    if (message is UpdateBankSuccess) {
      BuildContext? dialogContext;

      unawaited(showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return const ModalPopUpNoClose(
            icon: 'assets/images/profile/bank.svg',
            title: 'Akun Bank Berhasil Diubah',
            message:
                'Akun bank akan digunakan untuk melakukan pencairan pinjaman',
          );
        },
      ));

      Future.delayed(const Duration(seconds: 1), () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          widget.bankBloc.updateBankMessage.sink.add(null);
          widget.bankBloc.getBankData();
          widget.bankBloc.stepController.sink.add(1);
        }
      });
    }

    if (message is UpdateBankError) {
      // ignore: use_build_context_synchronously
      widget.bankBloc.getBankData();
      context.showSnackBarError(message.message);
    }

    if (message is InvalidInformationMessageBank) {
      // ignore: use_build_context_synchronously
      widget.bankBloc.getBankData();
      context.showSnackBarError(
          'Terdapat error yang tidak diketahui silakan coba lagi beberapa saat');
    }
  }

  Widget bankFormWidget(InfoBankBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.bankSelectedStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final Map<String, dynamic> dataBank = bloc.listBank.value.firstWhere(
            (item) => item['id'] == data,
            orElse: () => {},
          );
          bankController.text = data.toString();
          bankDisplay.text = dataBank['nama'];
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nama Bank'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) =>
                            ModalBottomListItemWithSearch(
                          bankController,
                          bankDisplay,
                          bloc.listBank.value,
                          'Pilih Bank',
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: bankDisplay,
                        style: const TextStyle(color: Colors.black),
                        decoration: inputDecorWithIconSvg(
                          context,
                          'Pilih Bank',
                          snapshot.hasError,
                          'assets/images/icons/dropdown.svg',
                        ),
                      ),
                    ),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.error! as String,
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget formNoRekening(InfoBankBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.noRekStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          noRekController.text = snapshot.data!;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nomor Rekening'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: inputDecor(
                      context,
                      'Contoh: 123123123123',
                      snapshot.hasError,
                    ),
                    controller: noRekController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        bloc.noRek.sink.add(null);
                      } else {
                        bloc.noRek.sink.add(value);
                      }
                    },
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
                        text: snapshot.error.toString(),
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget formKotaBank(InfoBankBloc bloc) {
    return StreamBuilder<String?>(
      stream: bloc.kotaBankStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          kotaBankController.text = snapshot.data!;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kota Bank'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: inputDecor(
                      context,
                      'Contoh: Jakarta Utara',
                      snapshot.hasError,
                    ),
                    controller: kotaBankController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        bloc.kotaBank.sink.add(null);
                      } else {
                        bloc.kotaBank.sink.add(value);
                      }
                    },
                    inputFormatters: [
                      NoLeadingSpaceInputFormatter(),
                    ],
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle3(
                        text: snapshot.error.toString(),
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget annoutcementBank(BuildContext context) {
    return Container(
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
    );
  }
}
