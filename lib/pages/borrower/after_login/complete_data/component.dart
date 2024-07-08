import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../widgets/widget_element.dart';

class CheckInfoBank extends StatelessWidget {
  final String bankName;
  final String nama;
  final String noRek;
  final String kotaBank;
  final bool isValid;
  final VoidCallback? action;
  const CheckInfoBank({
    super.key,
    required this.bankName,
    required this.nama,
    required this.kotaBank,
    required this.noRek,
    required this.isValid,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 42,
                height: 4,
                color: HexColor('#DDDDDD'),
              ),
            ),
            const SizedBox(height: 24),
            const Headline2(text: 'Cek informasi akun bank Anda'),
            const SizedBox(height: 8),
            Subtitle2(
              text:
                  'Informasi rekening di bawah ini diperlukan untuk melakukan pencairan pinjaman di Danain.',
              color: HexColor('#777777'),
            ),
            const SizedBox(height: 16),
            isValid ? Container() : bankNotValid(context),
            const SizedBox(height: 16),
            const Subtitle2(text: 'Nama Bank'),
            Headline3(text: bankName),
            const SizedBox(height: 12),
            const Subtitle2(text: 'Nomor Rekening'),
            Headline3(text: noRek),
            const SizedBox(height: 12),
            const Subtitle2(text: 'Nama Pemilik Rekening'),
            Headline3(text: nama),
            const SizedBox(height: 12),
            const Subtitle2(text: 'Kota Bank'),
            Headline3(text: kotaBank),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 45,
                  child: ElevatedButton(
                    onPressed:  () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: const BorderSide(
                            color: Color(0xff24663F),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      'Ubah',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HexColor(primaryColorHex),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: isValid ? action! : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          isValid ? HexColor(primaryColorHex) : Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side:  BorderSide(
                            color:isValid ? Color(0xff24663F) : Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

Widget bankNotValid(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: HexColor('#FFF4F4'),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Subtitle2(
      text: 'Nama pemilik rekening tidak sesuai KTP',
      color: HexColor('#EB5757'),
    ),
  );
}
