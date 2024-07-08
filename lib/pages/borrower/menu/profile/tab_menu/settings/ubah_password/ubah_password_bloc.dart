import 'dart:convert';

import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

import 'ubah_password_state.dart';

class ChangePasswordBloc {
  final passwordController = BehaviorSubject<String>();
  Stream<String> get passwordStream => passwordController.stream;

  final newPasswordController = BehaviorSubject<String>();
  Stream<String> get newPasswordStream => newPasswordController.stream;

  final confirmPasswordController = BehaviorSubject<String>();
  Stream<String> get confirmPasswordStream => confirmPasswordController.stream;

  Stream<bool> get buttonKataSandi => Rx.combineLatest3(
          passwordStream, newPasswordStream, confirmPasswordStream,
          (String a, String b, String c) {
        return a.length > 3 &&
            Validator.isValidLengthPassWord(b) &&
            Validator.isValidLowerCase(b) &&
            Validator.isValidUpperCase(b) &&
            Validator.isValidPasswordNumber(b) &&
            b == c;
      });

  final message = BehaviorSubject<ChangePasswordState?>();
  Stream<ChangePasswordState?> get messageStream => message.stream;

  void passwordChange(String value) {
    final controller = newPasswordController.sink;

    final List<String> errors = [];

    if (!Validator.isValidLowerCase(value)) {
      errors.add('1');
    }
    if (!Validator.isValidUpperCase(value)) {
      errors.add('2');
    }
    if (!Validator.isValidPasswordNumber(value)) {
      errors.add('3');
    }
    if (!Validator.isValidLengthPassWord(value)) {
      errors.add('4');
    }

    if (errors.isNotEmpty) {
      controller.addError(errors);
    } else {
      controller.add(value);
    }
  }

  void postChangePassword() async {
    try {
      final old = passwordController.valueOrNull;
      final newPass = newPasswordController.valueOrNull;
      final confirm = confirmPasswordController.valueOrNull;
      if (old != null && newPass != null && confirm != null) {
        final response =
            await _apiService.updatePassword(old, newPass, confirm);
        final data = jsonDecode(response.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          message.sink.add(const ChangePasswordStateSuccess());
        } else {
          message.sink.add(
            ChangePasswordStateErrorValidation(
              data['message'],
              data,
            ),
          );
        }
      } else {
        message.sink.add(
          const ChangePasswordStateError(
            'Pastikan anda mengisi semua form',
            [],
          ),
        );
      }
    } catch (e) {
      message.sink.add(
        ChangePasswordStateError(
          e.toString(),
          e,
        ),
      );
    }
  }

  void dispose() {
    passwordController.close();
    newPasswordController.close();
    confirmPasswordController.close();
  }

  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
}
