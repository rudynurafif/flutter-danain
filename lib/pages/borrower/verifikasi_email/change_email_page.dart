import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/utils/constants.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'package:flutter_danain/widgets/form/text_field_widget.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({
    super.key,
  });

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  bool isValidEmail = false;
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(
          context: context,
          elevation: 0,
          isLeading: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    HelpTemporary.routeName,
                  );
                },
                child: TextWidget(
                  text: 'Bantuan',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Constants.get.borrowerColor,
                ),
              ),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/register/change_email.svg'),
            const SizedBox(height: 24),
            Subtitle2(
              text: changeEmailDesc,
              color: HexColor('#5F5F5F'),
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            formEmail(context),
            const SizedBox(height: 32),
            buttonChange(context)
          ],
        ),
      ),
    );
  }

  Widget formEmail(
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextF(
          controller: emailController,
          hint: 'Alamat Email',
          hintText: 'Contoh: jhondoebaru@gmail.com',
          onChanged: (value) {
            setState(() {
              isValidEmail = Validator.isValidEmail(value);
            });
          },
        )
      ],
    );
  }

  Widget buttonChange(BuildContext context) {
    return ButtonWidget(
      title: changeEmailText,
      color: isValidEmail ? null : const Color(0xffADB3BC),
      onPressed: () {
        if (isValidEmail) {
          Navigator.pop(context, emailController.text);
        }
      },
    );
  }
}
