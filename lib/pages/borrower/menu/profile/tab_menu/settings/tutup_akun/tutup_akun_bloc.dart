import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/otp_state.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class TutupAkunBloc {
  final isReady = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isReadyStream => isReady.stream;

  final stepController = BehaviorSubject<int>.seeded(1);
  Stream<int> get stepStream => stepController.stream;

  final listAlasan = BehaviorSubject<List<dynamic>>();
  Stream<List<dynamic>> get listAlasanStream => listAlasan.stream;

  final alasanSelected = BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);
  Stream<List<Map<String, dynamic>>> get alasanSelectedStream =>
      alasanSelected.stream;

  final otpStatusController = BehaviorSubject<bool>();
  Stream<bool> get otpStatusStream => otpStatusController.stream;

  final reqOtpMessage = BehaviorSubject<OtpMessageState>();
  Stream<OtpMessageState> get reqOtpMessageStream => reqOtpMessage.stream;

  final validateOtpMessage = BehaviorSubject<OtpMessageState>();
  Stream<OtpMessageState> get validateOtpMessageStream =>
      validateOtpMessage.stream;

  void initGetData() async {
    try {
      final listTutupAkun = await _apiService.get_tutupAkun();
      listAlasan.sink.add(listTutupAkun);
      print(listTutupAkun);
    } catch (e) {
      print(e.toString());
    }

    isReady.sink.add(true);
  }

  void postToOtp() async {
    try {
      final listData = alasanSelected.valueOrNull ?? [];
      final response = await _apiService.reqOtpTutupAkun(listData);
      final dataBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        reqOtpMessage.sink.add(const OtpMessageSuccess());
      } else {
        reqOtpMessage.sink.add(OtpMessageError(dataBody['message'], dataBody));
        print(dataBody['message']);
      }
    } catch (e) {
      reqOtpMessage.sink.add(OtpMessageError(e.toString(), e));
      print(e.toString());
    }
  }

  void validateOtp(String otp) async {
    try {
      final response = await _apiService.validasiOtpTutupAkun(otp);
      final dataBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(dataBody['data']);
        otpStatusController.sink.add(true);
        validateOtpMessage.sink.add(const OtpMessageSuccess());
      } else {
        otpStatusController.sink.add(false);
        validateOtpMessage.sink
            .add(OtpMessageError(dataBody['message'], dataBody));
      }
    } catch (e) {
      otpStatusController.sink.add(false);
      validateOtpMessage.sink.add(OtpMessageError(e.toString(), e));
    }
  }

  void dispose() {
    stepController.close();
    isReady.close();
    listAlasan.close();
    alasanSelected.close();
  }

  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
}
