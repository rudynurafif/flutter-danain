import 'package:flutter/material.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeTkbPage extends StatefulWidget {
  static const routeName = '/home_tkb_page';

  const HomeTkbPage({Key? key}) : super(key: key);

  @override
  State<HomeTkbPage> createState() => _HomeTkbPageState();
}

class _HomeTkbPageState extends State<HomeTkbPage> {
  @override
  Widget build(BuildContext context) {
    final pdfData = ModalRoute.of(context)?.settings.arguments as String?;
    print('link data pdf TKB $pdfData');

    return Scaffold(
      appBar: previousTitle(context, 'TKB 90'),
      backgroundColor: HexColor('#FFFFFF'),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: GestureDetector(
              onTapUp: (TapUpDetails details) {
                // Handle tap event
                print('Check Check');
                print(details);
              },
              onLongPress: () {
                // Handle long press event
              },
              child: Container(
                width: 360,
                height: 640,
                clipBehavior: Clip.none, // Set clipBehavior to Clip.none
                decoration: const BoxDecoration(color: Colors.white),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 24,
                      top: 0,
                      child: SizedBox(
                        width: 312,
                        height: 2300,
                        child: Text(
                          'Tingkat Keberhasilan 90 (TKB90) menunjukkan keberhasilan Danain dalam menjaga tingkat kredit bermasalah (Non Performing Loan/NPL) agar tetap rendah. Semakin tinggi angka TKB, maka semakin baik pula performa Danain dalam menekan angka NPL. ',
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 24,
                      top: 314,
                      child: SizedBox(
                        width: 312,
                        child: Text(
                          'Keterangan: ',
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      top: 185,
                      child: Container(
                        width: 312,
                        height: 105,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 312,
                                height: 105,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1FCF4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              top: 16,
                              child: Container(
                                width: 280,
                                height: 73,
                                child: Stack(
                                  children: [
                                    const Positioned(
                                      left: 74,
                                      top: 0,
                                      child: Text(
                                        'TKB90 = 100%-TWP90',
                                        style: TextStyle(
                                          color: Color(0xFF27AE60),
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 34,
                                      child: Container(
                                        width: 280,
                                        height: 39,
                                        child: Stack(
                                          children: [
                                            const Positioned(
                                              left: 0,
                                              top: 11,
                                              child: Text(
                                                'TWP90 =',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 61,
                                              top: 0,
                                              child: Container(
                                                width: 219,
                                                height: 39,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 0,
                                                      top: 19,
                                                      child: Container(
                                                        width: 182,
                                                        height: 1,
                                                        color: const Color(
                                                            0xFF333333),
                                                      ),
                                                    ),
                                                    const Positioned(
                                                      left: 4,
                                                      top: 0,
                                                      child: Text(
                                                        'Outstanding wanprestasi  > 90 hari',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF333333),
                                                          fontSize: 10,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.3,
                                                        ),
                                                      ),
                                                    ),
                                                    const Positioned(
                                                      left: 46,
                                                      top: 24,
                                                      child: Text(
                                                        'Total Outstanding',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF333333),
                                                          fontSize: 10,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.3,
                                                        ),
                                                      ),
                                                    ),
                                                    const Positioned(
                                                      left: 186,
                                                      top: 10,
                                                      child: Text(
                                                        'X 100%',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.3,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 24,
                      top: 345,
                      child: SizedBox(
                          width: 312,
                          child: Text(
                            'TKB90 adalah tingkat keberhasilan penyelenggara Fintech P2P Lending dalam memfasilitasi penyelesaian kewajiban pinjam meminjam dalam jangka waktu sampai dengan 90 hari, terhitung sejak jatuh tempo.\nTWP90 adalah ukuran tingkat wanprestasi atau kelalaian penyelesaian kewajiban yang tertera dalam perjanjian di atas 90 hari sejak tanggal jatuh tempo. TKB90 diperbaharui secara berkala pada pukul 00.00 WIB setiap hari.',
                            style: TextStyle(
                              color: Color(0xFF777777),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.7,
                            ),
                            textAlign: TextAlign
                                .left, // Use `TextAlign.justify` to justify text
                          )),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
