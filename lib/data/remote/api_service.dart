import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/data/api/http_client.dart';
import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/data/remote/response/simulasi_cicilan/list_produk.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/info_product_use_case.dart';
import 'package:flutter_danain/domain/usecases/post_hubungan_keluarga.dart';
import 'package:flutter_danain/domain/usecases/simulasi_cnd_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/exception/remote_data_source_exception.dart';
import 'package:flutter_danain/data/remote/remote_data_source.dart';
import 'package:flutter_danain/data/remote/response/token_response.dart';
import 'package:flutter_danain/data/remote/response/user_response.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart' as path;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../domain/models/pendanaan.dart';

class ApiService implements RemoteDataSource {
  static const String xAccessToken = 'token';
  static const String golangAuth = 'golang-auth';
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  final LocalStorage storage = LocalStorage('todo_app.json');
  final SimpleHttpClient _client;
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );

  Future<String?> tokenFromCache() async {
    final prefs = RxSharedPreferences.getInstance();
    return await prefs.getString('token');
  }

  ApiService(this._client);

  String generateSignatureKey(Map<String, dynamic> payload) {
    final header = {
      'alg': 'HS256', // Algorithm used for signature (HMAC SHA-256)
      'typ': 'JWT' // Token type
    };

    final secretKey = utf8.encode(dotenv.env['SECRET_KEY']!);
    final String base64Header = base64UrlWithoutPadding(json.encode(header));
    final String base64Payload = base64UrlWithoutPadding(json.encode(payload));

    final String signatureInput = '$base64Header.$base64Payload';
    final hmac = Hmac(sha256, secretKey);
    final digest = hmac.convert(utf8.encode(signatureInput));

    final base64Signature = base64Url
        .encode(digest.bytes)
        .replaceAll('+', '-')
        .replaceAll('/', '_')
        .replaceAll('=', '');
    return base64Signature;
  }

  String base64UrlWithoutPadding(String input) {
    return base64Url
        .encode(utf8.encode(input))
        .replaceAll('+', '-')
        .replaceAll('/', '_')
        .replaceAll('=', '');
  }

  String encodeJwt(Map<String, dynamic> payload, String secretKey) {
    final jwt = JWT(payload);
    final token = jwt.sign(SecretKey(secretKey));
    return token.toString();
  }

  static Single<T> _wrap<T>(
          Future<T> Function(CancellationToken token) block) =>
      useCancellationToken<T>((cancelToken) async {
        try {
          return await block(cancelToken);
        } on CancellationException {
          rethrow;
        } on SocketException catch (e, s) {
          throw RemoteDataSourceException('No internet connection', e, s);
        } on SimpleTimeoutException catch (e, s) {
          throw RemoteDataSourceException('Timeout error', e, s);
        } on SimpleErrorResponseException catch (e, s) {
          String message = '';
          try {
            if (e.statusCode == 404) {
              message = 'Url tidak terdefinisi';
            } else if (e.statusCode == 400 || e.statusCode == 401) {
              message = jsonDecode(e.errorResponseBody)['message'] as String;
            } else if (e.statusCode == 500 || e.statusCode == 502) {
              message = 'Saat ini aplikasi sedang mengalami gangguan';
            }
          } catch (error) {
            message = error.toString();
          }

          throw RemoteDataSourceException(message, e, s);
        } catch (e, s) {
          throw RemoteDataSourceException('Other error', e, s);
        }
      });
  void sendCrash(
    String url,
    Map<String, dynamic> param,
    dynamic response,
  ) async {
    final Map<String, dynamic> data = {
      'url': url,
      'param': param.toString(),
      'response': response.toString(),
    };
    print('data bang: $data');
    FormatException(data.toString());
  }

  ///
  /// Login user with [email] and [password]
  /// return [TokenResponse] including message and token
  ///
  @override
  Single<TokenResponse> loginUser(
    String email,
    String password,
  ) =>
      _wrap(
        (cancelToken) async {
          final dateNow = Signature().getTimestamp();

          final urlBorrower = Uri.https(
            dotenv.env['BASE_URL']!,
            'api/beeborroweruser/v1/user/login',
          );
          final urlLender = Uri.https(
            dotenv.env['BASE_URL']!,
            'api/beedanainuser/v1/datas/login',
          );
          final map = <String, dynamic>{};
          map['email'] = email;
          map['password'] = password;
          Map<String, dynamic> json = {};
          final payloadLender = {
            'request': map,
            'timestamp': dateNow,
          };
          final payloadUser = {
            'request': {'hp': email, 'password': password},
            'timestamp': dateNow,
          };
          final signature = generateSignatureKey(payloadUser);
          final int userStatus = await rxPrefs.getInt('user_status') ?? 0;

          print('OKE DAH BANG');

          switch (userStatus) {
            case 2:
              json = await _client.postJson(
                urlBorrower,
                headers: {
                  'Authorization': Signature().getBasicAuth(
                    dotenv.env['UNAMEAUTH'].toString(),
                    dotenv.env['PWAUTH'].toString(),
                  ),
                  'golang-auth': 'golang123',
                  'api-key': dotenv.env['API_KEY_AUTH'].toString(),
                  'timestamps': dateNow,
                  'x-SIGNATURE-key': signature,
                },
                body: payloadUser,
                cancelToken: cancelToken,
              );

              break;
            case 1:
              json = await _client.postJson(
                urlLender,
                body: payloadLender,
                headers: {
                  'Authorization': Signature().getBasicAuth(
                    dotenv.env['UNAMELENDER'].toString(),
                    dotenv.env['PWLENDER'].toString(),
                  ),
                  'golang-auth': 'golang123',
                  'api-key': dotenv.env['API_KEY_LENDER'].toString(),
                  'timestamps': dateNow,
                  'x-SIGNATURE-key': signature,
                },
              );

              break;
            default:
          }
          print('ok bang');
          final Map<String, dynamic> jsonData = {
            'token': json['data']['accessToken'].toString(),
            'refreshToken': json['data']['refreshToken'].toString(),
            'message': json['message'] ?? json['responseMessage'],
          };

          await storage.setItem(
            'token',
            json['data']['accessToken'],
          );
          await rxPrefs.setString(
            'token',
            json['data']['accessToken'].toString(),
          );
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', json['data']['accessToken']);

          return TokenResponse.fromJson(jsonData);
        },
      );

  @override
  Single<TokenResponse> refreshToken(String refreshToken) => _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/beeborroweruser/v1/user/refresh',
          );
          final dateNow = Signature().getTimestamp();
          final secret = dotenv.env['API_KEY_AUTH']!;
          final payload = {
            'get': url.toString(),
            'timestamp': dateNow,
          };
          final signature = Signature().getSignature(secret, payload);
          final header = {
            'api-key': secret,
            'x-SIGNATURE-key': signature,
            'timestamps': dateNow,
          };
          final response = await _client.getJson(
            url,
            headers: header,
          );
          final Map<String, dynamic> jsonData = {
            'token': response['data']['accessToken'].toString(),
            'refreshToken': response['data']['refreshToken'].toString(),
            'message': response['message'],
          };
          await storage.setItem(
            'token',
            response['data']['accessToken'],
          );
          await rxPrefs.setString(
            'token',
            response['data']['accessToken'].toString(),
          );
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response['data']['accessToken']);
          return TokenResponse.fromJson(jsonData);
        },
      );
  @override
  Single<TokenResponse> registerBorrower(Map<String, dynamic> myJson) => _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/beeborroweruser/v1/user/register-borrower',
          );
          final dateNow = Signature().getTimestamp();
          final secret = dotenv.env['API_KEY_AUTH']!;
          final payload = {
            'get': url.toString(),
            'timestamp': dateNow,
          };
          final signature = Signature().getSignature(secret, payload);
          final header = {
            'api-key': secret,
            'x-SIGNATURE-key': signature,
            'timestamps': dateNow,
          };
          payload;
          final response = await _client.postJson(
            url,
            body: {
              'request': myJson,
            },
            headers: header,
          );
          final Map<String, dynamic> jsonData = {
            'token': response['data']['token']['AccessToken'].toString(),
            'refreshToken':
                response['data']['token']['RefreshToken'].toString(),
            'message': response['responseMessage'],
          };
          await storage.setItem(
            'token',
            response['data']['token']['AccessToken'],
          );
          await rxPrefs.setString(
            'token',
            response['data']['token']['AccessToken'],
          );
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'token',
            response['data']['token']['AccessToken'],
          );
          return TokenResponse.fromJson(jsonData);
        },
      );

  @override
  Single<TokenResponse> sendRegisterLender(
    String phone,
    String name,
    String? referal,
    String email,
    String password,
  ) =>
      _wrap((cancelToken) async {
        final urlLender = Uri.https(
            dotenv.env['BASE_URL']!, '/api/v1/msuser//datas/registrasi');
        final body = {
          'email': email,
          'password': password,
          'password_confirm': password,
          'hp': phone,
          'nama': name,
          'referal': referal!,
        };

        final json = await _client.postMultipart(
          urlLender,
          [],
          fields: body,
          headers: {}, // Provide an empty map for no additional headers
        );
        final Map<String, dynamic> jsonData = {
          'token': json['data']['token'],
          'message': json['message'],
          'status': json['status'],
        };
        await _analytics.logEvent(name: 'register_Step_1', parameters: {
          'email': email,
          'phone_number': phone,
          'name': name,
          'type': 'lender'
        });

        await storage.setItem('token', json['data']);
        await rxPrefs.setString('token', json['data']['token'].toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', json['data']['token']);
        if (json != null && json['status'] != 200 && json['status'] != 201) {
          sendCrash(
            urlLender.toString(),
            body,
            json,
          );
        }
        return TokenResponse.fromJson(jsonData);
      });

  @override
  Single<TokenResponse> forgotPasswordFirst(
    String email,
  ) =>
      _wrap(
        (cancelToken) async {
          final int userStatus = await rxPrefs.getInt('user_status') ?? 0;
          var response;
          final url = Uri.parse(
              'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/forgotPassword/request');
          final maps = {
            'request': {'email': email}
          };
          final dateNow = Signature().getTimestamp();
          final payload = {
            'request': {'email': email},
            'timestamp': dateNow
          };
          final token = await tokenFromCache();
          final signature = generateSignatureKey(payload);
          final headers = {
            'timestamps': dateNow,
            'api-key': signature,
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          };
          final urlLender = Uri.parse(
              'https://${dotenv.env['BASE_URL']}/api/v1/msuser/datas/resetpassword');
          final map = <String, dynamic>{};
          map['email'] = email;
          final responip =
              await http.get(Uri.parse('https://api.ipify.org?format=json'));

          final dataip = responip.body;
          final jsondataip = jsonDecode(dataip);
          final String? result = await PlatformDeviceId.getDeviceId;
          print('Platform: $result');
          final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          print('Running on ${androidInfo.model}');
          final body = {
            'email': email,
            'ip': jsondataip['ip'].toString(),
            'device': androidInfo.model,
            'macAddr': '2222'
          };

          switch (userStatus) {
            case 2:
              response = await _client.postJson(
                url,
                headers: headers,
                body: maps,
              );
              break;
            case 1:
              final String username = dotenv.env['USERNAMELENDER'].toString();
              final String password = dotenv.env['PASSWORDLENDER'].toString();
              final String cred = '$username:$password';
              final String basicAuth =
                  'Basic ${base64Encode(utf8.encode(cred))}';

              final headers = {
                'Authorization': basicAuth,
                'golang-auth': 'twb3pkKgSge6DstmrQW49w'
              };

              await rxPrefs.setString('email_reset_password', email);
              response = await _client.postMultipart(
                urlLender,
                [],
                fields: body,
                headers:
                    headers, // Provide an empty map for no additional headers
              );

              break;

            // More cases as needed
            default:
            // Code to execute if none of the cases match the expression
          }
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> makeNewPassword(
    String kodeVerifikasi,
    String password,
  ) =>
      _wrap(
        (cancelToken) async {
          final int userStatus = await rxPrefs.getInt('user_status') ?? 0;
          final email = await rxPrefs.getString('email_reset_password');
          final url = Uri.https(dotenv.env['BASE_URL']!,
              '/api/borroweruser/v2/user/forgotPassword/validasi');
          final bodys = {
            'request': {'token': kodeVerifikasi, 'password': password}
          };
          final dateNow = Signature().getTimestamp();
          final payload = {
            'request': {'token': kodeVerifikasi, 'password': password},
            'timestamp': dateNow
          };
          final token = await tokenFromCache();
          final signature = generateSignatureKey(payload);
          final headers = {
            'timestamps': dateNow,
            'api-key': signature,
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          };
          var response;
          final urlLender = Uri.parse(
              'https://${dotenv.env['BASE_URL']}/api/v1/msuser/datas/validasiresetpassword');
          final map = <String, dynamic>{};
          map['token'] = kodeVerifikasi;
          map['email'] = email;
          map['password'] = password;
          map['password_confirm'] = password;
          final body = {
            'token': kodeVerifikasi,
            'email': email ?? '',
            'password': password,
            'password_confirm': password,
          };

          switch (userStatus) {
            case 2:
              response =
                  await _client.postJson(url, headers: headers, body: bodys);
              break;
            case 1:
              response = await _client.postMultipart(
                urlLender,
                [],
                fields: body,
                headers: {}, // Provide an empty map for no additional headers
              );
              break;
            // More cases as needed
            default:
            // Code to execute if none of the cases match the expression
          }
          return TokenResponse.fromJson(response);
        },
      );

  ///
  /// Login user with [email] and [password]
  /// return message
  ///
  Future<http.Response> getFaqList() async {
    final urlString =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/v2/faq/listfaq';
    final url = Uri.parse(urlString);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': urlString,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {'timestamps': dateNow, 'api-key': signature};
    final response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }

  Future<http.Response> getFaqDetail(dynamic idFaq) async {
    final String initUrl =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/v2/master/listactive/faqdetail';
    final urlString = '$initUrl?idfaq=$idFaq';
    final url = Uri.parse(urlString);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': initUrl,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {'timestamps': dateNow, 'api-key': signature};
    final response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }

  ///
  /// Get user profile by [email] and [token]
  /// return [User]
  ///ww
  ///
  @override
  Single<UserResponse> getUserProfile(
    String token,
  ) =>
      _wrap((cancelToken) async {
        final int userStatus = await rxPrefs.getInt('user_status') ?? 0;
        await storage.setItem('state_beranda', null);
        final String initUrlProfileBorrower =
            'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/data/basicDataBorrower';
        final String initUrlProfileLender =
            'https://${dotenv.env['BASE_URL']}/api/beedanainuser/v1/access/profile';
        final urlStringProfile =
            userStatus == 1 ? initUrlProfileLender : initUrlProfileBorrower;
        final urlProfile = Uri.parse(urlStringProfile);
        final timestamp = Signature().getTimestamp();
        final headersProfileBorrower = {
          'golang-auth': 'golang123',
          'Authorization': 'Bearer $token',
        };

        var jsonProfile;

        switch (userStatus) {
          case 2:
            jsonProfile = await _client.getJson(
              urlProfile,
              headers: headersProfileBorrower,
            );
            break;
          case 1:
            final apiKeyLender = dotenv.env['API_KEY_LENDER'].toString();
            final payloadLender = {
              'get': urlStringProfile,
              'timestamp': timestamp,
            };
            final signatureLender = Signature().getSignature(
              apiKeyLender,
              payloadLender,
            );
            final headerLender = {
              'Authorization': 'Bearer $token',
              'api-key': apiKeyLender,
              'timestamps': timestamp,
              'x-SIGNATURE-key': signatureLender,
            };
            jsonProfile = await _client.getJson(
              urlProfile,
              headers: headerLender,
            );
            await rxPrefs.setString(
              'email_ubah',
              'azzam@gmail.com',
            );

            break;
          // More cases as needed
          default:
          // Code to execute if none of the cases match the expression
        }
        // _analytics.logEvent(name: 'login', parameters: {
        //   'Value': jsonProfile['data']['nama_borrower'],
        //   'idborrower': jsonProfile['data']['idborrower']
        // });

        final Map<String, dynamic> jsonDataProfile = {
          'username': userStatus == 1
              ? jsonProfile['data']['username'] ?? ''
              : jsonProfile['data']['nama_borrower'],
          'email': jsonProfile['data']['email'] ?? '',
          'id_borrower': userStatus == 1
              ? jsonProfile['data']['idUserClient']
              : jsonProfile['data']['idborrower'],
          'id_rekening':
              userStatus == 1 ? 0 : jsonProfile['data']['id_rekening'],
          'tlp_mobile': userStatus == 1
              ? jsonProfile['data']['hp'] ?? ''
              : jsonProfile['data']['tlp_mobile'],
          'ktp': userStatus == 1 ? 'kosong' : jsonProfile['data']['ktp'],
        };
        // final Map<String, dynamic> jsonDataProfile = {
        //   'username': 'azzam',
        //   'email': 'email',
        //   'id_borrower': 0,
        //   'id_rekening': 0,
        //   'tlp_mobile': '08213231231',
        //   'ktp': 'kosong',
        // };
        if (userStatus == 2) {
          await rxPrefs.setString(
            'usernameProfile',
            jsonProfile['data']['nama_borrower'],
          );
          await rxPrefs.setString(
            'ktpProfile',
            jsonProfile['data']['ktp'],
          );
        }
        // await _analytics.logEvent(name: 'login', parameters: {
        //   'Value': userStatus == 1
        //       ? jsonProfile['data']['username'] ?? ''
        //       : jsonProfile['data']['nama_borrower'],
        //   'idborrower': userStatus == 1
        //       ? jsonProfile['data']['idUserClient']
        //       : jsonProfile['data']['idborrower'],
        //   'type': userStatus == 1 ? 'lender' : 'borrower'
        // });

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString(
            'tlp_mobile',
            userStatus == 1
                ? jsonProfile['data']['hp'] ?? ''
                : jsonProfile['data']['tlp_mobile']);
        return UserResponse.fromJson(jsonDataProfile);
      });

  @override
  Single<TokenResponse> getBerandaProfile(String token, String lastPage) =>
      _wrap((cancelToken) async {
        final int userStatus = await rxPrefs.getInt('user_status') ?? 0;
        await storage.setItem('state_beranda', null);
        final String initUrl =
            'https://${dotenv.env['BASE_URL']}/api/beeborroweruser/v1/user/dashboard';
        final uriLender =
            'https://${dotenv.env['BASE_URL']}/api/beedanainuser/v1/access/beranda';
        final urlLender = Uri.parse(uriLender);
        final dateNow = Signature().getTimestamp();
        var json;
        var tokens;
        final secretKey = 'yourSecretKey';
        switch (userStatus) {
          case 2:
            final payloadBorrower = {
              'get': initUrl,
              'timestamp': dateNow,
            };
            final signatureBorrower = Signature().getSignature(
              secretKey,
              payloadBorrower,
            );
            final headerBorrower = {
              'Authorization': 'Bearer $token',
              'api-key': dotenv.env['API_KEY_AUTH'].toString(),
              'x-SIGNATURE-key': signatureBorrower,
            };
            json = await _client.getJson(
              Uri.parse(initUrl),
              headers: headerBorrower,
              cancelToken: cancelToken,
            );
            tokens = encodeJwt(
              {
                'beranda': json['data'],
                'last_page': lastPage,
              },
              secretKey,
            );
            break;
          case 1:
            final apiKeyLender = dotenv.env['API_KEY_LENDER'].toString();
            final payloadLender = {
              'get': uriLender,
              'timestamp': dateNow,
            };
            final signatureLender = Signature().getSignature(
              apiKeyLender,
              payloadLender,
            );
            final headerLender = {
              'Authorization': 'Bearer $token',
              'api-key': apiKeyLender,
              'timestamps': dateNow,
              'x-SIGNATURE-key': signatureLender
            };
            json = await _client.getJson(
              urlLender,
              headers: headerLender,
              cancelToken: cancelToken,
            );
            tokens = encodeJwt(
              {
                'beranda': json['data'],
                'last_page': lastPage,
              },
              secretKey,
            );
            break;
          // More cases as needed
          default:
          // Code to execute if none of the cases match the expression
        }

        final Map<String, dynamic> jsonData = {
          'token': tokens,
          'message': '',
          'status': json['status'],
          'lastPage': lastPage,
        };

        return TokenResponse.fromJson(jsonData);
      });

  @override
  Single<UserResponse> getUserProfileWithoutToken() =>
      _wrap((cancelToken) async {
        print('masuk di getBeranda profile');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token_sementara');
        await storage.setItem('state_beranda', null);
        final String initUrlProfile =
            'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/data/basicDataBorrower';
        final urlStringProfile = initUrlProfile;
        final urlProfile = Uri.parse(urlStringProfile);
        final headersProfile = <String, String?>{
          'golang-auth': 'golang123',
          'token': token,
        };

        // Remove null values from the headers
        final filteredHeadersProfile = headersProfile
            .map((key, value) =>
                MapEntry(key, value ?? '')) // Replace null with an empty string
            .cast<String, String>(); // Cast to non-nullable strings

        final jsonProfile = await _client.getJson(
          urlProfile,
          headers: filteredHeadersProfile,
          cancelToken: cancelToken,
        );
        print('data detail user ${jsonProfile['data']}');

        final Map<String, dynamic> jsonDataProfile = {
          'username': jsonProfile['data']['nama_borrower'],
          'email': jsonProfile['data']['email'],
          'id_borrower': jsonProfile['data']['idborrower'],
          'id_rekening': jsonProfile['data']['id_rekening'],
          'tlp_mobile': jsonProfile['data']['tlp_mobile'],
          'token': token,
          'ktp': jsonProfile['data']['ktp'] ?? '',
        };
        return UserResponse.fromJson(jsonDataProfile);
      });

  @override
  Single<TokenResponse> reqOtpChangeHp(
    String new_hp,
    String kode_verifikasi,
    File fileImage,
    String token,
  ) =>
      _wrap(
        (cancelToken) async {
          print('masuk req otp request hp gan');
          await rxPrefs.setString('hp_baru', new_hp);
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/requestotp/updatehp';

          final header = {
            'golang-auth': 'golang123',
            'token': token,
          };
          final body = {
            'new_hp': new_hp,
            'kode_verifikasi': kode_verifikasi,
          };

          final stream = http.ByteStream(fileImage.openRead());
          final length = await fileImage.length();
          final filename = path.basename(fileImage.path);

          final decoded = await _client.postMultipart(
            Uri.parse(uri),
            [
              http.MultipartFile(
                'fileimage',
                stream,
                length,
                filename: filename,
              ),
            ],
            fields: body,
            headers: header,
          );
          if (decoded != null &&
              decoded['status'] != 200 &&
              decoded['status'] != 201) {
            sendCrash(
              uri,
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> regisRdlLender(
    String token,
    Map<String, dynamic> payload,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/v1/msekyc/ekyc/registrasiRDL',
          );
          final Map<String, String> payloadAsString = {};

          payload.forEach((key, value) {
            final String stringValue = value.toString();
            payloadAsString[key] = stringValue;
          });
          final header = {'token': token};
          final response = await _client.postMultipart(
            url,
            [],
            headers: header,
            fields: payloadAsString,
          );
          if (response['status'] != 200 && response['status'] != 201) {
            sendCrash(
              url.toString(),
              payloadAsString,
              response,
            );
          }
          print(response);
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> reqOtpRegisterLender(
    String hp,
  ) =>
      _wrap(
        (cancelToken) async {
          print('masuk req otp request register lender gan');
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/v1/msuser/datas/sendotp';

          final String username = dotenv.env['USERNAMELENDER'].toString();
          final String password = dotenv.env['PASSWORDLENDER'].toString();
          final String cred = '$username:$password';
          final String basicAuth = 'Basic ${base64Encode(utf8.encode(cred))}';

          final headers = {
            'Authorization': basicAuth,
            'golang-auth': 'twb3pkKgSge6DstmrQW49w'
          };
          final body = {
            'hp': hp,
          };
          final decoded = await _client.postMultipart(
            Uri.parse(uri),
            [],
            fields: body,
            headers: headers,
          );
          if (decoded != null &&
              decoded['status'] != 200 &&
              decoded['status'] != 201) {
            sendCrash(
              uri,
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> sendOtpRegisterLender(
    String otp,
  ) =>
      _wrap(
        (cancelToken) async {
          print('masuk req otp request register lender gan');
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/v1/msuser/datas/postotp';

          final String username = dotenv.env['USERNAMELENDER'].toString();
          final String password = dotenv.env['PASSWORDLENDER'].toString();
          final String cred = '$username:$password';
          final String basicAuth = 'Basic ${base64Encode(utf8.encode(cred))}';

          final headers = {
            'Authorization': basicAuth,
            'golang-auth': 'twb3pkKgSge6DstmrQW49w'
          };
          final body = {
            'kode': otp,
          };
          final decoded = await _client.postMultipart(
            Uri.parse(uri),
            [],
            fields: body,
            headers: headers,
          );
          print('decode $decoded');
          if (decoded != null &&
              decoded['status'] != 200 &&
              decoded['status'] != 201) {
            sendCrash(
              uri,
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> sendOtpRegisterBorrower(
    String name,
    String phone,
    String email,
    String otp,
    String? kodeVerif,
  ) =>
      _wrap(
        (cancelToken) async {
          final String urlString =
              'https://${dotenv.env['BASE_URL']}/api/borroweruser/datas/validateotp/createBorrower';
          final url = Uri.parse(urlString);
          final headers = {'golang-auth': 'golang123'};
          final body = {
            'nama': name,
            'hp': phone,
            'email': email,
            'kode': otp,
            'kode_unik': kodeVerif ?? ''
          };
          final response =
              await _client.post(url, headers: headers, body: body);
          final Map<String, dynamic> decoded = json.decode(response.body);
          if (decoded['status'] != 200 && decoded['status'] != 201) {
            sendCrash(
              urlString,
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> reqOtpRegisterBorrower(
          String phone, String? kodeVeri) =>
      _wrap(
        (cancelToken) async {
          print('masuk req otp request register lender gan');
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/borroweruser/datas/requestotp/request';
          final url = Uri.parse(uri);
          final bodys = {'hp': phone};
          final headers = {'golang-auth': 'golang123'};

          final response =
              await _client.post(url, body: bodys, headers: headers);
          final decoded = json.decode(response.body);
          if (decoded != null &&
              decoded['status'] != 200 &&
              decoded['status'] != 201) {
            sendCrash(
              uri,
              bodys,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> sendPinRegisterLender(
    String pin,
    String token,
  ) =>
      _wrap(
        (cancelToken) async {
          print('masuk req otp request register lender gan');
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/v1/msuser//users/createpin';

          final headers = {
            'token': token,
          };
          final body = {
            'pin': pin,
          };
          final decoded = await _client.postMultipart(
            Uri.parse(uri),
            [],
            fields: body,
            headers: headers,
          );
          if (decoded != null &&
              decoded['status'] != 200 &&
              decoded['status'] != 201) {
            sendCrash(
              uri,
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> sendEmailRegisterLender(String token) => _wrap(
        (cancelToken) async {
          print('masuk req otp request register lender gan');
          final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          final String? emailUbah = await rxPrefs.getString('email_ubah');
          final String email =
              emailUbah == null ? decodedToken['email'] : emailUbah;
          print('email checking register ${emailUbah}');
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/v1/msuser//users/resendemail?email=$email';

          final headers = {
            'token': token,
          };
          final response = await _client.get(
            Uri.parse(uri),
            headers: headers,
          );
          final Map<String, dynamic> decoded = json.decode(response.body);
          if (decoded['status'] != 200 && decoded['status'] != 201) {
            sendCrash(
              uri,
              {},
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> validasiOtpChangeHp(
    String hp,
    String otp,
    String token,
  ) =>
      _wrap(
        (cancelToken) async {
          print('masuk req otp request hp gan');
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/validasiotp/updatehp';

          final header = {
            'golang-auth': 'golang123',
            'token': token,
          };
          final body = {
            'hp': hp,
            'otp': otp,
          };
          final decoded = await _client.postJson(
            Uri.parse(uri),
            body: body,
            headers: header,
            // cancelToken: cancelToken,
          );
          if (decoded['status'] != 200 && decoded['status'] != 201) {
            sendCrash(
              uri,
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> validasiOtpChangeEmail(
    String hp,
    String otp,
    String token,
  ) =>
      _wrap(
        (cancelToken) async {
          print('masuk req otp request email gan');
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/borroweruser/datas/validateotp/updatedataemail';

          final header = {
            'golang-auth': 'golang123',
            'token': token,
          };
          final body = {
            'hp': hp,
            'otp': otp,
          };
          print('hehe: $body');
          final decoded = await _client.postMultipart(
            Uri.parse(uri),
            [],
            fields: body,
            headers: header,
          );
          print('hai gan: $decoded');
          if (decoded['status'] == 200 || decoded['status'] == 201) {
            final Map<String, dynamic> data = decoded['data'];
            print(data);
            storage.setItem('verif_email', data['kodeVerifikasi']);
          } else {
            sendCrash(
              uri,
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );
  @override
  Single<TokenResponse> changeEmailRequest(
    String new_email,
    String kode_verifikasi,
    String type,
    File fileImage,
    String token,
  ) =>
      _wrap(
        (cancelToken) async {
          print('masuk req otp request hp gan');
          await rxPrefs.setString('email_baru', new_email);
          final uri =
              'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/request/updateemail';

          final header = {
            'golang-auth': 'golang123',
            'token': token,
          };
          final body = {
            'new_email': new_email,
            'kode_verifikasi': kode_verifikasi,
            'type': type
          };

          final stream = http.ByteStream(fileImage.openRead());
          final length = await fileImage.length();
          final filename = path.basename(fileImage.path);

          final decoded = await _client.postMultipart(
            Uri.parse(uri),
            [
              http.MultipartFile(
                'fileimage',
                stream,
                length,
                filename: filename,
              ),
            ],
            fields: body,
            headers: header,
          );
          if (decoded['status'] != 200 && decoded['status'] != 201) {
            sendCrash(
              uri,
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> getToken() => _wrap((cancelToken) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token_sementara');
        final Map<String, dynamic> jsonData = {
          'token': token,
          'message': 'sukses',
          'status': '200',
        };
        return TokenResponse.fromJson(jsonData);
      });

  @override
  Single<GeneralResponse> getBerandaProfileWithoutToken(String lastPage) =>
      _wrap((cancelToken) async {
        print('masuk di getBeranda profile');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token_sementara');
        await storage.setItem('state_beranda', null);
        final String initUrl =
            'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/beranda';
        final urlString = initUrl;
        final url = Uri.parse(urlString);
        final dateNow = Signature().getTimestamp();
        final payload = {
          'get': initUrl,
          'timestamp': dateNow,
        };
        final signature = generateSignatureKey(payload);
        final headers = {
          'timestamps': dateNow,
          'api-key': signature,
          'Authorization': 'Bearer $token',
        };
        final json = await _client.getJson(
          url,
          headers: headers,
          cancelToken: cancelToken,
        );
        final data = json['data'];
        await prefs.setBool('ktp_status', data['status']['ktp']);
        await prefs.setBool('selfie_status', data['status']['selfie']);
        const secretKey = 'yourSecretKey';
        final tokens = encodeJwt(
            {'beranda': json['data'], 'last_page': lastPage}, secretKey);
        final Map<String, dynamic> jsonData = {
          'token': tokens,
          'message': '',
          'status': json['status'],
          'lastPage': lastPage,
        };

        return GeneralResponse.fromJson(jsonData);
      });

  @override
  Single<TokenResponse> registerUser(
    String name,
    String email,
    String password,
  ) =>
      _wrap((cancelToken) async {
        final url = Uri.https(baseUrl, '/users');
        final body = <String, String>{
          'name': name,
          'email': email,
          'password': password,
        };
        final decoded = await _client.postJson(
          url,
          body: body,
          cancelToken: cancelToken,
        );

        return TokenResponse.fromJson(decoded);
      });

  ///
  /// Change password of user
  /// return message
  ///
  @override
  Single<TokenResponse> changePassword(
    String email,
    String password,
    String newPassword,
    String token,
  ) =>
      _wrap((cancelToken) async {
        final url = Uri.https(baseUrl, '/users/$email/password');
        final body = {'password': password, 'new_password': newPassword};
        final json = await _client.putJson(
          url,
          headers: {xAccessToken: token},
          body: body,
          cancelToken: cancelToken,
        );
        return TokenResponse.fromJson(json);
      });

  ///
  /// Reset password
  /// Special token and newPassword to reset password,
  /// otherwise, send an email to email
  /// return message
  ///
  @override
  Single<TokenResponse> resetPassword(
    String email,
  ) =>
      _wrap((cancelToken) async {
        final url = Uri.https(baseUrl, '/users/$email/password');
        final task = _client.postJson(
          url,
          body: {'email': email},
          cancelToken: cancelToken,
        );
        final json = await task;
        return TokenResponse.fromJson(json);
      });

  ///
  /// Upload avatar image
  /// return [User] profile after image file is uploaded
  ///
  ///

  @override
  Single<TokenResponse> cicilEmasReq(String token, int idProduk,
          List<dynamic> dataProduk, String? kodeCheckout) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/borrowerpinjaman/pinjaman/privy/cicilemas/requestotp',
          );
          final header = {'golang-auth': 'golang123', 'token': token};
          var body = {
            'idProduk': idProduk,
            'dataProdukSupplier': dataProduk,
          };

          if (kodeCheckout != null) {
            body = {
              'idProduk': idProduk,
              'dataProdukSupplier': dataProduk,
              'kodeCheckout': kodeCheckout
            };
          }

          final decoded = await _client.postJson(
            url,
            headers: header,
            body: body,
          );
          if (decoded['status'] == 201 || decoded['status'] == 200) {
            await storage.setItem(
                'kode_checkout', decoded['data']['kodeCheckouut']);
            print('kode bang: ${decoded['data']['kodeCheckouut']}');
          } else {
            sendCrash(
              url.toString(),
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> cicilEmasVal(
    String token,
    Map<String, dynamic> data,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/borrowerpinjaman/pinjaman/privy/cicilemas/validasiotp',
          );
          final header = {'golang-auth': 'golang123', 'token': token};
          print(data);
          final decoded = await _client.postJson(
            url,
            headers: header,
            body: data,
          );
          if (decoded['status'] == 201 || decoded['status'] == 200) {
            await storage.setItem(
              'response_cicil',
              jsonEncode(decoded['data']),
            );
          } else {
            sendCrash(
              url.toString(),
              data,
              decoded,
            );
          }
          print(jsonEncode(decoded['data']));

          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> actionCicilan(
    String token,
    String va,
    num total,
    int status,
  ) =>
      _wrap((cancelToken) async {
        final url = Uri.https(dotenv.env['BASE_URL']!,
            '/api/borrowertransaksi/auth/payment/cicilDp');
        final body = {
          'virtualAccount': va,
          'totalPembayaran': total,
          'isStatus': status,
        };
        const String username = 'OFyWRO1MwcPSY3GV0YaUNROgF0kUKUHG';
        const String password = '6UGO9w3a9Oj13ViToGikPfD9lVYOcI8T';
        const String cred = '$username:$password';
        final String basicAuth = 'Basic ${base64Encode(utf8.encode(cred))}';
        final header = {
          'Authorization': basicAuth,
          'golang-auth': 'golang-123',
          'token': token,
        };

        final decoded = await _client.postJson(
          url,
          headers: header,
          body: body,
        );

        if (decoded['status'] != 200 && decoded['status'] != 201) {
          sendCrash(
            url.toString(),
            body,
            decoded,
          );
        }
        return TokenResponse.fromJson(decoded);
      });

  Future<List<dynamic>> getMasterCaraBayar(String bank) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']!}/api/borrowerlist/v2/master/carabayar?namaBank=$bank');
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get':
          'https://${dotenv.env['BASE_URL']!}/api/borrowerlist/v2/master/carabayar',
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final header = {
      'api-key': signature,
      'timestamps': dateNow,
    };
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body);
    return data['data'];
  }

  Future<http.Response> reqOtpPenawaranPinjaman(
      String token, int idjaminan) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/borrowerpinjaman/pinjaman/privy/requestotp?idjaminan=$idjaminan');
    final header = {'golang-auth': 'golang123', 'token': token};
    final response = await http.get(url, headers: header);
    print(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> reqOtpKonfirmasiPinjaman(
      String token, int idjaminan) async {
    final String initUrl =
        'https://${dotenv.env['BASE_URL']}/api/beeborrowertransaksi/v1/cnd/requestotp?idjaminan=$idjaminan';

    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': initUrl,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {
      'Authorization': 'Bearer $token',
      'api-key': dotenv.env['API_KEY_AUTH'].toString(),
      'x-SIGNATURE-key': signature,
      'timestamps': dateNow,
    };
    print(headers);
    final Map<String, String> queryParams = {
      'idjaminan': idjaminan.toString(),
    };
    final url = Uri.https(dotenv.env['BASE_URL']!,
        '/api/beeborrowertransaksi/v1/cnd/requestotp', queryParams);
    final response = await http.get(url, headers: headers);
    print(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> getInfoPromoDanain(String token) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/v1/msuser/marketing/listbenner');
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    print(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    return response;
  }

  @override
  Single<TokenResponse> getPayment(
    String token,
    int idAgreement,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/borrowertransaksi/transaksi/portofolio/paymentpinjaman',
          );
          final header = {
            'golang-auth': 'golang123',
            'token': token,
          };
          final body = {'idagreement': idAgreement.toString()};
          final response = await _client.postMultipart(url, [],
              headers: header, fields: body);
          if (response['status'] == 200 || response['status'] == 201) {
            await storage.setItem(
              'result_payment',
              response['data'],
            );
          } else {
            sendCrash(
              url.toString(),
              {},
              response.body,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> postValidasiOtpPinjaman(
    String token,
    int idproduk,
    int idjaminan,
    String otp,
    int idRekening,
    String tujuanPinjaman,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(dotenv.env['BASE_URL']!,
              '/api/borrowerpinjaman/pinjaman/privy/validasiotp');
          final body = {
            'idproduk': idproduk.toString(),
            'idjaminan': idjaminan.toString(),
            'otp': otp,
            'idrekening': idRekening.toString(),
            'tujuan_pinjaman': tujuanPinjaman,
          };
          print('body validasi privy $body');
          final header = {'token': token, 'golang-auth': 'golang123'};
          final response = await _client.postMultipart(
            url,
            [],
            headers: header,
            fields: body,
          );
          print(response);
          if (response['status'] == 200 || response['status'] == 201) {
            await storage.setItem(
                'penawaran_pinjaman', jsonEncode(response['data']));
          } else {
            sendCrash(
              url.toString(),
              {},
              response.body,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );
  @override
  Future<Either<String, GeneralResponse>> postKonfirmasiPinjaman(
    String token,
    Map<String, dynamic> payload,
  ) async {
    final url =
        'https://${dotenv.env['BASE_URL']}/api/beeborrowertransaksi/v1/cnd/validasiotp';

    final header = {
      'Authorization': 'Bearer $token',
      'api-key': dotenv.env['API_KEY_AUTH'].toString(),
    };
    final response = await HttpClientCustom().postRequest(
      url,
      headers: header,
      body: payload,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>>
      postKonfirmasiPenyerahanKonfirmasPinjamanCND(
    String token,
    Map<String, dynamic> payload,
  ) async {
    final url =
        'https://${dotenv.env['BASE_URL']}/api/beeborrowertransaksi/v1/cnd/bpkb';
    final dateNow = Signature().getTimestamp();
    final payloadS = {
      'request': payload,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payloadS);
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': dotenv.env['API_KEY_AUTH'].toString(),
      'x-SIGNATURE-key': signature,
      'timestamps': dateNow,
    };
    final response = await HttpClientCustom().postRequest(
      url,
      headers: header,
      body: {'request': payload},
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Single<TokenResponse> postKonfirmasiSurveyCND(
    String token,
    int idTaskPengajuan,
    int idPengajuan,
  ) =>
      _wrap(
        (cancelToken) async {
          final String initUrl =
              'https://${dotenv.env['BASE_URL']}/api/beeborrowertransaksi/v1/cnd/konfirmasi/survey';
          final body = {
            'idPengajuan': idPengajuan,
            'idTaskPengajuan': idTaskPengajuan,
          };
          print('test body $body');
          final dateNow = Signature().getTimestamp();
          final payload = {
            'request': body,
            'timestamp': dateNow,
          };
          final signature = generateSignatureKey(payload);
          final headers = {
            'Authorization': 'Bearer $token',
            'api-key': dotenv.env['API_KEY_AUTH'].toString(),
            'x-SIGNATURE-key': signature,
            'timestamps': dateNow,
          };
          print('body header $headers $initUrl');
          final Map<String, String> queryParams = {
            'idTaskPengajuan': idTaskPengajuan.toString(),
          };
          final url = Uri.https(
              dotenv.env['BASE_URL']!,
              '/api/beeborrowertransaksi/v1/cnd/konfirmasi/survey',
              queryParams);

          final response = await _client
              .postJson(url, headers: headers, body: {'request': body});
          print(response);
          if (response['status'] == 200 || response['status'] == 201) {
          } else {
            sendCrash(
              url.toString(),
              {},
              response.body,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> simulasiPinjaman(
    int gram,
    int karat,
    int jangkaWaktu,
    int nilaiPinjaman,
  ) =>
      _wrap(
        (cancelToken) async {
          await storage.setItem('simulasiPinjaman', null);
          final url = Uri.https(dotenv.env['BASE_LUMEN_URL']!, '/simulasireal');
          final body = <String, dynamic>{
            'gram': gram,
            'idCompany': 6,
            'idProduk': 5,
            'jumlahHari': jangkaWaktu,
            'karat': karat,
            'nilaiPinjaman': nilaiPinjaman
          };
          print(body);
          print('print body simulasi pinjaman');
          final decoded = await _client.postJson(
            url,
            body: body,
            cancelToken: cancelToken,
          );

          if (decoded['status'] != 200 && decoded['status'] != 201) {
            sendCrash(
              url.toString(),
              body,
              decoded,
            );
          }
          await storage.setItem('simulasiPinjaman', decoded);
          return TokenResponse.fromJson(decoded);
        },
      );
  Future<http.Response> getMitraTerdekat(int provinsi, int kota) async {
    final url1 =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/master/all/listmitra?idProvinsi=$provinsi&idKota=$kota';
    print(url1);
    final url = Uri.parse(url1);
    final headers = {'golang-auth': 'golang123'};
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    return response;
  }

  //register
  Future<http.Response> validateEmailAndPhone(
      String? email, String? phone, String? referral) async {
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/datas/checkemailhp';
    final url = Uri.parse(urlString);
    final headers = {'golang-auth': 'golang123'};
    final body = {
      'email': email ?? 'sample@gmail.com',
      'hp': phone ?? '00000000000',
      'kode_unik': referral!,
    };
    print('response borrower valids ${body}');
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print('response borrower valid ${response.body}');
    return response;
  }

  Future<http.Response> validateBuatAkun(String? val, String? check) async {
    var atribute;
    if (check == 'ajaktemen') {
      atribute = 'kode=$val';
    } else {
      atribute = '$check=$val';
    }
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/v1/msuser/datas/checkdata/$check?$atribute';
    final url = Uri.parse(urlString);
    final String username = dotenv.env['USERNAMELENDER'].toString();
    final String password = dotenv.env['PASSWORDLENDER'].toString();
    final String cred = '$username:$password';
    final String basicAuth = 'Basic ${base64Encode(utf8.encode(cred))}';

    final headers = {
      'Authorization': basicAuth,
      'golang-auth': 'twb3pkKgSge6DstmrQW49w'
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> getDocumentPP() async {
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/beedanaingenerate/v1/dokumen/PP';
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': urlString,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final url = Uri.parse(urlString);
    final String username = dotenv.env['USERNAMEDOCUMENT'].toString();
    final String password = dotenv.env['PASSWORDDOCUMENT'].toString();
    final String cred = '$username:$password';
    final String basicAuth = 'Basic ${base64Encode(utf8.encode(cred))}';
    print("signature get document pp $signature");
    final headers = {
      'Authorization': basicAuth,
      'api-key': '1zxqyCk4wpG08bYcR0TvLZZmlOYmc2Hc'
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print('url validasi $urlString');
    print('response validate button ${response.body}');
    return response;
  }

  Future<http.Response> requestOtp(String phone) async {
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/datas/requestotp/request';
    final url = Uri.parse(urlString);
    final headers = {'golang-auth': 'golang123'};
    final body = {'hp': phone};
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        body,
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> resendOtp(String phone) async {
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/datas/requestotp/send';
    final url = Uri.parse(urlString);
    final headers = {'golang-auth': 'golang123'};
    final body = {'hp': phone};
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        body,
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> getCheckFdcs(String token) async {
    final String initUrlProfile =
        'https://${dotenv.env['BASE_URL']}/api/borrowertransaksi/transaksi/checkfdc';
    final urlStringProfile = initUrlProfile;
    final urlProfile = Uri.parse(urlStringProfile);
    final headersProfile = {
      'golang-auth': 'golang123',
      'token': token,
    };
    final response = await http.get(urlProfile, headers: headersProfile);
    return response;
  }

  Future<String> getPortofolios(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    final String initUrlProfile =
        'https://${dotenv.env['BASE_URL']}/api/borrowertransaksi/transaksi/portofolio?page=2&page_size';
    final urlStringProfile = initUrlProfile;
    final urlProfile = Uri.parse(urlStringProfile);
    final headersProfile = {
      'golang-auth': 'golang123',
      'token': token,
    };
    final response = await http.get(urlProfile, headers: headersProfile);
    final passingResponse = response.body;
    print(passingResponse);
    return passingResponse;
  }

  Future<Map<String, dynamic>> getPinjamanList(
      int page, String parameter) async {
    final String initUrlProfile =
        'https://${dotenv.env['BASE_URL']}/api/borrowertransaksi/transaksi/portofolio?page=$page$parameter';
    print('url initUrlProfile $initUrlProfile ');
    final urlStringProfile = initUrlProfile;
    final urlProfile = Uri.parse(urlStringProfile);
    final token = await tokenFromCache();
    print('tokenya bang: $token');
    final headersProfile = {
      'golang-auth': 'golang123',
      'token': token.toString(),
    };
    final response = await http.get(urlProfile, headers: headersProfile);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        initUrlProfile,
        {},
        response.body,
      );
    }
    print('datanyabang: ${response.body}');
    final passingResponse = jsonDecode(response.body);
    return passingResponse['data'];
  }

  Future<String> getDetailPortofolios(String token, int idAgreement) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('token', token);
    print('getDetailPortofolio $idAgreement');
    final String initUrlProfile =
        'https://${dotenv.env['BASE_URL']}/api/borrowertransaksi/transaksi/detailportofolio/detailPortofolio?idagreement=$idAgreement';
    final urlStringProfile = initUrlProfile;
    final urlProfile = Uri.parse(urlStringProfile);
    final headersProfile = {
      'golang-auth': 'golang123',
      'token': token,
    };
    print('initUrlProfile $initUrlProfile');
    final response = await http.get(urlProfile, headers: headersProfile);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        initUrlProfile,
        {},
        response.body,
      );
    }
    final passingResponse = response.body;
    print('data get detaol protofolio $passingResponse');
    return passingResponse;
  }

  Future<http.Response> postPembayaranPortofolios(
      String token, int idAgreement) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store the token in SharedPreferences
    await prefs.setString('token', token);

    // Define the URL
    final baseUrl = dotenv.env['BASE_URL']; // Replace with your actual base URL
    final initUrlProfile =
        'https://$baseUrl/api/borrowertransaksi/transaksi/portofolio/paymentpinjaman';
    final urlProfile = Uri.parse(initUrlProfile);

    // Define the headers
    final headersProfile = {
      'golang-auth': 'golang123',
      'token': token,
    };

    // Define the request body
    final requestBody = {
      'idagreement': idAgreement.toString(),
      // Add any other request parameters as needed
    };
    print('data get pembayaran ');

    final response = await http.post(
      urlProfile,
      headers: headersProfile,
      body: requestBody,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        initUrlProfile,
        requestBody,
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> validateOtp(
    String name,
    String phone,
    String email,
    String otp,
    String kodeUnik,
  ) async {
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/datas/validateotp/createBorrower';
    final url = Uri.parse(urlString);
    final headers = {'golang-auth': 'golang123'};
    final body = {
      'nama': name,
      'hp': phone,
      'email': email,
      'kode': otp,
      'kode_unik': kodeUnik
    };
    _analytics.logEvent(name: 'register_step_1', parameters: {
      'email': email,
      'phone_number': phone,
      'username': name,
      'type': 'borrower'
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        urlString,
        body,
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> createPassword(
      String token, String password, String confirmPassword) async {
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/password/create';
    final url = Uri.parse(urlString);
    final headers = {'golang-auth': 'golang123', 'token': token};

    final body = {'password': password, 'password_confirm': confirmPassword};
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        urlString,
        body,
        response.body,
      );
    }
    return response;
  }

  Future<List<Map<String, dynamic>>> fetchProvince() async {
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/v2/master/listprovinsi';
    final url = Uri.parse(urlString);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': urlString,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {'timestamps': dateNow, 'api-key': signature};
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      sendCrash(
        urlString,
        {},
        response.body,
      );
    }
    throw Exception(response.reasonPhrase);
  }

  Future<List<Map<String, dynamic>>> fetchCity(int idProvince) async {
    final String urlString =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/v2/master/listkabupaten/byidprovinsi';
    final url = Uri.parse('$urlString?idprovinsi=$idProvince');
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': urlString,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {'timestamps': dateNow, 'api-key': signature};
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      sendCrash(
        urlString,
        {},
        response.body,
      );
    }
    throw Exception(response.reasonPhrase);
  }

  Future<http.Response> resendEmail(String token, String email) async {
    final url1 =
        "https://${dotenv.env['BASE_URL']}/api/borroweruser/users/sendmail/verifikasi";
    final url = Uri.parse(url1);
    final headers = {'token': token, 'golang-auth': 'golang123'};
    final body = {'email': email};
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 200) {
      sendCrash(
        url1,
        body,
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> updateEmail(String token, String email) async {
    final url1 =
        "https://${dotenv.env['BASE_URL']}/api/borroweruser/users/updateEmail";
    final url = Uri.parse(url1);
    final headers = {'token': token, 'golang-auth': 'golang123'};
    final body = {'email': email};
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      sendCrash(
        url1,
        body,
        response.body,
      );
    }
    return response;
  }

  //pengajuan pinjaman
  Future<http.Response> getKupon(String kupon) async {
    // Make sure you've configured your .env or environment variables properly
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) {
      throw Exception('BASE_URL not defined in environment variables.');
    }

    final url = Uri.parse(
        'https://$baseUrl/api/borrowertransaksi/transaksi/voucher?voucher=$kupon');

    // You may need to replace 'tokenFromCache()' with your actual token retrieval logic
    final token = await tokenFromCache();

    final headers = {'token': token ?? '', 'golang-auth': 'golang123'};

    try {
      final response = await http.get(url, headers: headers);
      print('check kupon: ${response.statusCode}');
      if (response.statusCode != 200) {
        sendCrash(
          url.toString(),
          {},
          response.body,
        );
      }
      return response;
    } catch (e) {
      // Handle any exceptions, e.g., network errors
      print('Error: $e');
      rethrow; // Re-throw the exception to be caught higher up the call stack
    }
  }

  // Future<PinjamanResponse> checkPinjaman() async {
  //   return PinjamanResponse(
  //     id_pinjaman: 1231231231231,
  //     nama_peminjam: 'Alvan Fathurahman',
  //   );
  // }

  Future<Object> postPinjaman(
    String? agunan,
    String? buktiPembelian,
    String tujuan,
    String? kupon,
  ) async {
    // Create a new multipart request
    print('oke bang masuk');
    final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://${dotenv.env['BASE_URL']}/api/borrowertransaksi/transaksi/postjaminan'));
    print('qr code contoh ${buktiPembelian}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Add headers to the request
    request.headers['token'] =
        prefs.getString('token')!; // Replace with your access token
    request.headers['golang-auth'] =
        'golang123'; // Adjust content type if needed

    // Add fields to the request
    request.fields['tujuan'] = tujuan;
    if (agunan != null) {
      request.fields['fotojaminan'] = agunan;
    }
    if (buktiPembelian != null) {
      request.fields['fotobuktibeli'] = buktiPembelian;
    }
    if (kupon != null) {
      request.fields['kupon'] = kupon;
    }

    // Send the request and get the response
    final response = await request.send();
    print('qr code contohs ${response.statusCode}');
    print('headernya bang: ${request.fields}');
    // Check the response status code
    if (response.statusCode == 200) {
      print(response.headers);
      // Parse the response data
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      print('qr code contohsss ${jsonResponse}');
      // Access the 'qr_code' value from the 'data' object
      final qrCode = jsonResponse['data']['qr_code'];
      return qrCode;
    } else {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      sendCrash(
        'https://${dotenv.env['BASE_URL']}/api/borrowertransaksi/transaksi/postjaminan',
        {},
        jsonResponse ?? {},
      );
      // Handle the error, e.g., by throwing an exception or returning an error response
      throw Exception('Failed to post Pinjaman: ${response.statusCode}');
    }
  }

  //simulasi cicilan
  Future<List<ListProductResponse>> getListProduct(int id) async {
    final url1 =
        'https://${dotenv.env['BASE_URL']!}/api/borrowerlist/master/produk?idMasterProduk=$id';
    final url = Uri.parse(url1);

    final response = await http.get(url);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        'https://${dotenv.env['BASE_URL']}/api/borrowertransaksi/transaksi/postjaminan',
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body);
    final listProduct = data['data'];
    final productListData = listProduct[0]['listProduk'];

    final List<ListProductResponse> dataResult =
        (productListData as List<dynamic>)
            .map((item) => ListProductResponse.fromJson(item))
            .toList();

    return dataResult;
  }

  Future<http.Response> masterUploadFile(
      File file, String category, String type) async {
    final String url =
        'https://${dotenv.env['BASE_URL']}/api/borrowerupload/upload/$category';
    final String? token = await tokenFromCache();
    final headers = {'token': token.toString(), 'golang-auth': 'golang123'};

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();
    final multipartFile = http.MultipartFile(
      'fileimage',
      fileStream,
      fileLength,
      filename: 'file-master.jpg',
    );
    request.files.add(multipartFile);

    request.fields['type'] = type; // Replace with the desired value
    final response = await request.send();
    print(fileLength);
    // Convert the StreamedResponse to an http.Response
    final httpResponse = await http.Response.fromStream(response);

    return httpResponse;
  }

  Future<http.Response> masterUploadFileLender(
      File file, String category, String type) async {
    final String url =
        'https://${dotenv.env['BASE_URL']}/api/v1/msupload/upload/updatektp';
    final String? token = await tokenFromCache();
    final headers = {'token': token.toString()};

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();
    final multipartFile = http.MultipartFile(
      'fileimage',
      fileStream,
      fileLength,
      filename: 'file-master.jpg',
    );
    request.files.add(multipartFile); // Replace with the desired value
    final response = await request.send();
    print(fileLength);
    // Convert the StreamedResponse to an http.Response
    final httpResponse = await http.Response.fromStream(response);
    print(httpResponse.body);
    return httpResponse;
  }

  Future<http.Response> masterUploadFileSelfiLender(
      File file, String category, String type) async {
    final String url =
        'https://${dotenv.env['BASE_URL']}/api/v1/msupload/upload/selfie';
    final String? token = await tokenFromCache();
    final headers = {'token': token.toString()};

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();
    final multipartFile = http.MultipartFile(
      'fileimage',
      fileStream,
      fileLength,
      filename: 'file-master.jpg',
    );
    request.files.add(multipartFile);

    // request.fields['type'] = type; // Replace with the desired value
    final response = await request.send();
    print(fileLength);
    // Convert the StreamedResponse to an http.Response
    final httpResponse = await http.Response.fromStream(response);
    if (httpResponse.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url,
        request.fields,
        jsonDecode(httpResponse.body) ?? {},
      );
    }
    return httpResponse;
  }

  Future<http.Response> getMaster(
      String category, String? paramTambahan) async {
    final urlString =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/v2/master/listactive/$category';
    final urlParam = '$urlString?$paramTambahan';
    final url = Uri.parse(urlParam);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': urlString,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {'timestamps': dateNow, 'api-key': signature};
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        urlParam,
        {},
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> postRegisPrivy(Map<String, dynamic> dataPost) async {
    final urlString =
        'https://${dotenv.env['BASE_URL']}/api/borrowerekyc/v2/privy/registrasi';
    const timeStamp = '123123121231232';
    final url = Uri.parse(urlString);
    final payload = {'request': dataPost, 'timestamp': timeStamp};
    final signature = generateSignatureKey(payload);
    final token = await tokenFromCache();
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': signature,
      'Content-type': 'application/json',
      'timestamps': timeStamp
    };
    final jsonPayload = jsonEncode({'request': dataPost});
    print(jsonPayload);
    print(header);
    final response = await http.post(url, headers: header, body: jsonPayload);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        urlString,
        payload,
        response.body,
      );
    }
    print(response.body);
    return response;
  }

  Future<http.Response> postRegisPrivyV1(Map<String, dynamic> dataPost) async {
    final urlString =
        'https://${dotenv.env['BASE_URL']}/api/borrowerekyc/privy/registrasi';
    // const timeStamp = '123123121231232';
    final url = Uri.parse(urlString);
    // final payload = {"request": dataPost, "timestamp": timeStamp};
    // final signature = generateSignatureKey(payload);
    final token = await tokenFromCache();
    final header = {'token': token.toString(), 'golang-auth': 'golang123'};
    // final jsonPayload = jsonEncode({'request': dataPost});
    print(dataPost.toString());
    print(header);
    final response = await http.post(url, headers: header, body: dataPost);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        urlString,
        dataPost,
        response.body,
      );
    }
    print(response.body);
    return response;
  }

  Future<Map<String, dynamic>> setBeranda() async {
    print('storage: ${storage.getItem('state_beranda')}');
    final initUrl =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/beranda';
    final url = Uri.parse(initUrl);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': initUrl,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final token = await tokenFromCache();
    final headers = {
      'timestamps': dateNow,
      'api-key': signature,
      'Authorization': 'Bearer $token',
    };

    final responses = await http.get(url, headers: headers);
    if (responses.isRedirect) {
      sendCrash(
        initUrl,
        {},
        jsonDecode(responses.body) ?? {},
      );
    }
    const secretKey = 'yourSecretKey';
    final responseBeranda = jsonDecode(responses.body);
    final tokens = encodeJwt(responseBeranda['data'], secretKey);
    final Map<String, dynamic> response = {
      'token': tokens,
      'message': responseBeranda['message'],
      'status': responseBeranda['status'],
      'lastPage': null,
    };
    await storage.setItem('state_beranda', responseBeranda['data']);
    return response;
  }

  Future<Map<String, dynamic>> setBerandaToken(
      String token, String lastPage) async {
    final initUrl =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/beranda';
    final url = Uri.parse(initUrl);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': initUrl,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final token = await tokenFromCache();
    final headers = {
      'timestamps': dateNow,
      'api-key': signature,
      'Authorization': 'Bearer $token',
    };

    final responses = await http.get(url, headers: headers);

    const secretKey = 'yourSecretKey';
    final responseBeranda = jsonDecode(responses.body);
    final tokens = encodeJwt(
        {'beranda': responseBeranda['data'], 'last_page': lastPage}, secretKey);
    final Map<String, dynamic> response = {
      'token': tokens,
      'message': responseBeranda['message'],
      'status': responseBeranda['status'],
      'lastPage': null,
    };
    return response;
  }

  //complete data
  @override
  Future<Either<String, GeneralResponse>> getInfoBank({
    required int idBank,
    required String noRek,
    required String token,
  }) async {
    final secret = dotenv.env['SECRET_KEY'].toString();
    final timestamp = Signature().getTimestamp();
    final payload = {
      'request': {
        'id_bank': idBank,
        'no_rekening': noRek,
      },
      'timestamp': timestamp,
    };
    final signature = Signature().getSignature(secret, payload);
    final header = {
      'timestamps': timestamp,
      'api-key': signature,
      'Authorization': 'Bearer $token',
    };
    final url =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/validasi/bank';
    final response = await HttpClientCustom().postRequest(
      url,
      headers: header,
      body: payload,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  Future<http.Response> validateBank(int idBank, String noRek) async {
    print('======== validate bank ==========');
    final data = {
      'request': {'id_bank': idBank, 'no_rekening': noRek}
    };
    print('Payload: $data');
    final urlString =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/validasi/bank';
    final url = Uri.parse(urlString);
    final dateNow = Signature().getTimestamp();
    final token = await tokenFromCache();
    final payload = {
      'request': {'id_bank': idBank, 'no_rekening': noRek},
      'timestamp': dateNow
    };
    final signature = generateSignatureKey(payload);

    final headers = {
      'timestamps': dateNow,
      'api-key': signature,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        urlString,
        data,
        response.body,
      );
    }
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> postDataPendukung({
    required Map<String, dynamic> data,
    required String token,
  }) async {
    final secret = dotenv.env['SECRET_KEY'].toString();
    final timestamp = Signature().getTimestamp();
    final payload = {
      'request': data,
      'timestamp': timestamp,
    };
    final signature = Signature().getSignature(secret, payload);
    final header = {
      'timestamps': timestamp,
      'api-key': signature,
      'Authorization': 'Bearer $token',
    };
    final url =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/updatedata';
    final response = await HttpClientCustom().postRequest(
      url,
      headers: header,
      body: payload,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  Future<http.Response> completeData(Map<String, dynamic> payloadData) async {
    print('=========== complete data log ===========');
    final urlString =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/updatedata';
    final url = Uri.parse(urlString);
    final dateNow = Signature().getTimestamp();
    final token = await tokenFromCache();
    final payload = {'request': payloadData, 'timestamp': dateNow};
    final payloadPost = {'request': payloadData};
    final signature = generateSignatureKey(payload);

    final headers = {
      'timestamps': dateNow,
      'api-key': signature,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payloadPost),
    );
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        urlString,
        payloadPost,
        response.body,
      );
    }
    print('=====end data log =============');
    return response;
  }

  Future<http.Response> postPrivyRejected(
    String code,
    String type,
    File? ktp,
    File? selfie,
    File? support,
    int user,
  ) async {
    print('user status $user');
    final String urlString = user == 2
        ? 'https://${dotenv.env['BASE_URL']}/api/borrowerekyc/privy/updatedata'
        : 'https://${dotenv.env['BASE_URL']}/api/v1/msekyc/ekyc/updatedata';
    final url = Uri.parse(urlString);
    final token = await tokenFromCache();
    final headers = {'golang-auth': 'golang123', 'token': token.toString()};

    final request = http.MultipartRequest('POST', Uri.parse(url.toString()));
    request.headers.addAll(headers);
    if (ktp != null) {
      print('1');
      request.fields['typefilependukung'] = 'KTP';
      request.files.add(
        http.MultipartFile(
          'ktp',
          ktp.readAsBytes().asStream(),
          ktp.lengthSync(),
          filename: 'ktp.jpg',
        ),
      );
    }
    if (selfie != null) {
      print('2');
      request.fields['typefilependukung'] = 'Selfie';
      request.files.add(
        http.MultipartFile(
          'selfie',
          selfie.readAsBytes().asStream(),
          selfie.lengthSync(),
          filename: 'selfie.jpg',
        ),
      );
    }
    if (support != null) {
      print('3');
      request.files.add(
        http.MultipartFile(
          'support',
          support.readAsBytes().asStream(),
          support.lengthSync(),
          filename: 'support.jpg',
        ),
      );
    }
    request.fields['code'] = code;

    final response = await request.send();

    // Convert the StreamedResponse to an http.Response
    final httpResponse = await http.Response.fromStream(response);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        urlString,
        request.fields,
        jsonDecode(httpResponse.body) ?? {},
      );
    }

    return httpResponse;
  }

  //simulasi cicilan
  Future<List<dynamic>> getMasterJenisEmas() async {
    final urlString =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/master/jenisemas';
    final url = Uri.parse(urlString);
    final response = await http.get(url);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        urlString,
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body);
    return data['data'];
  }

  Future<List<dynamic>> getListJenisEmas(String namaJenisEmas, int page) async {
    final String namaJenisEmasiEncode = namaJenisEmas.replaceAll(' ', '%20');
    final urlString =
        'https://${dotenv.env['BASE_URL']}/api/borrowercicil/v1/datas/master/produk/simulasi?page=$page&searchNamaJenisEmas=$namaJenisEmasiEncode';
    print(urlString);
    final url = Uri.parse(urlString);
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    print('callback response list jenis emas ${data['data']['data']}');
    return data['data']['data'];
  }

  Future<http.Response> calculateSimulasiCicilan(
    List<Map<String, dynamic>> dataEmas,
    int totalHarga,
    int idProduct,
    int tenor,
    int isCount,
  ) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borrowercicil/v2/calculate/cicilEmas';
    final url = Uri.parse(uri);
    final dateNow = Signature().getTimestamp();

    final payload = {
      'request': {
        'isCount': isCount,
        'detailEmas': dataEmas,
        'totalHargaEmas': totalHarga,
        'idProduk': idProduct,
        'tenor': tenor,
      },
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final header = {
      'api-key': signature,
      'timestamps': dateNow,
      'Content-Type': 'application/json',
    };
    print(payload);

    final response =
        await http.post(url, headers: header, body: jsonEncode(payload));
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        uri,
        payload,
        response.body,
      );
    }
    return response;
  }

  //tutup akun
  Future<List<dynamic>> get_tutupAkun() async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/v2/master/tutupakun';
    final url = Uri.parse(uri);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': uri,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final header = {'api-key': signature, 'timestamps': dateNow};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        uri,
        {},
        response.body,
      );
    }
    final body = jsonDecode(response.body);

    return body['data'];
  }

  Future<http.Response> reqOtpTutupAkun(
      List<Map<String, dynamic>> alasan) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/otp/request/tutupakun';
    final url = Uri.parse(uri);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'request': {'alasanTutupAkun': alasan},
      'timestamp': dateNow
    };
    final signature = generateSignatureKey(payload);
    final token = await tokenFromCache();
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': signature,
      'Content-type': 'application/json',
      'timestamps': dateNow
    };
    final response =
        await http.post(url, body: jsonEncode(payload), headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        uri,
        payload,
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> validasiOtpTutupAkun(String otp) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/otp/validasi/tutupakun';
    final url = Uri.parse(uri);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'request': {'kodeOtp': otp},
      'timestamp': dateNow
    };
    final signature = generateSignatureKey(payload);
    final token = await tokenFromCache();
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': signature,
      'Content-type': 'application/json',
      'timestamps': dateNow
    };
    final response =
        await http.post(url, body: jsonEncode(payload), headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        uri,
        payload,
        response.body,
      );
    }
    return response;
  }

  Future<http.Response> cancelTutupAkun(int idClose) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/v2/user/tutupakun';
    final url = Uri.parse(uri);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'request': {'idClose': idClose, 'isActive': 2},
      'timestamp': dateNow
    };
    final signature = generateSignatureKey(payload);
    final String? token = await tokenFromCache();
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': signature,
      'Content-type': 'application/json',
      'timestamps': dateNow
    };

    final response =
        await http.post(url, body: jsonEncode(payload), headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        uri,
        payload,
        response.body,
      );
    }
    return response;
  }

  Future<Map<String, dynamic>> getDataPribadi(String endpoint) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/data/$endpoint';
    final uriLender =
        'https://${dotenv.env['BASE_URL']}/api/v1/msuser//users/detailprofile';
    final url = Uri.parse(uri);
    final urlLender = Uri.parse(uriLender);
    final token = await tokenFromCache();
    print(token);
    final header = {
      'Authorization': 'Bearer ${token.toString()}',
      'golang-auth': 'golang123'
    };
    final int userStatus = await rxPrefs.getInt('user_status') ?? 0;
    var response;
    switch (userStatus) {
      case 2:
        response = await http.get(url, headers: header);
        break;
      case 1:
        response = await http.get(urlLender, headers: header);
        break;
      // More cases as needed
      default:
      // Code to execute if none of the cases match the expression
    }
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        uri,
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body);
    print(data['data']);
    return data['data'];
  }

  Future<dynamic> getDataBank() async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/data/bank_list';
    final uriLender =
        'https://${dotenv.env['BASE_URL']}/api/v1/msuser/users/detailbankuser';
    final int? userStatus = await rxPrefs.getInt('user_status');

    if (userStatus == null) {
      // Handle the case where 'user_status' is not available or is null
      return null; // Or return an appropriate value for the null case
    }

    final url = Uri.parse(uri);
    final urlLender = Uri.parse(uriLender);
    final String? token = await tokenFromCache();
    print(token);
    final header = {'token': token.toString(), 'golang-auth': 'golang123'};

    try {
      var response;
      dynamic dataSending;

      switch (userStatus) {
        case 2:
          response = await http.get(url, headers: header);
          final data = jsonDecode(response.body);
          dataSending = data['data'];
          break;
        case 1:
          response = await http.get(urlLender, headers: header);
          final data = jsonDecode(response.body);

          if (data['data'] is List) {
            dataSending = data['data'];
          } else {
            dataSending = [data['data']];
          }
          break;
        // Add more cases as needed
        default:
          dataSending = [];
          break;
      }
      if (response.statusCode != 200 || response.statusCode != 201) {
        sendCrash(
          uri,
          {},
          response.body,
        );
      }

      return dataSending;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<http.Response> getSupplierEmas(
    int? idSupplier,
    int page,
  ) async {
    final id = idSupplier ?? '';
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']}/api/borrowercicil/v1/datas/supplier?idSupplier=$id&statusAktif=1&page=$page',
    );
    final response = await http.get(url);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print(response.body);
    return response;
  }

  Future<http.Response> updateDataBank(
    int idBank,
    String noRek,
    String an_rek,
    String kotaBank,
    int idRek,
  ) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/updatedata/bank?idrekening=${idRek.toString()}';
    final url = Uri.parse(uri);
    print(url);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final header = {'golang-auth': 'golang123', 'token': token.toString()};
    final body = {
      'no_rekening': noRek,
      'an_rekening': an_rek,
      'id_bank':
          idBank.toString(), // Keep it as an int if the API expects an int
      'kota_bank': kotaBank
    };
    print('Masuk update bank log');
    print(jsonEncode(body));
    final response = await http.post(url, headers: header, body: body);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        uri,
        body,
        response.body,
      );
    }
    print(response.body);
    return response;
  }

  Future<http.Response> pinSending(String pin) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/v1/msuser/users/checkpin?pin=${pin}';
    final url = Uri.parse(uri);
    print(url);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final header = {'token': token.toString()};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        uri,
        {},
        response.body,
      );
    }
    print(token);
    print('masuk pin log${response.body}');
    return response;
  }

  Future<Map<String, dynamic>> updateDataBankLender(
    int idBank,
    String noRek,
    String kotaBank,
  ) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/v1/msuser/users/updatebank';
    final url = Uri.parse(uri);
    print(url);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final header = {'token': token.toString()};
    final body = {
      'norekening': noRek,
      'idbank':
          idBank.toString(), // Keep it as an int if the API expects an int
      'kotabank': kotaBank
    };
    print('Masuk update bank log');
    print(jsonEncode(body));
    final response = await _client.postMultipart(
      url,
      headers: header,
      [],
      fields: body,
    );
    print('response data error ${response}');

    print('response data errors ${response['status']}');

    if (response['status'] != 200 || response['status'] != 201) {
      sendCrash(
        uri,
        {},
        response ?? {},
      );
    }
    print(response);
    return response;
  }

  Future<Map<String, dynamic>> addMitra(
    String email,
    String nama,
    String hp,
    String idprovinsi,
    String idkabupaten,
  ) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/master/addmitra';
    final url = Uri.parse(uri);
    print(url);
    final header = {'golang-auth': 'golang123'};
    final body = {
      'email': email,
      'name': nama, // Keep it as an int if the API expects an int
      'hp': hp,
      'idprovinsi': idprovinsi,
      'idkabupaten': idkabupaten,
    };
    print('Masuk update bank log');
    print(jsonEncode(body));
    final response = await _client.postMultipart(
      url,
      headers: header,
      [],
      fields: body,
    );
    print(response);
    return response;
  }

  Future<http.Response> updatePassword(
    String oldPass,
    String newPass,
    String confirmPass,
  ) async {
    print('masuk ganti password');
    final int userStatus = await rxPrefs.getInt('user_status') ?? 0;
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/password/create';
    final urlLender = Uri.parse(
      'https://${dotenv.env['BASE_URL']}/api/v1/msuser/users/updatepassword',
    );
    final url = Uri.parse(uri);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final header = {'golang-auth': 'golang123', 'token': token.toString()};

    final body = {
      'password_old': oldPass,
      'password': newPass,
      'password_confirm': confirmPass
    };

    final bodyLender = {
      'passwordold': oldPass,
      'passwordnew_satu': newPass,
      'passwordnew_confirm': confirmPass,
      // 'isDisable': false,
    };

    http.Response response;

    switch (userStatus) {
      case 1:
        response =
            await http.post(urlLender, headers: header, body: bodyLender);
        break;
      case 2:
        response = await http.post(url, headers: header, body: body);
        break;
      default:
        response = await http.post(url, headers: header, body: body);
    }

    return response;
  }

  Future<Map<String, dynamic>> getListCicilEmas(
    String token,
    int page,
    int idProvinsi,
    int idKota,
    int idSupplier,
    String? param,
  ) async {
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']}/api/borrowercicil/v2/supplier/produk?page=$page&page_size=10&idProvinsi=$idProvinsi&idKota=$idKota&idSupplier=$idSupplier${param ?? ''}',
    );
    print(url);
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get':
          'https://${dotenv.env['BASE_URL']}/api/borrowercicil/v2/supplier/produk',
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {
      'Authorization': 'Bearer $token',
      'timestamps': dateNow,
      'api-key': signature
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body);
    print('response list cicilan ${data}');
    return data;
  }

  //update hp
  Future<bool> reqEmailUpdateHp(String token) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/request/updatehp';
    final url = Uri.parse(uri);
    final header = {'token': token, 'golang-auth': 'golang123'};
    final response = await http.get(url, headers: header);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      sendCrash(
        uri,
        {},
        response.body,
      );
      return false;
    }
  }

  //update email
  Future<bool> reqOtpUpdateEmail(String token, String hp, String type) async {
    final uri =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/datas/requestotp/updatedataemail?type=$type';
    final url = Uri.parse(uri);
    final header = {'token': token, 'golang-auth': 'golang123'};
    final body = {'hp': hp};
    final response = await http.post(url, headers: header, body: body);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      sendCrash(
        uri,
        {},
        response.body,
      );
      return false;
    }
  }

  Future<Map<String, dynamic>> getDetailPinjaman(
    String token,
    int idjaminan,
    int idproduk,
  ) async {
    print('Masuk get pinjaman Bang');
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/borrowerpinjaman/pinjaman/detailpinjaman?idjaminan=$idjaminan&idproduk=$idproduk');
    print(url);
    final header = {'golang-auth': 'golang123', 'token': token};
    final response = await http.get(url, headers: header);
    print(response.body);
    final body = jsonDecode(response.body);
    final Map<String, dynamic> data = body['data'];
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    return data;
  }

  Future<Map<String, dynamic>> getDetailKonfirmasiPinjaman(
    String token,
    int idPengajuan,
  ) async {
    final String initUrl =
        'https://${dotenv.env['BASE_URL']}/api/beeborrowertransaksi/v1/cnd/konfirmasi/cnd?idPengajuan=$idPengajuan';

    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': initUrl,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {
      'Authorization': 'Bearer $token',
      'api-key': dotenv.env['API_KEY_AUTH'].toString(),
      'x-SIGNATURE-key': signature,
      'timestamps': dateNow,
    };
    print('idPengajuan $headers');
    String path = '/api/beeborrowertransaksi/v1/cnd/konfirmasi/cnd';
    path = path.replaceAll('%3', '?');
    final Map<String, String> queryParams = {
      'idPengajuan': idPengajuan.toString(),
    };
    final url = Uri.https(dotenv.env['BASE_URL']!, path, queryParams);

    final response = await http.get(url, headers: headers);
    print('CHECK CHECK $url ');
    print(response.body);
    // if (response['status'] == 200 || response['status'] == 201) {
    // } else {
    //   sendCrash(
    //     url.toString(),
    //     {},
    //     response.body,
    //   );
    // }
    final Map<String, dynamic> result = jsonDecode(response.body);
    return result['data'];
  }

  Future<Map<String, dynamic>> getDetailKonfirmasiSurvey(
    String token,
    String idTaskPengajuan,
    String idPengajuan,
  ) async {
    final String initUrl =
        'https://${dotenv.env['BASE_URL']}/api/beeborrowertransaksi/v1/cnd/konfirmasi/survey?idTaskPengajuan=$idTaskPengajuan';

    final body = {
      'idPengajuan': idPengajuan,
      'idTaskPengajuan': idTaskPengajuan,
    };
    print('test body $body');
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get': initUrl,
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final headers = {
      'Authorization': 'Bearer $token',
      'api-key': dotenv.env['API_KEY_AUTH'].toString(),
      'x-SIGNATURE-key': signature,
      'timestamps': dateNow,
    };
    print('check email $initUrl');
    final Map<String, String> queryParams = {
      'idTaskPengajuan': idTaskPengajuan.toString(),
    };
    final url = Uri.https(
      dotenv.env['BASE_URL']!,
      '/api/beeborrowertransaksi/v1/cnd/konfirmasi/survey',
      queryParams,
    );

    final response = await http.get(
      url,
      headers: headers,
    );

    log.d(
      '${response.statusCode}\n'
      '${response.body}\n',
    );
    final Map<String, dynamic> result = jsonDecode(response.body);
    return result['data'];
  }

  //lender
  Future<Map<String, dynamic>> getSetorDanaLender(String token) async {
    print('masuk api get data');
    final url = Uri.https(
        dotenv.env['BASE_URL']!, '/api/v1/mstransaksi/transaction/setordana');
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print(response.body);
    final Map<String, dynamic> result = jsonDecode(response.body);
    return result['data'];
  }

  Future<Map<String, dynamic>> getWithDrawLender(String token) async {
    print('masuk api get data');
    final url = Uri.https(
        dotenv.env['BASE_URL']!, '/api/v1/mstransaksi/transaction/getwithdraw');
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print(response.body);
    final Map<String, dynamic> result = jsonDecode(response.body);
    return result['data'];
  }

  //lender pendanaan
  Future<List<dynamic>> getProductPendaanan1(String token) async {
    print('masuk api get produk pendanaan');
    final url = Uri.https(
        dotenv.env['BASE_URL']!, '/api/v1/mspendanaan//pendanaan/produk');
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print('ini produk: ${response.body}');
    final result = jsonDecode(response.body);
    return result['data'];
  }

  Future<Map<String, dynamic>> getDataPendanaan(
    String token,
    String params,
  ) async {
    print('================ masuk api get list pendanaan ==================');
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/v1/mspendanaan//pendanaan/listpendanaanpaginate?status=0&$params');
    print(url);
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final body = jsonDecode(response.body);
    return body['data'];
  }

  Future<Map<String, dynamic>> getDetailDataPendanaan(
    String token,
    String params,
  ) async {
    print('================ masuk api get list pendanaan ==================');
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/v1/mspendanaan/pendanaan/detailpendanaan?$params');
    print(url);
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final body = jsonDecode(response.body);
    return body['data'];
  }

  Future<dynamic> getDocumentPendanaanP3(
    String id,
    int idJaminan,
  ) async {
    print('================= masuk api get document ==============');
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/v1/msekyc//ekyc/document_perjanjian?id=$id&idJaminan=$idJaminan');
    print(url);
    final response = await http.get(url);
    if (response.statusCode != 200 || response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    return response.body;
  }

  @override
  Single<TokenResponse> tarikDana(
    String token,
    int nominal,
    String pin,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(dotenv.env['BASE_URL']!,
              '/api/v1/mstransaksi/transaction/tarikdanapin');
          final body = {
            'nominal': nominal.toString(),
            'pin': pin,
          };

          final header = {'token': token};

          final decoded = await _client.postMultipart(
            url,
            headers: header,
            [],
            fields: body,
          );
          if (decoded['status'] == null ||
              (decoded['status'] != 200 && decoded['status'] != 201)) {
            sendCrash(
              url.toString(),
              body,
              decoded,
            );
          }
          return TokenResponse.fromJson(decoded);
        },
      );

  @override
  Single<TokenResponse> checkPinLender(
    String token,
    String pin,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.parse(
            'https://${dotenv.env['BASE_URL']!}/api/v1/msuser/users/checkpin?pin=$pin',
          );
          final header = {
            'token': token,
          };
          final response = await _client.getJson(
            url,
            headers: header,
          );
          if (response['status'] != 200) {
            sendCrash(
              url.toString(),
              {},
              response,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> ubahPinLender(
    String token,
    String currentPin,
    String newPin,
    String confirmPin,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/v1/msuser/users/updatepin',
          );

          final header = {
            'token': token,
          };
          final body = {
            'pin_lama': currentPin,
            'pin': newPin,
            'pin2': confirmPin,
          };
          final response = await _client.postMultipart(
            url,
            headers: header,
            [],
            fields: body,
          );
          if (response['status'] == null ||
              (response['status'] != 200 && response['status'] != 201)) {
            sendCrash(
              url.toString(),
              body,
              response,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> sendOtpForgotPinLender(
    String token,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/v1/msuser//users/sendotppin',
          );
          final header = {'token': token};
          final response = await _client.postMultipart(
            url,
            headers: header,
            [],
          );
          if (response['status'] == null ||
              (response['status'] != 200 && response['status'] != 201)) {
            sendCrash(
              url.toString(),
              {},
              response,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> resendOtpForgotPinLender(
    String token,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/v1/msuser//users/resendotppin',
          );
          final header = {'token': token};
          final response = await _client.getJson(url, headers: header);
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> validasiOtpForgotPin(
    String token,
    String kode,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/v1/msuser//users/validasiotppin',
          );
          final header = {'token': token};
          final response = await _client.postMultipart(
            url,
            headers: header,
            fields: {'kode': kode},
            [],
          );
          if (response['status'] == '200' || response['status'] == 201) {
            storage.setItem('forgot_pin_key', response['data']);
          } else {
            sendCrash(
              url.toString(),
              {'kode': kode},
              response,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );
  @override
  Single<TokenResponse> resetForgotPin(
    String token,
    String pin,
    String key,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/v1/msuser//users/postresetpin',
          );
          final header = {'token': token};
          final response = await _client.postMultipart(
            url,
            headers: header,
            fields: {
              'pin': pin,
              'key': key,
            },
            [],
          );
          if (response['status'] == '200' || response['status'] == 201) {
            storage.setItem('forgot_pin_key', response['data']);
          } else {
            sendCrash(
              url.toString(),
              {
                'pin': pin,
                'key': key,
              },
              response,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );
  @override
  Single<TokenResponse> requestOtpPendanaan(
    String token,
    String nosbg,
  ) =>
      _wrap(
        (cancelToken) async {
          print('=========== Masuk privy otp pendanaan ================');
          final url = Uri.parse(
            'https://${dotenv.env['BASE_URL']}/api/v1/mspendanaan/pendanaan/privy/requestotp?type=send&nosbg=$nosbg',
          );
          final header = {'token': token};

          final response = await _client.getJson(
            url,
            headers: header,
          );
          if (response['status'] == null ||
              (response['status'] != 200 && response['status'] != 201)) {
            sendCrash(
              url.toString(),
              {},
              response,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );
  @override
  Single<TokenResponse> validateOtpPendanaan(
          String token, String noSbg, String otp) =>
      _wrap(
        (cancelToken) async {
          print('=========== Masuk privy otp pendanaan ================');
          final url = Uri.https(dotenv.env['BASE_URL']!,
              '/api/v1/mspendanaan/pendanaan/privy/pendanaan');
          final header = {'token': token};
          final body = {
            'nosbg': noSbg,
            'otp': otp,
          };

          final response = await _client.postMultipart(
            url,
            headers: header,
            [],
            fields: body,
          );
          if (response['status'] == null ||
              (response['status'] != 200 && response['status'] != 201)) {
            sendCrash(
              url.toString(),
              body,
              response,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );

  Future<Map<String, dynamic>> getAjakTeman(String token) async {
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']}/api/v1/mstransaksi/transaction/ajaktemankode',
    );
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  Future<Map<String, dynamic>> getPortofolioLender(String token) async {
    final url = Uri.https(
        dotenv.env['BASE_URL']!, '/api/v1/msuser/users/laporankeuangan');
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  Future<Map<String, dynamic>> getPendanaanList(
    int type,
    int page,
    String token,
    String parameters,
  ) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']!}/api/v1/msuser/users/portfolioemas?page=$page&$parameters');

    print('urlnya gan: $url');
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  Future<Map<String, dynamic>> getDetailPendanaan(
      String token, String nosbg) async {
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']!}/api/v1/mspendanaan/pendanaan/detailpendanaan?nosbg=$nosbg',
    );
    print(url);
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body)['data'];
    print(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getDocumentPerjanjianTtd(
    String token,
    int idJaminan,
  ) async {
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']!}/api/v1/msekyc//ekyc/getdocument?idjaminan=$idJaminan',
    );
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print(response.body);
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  Future<Map<String, dynamic>> getKuponCicilEmas(
      String kupon, String token) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']!}/api/borrowertransaksi/transaksi/voucher?voucher=$kupon');
    final header = {'token': token, 'golang-auth': 'golang123'};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final Map<String, dynamic> data = jsonDecode(response.body)['data'];
    return data;
  }

  Future<http.Response> getDocumentPerjanjian(
    Map<String, dynamic> dataJson,
    int idBorrower,
  ) async {
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']!}/api/borrowerpinjaman/pinjaman/syaratKetentuan/cicilemas?idborrower=$idBorrower',
    );
    final header = {'Content-Type': 'application/json'};
    print(dataJson);
    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode(dataJson),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        dataJson,
        response.body,
      );
    }
    return response;
  }

  Future<Map<String, dynamic>> getRiwayatTransaksi(
      String token, int page, String params) async {
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']!}/api/v1/msuser/users/riwayattsaldotersedia?page=$page&order_tgl=desc&page_size=10$params',
    );
    print(url);
    final header = {'token': token};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    // print('api service ${response.body}');
    final data = jsonDecode(response.body)['data'];
    return data;
  }

  Future<Map<String, dynamic>> getTransaksiCicilEmas(
    String token,
    int page,
    String params,
  ) async {
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']!}/api/borrowercicil/v2/user/riwayat/cicilemas?page=$page&page_size=10&$params',
    );
    print('url get transaksi cicil emas $url');
    final dateNow = Signature().getTimestamp();
    final payload = {
      'get':
          'https://${dotenv.env['BASE_URL']!}/api/borrowercicil/v2/user/riwayat/cicilemas',
      'timestamp': dateNow,
    };
    final signature = generateSignatureKey(payload);
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': signature,
      'timestamps': dateNow,
    };
    print('header cicilan $header');
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body);
    print(response.body);
    final result = data['data'];
    return result;
  }

  Future<Map<String, dynamic>> getDataSupplier(int idSupplier) async {
    final url = Uri.parse(
      'https://${dotenv.env['BASE_URL']!}/api/borrowercicil/v1/datas/supplier?idSupplier=$idSupplier',
    );
    final response = await http.get(url);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print(response.body);

    final result = jsonDecode(response.body)['data'];
    return result;
  }

  Future<http.Response> getListMasterLender(
      String category, String? param) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']!}/api/v1/msuser/datas/$category?${param ?? ''}');
    final response = await http.get(url);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    print(response.body);
    return response;
  }

  @override
  Single<TokenResponse> verificationLender(
    String token,
    Map<String, dynamic> payload,
  ) =>
      _wrap(
        (cancelToken) async {
          final url = Uri.https(
            dotenv.env['BASE_URL']!,
            '/api/v1/msekyc/ekyc/registrasiprivy',
          );
          final Map<String, String> payloadAsString = {};

          payload.forEach((key, value) {
            final String stringValue = value.toString();
            payloadAsString[key] = stringValue;
          });
          final header = {'token': token};
          final response = await _client.postMultipart(
            url,
            [],
            headers: header,
            fields: payloadAsString,
          );
          if (response['status'] != 200 && response['status'] != 201) {
            sendCrash(
              url.toString(),
              payloadAsString,
              response,
            );
          }
          print(response);
          return TokenResponse.fromJson(response);
        },
      );

  Future<Map<String, dynamic>> getNotifikasi(String token, String param) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/data/listNotifikasi?$param');
    final header = {
      'golang-auth': 'golang123',
      'token': token,
    };
    print(url);

    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body)['data'];
    // print(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getNotifikasiLender(
      String token, String param) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/v1/msuser/users/listnotifikasi?$param');
    final header = {
      'golang-auth': 'golang123',
      'token': token,
    };
    print(url);

    final response = await http.get(url, headers: header);
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final data = jsonDecode(response.body)['data'];
    print(response.body);
    return data;
  }

  Future<http.Response> readNotif(String token, int idNotif) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/updatedata/readNotifikasi');
    final header = {
      'golang-auth': 'golang123',
      'token': token,
    };

    final response = await http.post(
      url,
      headers: header,
      body: {'idnotif': idNotif.toString()},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {'idnotif': idNotif.toString()},
        response.body,
      );
    }
    print(response.body);
    return response;
  }

  Future<http.Response> readNotifLender(String token, int idNotif) async {
    final url = Uri.parse(
        'https://${dotenv.env['BASE_URL']}/api/v1/msuser/users/readnotifikasi');
    final header = {
      'golang-auth': 'golang123',
      'token': token,
    };

    final response = await http.post(
      url,
      headers: header,
      body: {'idnotif': idNotif.toString()},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      sendCrash(
        url.toString(),
        {'idnotif': idNotif.toString()},
        response.body,
      );
    }
    print(response.body);
    return response;
  }

  @override
  Single<TokenResponse> simulasiMaxi(
    int nilaiPinjaman,
    int jumlahHari,
  ) =>
      _wrap(
        (cancelToken) async {
          final url =
              Uri.parse('https://lumen-dev.danain.co.id/simulasilender');
          final header = {'Content-Type': 'application/json'};
          final body = {
            'nilaiPinjaman': nilaiPinjaman,
            'idProduk': 15,
            'jumlahHari': jumlahHari,
          };
          final response = await _client.postJson(
            url,
            headers: header,
            body: body,
            cancelToken: cancelToken,
          );
          if (response['status'] == 200) {
            await storage.setItem('simulasi_maxi', response);
          } else {
            sendCrash(
              url.toString(),
              body,
              response,
            );
          }
          return TokenResponse.fromJson(response);
        },
      );

  @override
  Single<TokenResponse> calculateCicilan(Map<String, dynamic> payload) => _wrap(
        (cancelToken) async {
          final url = Uri.parse(
            'https://${dotenv.env['BASE_URL']}/api/borrowercicil/v2/calculate/cicilEmas',
          );

          final request = {
            'request': payload,
            'timestamp': '12345',
          };
          final signature = generateSignatureKey(request);
          final header = {
            'api-key': signature,
            'timestamps': '12345',
          };

          final response = await _client.postJson(
            url,
            body: request,
            headers: header,
          );

          if (response['status'] == 200) {
            await storage.setItem('calculate_cicilan', response['data']);
          } else {
            sendCrash(
              url.toString(),
              request,
              response,
            );
          }

          return TokenResponse.fromJson(response);
        },
      );

  Future<Map<String, dynamic>> checkVersion() async {
    final url =
        Uri.parse('https://${dotenv.env['BASE_URL']}/api/v1/sendgrid/versiAPK');
    final header = {'Key-auth': 'FaSystem213'};
    final response = await http.get(url, headers: header);
    if (response.statusCode != 200) {
      sendCrash(
        url.toString(),
        {},
        response.body,
      );
    }
    final body = jsonDecode(response.body);

    return body['data'];
  }

  // mulai v3
  @override
  Future<Either<String, GeneralResponse>> getProduk(
    GetProdukParams params,
  ) async {
    final apiKey = dotenv.env['API_KEY_USER'].toString();
    final url =
        'https://${dotenv.env['BASE_URL']}/api/msadsmaster/v1/master/produk';
    final timestamp = Signature().getTimestamp();
    final payload = {
      'get': url,
      'timestamp': timestamp,
    };
    final signature = Signature().getSignature(apiKey, payload);
    final header = {
      'api-key': apiKey,
      'timestamps': timestamp,
      'x-SIGNATURE-key': signature,
    };
    final response = await HttpClientCustom().getRequestV2(
      url,
      headers: header,
      queryParams: params.toJson(),
      converter: (response) => GeneralResponse.fromJson(response['Response']),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> getMasterData(
    String endpoint,
    Map<String, dynamic> params,
  ) async {
    final apiKey = dotenv.env['API_KEY_USER'].toString();
    final url =
        'https://${dotenv.env['BASE_URL']}/api/msadsmaster/v1/master/$endpoint';

    final timestamp = Signature().getTimestamp();
    final payload = {
      'get': url,
      'timestamp': timestamp,
    };
    final signature = Signature().getSignature(apiKey, payload);
    final header = {
      'api-key': apiKey,
      'timestamps': timestamp,
      'x-SIGNATURE-key': signature,
    };
    final response = await HttpClientCustom().getRequestV2(
      url,
      headers: header,
      queryParams: params,
      converter: (response) => GeneralResponse.fromJson(response['Response']),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> getMasterV1(
    String endpoint,
    Map<String, dynamic> params,
  ) async {
    final apiKey = dotenv.env['SECRET_KEY'].toString();
    final url =
        'https://${dotenv.env['BASE_URL']}/api/borrowerlist/v2/master/listactive/$endpoint';

    final timestamp = Signature().getTimestamp();
    final payload = {
      'get': url,
      'timestamp': timestamp,
    };
    final signature = Signature().getSignature(apiKey, payload);
    final header = {
      // 'api-key': apiKey,
      'timestamps': timestamp,
      'golang-auth': 'golang123',
      'x-SIGNATURE-key': signature,
      'api-key': signature,
    };
    final response = await HttpClientCustom().getRequestV2(
      url,
      headers: header,
      queryParams: params,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> getRiwayatTransaksiv3(
    String endpoint,
    Map<String, dynamic> params,
    String token,
  ) async {
    final apiKey = dotenv.env['API_KEY_AUTH'].toString();
    final url = 'https://${dotenv.env['BASE_URL']}$endpoint';

    final timestamp = Signature().getTimestamp();
    final payload = {
      'get': url,
      'timestamp': timestamp,
    };
    final signature = Signature().getSignature(apiKey, payload);
    final header = {
      'Authorization': 'Bearer $token',
      'x-SIGNATURE-key': signature,
      'api-key': apiKey,
    };
    final response = await HttpClientCustom().getRequestV2(
      url,
      headers: header,
      queryParams: params,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> getDataUser(
    String token,
    String urlParam,
  ) async {
    final apiKey = dotenv.env['API_KEY_USER'].toString();
    final url =
        'https://${dotenv.env['BASE_URL']}/api/borroweruser/users/data/$urlParam';

    final timestamp = Signature().getTimestamp();
    final payload = {
      'get': url,
      'timestamp': timestamp,
    };
    final signature = Signature().getSignature(apiKey, payload);
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': apiKey,
      'timestamps': timestamp,
      'x-SIGNATURE-key': signature,
      'golang-auth': 'golang123',
    };
    final response = await HttpClientCustom().getRequestV2(
      url,
      headers: header,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> getHubunganKeluarga(
    String token,
  ) async {
    final apiKey = dotenv.env['API_KEY_AUTH'].toString();
    final url =
        'https://${dotenv.env['BASE_URL']}/api/beeborroweruser/v1/user/detail/keluarga';

    final timestamp = Signature().getTimestamp();
    final payload = {
      'get': url,
      'timestamp': timestamp,
    };
    final signature = Signature().getSignature(apiKey, payload);
    final header = {
      'api-key': apiKey,
      'timestamps': timestamp,
      'x-SIGNATURE-key': signature,
      'Authorization': 'Bearer $token',
    };
    final response = await HttpClientCustom().getRequestV2(
      url,
      headers: header,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> simulasiCnD(
      SimulasiParams payload) async {
    final apiKey = dotenv.env['API_KEY_AUTH'].toString();
    final url =
        'https://${dotenv.env['BASE_URL']}/api/beeborrowertransaksi/v1/simulasi/cnd';
    final timestamp = Signature().getTimestamp();
    final body = {
      'request': payload.toJson(),
      'timestamp': timestamp,
    };
    print('ini body bang $body');
    final basic = Signature().getBasicAuth(
      'UDo9Za8nFuJzGq6iYQZs0Kioafa9OPTq',
      'fx5mC88y8QMFEEy6zii7s2X8o4rkAn62',
    );
    final signature = Signature().getSignature(apiKey, body);
    final header = {
      'Authorization': basic,
      'api-key': apiKey,
      'timestamps': timestamp,
      'x-SIGNATURE-key': signature,
    };
    final response = await HttpClientCustom().postRequest(
      url,
      headers: header,
      body: body,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> postPengajuanCnd(
    String token,
    Map<String, dynamic> payload,
  ) async {
    final apiKey = dotenv.env['API_KEY_AUTH'].toString();
    final url =
        'https://${dotenv.env['BASE_URL']}/api/beeborrowertransaksi/v1/cnd/pengajuan/pinjaman';
    final timestamp = Signature().getTimestamp();
    final body = {
      'request': payload,
      'timestamp': timestamp,
    };
    print('ini body bang $body');

    final signature = Signature().getSignature(apiKey, body);
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': apiKey,
      'timestamps': timestamp,
      'x-SIGNATURE-key': signature,
    };
    final response = await HttpClientCustom().postRequest(
      url,
      headers: header,
      body: body,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> postHubunganKeluarga(
    String token,
    DataKeluargaPayload payload,
  ) async {
    final apiKey = dotenv.env['API_KEY_AUTH'].toString();
    final url =
        'https://${dotenv.env['BASE_URL']}/api/beeborroweruser/v1/user/update/data';
    final timestamp = Signature().getTimestamp();
    final body = {
      'request': {
        'dataKeluarga': payload.toJson(),
      },
      'timestamp': timestamp,
    };
    print('ini body bang $body');

    final signature = Signature().getSignature(apiKey, body);
    final header = {
      'Authorization': 'Bearer $token',
      'api-key': apiKey,
      'timestamps': timestamp,
      'x-SIGNATURE-key': signature,
    };
    final response = await HttpClientCustom().postRequest(
      url,
      headers: header,
      body: body,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> uploadFileManager(
    Map<String, dynamic> params,
    String file,
  ) async {
    final url =
        'https://${dotenv.env['BASE_URL']}/api/beedanainupload/v1/upload/manager';
    final apiKey = dotenv.env['API_KEY_AUTH'].toString();
    final basic = Signature().getBasicAuth(
      'UDo9Za8nFuJzGq6iYQZs0Kioafa9OPTq',
      'fx5mC88y8QMFEEy6zii7s2X8o4rkAn62',
    );
    final header = {
      'Authorization': basic,
      'api-key': apiKey,
    };
    final response = await HttpClientCustom().postFormData(
      url,
      headers: header,
      body: {
        'file': file,
      },
      queryParams: params,
      converter: (response) => GeneralResponse.fromJson(response),
    );
    return response;
  }

  /*
    NEW PENDANAAN  
  */

  @override
  Future<Either<String, GeneralResponse>> getRequest({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String? token,
  }) async {
    Map<String, String> header = {};
    String basicAuth = '';
    String signature = '';
    final timestamp = Signature().getTimestamp();
    final urlFull = 'https://${dotenv.env['BASE_URL']}/$url';
    final payload = {
      'get': urlFull,
      'timestamp': timestamp,
    };
    if (service == serviceBackend.auth) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_AUTH'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEAUTH'].toString(),
        dotenv.env['PWAUTH'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_AUTH'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.user) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_USER'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEUSER'].toString(),
        dotenv.env['PWUSER'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_USER'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }
    if (service == serviceBackend.authLender) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_LENDER'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMELENDER'].toString(),
        dotenv.env['PWLENDER'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_LENDER'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.dokumen) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_DOKUMEN'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEDOKUMEN'].toString(),
        dotenv.env['PWDOKUMEN'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_DOKUMEN'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }
    if (service == serviceBackend.email) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_EMAIL'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEEMAIL'].toString(),
        dotenv.env['PWEMAIL'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_EMAIL'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (isUseToken) {
      header['Authorization'] = 'Bearer $token';
    } else {
      header['Authorization'] = basicAuth;
    }

    final headers = {
      ...header,
      ...moreHeader,
    };

    final response = HttpClientCustom().getRequestV2(
      urlFull,
      headers: headers,
      queryParams: queryParam,
      converter: (response) => GeneralResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> postRequestV2({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required String? token,
  }) async {
    final timestamp = Signature().getTimestamp();

    final payload = {
      'request': body,
      'timestamp': timestamp,
    };
    final String basicAuth = Signature().getBasicAuth(
      dotenv.env['UNAMEAUTH'].toString(),
      dotenv.env['PWAUTH'].toString(),
    );
    final String signature = Signature().getSignature(
      dotenv.env['SECRET_KEY'].toString(),
      payload,
    );
    final Map<String, String> header = {
      'api-key': dotenv.env['API_KEY_AUTH'].toString(),
      'x-SIGNATURE-key': signature,
      'timestamps': timestamp,
    };
    if (isUseToken == true) {
      header['Authorization'] = 'Bearer $token';
    } else {
      header['Authorization'] = basicAuth;
    }
    final urlFull = 'https://${dotenv.env['BASE_URL']}/$url';
    final headers = {
      ...header,
      ...moreHeader,
    };
    final response = HttpClientCustom().postRequest(
      urlFull,
      headers: headers,
      body: body,
      converter: (response) => GeneralResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> getRequestV2({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required String? token,
  }) async {
    final timestamp = Signature().getTimestamp();
    final urlFull = 'https://${dotenv.env['BASE_URL']}/$url';
    final payload = {
      'get': urlFull,
      'timestamp': timestamp,
    };
    final String basicAuth = Signature().getBasicAuth(
      dotenv.env['UNAMEAUTH'].toString(),
      dotenv.env['PWAUTH'].toString(),
    );
    final String signature = Signature().getSignature(
      dotenv.env['SECRET_KEY'].toString(),
      payload,
    );
    final Map<String, String> header = {
      'api-key': signature,
      'timestamps': timestamp,
    };
    if (isUseToken == true) {
      header['Authorization'] = 'Bearer $token';
    } else {
      header['Authorization'] = basicAuth;
    }

    final headers = {
      ...header,
      ...moreHeader,
    };
    final response = HttpClientCustom().getRequestV2(
      urlFull,
      headers: headers,
      queryParams: queryParam,
      converter: (response) => GeneralResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> postRequest({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String? token,
  }) async {
    Map<String, String> header = {};
    String basicAuth = '';
    String signature = '';
    final timestamp = Signature().getTimestamp();
    final urlFull = 'https://${dotenv.env['BASE_URL']}/$url';
    final payload = {
      'request': body,
      'timestamp': timestamp,
    };

    if (service == serviceBackend.auth) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_AUTH'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEAUTH'].toString(),
        dotenv.env['PWAUTH'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_AUTH'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.user) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_USER'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEUSER'].toString(),
        dotenv.env['PWUSER'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_USER'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.authLender) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_LENDER'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMELENDER'].toString(),
        dotenv.env['PWLENDER'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_LENDER'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.dokumen) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_DOKUMEN'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEDOKUMEN'].toString(),
        dotenv.env['PWDOKUMEN'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_DOKUMEN'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }
    if (service == serviceBackend.email) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_EMAIL'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEEMAIL'].toString(),
        dotenv.env['PWEMAIL'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_EMAIL'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (isUseToken) {
      header['Authorization'] = 'Bearer $token';
    } else {
      header['Authorization'] = basicAuth;
    }

    final headers = {
      ...header,
      ...moreHeader,
    };

    final response = HttpClientCustom().postRequest(
      urlFull,
      headers: headers,
      body: payload,
      converter: (response) => GeneralResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<String, dynamic>> postRequestDokumen({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String? token,
  }) async {
    Map<String, String> header = {};
    String basicAuth = '';
    String signature = '';
    final timestamp = Signature().getTimestamp();
    final urlFull = 'https://${dotenv.env['BASE_URL']}/$url';
    final payload = {
      'request': body,
      'timestamp': timestamp,
    };

    if (service == serviceBackend.dokumen) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_DOKUMEN'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEDOKUMEN'].toString(),
        dotenv.env['PWDOKUMEN'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_DOKUMEN'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (isUseToken) {
      header['Authorization'] = 'Bearer $token';
    } else {
      header['Authorization'] = basicAuth;
    }

    final headers = {
      ...header,
      ...moreHeader,
    };

    final response = HttpClientCustom().postRequestDocument(
      urlFull,
      headers: headers,
      body: body,
    );

    return response;
  }

  @override
  Future<Either<String, GeneralResponse>> postFormData({
    required String url,
    required Map<String, String> body,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String? token,
  }) async {
    Map<String, String> header = {};
    String basicAuth = '';
    String signature = '';
    final timestamp = Signature().getTimestamp();
    final urlFull = 'https://${dotenv.env['BASE_URL']}/$url';
    final payload = {
      'request': body,
      'timestamp': timestamp,
    };
    if (service == serviceBackend.auth) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_AUTH'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEAUTH'].toString(),
        dotenv.env['PWAUTH'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_AUTH'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.user) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_USER'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEUSER'].toString(),
        dotenv.env['PWUSER'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_USER'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.authLender) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_LENDER'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMELENDER'].toString(),
        dotenv.env['PWLENDER'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_LENDER'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.dokumen) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_DOKUMEN'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEDOKUMEN'].toString(),
        dotenv.env['PWDOKUMEN'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_DOKUMEN'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.email) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_EMAIL'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEEMAIL'].toString(),
        dotenv.env['PWEMAIL'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_EMAIL'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (isUseToken) {
      header['Authorization'] = 'Bearer $token';
    } else {
      header['Authorization'] = basicAuth;
    }

    final headers = {
      ...header,
      ...moreHeader,
    };

    final response = HttpClientCustom().postFormData(
      urlFull,
      headers: headers,
      queryParams: queryParam,
      body: body,
      converter: (response) => GeneralResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<String, dynamic>> getDokumen({
    required String url,
    required Map<String, dynamic> queryParam,
    required Map<String, String> moreHeader,
    required bool isUseToken,
    required serviceBackend service,
    required String? token,
  }) async {
    Map<String, String> header = {};
    String basicAuth = '';
    String signature = '';
    // ignore: unused_local_variable
    dynamic resData;
    final timestamp = Signature().getTimestamp();
    final urlFull = 'https://${dotenv.env['BASE_URL']}/$url';
    final payload = {
      'get': urlFull,
      'timestamp': timestamp,
    };
    if (service == serviceBackend.auth) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_AUTH'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEAUTH'].toString(),
        dotenv.env['PWAUTH'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_AUTH'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.user) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_USER'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEUSER'].toString(),
        dotenv.env['PWUSER'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_USER'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (service == serviceBackend.authLender) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_LENDER'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMELENDER'].toString(),
        dotenv.env['PWLENDER'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_LENDER'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }
    if (service == serviceBackend.dokumen) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_DOKUMEN'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEDOKUMEN'].toString(),
        dotenv.env['PWDOKUMEN'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_DOKUMEN'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }
    if (service == serviceBackend.email) {
      signature = Signature().getSignature(
        dotenv.env['API_KEY_EMAIL'].toString(),
        payload,
      );
      basicAuth = Signature().getBasicAuth(
        dotenv.env['UNAMEEMAIL'].toString(),
        dotenv.env['PWEMAIL'].toString(),
      );
      header = {
        'api-key': dotenv.env['API_KEY_EMAIL'].toString(),
        'x-SIGNATURE-key': signature,
        'timestamps': timestamp,
      };
    }

    if (isUseToken) {
      header['Authorization'] = 'Bearer $token';
    } else {
      header['Authorization'] = basicAuth;
    }

    final headers = {
      ...header,
      ...moreHeader,
    };

    final response = await HttpClientCustom().postRequestDocument2(
      urlFull,
      headers: headers,
      body: queryParam,
      converter: (res) => resData = res,
    );

    return response;
  }
}
