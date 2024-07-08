import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class Signature {
  String secretKey = dotenv.env['API_KEY'].toString();

  String getBasicAuth(String username, String password) {
    final String cred = '$username:$password';
    print('ini username: $username');
    print('ini password: $password');
    final String basicAuth = 'Basic ${base64Encode(utf8.encode(cred))}';
    return basicAuth;
  }

  String getSignature(
    String secret,
    Map<String, dynamic> payload,
  ) {
    final jwt = JWT(payload);
    final tokenJwt = jwt.sign(
      SecretKey(secret),
      noIssueAt: true,
    );
    print('secretnya: $secret');
    print("RESPONSE SIGNATURE $tokenJwt");
    return tokenJwt.split('.')[2];
  }

  String getTimestamp() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final wibDateTime = dateTime.toUtc().add(const Duration(hours: 7));

    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm").format(wibDateTime);

    // ignore: join_return_with_assignment
    formattedDate += '+07:00';
    return formattedDate;
  }
}
