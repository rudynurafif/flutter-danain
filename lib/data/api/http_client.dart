import 'dart:convert';
import 'dart:io';

import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http/http.dart' as http;

typedef ResponseConverter<T> = T Function(dynamic response);
String _getDataAsString(dynamic data) {
  try {
    final response = jsonDecode(data);
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(response);
  } catch (e) {
    return data.toString();
  }
}

class HttpClientCustom {
  Future<Either<String, T>> postRequest<T>(
    String url, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
    required ResponseConverter<T> converter,
  }) async {
    try {
      final Uri uri = Uri.parse(
        url,
      );

      final Map<String, String> header = headers ?? {};
      header['Content-Type'] = 'application/json';
      final http.Response response = await http.post(
        uri,
        headers: header,
        body: jsonEncode(body),
      );
      print('ini masuk header bang: $header');
      //header message
      try {
        String headerRequest = '';
        header.forEach((k, v) => headerRequest += '► $k: $v\n');
        String headerMessage = '';
        response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');
        final bodyPrint = _getDataAsString(jsonEncode(body));
        // query params message
        final String prettyJson = _getDataAsString(response.body);
        log.d(
          'Request POST ${response.statusCode} > $url\n'
          'Header Request:\n'
          '$headerRequest\n'
          'Headers:\n'
          '$headerMessage\n'
          'Body Request:\n'
          '$bodyPrint\n'
          'Response: $prettyJson',
        );
      } catch (e) {
        log.e(
          'Request POST > $uri\n'
          'error: ${e.toString()}',
        );
      }
      if (response.statusCode == 404) {
        return const Left('Url tidak terdefinisi, salah fe ini pak');
      }
      if (response.statusCode == 500 || response.statusCode == 502) {
        return Left(Constants.get.errorServer);
      }
      if (response.statusCode < 200 || response.statusCode > 202) {
        final body = jsonDecode(response.body);
        return Left(
          body['responseMessage'] ??
              body['message'] ??
              body['Response']['responseMessage'],
        );
      }
      final responseBody = jsonDecode(response.body);
      return Right(converter(responseBody));
    } catch (e) {
      return Left(
        'error tidak terdefinisi: ${e.toString()}',
      );
    }
  }

  Future<Either<String, T>> postRequestDocument<T>(
    String url, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
  }) async {
    try {
      final Uri uri = Uri.parse(
        url,
      );

      final Map<String, String> header = headers ?? {};
      header['Content-Type'] = 'application/json';
      final http.Response response = await http.post(
        uri,
        headers: header,
        body: jsonEncode(body),
      );
      print('ini masuk header bang: $header');
      //header message
      try {
        String headerMessage = '';
        response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');
        final bodyPrint = _getDataAsString(jsonEncode(body));
        // query params message
        final String prettyJson = _getDataAsString(response.body);
        log.d(
          'Request POST > $url\n'
          'Headers:\n'
          '$headerMessage\n'
          'Body Request:\n'
          '$bodyPrint\n'
          'Response: $prettyJson',
        );
      } catch (e) {
        log.e(
          'Request POST > $uri\n'
          'error: ${e.toString()}',
        );
      }
      if (response.statusCode == 404) {
        return const Left('Url tidak terdefinisi, salah fe ini pak');
      }
      if (response.statusCode == 500 || response.statusCode == 502) {
        return Left(Constants.get.errorServer);
      }
      if (response.statusCode < 200 || response.statusCode > 202) {
        final body = jsonDecode(response.body);
        return Left(
          body['responseMessage'] ??
              body['message'] ??
              body['Response']['responseMessage'],
        );
      }
      // final responseBody = jsonDecode(response.body);
      return Right(response.body as T);
    } catch (e) {
      return Left(
        'error tidak terdefinisi: ${e.toString()}',
      );
    }
  }

  Future<Either<String, T>> postRequestDocument2<T>(
    String url, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
    required ResponseConverter<T> converter,
  }) async {
    try {
      final Uri uri = Uri.parse(
        url,
      );

      final Map<String, String> header = headers ?? {};
      header['Content-Type'] = 'application/json';
      final http.Response response = await http.post(
        uri,
        headers: header,
        body: jsonEncode(body),
      );
      print('ini masuk header bang: $header');
      //header message
      try {
        String headerMessage = '';
        response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');
        final bodyPrint = _getDataAsString(jsonEncode(body));
        // query params message
        final String prettyJson = _getDataAsString(response.body);
        log.d(
          'Request POST > $url\n'
          'Headers:\n'
          '$headerMessage\n'
          'Body Request:\n'
          '$bodyPrint\n'
          'Response: $prettyJson',
        );
      } catch (e) {
        log.e(
          'Request POST > $uri\n'
          'error: ${e.toString()}',
        );
      }
      if (response.statusCode == 404) {
        return const Left('Url tidak terdefinisi, salah fe ini pak');
      }
      if (response.statusCode == 500 || response.statusCode == 502) {
        return Left(Constants.get.errorServer);
      }
      if (response.statusCode < 200 || response.statusCode > 202) {
        final body = jsonDecode(response.body);
        return Left(
          body['responseMessage'] ??
              body['message'] ??
              body['Response']['responseMessage'],
        );
      }
      // final responseBody = jsonDecode(response.body);
      return Right(response.body as T);
    } catch (e) {
      return Left(
        'error tidak terdefinisi: ${e.toString()}',
      );
    }
  }

  Future<Either<String, T>> postFormData<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required Map<String, String> body,
    required ResponseConverter<T> converter,
  }) async {
    try {
      final params = queryParams ?? {};
      String param = '?';
      params.forEach((key, value) {
        if (value is List) {
          value.forEach((element) {
            param += '$key=${Uri.encodeQueryComponent(element.toString())}&';
          });
        } else {
          param += '$key=${Uri.encodeQueryComponent(value.toString())}&';
        }
      });
      final Uri uri = Uri.parse(url + param);
      print('ini url bang $uri');

      final Map<String, String> header = headers ?? {};
      header['Content-Type'] = 'multipart/form-data';
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(header);

      await Future.forEach(body.entries, (
        MapEntry<String, String> entry,
      ) async {
        final String key = entry.key;
        final String value = entry.value;

        // ignore: avoid_slow_async_io
        if (await File(value).exists()) {
          final fileStream = http.ByteStream(File(value).openRead());
          final fileLength = await File(value).length();
          final multipartFile = http.MultipartFile(
            key,
            fileStream,
            fileLength,
            filename: 'file-master.jpg',
          );
          request.files.add(multipartFile);
        } else {
          request.fields[key] = value;
        }
      });
      final req = await request.send();
      final response = await http.Response.fromStream(req);

      //header message
      try {
        String headerMessage = '';
        response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');
        final bodyPrint = _getDataAsString(body);
        // query params message
        String paramsMessage = '';
        params.forEach((k, v) => paramsMessage += '► $k: $v\n');
        final String prettyJson = _getDataAsString(response.body);
        log.d(
          'Request POST ${response.statusCode} > $url\n'
          'Headers:\n'
          '$headerMessage\n'
          'Body Request:\n'
          '$bodyPrint\n'
          'Query params:\n'
          '$paramsMessage\n'
          'Response: $prettyJson',
        );
      } catch (e) {
        log.e(
          'Request POST > $uri\n'
          'error: ${e.toString()}',
        );
      }

      if (response.statusCode == 404) {
        return const Left('Url tidak terdefinisi, salah fe ini pak');
      }
      if (response.statusCode == 500 || response.statusCode == 502) {
        return Left(Constants.get.errorServer);
      }
      if (response.statusCode < 200 || response.statusCode > 202) {
        final body = jsonDecode(response.body);
        return Left(
          body['responseMessage'] ??
              body['message'] ??
              body['Response']['responseMessage'],
        );
      }
      final responseBody = jsonDecode(response.body);
      return Right(converter(responseBody));
    } catch (e) {
      print('error bang: ${e.toString()}');
      return Left(
        'error tidak terdefinisi: ${e.toString()}',
      );
    }
  }

  Future<Either<String, T>> getRequestV2<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required ResponseConverter<T> converter,
  }) async {
    try {
      // mapping params
      final params = queryParams ?? {};
      String param = '?';
      params.forEach((key, value) {
        if (value is List) {
          value.forEach((element) {
            param += '$key=${Uri.encodeQueryComponent(element.toString())}&';
          });
        } else {
          param += '$key=${Uri.encodeQueryComponent(value.toString())}&';
        }
      });

      final Uri uri = Uri.parse(url + param);
      final Map<String, String> header = headers ?? {};
      final http.Response response = await http.get(uri, headers: header);

      //header message
      try {
        String headerMessage = '';
        response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');

        String headerRequest = '';
        header.forEach((k, v) => headerRequest += '► $k: $v\n');

        // query params message
        String paramsMessage = '';
        params.forEach((k, v) => paramsMessage += '► $k: $v\n');
        final String prettyJson = _getDataAsString(response.body);
        log.d(
          'Request GET ${response.statusCode} > $url\n'
          'Header Request:\n'
          '$headerRequest\n'
          'Headers:\n'
          '$headerMessage\n'
          'Query Params:\n'
          '$paramsMessage\n'
          'Response: $prettyJson',
        );
      } catch (e) {
        log.e(
          'Request GET > $uri\n'
          'error: ${e.toString()}',
        );
      }
      if (response.statusCode == 404) {
        return const Left('Url tidak terdefinisi, salah fe ini pak');
      }
      if (response.statusCode == 500 || response.statusCode == 502) {
        return Left(Constants.get.errorServer);
      }
      if (response.statusCode < 200 || response.statusCode > 202) {
        final body = jsonDecode(response.body);
        return Left(
          body['responseMessage'] ??
              body['message'] ??
              body['Response']['responseMessage'],
        );
      }
      final responseBody = jsonDecode(response.body);
      return Right(converter(responseBody));
    } catch (e) {
      return Left(
        'error tidak terdefinisi: ${e.toString()}',
      );
    }
  }

  Future<Either<String, T>> postHtmlResponse<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required ResponseConverter<T> converter,
  }) async {
    try {
      // mapping params
      final params = queryParams ?? {};
      String param = '?';
      params.forEach((key, value) {
        if (value is List) {
          value.forEach((element) {
            param += '$key=${Uri.encodeQueryComponent(element.toString())}&';
          });
        } else {
          param += '$key=${Uri.encodeQueryComponent(value.toString())}&';
        }
      });

      final Uri uri = Uri.parse(url + param);
      final Map<String, String> header = headers ?? {};
      final http.Response response = await http.post(
        uri,
        headers: header,
      );

      //header message
      try {
        String headerMessage = '';
        response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');

        String headerRequest = '';
        header.forEach((k, v) => headerRequest += '► $k: $v\n');

        // query params message
        String paramsMessage = '';
        params.forEach((k, v) => paramsMessage += '► $k: $v\n');
        final String prettyJson = _getDataAsString(response.body);
        log.d(
          'Request POST ${response.statusCode} > $url\n'
          'Header Request:\n'
          '$headerRequest\n'
          'Headers:\n'
          '$headerMessage\n'
          'Query Params:\n'
          '$paramsMessage\n'
          'Response: $prettyJson',
        );
      } catch (e) {
        log.e(
          'Request GET > $uri\n'
          'error: ${e.toString()}',
        );
      }
      if (response.statusCode == 404) {
        return const Left('Url tidak terdefinisi, salah fe ini pak');
      }
      if (response.statusCode == 500 || response.statusCode == 502) {
        return Left(Constants.get.errorServer);
      }
      if (response.statusCode < 200 || response.statusCode > 202) {
        final body = jsonDecode(response.body);
        return Left(
          body['responseMessage'] ??
              body['message'] ??
              body['Response']['responseMessage'],
        );
      }

      return Right(converter(response.body));
    } catch (e) {
      return Left(
        'error tidak terdefinisi: ${e.toString()}',
      );
    }
  }
}
