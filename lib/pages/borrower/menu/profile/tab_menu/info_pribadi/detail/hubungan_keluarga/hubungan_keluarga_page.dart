import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/hubungan_keluarga/hubungan_keluarga_bloc.dart';
import 'package:flutter_danain/utils/input_formatter.dart';
import 'package:flutter_danain/utils/loading.dart';
import 'package:flutter_danain/utils/snackbar.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class HubunganKeluargaPage extends StatefulWidget {
  static const routeName = '/hubungan_keluarga';
  const HubunganKeluargaPage({super.key});

  @override
  State<HubunganKeluargaPage> createState() => _HubunganKeluargaPageState();
}

class _HubunganKeluargaPageState extends State<HubunganKeluargaPage> {
  final namaKeluargaController = TextEditingController();
  final noHpKeluargaController = TextEditingController();
  final namaPasanganController = TextEditingController();
  final ktpPasanganController = TextEditingController();
  final noHpPasanganController = TextEditingController();

  bool validNamaKeluarga = true;
  bool validHpKeluarga = true;
  bool validNamaPasangan = true;
  bool validKtpPasangan = true;
  bool validHpPasangan = true;

  @override
  void initState() {
    super.initState();
    final bloc = context.bloc<HubunganKeluargaBloc>();
    bloc.getHubunganKeluarga();
    bloc.checkBeranda();
    bloc.getMasterHubungan();
    bloc.errorMessage.listen(
      (value) {
        if (value != null) {
          context.showSnackBarError(value);
        }
      },
    );
    bloc.isLoading.listen(
      (value) {
        try {
          if (value == true) {
            context.showLoading();
          } else {
            context.dismiss();
          }
        } catch (e) {
          context.dismiss();
        }
      },
    );
    bloc.isPostDone.listen(
      (value) async {
        if (value == true) {
          // Capture the context where the dialog is shown
          await navigate();
        }
      },
    );
  }

