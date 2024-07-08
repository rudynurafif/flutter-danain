import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PasswordValidate extends StatelessWidget {
  final bool isShow;
  final bool passwordLowerCase;
  final bool passwordUpperCase;
  final bool passwordNumber;
  final bool passwordLength;
  PasswordValidate({
    super.key,
    required this.isShow,
    required this.passwordLowerCase,
    required this.passwordUpperCase,
    required this.passwordNumber,
    required this.passwordLength,
  });
  Icon invalidIcon = const Icon(Icons.close, color: Colors.red, size: 15);
  Icon validIcon = const Icon(Icons.check, color: Colors.green, size: 15);
  Color invalidColor = Colors.red;
  Color validColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isShow,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color:  Color(0xFFF1FCF4)),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 8,
              offset: Offset(1, 1),
              spreadRadius: 0,
            )]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Password harus terdiri dari:',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        passwordLowerCase ? invalidIcon : validIcon,
                        Text(
                          "Huruf kecil",
                          style: TextStyle(
                            color:
                                passwordLowerCase ? invalidColor : validColor,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        passwordUpperCase ? invalidIcon : validIcon,
                        Text(
                          "Huruf Kapital",
                          style: TextStyle(
                              color:
                                  passwordUpperCase ? invalidColor : validColor,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        passwordNumber ? invalidIcon : validIcon,
                        Text(
                          "Angka",
                          style: TextStyle(
                              color: passwordNumber ? invalidColor : validColor,
                              fontSize: 10),
                        )
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        passwordLength ? invalidIcon : validIcon,
                        Text(
                          "Minimal 8 karakter",
                          style: TextStyle(
                              color: passwordLength ? invalidColor : validColor,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
