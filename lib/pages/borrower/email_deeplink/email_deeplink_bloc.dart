import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';

enum emailStatus {
  initial,
  success,
  failed,
}

class EmailDeepLinkBloc extends DisposeCallbackBaseBloc {
  final Function({
    required String keys,
    required String isVerifikasi,
  }) getVerifikasi;
  final Stream<emailStatus> emailVerif;
  final Stream<bool> isLogin;

  EmailDeepLinkBloc._({
    required this.getVerifikasi,
    required this.emailVerif,
    required this.isLogin,
    required Function0<void> dispose,
  }) : super(dispose);

  factory EmailDeepLinkBloc(
    GetAuthStateStreamUseCase getAuth,
  ) {
    final emailVerif = BehaviorSubject<emailStatus>.seeded(emailStatus.initial);
    final isLogin = BehaviorSubject<bool>.seeded(false);
    final authState$ = getAuth();
    Future<void> getVerifikasi({
      required String keys,
      required String isVerifikasi,
    }) async {
      try {
        log.d(
          'Keys nih bang = $keys\n'
          'isVerifnya bang = $isVerifikasi\n',
        );
        //validasi emailnya sama nggak
        final event = await authState$.first;
        final email = event.orNull()?.userAndToken?.user.email;
        if (email != null) {
          final emailHash = md5
              .convert(
                utf8.encode(email.toString()),
              )
              .toString();
          log.d(
            'ini emailnya: $email\n'
            'ini md5 emailnya: $emailHash\n',
          );
          if (emailHash == keys) {
            isLogin.add(true);
          } else {
            isLogin.add(false);
          }
        }

        //validasi isVerifikasi
        if (isVerifikasi == '1') {
          emailVerif.add(emailStatus.success);
        } else {
          emailVerif.add(emailStatus.failed);
        }
      } catch (e) {
        isLogin.add(false);
        emailVerif.add(emailStatus.failed);
      }
    }

    return EmailDeepLinkBloc._(
      getVerifikasi: getVerifikasi,
      isLogin: isLogin.stream,
      emailVerif: emailVerif.stream,
      dispose: () {
        emailVerif.close();
        isLogin.close();
      },
    );
  }
}
