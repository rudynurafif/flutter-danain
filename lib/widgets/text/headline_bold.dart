import 'package:flutter/material.dart';

class HeadlineBold1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  HeadlineBold1({required this.text, this.color, this.align});

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black,
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class HeadlineBold2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  HeadlineBold2({required this.text, this.color, this.align});

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black,
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class HeadlineBold3 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  HeadlineBold3({required this.text, this.color, this.align});

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black,
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}
class HeadlineBold4 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  HeadlineBold4({required this.text, this.color, this.align});

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black,
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}
class HeadlineBold5 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  HeadlineBold5({required this.text, this.color, this.align});

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black,
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}