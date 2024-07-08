import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/borrower/register/register_bloc.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class ChangeEmailRegister extends StatefulWidget {
  final RegisterBloc regisBloc;
  const ChangeEmailRegister({super.key, required this.regisBloc});

  @override
  State<ChangeEmailRegister> createState() => _ChangeEmailRegisterState();
}

class _ChangeEmailRegisterState extends State<ChangeEmailRegister> {
  bool isValidEmail = false;
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/register/change_email.svg'),
          SizedBox(height: 24),
          Subtitle2(
            text: changeEmailDesc,
            color: HexColor('#5F5F5F'),
            align: TextAlign.center,
          ),
          SizedBox(height: 24),
          formEmail(widget.regisBloc),
          SizedBox(height: 32),
          buttonChange(widget.regisBloc)
        ],
      ),
    );
  }

  Widget formEmail(RegisterBloc rgBloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle3(color: HexColor('#AAAAAA'), text: 'Alamat Email'),
        SizedBox(height: 4),
        TextFormField(
          style: TextStyle(color: Colors.black),
          controller: emailController,
          decoration: inputDecorNoError(
            context,
            'Contoh: jhondoebaru@gmail.com',
          ),
          onChanged: (value) {
            setState(() {
              isValidEmail = Validator.isValidEmail(value);
            });
            rxPrefs.setString('email_sementara', value);
          },
        )
      ],
    );
  }

  Widget buttonChange(RegisterBloc rgBloc) {
    return Button1(
      btntext: changeEmailText,
      color: isValidEmail ? null : Color(0xffADB3BC),
      action: !isValidEmail
          ? null
          : () => {
                rgBloc.changeEmailExisting(context, emailController.text),
              },
    );
  }
}
