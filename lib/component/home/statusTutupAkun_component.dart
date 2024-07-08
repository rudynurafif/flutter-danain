import 'package:flutter/material.dart';
import 'package:flutter_danain/utils/snackbar.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../data/api/api_service_helper.dart';
import '../../pages/borrower/home/home_bloc.dart';

class StatusTutupAkun extends StatefulWidget {
  final Map<String, dynamic> data;
  final BuildContext context;
  final HomeBloc homeBloc;

  const StatusTutupAkun(
      {super.key, required this.data, required this.context, required this.homeBloc});

  @override
  State<StatusTutupAkun> createState() => _StatusTutupAkunState();
}

class _StatusTutupAkunState extends State<StatusTutupAkun> {
  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.data.containsKey('dataTutupAkun') && widget.data['dataTutupAkun']['idClose'] != 0) {
      final DateTime dateTime = DateTime.parse(widget.data['dataTutupAkun']['tglTutupAkun']);

      // Format the date
      final String formattedDate = DateFormat('d MMMM yyyy', 'en_US').format(dateTime);
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: HexColor('#FEF4E8'),
              border: Border.all(width: 1, color: HexColor('#FDE8CF')),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/images/icons/warning_red.svg'),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Headline5(text: 'Proses Penutupan Akun'),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(children: <TextSpan>[
                            const TextSpan(
                              text:
                                  'Proses penutupan akun memerlukan waktu 3 hari kerja. Akun Anda akan ditutup pada ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xff777777),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: formattedDate,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ButtonCustom(
                btntext: 'Batalkan Penutupan Akun',
                textcolor: HexColor('#FF8829'),
                color: HexColor('#FEF4E8'),
                action: () async {
                  final response =
                      await _apiService.cancelTutupAkun(widget.data['dataTutupAkun']['idClose']);
                  if (response.statusCode == 201) {
                    widget.homeBloc.setBeranda();
                  } else {
                    // ignore: use_build_context_synchronously
                    context.showSnackBarError('Maaf sepertinya ada kesalahan');
                  }
                },
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
