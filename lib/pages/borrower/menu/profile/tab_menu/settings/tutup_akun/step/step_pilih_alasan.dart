import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/tutup_akun_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:localstorage/localstorage.dart';

class StepPilihAlasan extends StatefulWidget {
  final TutupAkunBloc bloc;
  const StepPilihAlasan({super.key, required this.bloc});

  @override
  State<StepPilihAlasan> createState() => _StepPilihAlasanState();
}

class _StepPilihAlasanState extends State<StepPilihAlasan> {
  TextEditingController lainnyaController = TextEditingController();
  int charLengthLainnya = 0;
  final LocalStorage storage = LocalStorage('todo_app.json');

  @override
  Widget build(BuildContext context) {
    final taBloc = widget.bloc;
    return Scaffold(
      appBar: previousTitleCustom(context, 'Tutup Akun', () {
        taBloc.stepController.sink.add(1);
      }),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Headline3500(text: 'Alasan Penutupan Akun'),
              const SizedBox(height: 8),
              Subtitle2(
                text: 'Anda dapat memilih lebih dari 1 alasan penutupan akun',
                color: HexColor('#777777'),
              ),
              const SizedBox(height: 16),
              listPenutupanAkunWidget(taBloc),
              const SizedBox(height: 16),
              checkLainnya(taBloc)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            StreamBuilder(
              stream: taBloc.alasanSelectedStream,
              builder: (context, snapshot) {
                final data = snapshot.data ?? [];
                return Button1(
                  btntext: 'lanjut',
                  color: data.isNotEmpty ? null : HexColor('#ADB3BC'),
                  action: data.isNotEmpty
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => ModalPopUp(
                              icon: 'assets/images/icons/warning_red.svg',
                              title: 'Konfirmasi Penutupan Akun',
                              message:
                                  'Danain akan memproses pengajuan penutupan akun dalam 3 hari jam kerja',
                              actions: [
                                Button2(
                                  btntext: 'Tutup Akun',
                                  action: () {
                                    Navigator.pop(context);
                                    taBloc.postToOtp();
                                  },
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Subtitle2Extra(
                                      text: 'Batal',
                                      color: HexColor('#288C50'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      : null,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget listPenutupanAkunWidget(TutupAkunBloc taBloc) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: taBloc.alasanSelectedStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        final listAlasan = taBloc.listAlasan.valueOrNull ?? [];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listAlasan.asMap().entries.map((val) {
            // ignore: unused_local_variable
            final index = val.key;
            final item = val.value;
            final bool isSelected = data.any(
                (element) => element['idTutupAkun'] == item['idTutupAkun']);
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (isSelected == true) {
                    data.removeWhere((element) =>
                        element['idTutupAkun'] == item['idTutupAkun']);
                  } else {
                    data.add({
                      'idTutupAkun': item['idTutupAkun'],
                      'keterangan': item['keterangan']
                    });
                  }
                  taBloc.alasanSelected.sink.add(data);
                },
                child: checkBoxDetail(isSelected, item['keterangan']),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget checkLainnya(TutupAkunBloc taBloc) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: taBloc.alasanSelectedStream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        final bool isSelected =
            data.any((element) => element['idTutupAkun'] == 8);
        if (isSelected == true) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                color: HexColor('#F5F9F6'),
                child: TextFormField(
                  inputFormatters: [LessThan160()],
                  controller: lainnyaController,
                  onChanged: (value) {
                    setState(() {
                      charLengthLainnya = value.length;
                    });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 6,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Tulis disini...',
                    hintStyle: TextStyle(
                      color: HexColor('#AAAAAA'),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 247, 4, 4),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff288C50),
                        width: 1.0,
                      ),
                    ),
                    fillColor: Colors.grey,
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Subtitle3(
                text: '$charLengthLainnya/160 karakter',
                color: HexColor('#777777'),
              )
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget checkBoxDetail(bool isSelected, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getSelected(isSelected),
        const SizedBox(width: 10),
        Flexible(
          child: Subtitle2(
            text: content,
            color: HexColor('#777777'),
          ),
        )
      ],
    );
  }

  Widget getSelected(bool isSelected) {
    if (isSelected == true) {
      return Container(
        width: 16,
        height: 16,
        decoration: ShapeDecoration(
          color: HexColor('#288C50'),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: HexColor('#E9F6EB')),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 12,
        ),
      );
    } else {
      return Container(
        width: 16,
        height: 16,
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F3F3),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
  }
}
