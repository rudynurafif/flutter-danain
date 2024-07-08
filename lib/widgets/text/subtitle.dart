import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Subtitle500 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle500({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle600 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle600({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle16500 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle16500({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class SubtitleExtra extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const SubtitleExtra({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle1({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle2Large extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle2Large({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle2LargeModified extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle2LargeModified(
      {super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 76),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: color ?? HexColor('#333333'),
        ),
        textAlign: align ?? TextAlign.start,
      ),
    );
  }
}

class Subtitle2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle2({
    super.key,
    required this.text,
    this.color,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle2Extra extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fWeight;
  final TextAlign? align;

  const Subtitle2Extra(
      {super.key, required this.text, this.color, this.align, this.fWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: fWeight ?? FontWeight.w400,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle3 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle3({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class SubtitleSaldoTersedia extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const SubtitleSaldoTersedia(
      {super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: color ?? HexColor('#777777'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle3Extra extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle3Extra({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle4 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle4({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle4Extra extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle4Extra({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Subtitle5 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Subtitle5({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 9,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}
