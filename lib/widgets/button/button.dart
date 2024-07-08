import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/text/headline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? width;
  final Color? color;
  final Color? titleColor;
  final double? fontSize;
  final Color? splashColor;
  final double? paddingY;
  final Color? borderColor;
  final FontWeight? fontWeight;
  const Button({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.color,
    this.titleColor,
    this.fontSize,
    this.splashColor,
    this.paddingY,
    this.borderColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: paddingY ?? 13.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color ?? HexColor(borrowerColor),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: titleColor ?? HexColor('#FFFFFF'),
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight ?? FontWeight.w700,
            fontFamily: 'DMsans',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ButtonNormal extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;

  const ButtonNormal({
    Key? key,
    required this.btntext,
    this.color,
    this.textcolor,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;

            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }

          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                color ?? nullColor,
              ),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                btntext,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textcolor ?? Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonNormalLender extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;

  const ButtonNormalLender({
    super.key,
    required this.btntext,
    this.color,
    this.textcolor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;

            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xFF27AE5F), width: 1),
              );
            }
          }

          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                color ?? const Color(0xFF27AE5F),
              ),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                btntext,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textcolor ?? Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Button1 extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final String? icon;
  final VoidCallback? action;
  const Button1({
    super.key,
    required this.btntext,
    this.color,
    this.icon,
    this.textcolor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;
            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? nullColor),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Align children to the center
                  children: [
                    if (icon != '') SvgPicture.asset(icon ?? ''),
                    SizedBox(width: 8),
                    // Adding some space between SVG and text
                    Text(
                      btntext,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textcolor ?? Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Button1Lender extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const Button1Lender({super.key, required this.btntext, this.color, this.textcolor, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );

          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;

            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xFF27AE60), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? nullColor),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                btntext,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textcolor ?? Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Button2 extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const Button2({super.key, required this.btntext, this.color, this.textcolor, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 32,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;

            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? nullColor),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Text(
                btntext,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textcolor ?? Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Button3 extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const Button3({super.key, required this.btntext, this.color, this.textcolor, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 32,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;

            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? nullColor),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                btntext,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textcolor ?? Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonNoBorder extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const ButtonNoBorder({super.key, required this.btntext, this.color, this.textcolor, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color ?? const Color(0xff24663F)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
        onPressed: action,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            btntext,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textcolor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}

class ButtonSmall extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const ButtonSmall({super.key, required this.btntext, this.color, this.textcolor, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;
            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                color ?? nullColor,
              ),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                btntext,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textcolor ?? Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonCustom extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const ButtonCustom({super.key, required this.btntext, this.color, this.textcolor, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 32,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;
            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? nullColor),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Text(
                btntext,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textcolor ?? Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonCustomError extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const ButtonCustomError(
      {super.key, required this.btntext, this.color, this.textcolor, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 32,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            HexColor('#FDEEEE'),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: action == null
                  ? const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    )
                  : BorderSide(
                      color: HexColor('#EB5757'),
                      width: 1,
                    ),
            ),
          ),
        ),
        onPressed: action,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Text(
            btntext,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textcolor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonCustomWidth extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const ButtonCustomWidth({
    super.key,
    required this.btntext,
    this.color,
    this.textcolor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 135,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;
            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? nullColor),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Headline3(
                text: btntext,
                color: textcolor ?? Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonCustomWidth2 extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const ButtonCustomWidth2({
    super.key,
    required this.btntext,
    this.color,
    this.textcolor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 135,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;
            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? const Color(0xff24663F)),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Headline5(
                text: btntext,
                color: textcolor ?? Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonCustomWidget extends StatelessWidget {
  final Widget btntext;
  final Color? color;
  final Color? textcolor;
  final VoidCallback? action;
  const ButtonCustomWidget(
      {super.key, required this.btntext, this.color, this.textcolor, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 32,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          );
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;
            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? const Color(0xff24663F)),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: btntext,
            ),
          );
        },
      ),
    );
  }
}

class ButtonSmall1 extends StatelessWidget {
  final String btntext;
  final VoidCallback? action;
  const ButtonSmall1({
    super.key,
    required this.btntext,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: action!,
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: const BorderSide(
                color: Color(0xff24663F),
                width: 1,
              ),
            ),
          ),
        ),
        child: Headline5(
          text: btntext,
          color: HexColor(primaryColorHex),
        ),
      ),
    );
  }
}

class ButtonSmall3 extends StatelessWidget {
  final String btntext;
  final VoidCallback? action;
  const ButtonSmall3({
    super.key,
    required this.btntext,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: action!,
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: const BorderSide(
                color: Color(0xff24663F),
                width: 1,
              ),
            ),
          ),
        ),
        child: Headline5(
          text: btntext,
          color: HexColor(primaryColorHex),
        ),
      ),
    );
  }
}

