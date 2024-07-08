import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/pages/lender/rdl/regis_rdl_bloc.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class StepAlamatRdl extends StatefulWidget {
  final RegisRdlBloc rdlBloc;
  const StepAlamatRdl({
    super.key,
    required this.rdlBloc,
  });

  @override
  State<StepAlamatRdl> createState() => _StepAlamatRdlState();
}

class _StepAlamatRdlState extends State<StepAlamatRdl> {
  TextEditingController alamatController = TextEditingController();
  TextEditingController kecamatanController = TextEditingController();
  TextEditingController kelurahanController = TextEditingController();
  TextEditingController kodePosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = widget.rdlBloc;
    if (bloc.alamatValue.hasValue) {
      alamatController.text = bloc.alamatValue.value;
    }
    if (bloc.kecamatanValue.hasValue) {
      kecamatanController.text = bloc.kecamatanValue.value;
    }
    if (bloc.kelurahanValue.hasValue) {
      kelurahanController.text = bloc.kelurahanValue.value;
    }
    if (bloc.kodePosValue.hasValue) {
      kodePosController.text = bloc.kodePosValue.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.rdlBloc;
    return Scaffold(
      appBar: previousTitleCustom(
        context,
        'Data Alamat',
        () => bloc.stepChange(1),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              alertDataAman(context),
              const SizedBox(height: 24),
              formAlamat(bloc),
              const SizedBox(height: 16),
              provinsiForm(bloc),
              const SizedBox(height: 16),
              kotaForm(bloc),
              const SizedBox(height: 16),
              formKecamatan(bloc),
              const SizedBox(height: 16),
              formKelurahan(bloc),
              const SizedBox(height: 16),
              formKodePos(bloc),
              const SizedBox(height: 16),
              buttonNext(bloc),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonNext(RegisRdlBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.buttonAlamat,
      builder: (context, snapshot) {
        final isValid = snapshot.data ?? false;
        if (isValid == true) {
          return ButtonNormal(
            btntext: 'Lanjut',
            textcolor: Colors.white,
            action: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ModalPopUp(
                    icon: 'assets/lender/verifikasi/confirmation.svg',
                    title: 'Verifikasi Data Diri',
                    message:
                        'Untuk tahap verifikasi, kami akan mengirimkan data pribadi Anda ke badan verifikasi yang diatur oleh ketentuan perundang-undangan.',
                    actions: [
                      Button2(
                        btntext: 'Kirim',
                        action: () {
                          bloc.postPrivy();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            },
          );
        } else {
          return const ButtonNormal(
            btntext: 'Lanjut',
            color: Colors.grey,
            textcolor: Colors.white,
          );
        }
      },
    );
  }

  Widget alertDataAman(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffE9F6EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/icons/data_pribadi_lender.svg',
            width: 16,
            height: 16,
            color: HexColor(primaryColorHex),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Subtitle3(
                  text:
                      'Danain menjamin data Anda akan selalu aman pada sistem. Data akan digunakan sesuai dengan aturan',
                  color: HexColor('#777777'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget formAlamat(RegisRdlBloc bloc) {
    return StreamBuilder<String?>(
      stream: widget.rdlBloc.alamatErrorStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Alamat Sesuai KTP'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: inputDecorLender(
                      context,
                      'Contoh: Jalan Kirana',
                      snapshot.hasData,
                    ),
                    controller: alamatController,
                    onChanged: (value) => bloc.alamatChange(value),
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.data!,
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

  Widget provinsiForm(RegisRdlBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.provinsiList,
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>>(
          stream: bloc.provinsiStream,
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ModalBottomListItemObjectCustom(
                      dataSelected: snapshot.data,
                      dataVal: list,
                      label: 'Provinsi',
                      actionSelect: (val) {
                        bloc.provinsiChange(val);
                      },
                      idKey: 'idPropinsi',
                    );
                  },
                );
              },
              child: SelectFormContentCustom(
                placeHolder: 'Pilih provinsi',
                dataSelected: snapshot.data,
                label: 'Provinsi',
              ),
            );
          },
        );
      },
    );
  }

  Widget kotaForm(RegisRdlBloc bloc) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.kotaList,
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return StreamBuilder<Map<String, dynamic>?>(
          stream: bloc.kotaStream,
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ModalBottomListItemObjectCustom(
                      dataSelected: snapshot.data,
                      dataVal: list,
                      label: 'Kota',
                      actionSelect: (val) {
                        bloc.kotaChange(val);
                      },
                      idKey: 'idKota',
                    );
                  },
                );
              },
              child: SelectFormContentCustom(
                placeHolder: 'Pilih Kota',
                dataSelected: snapshot.data,
                label: 'Kabupaten/ Kota',
              ),
            );
          },
        );
      },
    );
  }

  Widget formKecamatan(RegisRdlBloc bloc) {
    return StreamBuilder<String?>(
      stream: widget.rdlBloc.kecamatanError,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kecamatan'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: inputDecorLender(
                      context,
                      'Contoh: Karangsambung',
                      snapshot.hasData,
                    ),
                    controller: kecamatanController,
                    onChanged: (value) => bloc.kecamatanChange(value),
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.data!,
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

  Widget formKelurahan(RegisRdlBloc bloc) {
    return StreamBuilder<String?>(
      stream: widget.rdlBloc.kelurahanError,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kelurahan'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: inputDecorLender(
                      context,
                      'Contoh: Plumbon',
                      snapshot.hasData,
                    ),
                    controller: kelurahanController,
                    onChanged: (value) => bloc.kelurahanChange(value),
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.data!,
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

  Widget formKodePos(RegisRdlBloc bloc) {
    return StreamBuilder<String?>(
      stream: widget.rdlBloc.kodePosError,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Kode Pos'),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: inputDecorLender(
                      context,
                      'Contoh: 12345',
                      snapshot.hasData,
                    ),
                    controller: kodePosController,
                    onChanged: (value) => bloc.kodePosChange(value),
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Subtitle2(
                        text: snapshot.data!,
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
}
