import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:http/http.dart' as http;
import 'package:http_client_hoc081098/http_client_hoc081098.dart';

import 'case_privy_state.dart';

class CasePrivyBloc {
  final casePrivyController = BehaviorSubject<Map<String, dynamic>?>();

  final ktpController = BehaviorSubject<File?>();
  final selfieController = BehaviorSubject<File?>();
  final supportController = BehaviorSubject<File?>();
  final typeController = BehaviorSubject<String>();
  final codeCaseController = BehaviorSubject<String>();
  final casePrivyMessage = BehaviorSubject<PrivyCaseMessage>();
  final fileLengthController = BehaviorSubject<List<String>?>();

  Stream<File?> get ktpStream => ktpController.stream;
  Stream<File?> get selfieStream => selfieController.stream;
  Stream<File?> get supportStream => supportController.stream;
  Stream<String> get typeStream => typeController.stream;
  Stream<String> get codeStream => codeCaseController.stream;
  Stream<List<String>?> get fileLengthStream => fileLengthController.stream;
  Stream<PrivyCaseMessage> get casePrivyMessageStream =>
      casePrivyMessage.stream;

  void initGetCase(String caseCode) {
    print('case privy');
    print(caseCode);
    codeCaseController.sink.add(caseCode);
    Map<String, dynamic>? casePrivy = casePrivyList.firstWhere(
      (message) => message["code"] == caseCode,
      orElse: () => {},
    );

    casePrivyController.add(casePrivy);
    List<String> typeList = casePrivy['mustUpload'];
    String type = typeList.join(', ');
    typeController.sink.add(type);
    print(typeController.value);
  }

  Stream<Map<String, dynamic>?> get casePrivyStream =>
      casePrivyController.stream;
  Stream<bool> get isValidButton => Rx.combineLatest2(
        casePrivyStream,
        fileLengthStream,
        (Map<String, dynamic>? casePrivy, List<String>? file) {
          List<String> mustUploadList = casePrivy!['mustUpload'];
          return mustUploadList.length == file!.length;
        },
      );
  void dispose() {
    casePrivyController.close();
    ktpController.close();
    selfieController.close();
    codeCaseController.close();
    typeController.close();
    supportController.close();
  }

  void postPrivy(int user) async {
    File? ktp = ktpController.valueOrNull;
    File? selfie = selfieController.valueOrNull;
    File? support = supportController.valueOrNull;
    String code = codeCaseController.value;
    String type = typeController.value;

    try {
      final response = await _apiService.postPrivyRejected(
        code,
        type,
        ktp,
        selfie,
        support,
        user
      );
      print(response.body);
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        casePrivyMessage.sink.add(PrivyCaseSuccess());
        _apiService.setBeranda();
      } else {
        casePrivyMessage.sink.add(
          PrivyCaseError(responseBody['message'], responseBody),
        );
      }
    } catch (e) {
      casePrivyMessage.sink.add(
        PrivyCaseError(e.toString(), e),
      );
    }
  }

  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
}
