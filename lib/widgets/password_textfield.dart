import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PasswordTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? errorText;
  final String labelText;
  final int userStatus;
  final TextInputAction textInputAction;
  final VoidCallback onSubmitted;
  final FocusNode? focusNode;

  const PasswordTextField({
    Key? key,
    required this.userStatus,
    required this.onChanged,
    required this.errorText,
    required this.labelText,
    required this.onSubmitted,
    required this.textInputAction,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextField(
          autocorrect: true,
          obscureText: _obscureText,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            errorBorder:
                const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder:
                const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            hintText: 'Masukan kata sandi',
            hintStyle: TextStyle(
              color: HexColor('#BEBEBE'),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor('#DDDDDD'))),
            errorText: widget.errorText,
            focusedBorder: OutlineInputBorder(
              // Set the focused border color
              borderSide: BorderSide(
                  color: widget.userStatus == 2
                      ? const Color(0xff24663F)
                      : const Color(
                          0xFF27AE60)), // Change to the desired blue color
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureText = !_obscureText),
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: HexColor('#AAAAAA'),
              ),
              iconSize: 18.0,
            ),
            // labelText: widget.labelText,
          ),
          keyboardType: TextInputType.text,
          maxLines: 1,
          style: const TextStyle(fontSize: 16.0, color: Colors.black),
          onChanged: widget.onChanged,
          onSubmitted: (_) => widget.onSubmitted(),
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
        ));
  }
}
