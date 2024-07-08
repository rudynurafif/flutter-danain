import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_danain/utils/dimens.dart';
import 'package:flutter_danain/utils/type_defs.dart';
import 'package:flutter_danain/widgets/space_v.dart';
import 'package:flutter_danain/widgets/text/text_widget.dart';
import 'package:hexcolor/hexcolor.dart';

class TextF extends StatefulWidget {
  const TextF({
    this.key,
    this.curFocusNode,
    this.nextFocusNode,
    this.hint,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.suffixIcon,
    this.controller,
    this.onTap,
    this.textAlign,
    this.enable,
    this.inputFormatter,
    this.minLine,
    this.maxLine,
    this.prefixIcon,
    this.isHintVisible = true,
    this.prefixText,
    this.hintText,
    this.autofillHints,
    this.semantic,
    this.onSubmit,
    this.hintColor,
  });

  final Key? key;
  final FocusNode? curFocusNode;
  final FocusNode? nextFocusNode;
  final String? hint;
  final Function(String)? validator;
  final Function(String)? onChanged;
  final Function? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool? obscureText;
  final int? minLine;
  final int? maxLine;
  final Widget? suffixIcon;
  final TextAlign? textAlign;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatter;
  final bool isHintVisible;
  final String? prefixText;
  final String? hintText;
  final Iterable<String>? autofillHints;
  final String? semantic;
  final Function1<String?, void>? onSubmit;
  final Color? hintColor;
  final Widget? prefixIcon;

  @override
  _TextFState createState() => _TextFState();
}

class _TextFState extends State<TextF> {
  bool isFocus = false;
  String currentVal = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // margin: EdgeInsets.symmetric(vertical: Dimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.isHintVisible,
            child: TextWidget(
              text: widget.hint ?? '',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: widget.hintColor ?? HexColor('#AAAAAA'),
            ),
          ),
          const SpacerV(value: 8),
          Semantics(
            label: widget.semantic,
            child: TextFormField(
              key: widget.key,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofillHints: widget.autofillHints,
              enabled: widget.enable,
              obscureText: widget.obscureText ?? false,
              focusNode: widget.curFocusNode,
              keyboardType: widget.keyboardType,
              controller: widget.controller,
              textInputAction: widget.textInputAction,
              textAlign: widget.textAlign ?? TextAlign.start,
              minLines: widget.minLine ?? 1,
              maxLines: widget.maxLine ?? 1,
              inputFormatters: widget.inputFormatter,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: Dimens.bodyMedium,
                color: HexColor('#333333'),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
              cursorColor: const Color(0xff333333),
              decoration: InputDecoration(
                prefix: widget.prefixIcon ??
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                    ),
                prefixText: widget.prefixText,
                alignLabelWithHint: true,
                isDense: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: HexColor('BEBEBE'),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: widget.suffixIcon,
                contentPadding: EdgeInsets.symmetric(
                  vertical: Dimens.space12,
                  // horizontal: Dimens.space16,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffDDDDDD),
                    width: 1.0,
                  ),
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
              validator: widget.validator as String? Function(String?)?,
              onChanged: widget.onChanged,
              onTap: widget.onTap as void Function()?,
              onFieldSubmitted: widget.onSubmit ?? onSubmitDefault,
            ),
          ),
        ],
      ),
    );
  }

  void onSubmitDefault(String? value) {
    setState(() {
      fieldFocusChange(
        context,
        widget.curFocusNode ?? FocusNode(),
        widget.nextFocusNode,
      );
    });
  }

  void fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode? nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

class TextFormDisable extends StatelessWidget {
  final String title;
  final String value;
  final bool isTitleVisible;
  final bool isDropdown;
  const TextFormDisable({
    super.key,
    required this.title,
    required this.value,
    this.isDropdown = false,
    this.isTitleVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isTitleVisible,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: title,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: HexColor('#AAAAAA'),
              ),
              const SpacerV(value: 4),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: HexColor('#DDDDDD')),
            color: HexColor('#F5F6F7'),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: value,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: HexColor('#999999'),
              ),
              if (isDropdown)
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 16,
                  color: HexColor('#999999'),
                )
            ],
          ),
        )
      ],
    );
  }
}