class ButtonSmall2 extends StatelessWidget {
  final String btntext;
  final VoidCallback? action;
  const ButtonSmall2({
    super.key,
    required this.btntext,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: action!,
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
        ),
        child: Headline5(
          text: btntext,
          color: Colors.white,
        ),
      ),
    );
  }
}

ButtonStyle buttonDecor() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(
      Colors.white,
    ),
    elevation: const MaterialStatePropertyAll(0),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
        side: const BorderSide(
          color: Color(0xff288C50),
          width: 0.5,
        ),
      ),
    ),
  );
}

class Button1Custom extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final Color borderColor;
  final VoidCallback? action;
  const Button1Custom({
    super.key,
    required this.btntext,
    this.color,
    this.textcolor,
    required this.borderColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color ?? const Color(0xff24663F)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: borderColor, width: 1)),
          ),
        ),
        onPressed: action,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            btntext,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textcolor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonLoading extends StatelessWidget {
  const ButtonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}

class ButtonLoadingNormal extends StatelessWidget {
  const ButtonLoadingNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? width;
  final Color? color;
  final Color? titleColor;
  final double? fontSize;
  final Color? splashColor;
  final double? paddingY;
  final Color? borderColor;
  final FontWeight? fontWeight;
  const ButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.color,
    this.titleColor,
    this.fontSize,
    this.splashColor,
    this.paddingY,
    this.borderColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: paddingY ?? 13.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color ?? HexColor(primaryColorHex),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: titleColor ?? Colors.white,
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight ?? FontWeight.w700,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ButtonWidgetCustom extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double? width;
  final Color? color;
  final double? paddingY;
  final Color? borderColor;
  const ButtonWidgetCustom({
    super.key,
    required this.child,
    required this.onPressed,
    this.width,
    this.color,
    this.paddingY,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: paddingY ?? 13.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color ?? HexColor(primaryColorHex),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: child,
      ),
    );
  }
}

class ButtonNoCircular extends StatelessWidget {
  final String btntext;
  final Color? color;
  final Color? textcolor;
  final String? icon;
  final VoidCallback? action;
  const ButtonNoCircular({
    super.key,
    required this.btntext,
    this.color,
    this.icon,
    this.textcolor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: FutureBuilder(
        future: getUserStatus(),
        builder: (context, snapshot) {
          RoundedRectangleBorder shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          );
          Color nullColor = HexColor('#AAAAAA');
          if (snapshot.hasData) {
            final data = snapshot.data ?? 1;
            if (data == 1) {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : BorderSide(color: HexColor(lenderColor), width: 1),
              );
              nullColor = HexColor(lenderColor);
            } else {
              shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: action == null
                    ? const BorderSide(color: Colors.transparent, width: 1)
                    : const BorderSide(color: Color(0xff24663F), width: 1),
              );
              nullColor = HexColor(primaryColorHex);
            }
          }
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color ?? nullColor),
              shape: MaterialStateProperty.all(shape),
            ),
            onPressed: action,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Align children to the center
                  children: [
                    if (icon != '') SvgPicture.asset(icon ?? ''),
                    SizedBox(width: 8),
                    // Adding some space between SVG and text
                    Text(
                      btntext,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textcolor ?? Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
