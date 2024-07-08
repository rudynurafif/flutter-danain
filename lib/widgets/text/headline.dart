import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Headline extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Headline1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline1({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Headline2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline2({super.key, required this.text, this.color, this.align});

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

class Headline3 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline3({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Headline3500 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline3500({super.key, required this.text, this.color, this.align});

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

class Headline4 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline4({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Headline5 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline5({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Headline5Extra extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline5Extra({super.key, required this.text, this.color, this.align});

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

class Headline1500 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline1500({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: color ?? HexColor('#333333'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class Headline2500 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline2500({super.key, required this.text, this.color, this.align});

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

class Headline2600 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline2600({super.key, required this.text, this.color, this.align});

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

class HeadlineSaldoTersedia extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const HeadlineSaldoTersedia({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: color ?? HexColor('#27AE60'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}

class HeadlineSaldoTersedia2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const HeadlineSaldoTersedia2({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: align ?? TextAlign.start,
      text: TextSpan(
        children: _buildTextSpans(text),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    final parts = text.split(',');
    final mainPart = parts[0];
    final decimalPart = parts.length > 1 ? ',${parts[1].substring(0, 2)}' : '';

    return [
      TextSpan(
        text: mainPart,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: color ?? HexColor('#27AE60'),
        ),
      ),
      TextSpan(
        text: decimalPart,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: color ?? HexColor('#27AE60'),
        ),
      ),
    ];
  }
}

class Headline4500 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  const Headline4500({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: color ?? HexColor('#28AF60'),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}
