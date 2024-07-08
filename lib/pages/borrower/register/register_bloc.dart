import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class RegisterBloc {
  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
  int currentStep = 0;
  final stepController = BehaviorSubject<int>.seeded(0);

  //step 1 controller
  final nameController = BehaviorSubject<String>();
  final emailController = BehaviorSubject<String>();
  final phoneController = BehaviorSubject<String>();
  final referralController = BehaviorSubject<String?>();
  final agreeController = BehaviorSubject<bool>.seeded(false);
  final haveAgreeController = BehaviorSubject<bool>.seeded(false);
  final validateStep1Controller = BehaviorSubject<bool>();

  //step 2 controller
  final tokenController = BehaviorSubject<String>();
  final otpStatusController = BehaviorSubject<bool>();
  final otpResponse = BehaviorSubject<String>();
  final haveResendController = BehaviorSubject<bool>.seeded(false);

  //step 3 controller
  final passwordController = BehaviorSubject<String>();
  final confirmPasswordController = BehaviorSubject<String>();
  final locationRegisController = BehaviorSubject<bool>();

  //step 4 controller
  final provinsiController = BehaviorSubject<int?>();
  final kotaController = BehaviorSubject<int?>();

  //change email controller

  Stream<int> get stepStream => stepController.stream;

  //step 1 stream
  Stream<String> get nameStream => nameController.stream;
  Stream<String> get emailStream => emailController.stream;
  Stream<String> get phoneStream => phoneController.stream;
  Stream<String?> get referralStream => referralController.stream;
  Stream<bool> get agreeStream => agreeController.stream;
  Stream<bool> get haveAgreeStream => haveAgreeController.stream;
  Stream<bool> get validateStep1Stream => validateStep1Controller.stream;
  Stream<bool> get buttonStep1Stream {
    return Rx.combineLatest5(
        nameStream, emailStream, phoneStream, agreeStream, validateStep1Stream,
        (
      String name,
      String email,
      String phone,
      bool agree,
      bool isValid,
    ) {
      final nameValid = name.isNotEmpty && name.length >= 3;
      final emailValid = email.isNotEmpty && Validator.isValidEmail(email);
      final phoneValid =
          phone.isNotEmpty && Validator.isValidPhoneNumber(phone);
      final agreeValid = agree == true;
      final isValidTrue = isValid == true;
      return nameValid && emailValid && phoneValid && agreeValid && isValidTrue;
    });
  }

  //step 2 stream
  Stream<String> get tokenStream => tokenController.stream;
  Stream<bool> get otpStatusStream => otpStatusController.stream;
  Stream<String> get otpFailedResponse => otpResponse.stream;
  Stream<bool> get haveResendStream => haveResendController.stream;

  //step 3 stream
  Stream<String> get passwordStream => passwordController.stream;
  Stream<String> get confirmPasswordStream => confirmPasswordController.stream;
  Stream<bool> get passwordButtonStream => Rx.combineLatest2(
        passwordStream,
        confirmPasswordStream,
        (
          String password,
          String confirmPassword,
        ) {
          final bool passwordValid = Validator.isValidPasswordRegis(password);
          final bool confirmPasswordValid =
              Validator.isValidPasswordRegis(confirmPassword);
          final bool samePass = password == confirmPassword;
          return passwordValid && confirmPasswordValid && samePass;
        },
      );
  Stream<bool> get locationRegisStream => locationRegisController.stream;

  //step 4 stream
  Stream<int?> get provinsiStream => provinsiController.stream;
  Stream<int?> get kotaStream => kotaController.stream;
  Stream<bool> get locationButtonStream =>
      Rx.combineLatest2(provinsiStream, kotaStream, (int? provinsi, int? kota) {
        return provinsi != null && kota != null;
      });

  //change email response

  void dispose() {
    stepController.close();
    nameController.close();
    emailController.close();
    phoneController.close();
    referralController.close();
    agreeController.close();
    haveAgreeController.close();
    passwordController.close();
    confirmPasswordController.close();
  }

  void nextStep() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = stepController.valueOrNull ?? 0;
    if (val < 5) {
      val++;
      stepController.sink.add(val);
      if (val > 2) {
        print('sama dengan 2');
        await prefs.setInt('step_sementara', val);
      }
    }
  }

  void prevStep() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = stepController.valueOrNull ?? 0;
    print('sama dengan 1 aja $val');
    if (val > 0) {
      val--;
      stepController.sink.add(val);
      if (val > 2) {
        print('sama dengan 2 aja');
        await prefs.setInt('step_sementara', val);
      }
    }
  }

  void changeName(String value) {
    final controller = nameController.sink;
    controller.add(value);
    if (value.isEmpty) {
      controller.addError('Nama wajib diisi');
    } else if (value.length < 3) {
      controller.addError('Nama minimal 3 karakter');
    }
  }

  // void changeEmail(String email) {
  //   final controller = emailController.sink;
  // }

  // void changePhone(String value) {
  //   final controller = phoneController.sink;
  // }

  void getEmailAndPhone(String email, String phone, String kode) async {
    String? emailPost;
    String? phonePost;
    if (email.length > 0) {
      emailPost = email;
    }
    if (phone.length > 2) {
      phonePost = phone;
    }

    //phone validation

    final response =
        await _apiService.validateEmailAndPhone(emailPost, phonePost, kode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final bool emailRes = jsonData["data"]["email"]["status_email"];
      final bool phoneRes = jsonData["data"]["hp"]["satus_hp"];
      final bool referralRes = jsonData["data"]["kode_unik"];

      //email validation
      if (email.length > 0) {
        emailController.sink.add(email);
        if (emailPost!.isEmpty) {
          emailController.sink.addError('Email wajib diisi');
        } else if (emailRes == false) {
          emailController.sink.addError("Email sudah terdaftar");
        } else if (!Validator.isValidEmail(emailPost)) {
          emailController.sink.addError('Email tidak valid');
        }
      }

      if (phone.length > 0) {
        phoneController.sink.add(phone);
        if (phone.isEmpty) {
          phoneController.sink.addError('Nomor Handphone wajib diisi');
        } else if (phoneRes == false) {
          phoneController.sink.addError('Nomor sudah terdaftar');
        } else if (!Validator.isValidPhoneNumber(phone)) {
          phoneController.sink.addError('Nomor Handphone tidak valid');
        }
      }

      if (kode.isNotEmpty) {
        referralController.sink.add(kode);
      }
      if (referralRes == false && kode.isNotEmpty) {
        referralController.sink.addError('Kode referral tidak valid');
      } else {
        referralController.sink.addError('');
      }

      if (emailRes == false ||
          phoneRes == false ||
          (referralRes == false && kode.length >= 1)) {
        validateStep1Controller.sink.add(false);
      } else {
        validateStep1Controller.sink.add(true);
      }
    }
  }

  // void changeReferral(String? value) {
  //   final controller = referralController.sink;
  //   // final val = int.tryParse(value!) ?? null;
  //   controller.add(value);
  // }

  void changeAgree(bool val) {
    final controller = agreeController.sink;
    controller.add(val);
    haveAgreeController.sink.add(true);
  }

  void nextToOtp(BuildContext context) async {
    final phone = phoneController.value;
    final response = await _apiService.requestOtp(phone);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(response.body.toString());
      stepController.sink.add(1);
    } else {
      context.showSnackBarError(
          'Maaf terjadi kesalahan, status: ${body['data']}, pesan: ${body['message']}');
    }
  }

  //step 2 changed
  void resendOtp(BuildContext context) async {
    final phone = phoneController.value;
    final response = await _apiService.resendOtp(phone);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(response.body.toString());
      haveResendController.sink.add(true);
      context.showSnackBarSuccess('Berhasil mengirim ulang otp');
      // nextStep();
    } else {
      context.showSnackBarError(body['message']);
    }
  }

  void postOtp(String otp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final LocalStorage storage = LocalStorage('todo_app.json');
    final rxPrefs = RxSharedPreferences(
      SharedPreferences.getInstance(),
      kReleaseMode ? null : RxSharedPreferencesDefaultLogger(),
    );
    final String name = nameController.value;
    final String email = emailController.value;
    final String phone = phoneController.value;
    String referral = '';
    if (referralController.hasValue) {
      referral = referralController.value!;
    }
    print(referral);
    final response =
        await _apiService.validateOtp(name, phone, email, otp, referral);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      otpStatusController.sink.add(true);
      tokenController.sink.add(body['data']['token']);
      final responseBerandaUser = await _apiService.setBerandaToken(
          tokenController.value, 'passwordScreen');
      await prefs.setString(
          'beranda_sementara', responseBerandaUser.toString());
      await prefs.setString(
          'token_sementara', tokenController.value.toString());
      await rxPrefs.setString('token', tokenController.value.toString());
      print(' token sementara bloc register');
      print(prefs.getString('token_sementara'));
      // await prefs.setInt('step_sementara', 2);
      await storage.setItem('cache', true);
      nextStep();
    } else {
      otpStatusController.sink.add(false);
      print(response.body);
    }
  }

  //step 3 changed
  void passwordChange(String value) {
    final controller = passwordController.sink;

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

  void confirmChange(String value) {
    confirmPasswordController.sink.add(value);
  }

  void postPassword(
    BuildContext context,
    String provinceName,
    String kotaName,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String password = passwordController.value;
    final String confirmPassword = confirmPasswordController.value;
    final String token = tokenController.value;
    final response = await _apiService.createPassword(
      token,
      password,
      confirmPassword,
    );
    print(response);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> provinceList =
          await _apiService.fetchProvince();
      print('provinsinya bang: $provinceName');
      print(provinceList);
      final int idProvince = getIndexProvince(provinceList, provinceName);
      if (idProvince != -1) {
        provinsiController.sink.add(idProvince);
        await prefs.setInt('step_sementara', 4);
        addMitra(context);
        resendEmail(context, 3);
      } else {
        await prefs.setInt('step_sementara', 3);
        locationNotExist(context);
      }
    } else {
      // await prefs.setInt('step_sementara', 2);
      context.showSnackBarError('Maaf sepertinya ada kesalahan');
    }
  }

  void locationNotExist(BuildContext context) {
    BuildContext? dialogContext;
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return ModalPopUp(
          icon: 'assets/images/register/warning.svg',
          title: locationNotExistTitle,
          message: locationNotExistSub,
          actions: [
            Button2(
              btntext: checkLocation,
              action: () {
                if (dialogContext != null) {
                  Navigator.of(dialogContext!).pop();
                  nextStep();
                }
              },
            ),
            const SizedBox(height: 11),
            Center(
              child: TextButton(
                child: const Headline5(
                  text: cancelText,
                  color: Color(0xff288C50),
                ),
                onPressed: () {
                  if (dialogContext != null) {
                    Navigator.of(dialogContext!).pop();
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //step 4
  void changeProvinsi(int? provinsi) {
    if (provinsi != null) {
      provinsiController.sink.add(provinsi);
    } else {
      provinsiController.sink.addError('Provinsi wajib diisi');
      provinsiController.sink.add(null);
      kotaController.sink.addError('Kota Kabupaten wajib diisi');
    }
  }

  void changeKota(int? kota) {
    if (kota != null) {
      kotaController.sink.add(kota);
    } else {
      kotaController.sink.addError('Kota/Kabupaten wajib diisi');
      kotaController.sink.add(null);
    }
  }

  void addMitra(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token_sementara'));

    final Map<String, dynamic> decodedToken =
        JwtDecoder.decode(prefs.getString('token_sementara')!);
    print(decodedToken);
    if (prefs.getString('token_sementara') != null) {
      final token = prefs.getString('token_sementara') ?? '';
      emailController.add(decodedToken['email']);
      nameController.add(decodedToken['username']);
      tokenController.add(token);
    }
    final String email = emailController.valueOrNull ?? 'example@gmail.com';
    final String nama = nameController.valueOrNull ?? '';
    final String hp = phoneController.valueOrNull ?? '';
    final String idProvinsi = provinsiController.valueOrNull.toString();
    final String idkabupaten = kotaController.valueOrNull.toString();
    // print('kabupaten $hp');
    final response =
        await _apiService.addMitra(email, nama, hp, idProvinsi, idkabupaten);
    final Map<String, dynamic> responseBody = jsonDecode(response.toString());
    print('response body $responseBody');
  }

  //step 5
  void resendEmail(BuildContext context, int statusSend) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token_sementara'));

    final Map<String, dynamic> decodedToken =
        JwtDecoder.decode(prefs.getString('token_sementara')!);
    print(decodedToken);
    if (prefs.getString('token_sementara') != null) {
      final token = prefs.getString('token_sementara') ?? '';
      emailController.add(decodedToken['email']);
      tokenController.add(token);
    }
    final String token = tokenController.valueOrNull ?? '';
    final String email = emailController.valueOrNull ?? 'example@gmail.com';
    final response = await _apiService.resendEmail(token, email);
    final responseBody = jsonDecode(response.body);
    await prefs.setInt('step_sementara', 4);
    print(email);
    print(token);
    print(responseBody);
    if (response.statusCode == 200) {
      if (statusSend == 1) {
        nextStep();
      } else if (statusSend == 2) {
        context.showSnackBarSuccess(responseBody['message']);
      } else if (statusSend == 3) {
        stepController.sink.add(4);
      }
    } else {
      context.showSnackBarError(responseBody['message']);
    }
  }

  //step 6 change email
  void changeEmailExisting(BuildContext context, String email) async {
    print('sip');
    final String token = tokenController.valueOrNull ?? '';
    final response = await _apiService.updateEmail(token, email);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      emailController.add(email);
      stepController.add(4);
    } else {
      // ignore: use_build_context_synchronously
      context.showSnackBarError(responseBody['message']);
    }
  }
}

int getIndexProvince(
  List<Map<String, dynamic>> provinceList,
  String provinceName,
) {
  int result = -1;
  if (provinceName == 'Daerah Khusus Ibukota Jakarta') {
    provinceName = 'jakarta';
  }
  for (var i = 0; i < provinceList.length; i++) {
    if (provinceList[i]['nama_provinsi']
        .toString()
        .toLowerCase()
        .contains(provinceName.toLowerCase())) {
      result = provinceList[i]['id_provinsi'];
      break;
    }
  }
  return result;
}

int getIndexKota(
  List<Map<String, dynamic>> kotaList,
  String kotaName,
) {
  int result = -1;
  for (var i = 0; i < kotaList.length; i++) {
    if (kotaList[i]['nama_kabupaten']
        .toString()
        .toLowerCase()
        .contains(kotaName.toLowerCase())) {
      result = kotaList[i]['id_kabupaten'];
      break;
    }
  }
  return result;
}