  Future<void> navigate() async {
    BuildContext? dialogContext;

    unawaited(
      showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return const ModalPopUpNoClose(
            icon: 'assets/images/icons/check.svg',
            title: 'Berhasil',
            message: 'Berhasil menambahkan kontak darurat',
          );
        },
      ),
    );
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.routeName,
            (route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<HubunganKeluargaBloc>();
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          isLeading: true,
          title: 'Kontak Darurat',
        ),
      ),
      bottomNavigation: bottomWidget(bloc),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerV(value: 24),
              kontakDaruratWidget(bloc),
              const SpacerV(value: 24),
              dataPasanganWidget(bloc),
              const SpacerV(value: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget kontakDaruratWidget(HubunganKeluargaBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.isKeluarga,
      builder: (context, snapshot) {
        final data = snapshot.data ?? 1;
        if (data == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Kontak Darurat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SpacerV(value: 16),
              TextWidget(
                text:
                    'Masukkan detail data dibawah ini dengan benar. Semua data wajib diisi.',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: HexColor('#777777'),
              ),
              const SpacerV(value: 16),
              Stack(
                children: [
                  TextF(
                    controller: namaKeluargaController,
                    hint: 'Nama Lengkap',
                    hintText: 'Contoh: Siti',
                    onChanged: (value) {
                      bloc.nameKeluarga.add(value);
                      print(bloc.nameKeluarga.valueOrNull);
                      if (value.length < 1) {
                        setState(() {
                          validNamaKeluarga = false;
                        });
                      } else {
                        setState(() {
                          validNamaKeluarga = true;
                        });
                      }
                    },
                    validator: (String? value) {
                      if (value!.length < 1) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  if (!validNamaKeluarga)
                    const ErrorText(error: 'Nama lengkap tidak valid')
                ],
              ),
              const SpacerV(value: 16),
              StreamBuilder<List<dynamic>>(
                stream: bloc.listHubungan,
                builder: (context, snapshot) {
                  final listHubungan = snapshot.data ?? [];
                  return StreamBuilder<Map<String, dynamic>?>(
                    stream: bloc.hubunganKeluarga.stream,
                    builder: (context, snapshot) {
                      return TextFormSelect(
                        dataSelected: snapshot.data,
                        textDisplay: 'hubunganKeluarga',
                        placeHolder: 'Pilih Hubungan Keluarga',
                        label: 'Hubungan',
                        idDisplay: 'idHubunganKeluarga',
                        listData: listHubungan,
                        onSelect: (value) {
                          bloc.hubunganKeluarga.add(value);
                        },
                      );
                    },
                  );
                },
              ),
              const SpacerV(value: 16),
              Stack(
                children: [
                  TextF(
                    controller: noHpKeluargaController,
                    hint: 'Nomor Handphone',
                    hintText: 'Contoh: 0812xxxxxxxx',
                    onChanged: (value) {
                      if (value.length < 1) {
                        bloc.noHpKeluarga.add(null);
                        setState(() {
                          validHpKeluarga = false;
                        });
                      } else {
                        bloc.noHpKeluarga.add(value);
                        if (value.length < 11) {
                          setState(() {
                            validHpKeluarga = false;
                          });
                        } else {
                          setState(() {
                            validHpKeluarga = true;
                          });
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (String? value) {
                      if (value!.length < 11) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  if (!validHpKeluarga)
                    const ErrorText(error: 'Nomor Handphone tidak valid')
                ],
              ),
            ],
          );
        } else {
          return StreamBuilder<Map<String, dynamic>?>(
            stream: bloc.keluargaData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data ?? {};
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    alertUpdate(context),
                    const SpacerV(value: 16),
                    const TextWidget(
                      text: 'Kontak Darurat',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    const SpacerV(value: 16),
                    TextFormDisable(
                      title: 'Nama Lengkap',
                      value: data['namaLengkap'].toString(),
                    ),
                    const SpacerV(value: 16),
                    TextFormDisable(
                      title: 'Hubungan',
                      value: data['namaHubungan'].toString(),
                      isDropdown: true,
                    ),
                    const SpacerV(value: 16),
                    TextFormDisable(
                      title: 'Nomor Handphone',
                      value: data['noHp'].toString(),
                    ),
                  ],
                );
              }
              return Container();
            },
          );
        }
      },
    );
  }

  Widget dataPasanganWidget(HubunganKeluargaBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.isPasangan,
      builder: (context, snapshot) {
        final isPasangan = snapshot.data ?? 1;
        if (isPasangan == 2) {
          return StreamBuilder<Map<String, dynamic>?>(
            stream: bloc.pasanganData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data ?? {};
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: 'Data Pasangan',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    const SpacerV(value: 16),
                    TextFormDisable(
                      title: 'Nama Lengkap',
                      value: data['namaLengkap'].toString(),
                    ),
                    const SpacerV(value: 16),
                    TextFormDisable(
                      title: 'Nomor KTP',
                      value: data['noKtp'].toString(),
                    ),
                    const SpacerV(value: 16),
                    TextFormDisable(
                      title: 'Nomor Handphone',
                      value: data['noHp'].toString(),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          );
        }
        if (isPasangan == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Data Pasangan',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SpacerV(value: 16),
              Stack(
                children: [
                  TextF(
                    controller: namaPasanganController,
                    hint: 'Nama Lengkap',
                    hintText: 'Contoh: Putri Kusuma',
                    onChanged: (value) {
                      if (value.length < 1) {
                        bloc.namePasangan.add(null);
                        setState(() {
                          validNamaPasangan = false;
                        });
                      } else {
                        bloc.namePasangan.add(value);
                        setState(() {
                          validNamaPasangan = true;
                        });
                      }
                    },
                    keyboardType: TextInputType.name,
                    validator: (String? value) {
                      if (value!.length < 1) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  if (!validNamaPasangan)
                    const ErrorText(error: 'Nama Pasangan tidak valid')
                ],
              ),
              const SpacerV(value: 16),
              Stack(
                children: [
                  TextF(
                    controller: ktpPasanganController,
                    hint: 'Nomor KTP',
                    hintText: 'Contoh: 1123465768123456',
                    onChanged: (value) {
                      if (value.length < 1) {
                        bloc.noKtpPasangan.add(null);
                        setState(() {
                          validKtpPasangan = false;
                        });
                      } else {
                        bloc.noKtpPasangan.add(value);
                        if (value.length != 16) {
                          setState(() {
                            validKtpPasangan = false;
                          });
                        } else {
                          setState(() {
                            validKtpPasangan = true;
                          });
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    validator: (String? value) {
                      if (value!.length != 16) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  if (!validKtpPasangan)
                    const ErrorText(error: 'Nomor KTP tidak valid')
                ],
              ),
              const SpacerV(value: 16),
              Stack(
                children: [
                  TextF(
                    controller: noHpPasanganController,
                    hint: 'Nomor Handphone',
                    hintText: 'Contoh: 0812xxxxxxxx',
                    onChanged: (value) {
                      if (value.length < 1) {
                        bloc.noHpPasangan.add(null);
                        setState(() {
                          validHpPasangan = false;
                        });
                      } else {
                        bloc.noHpPasangan.add(value);
                        if (value.length < 10) {
                          setState(() {
                            validHpPasangan = false;
                          });
                        } else {
                          setState(() {
                            validHpPasangan = true;
                          });
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (String? value) {
                      if (value!.length < 10) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  if (!validHpPasangan)
                    const ErrorText(error: 'Nomor Handphone tidak valid')
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget bottomWidget(HubunganKeluargaBloc bloc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: StreamBuilder<int>(
            stream: bloc.isKeluarga,
            builder: (context, snapshot) {
              final isKeluarga = snapshot.data ?? 1;
              return StreamBuilder<int>(
                stream: bloc.isPasangan,
                builder: (context, snapshot) {
                  final isPasangan = snapshot.data ?? 1;

                  if (isPasangan == 1 && isKeluarga == 1) {
                    return StreamBuilder<bool>(
                      stream: bloc.buttonPasangan,
                      builder: (context, snapshot) {
                        final isValid = snapshot.data ?? false;
                        return Button(
                          title: 'Simpan',
                          color: isValid
                              ? HexColor(primaryColorHex)
                              : HexColor('#ADB3BC'),
                          onPressed: () {
                            if (isValid) {
                              bloc.postPasangan();
                            }
                          },
                        );
                      },
                    );
                  }
                  if ((isPasangan == 0 || isPasangan == 2) && isKeluarga == 0) {
                    return StreamBuilder<bool>(
                      stream: bloc.buttonKeluarga,
                      builder: (context, snapshot) {
                        final isValid = snapshot.data ?? false;
                        return Button(
                          title: 'Simpan',
                          color: isValid
                              ? HexColor(primaryColorHex)
                              : HexColor('#ADB3BC'),
                          onPressed: () {
                            if (isValid) {
                              bloc.postKeluarga(false);
                            }
                          },
                        );
                      },
                    );
                  }
                  if (isPasangan == 1 && isKeluarga == 0) {
                    return StreamBuilder<bool>(
                      stream: bloc.buttonAll,
                      builder: (context, snapshot) {
                        final isValid = snapshot.data ?? false;
                        return Button(
                          title: 'Simpan',
                          color: isValid
                              ? HexColor(primaryColorHex)
                              : HexColor('#ADB3BC'),
                          onPressed: () {
                            if (isValid) {
                              bloc.postKeluarga(true);
                            }
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
        const SpacerV(value: 24),
      ],
    );
  }

  Widget alertUpdate(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF5F2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFFDE8CF)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: HexColor('#FF8829'),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () async {
                            // Handle the tap action, e.g., open a contact form or perform a phone call
                            const url = 'https://wa.link/rvbmhx';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              context.showSnackBarError(
                                'Maaf sepertinya terjadi kesalahan',
                              );
                            }
                          },
                          child: const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Untuk memperbarui data pribadi Anda silakan ',
                                  style: TextStyle(
                                    color: Color(0xFF5F5F5F),
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: 'hubungi kami',
                                  style: TextStyle(
                                    color: Color(0xFFFF8829),
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
