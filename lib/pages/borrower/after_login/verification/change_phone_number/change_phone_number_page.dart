import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/layout/appBar_PreviousTitle.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:hexcolor/hexcolor.dart';

import 'change_phone_number_bloc.dart';

class ChangeNoHpPage extends StatefulWidget {
  static const routeName = '/change_no_hp_page';

  const ChangeNoHpPage({super.key});

  @override
  State<ChangeNoHpPage> createState() => _ChangeNoHpPageState();
}

class _ChangeNoHpPageState extends State<ChangeNoHpPage> {
  final _phoneBloc = ChangePhoneBloc();
  TextEditingController oldPhoneController =
      TextEditingController(text: '08743523412312');
  TextEditingController newPhoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Ubah Nomor Handphone'),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle2(
              text:
                  'Untuk mengajukan perubahan nomor handphone, silakan melakukan pengisian data dibawah ini.',
            ),
            SizedBox(height: 24),
            formOldNumber(context),
            SizedBox(height: 16),
            formNewNumber(context)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24),
        height: 94,
        child: StreamBuilder<bool>(
          stream: _phoneBloc.buttonStream,
          builder: (context, snapshot) {
            bool isValid = snapshot.data ?? false;
            return Button1(
              btntext: 'Ubah Nomor Hp',
              color: isValid ? null : Colors.grey,
              action: isValid ? () {} : null,
            );
          },
        ),
      ),
    );
  }

  Widget formOldNumber(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Nomor Handphone Lama'),
        SizedBox(height: 4),
        Container(
          color: HexColor('#D8D8D8'),
          child: AbsorbPointer(
            child: TextFormField(
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: HexColor('#999999')),
              decoration: inputDecorNoError(context, '0845654423'),
              controller: oldPhoneController,
            ),
          ),
        ),
      ],
    );
  }

  Widget formNewNumber(BuildContext context) {
    return StreamBuilder<String>(
      stream: _phoneBloc.newPhoneStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
        } else {
          print('sip lah');
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Subtitle3(color: HexColor('#AAAAAA'), text: 'Nomor Handphone Baru'),
            SizedBox(height: 4),
            TextFormField(
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                _phoneBloc.changePhone(value);
              },
              decoration: inputDecor(
                context,
                'Contoh: 0845654423',
                snapshot.hasError,
              ),
              controller: newPhoneController,
            ),
            if (snapshot.hasError)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Subtitle2(
                    text: snapshot.error! as String,
                    color: Colors.red,
                  ),
                ],
              )
          ],
        );
      },
    );
  }
}
