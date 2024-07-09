import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/borrower/email_deeplink/email_deeplink_bloc.dart';
import 'package:flutter_danain/pages/borrower/email_deeplink/email_failed.dart';
import 'package:flutter_danain/pages/borrower/email_deeplink/email_success.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class EmailDeepLinkPage extends StatefulWidget {
  static const routeName = '/email_deeplink';
  final String keys;
  final String isVerifikasi;
  const EmailDeepLinkPage({
    super.key,
    required this.keys,
    required this.isVerifikasi,
  });

  @override
  State<EmailDeepLinkPage> createState() => _EmailDeepLinkPageState();
}

class _EmailDeepLinkPageState extends State<EmailDeepLinkPage> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  Widget build(BuildContext context) {
    final bloc = context.bloc<EmailDeepLinkBloc>();
    return WillPopScope(
      onWillPop: () async {
        await rxPrefs.clear();
        await Navigator.pushNamedAndRemoveUntil(
          context,
          PreferencePage.routeName,
          (route) => false,
        );
        return false;
      },
      child: StreamBuilder<emailStatus>(
        stream: bloc.emailVerif,
        builder: (context, snapshot) {
          final data = snapshot.data ?? emailStatus.initial;
          if (data == emailStatus.success) {
            return EmailSuccessScreen(bloc: bloc);
          }
          if (data == emailStatus.failed) {
            return const EmailFailedScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
