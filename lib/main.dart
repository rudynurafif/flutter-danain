import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:disposebag/disposebag.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'
    show PlatformDispatcher, debugPrint, debugPrintSynchronously, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/simulasi_repository_imp.dart';
import 'package:flutter_danain/data/transaksi_repository_imp.dart';
import 'package:flutter_danain/domain/repositories/simulasi_repository.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';
import 'package:flutter_danain/pages/borrower/email_deeplink/email_deeplink.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/expired_page.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/validate/validate_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/deeplink_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/update_hp_page.dart';
import 'package:flutter_danain/pages/borrower/register/Email_Status_Verif_Success_Borrower.dart';
import 'package:flutter_danain/pages/lender/register/email_status_verif_success.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:flutter_danain/app.dart';
import 'package:flutter_danain/data/local/local_data_source.dart';
import 'package:flutter_danain/data/local/method_channel_crypto_impl.dart';
import 'package:flutter_danain/data/local/shared_pref_util.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/data/remote/auth_interceptor.dart';
import 'package:flutter_danain/data/remote/remote_data_source.dart';
import 'package:flutter_danain/data/user_repository_imp.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  RxStreamBuilder.checkStateStreamEnabled = !kReleaseMode;
  _setupLoggers();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting('id_ID', null);
  final loggingInterceptor = SimpleLoggingInterceptor(
    SimpleLogger(
      loggerFunction: print,
      level: kReleaseMode ? SimpleLogLevel.none : SimpleLogLevel.body,
      headersToRedact: {
        ApiService.xAccessToken,
        HttpHeaders.authorizationHeader,
      },
    ),
  );

  late final Func0<Future<void>> onUnauthorized;
  final authInterceptor =
      AuthInterceptor(onUnauthorized: () => onUnauthorized());

  final simpleHttpClient = SimpleHttpClient(
    client: Platform.isIOS || Platform.isMacOS
        ? CupertinoClient.defaultSessionConfiguration()
        : http.Client(),
    timeout: const Duration(seconds: 20),
    requestInterceptors: [
      authInterceptor.requestInterceptor,
      // others interceptors above this line
      loggingInterceptor.requestInterceptor,
    ],
    responseInterceptors: [
      loggingInterceptor.responseInterceptor,
      // others interceptors below this line
      authInterceptor.responseInterceptor,
    ],
  );

  // construct RemoteDataSource
  final RemoteDataSource remoteDataSource = ApiService(simpleHttpClient);

  // construct LocalDataSource
  final rxPrefs = RxSharedPreferences.getInstance();
  final crypto = MethodChannelCryptoImpl();
  final LocalDataSource localDataSource = SharedPrefUtil(rxPrefs, crypto);
  onUnauthorized = () => localDataSource.removeUserAndToken().first;

  // construct UserRepository
  final UserRepository userRepository = UserRepositoryImpl(
    remoteDataSource,
    localDataSource,
  );
  final SimulasiRepository simulasiRepository = SimulasiRepositoryImpl(
    remoteDataSource,
    localDataSource,
  );

  final TransaksiRepository transaksiRepository = TransaksiRepositoryImpl(
    remoteDataSource,
    localDataSource,
  );

  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();

  // Get the saved app version from SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String savedAppVersion = prefs.getString('app_version') ?? '';
  await rxPrefs.setBool('first_launch', true);

  // Get the current app version using the package_info_plus package
  final String currentAppVersion = await getCurrentAppVersion();
  await initDeepLinkHandling();
  final themeData =
      ThemeData(brightness: Brightness.dark, fontFamily: 'Poppins');
  // Compare the saved version with the current version
  print('versinya bang: ${currentAppVersion.toString()}');
  if (savedAppVersion != currentAppVersion) {
    // Clear SharedPreferences data if the version has changed
    await clearSharedPreferencesData();
    final rxPrefs = RxSharedPreferences.getInstance();
    // Call the clear method to delete all data
    await rxPrefs.clear();
    // Save the current app version for future comparisons
    await prefs.setString('app_version', currentAppVersion);
  }
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(
    Providers(
      providers: [
        Provider<UserRepository>.value(
          userRepository,
        ),
        Provider<SimulasiRepository>.value(
          simulasiRepository,
        ),
        Provider<TransaksiRepository>.value(
          transaksiRepository,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initDeepLinkHandling() async {
  // Initialize the platform channel for handling deep links
  // print('check link nya bang $initialLink');
  getLinksStream().listen((String? link) {
    handleDeeplink(link);
  });
}

Future<void> handleDeeplink(String? link) async {
  if (Platform.isAndroid) {
    await handleAndroid(link);
  }

  if (Platform.isIOS) {
    await handleIos(link);
  }
}

Future<void> handleIos(String? link) async {}

Future<void> handleAndroid(String? link) async {
  final rxPrefs = RxSharedPreferences.getInstance();
  final navigatorState = navigatorKey.currentState;
  if (link == null) {
    // No deep link
    return;
  }
  final realLink = link.replaceAll('amp;', '');
  final deepLink = Uri.parse(realLink);
  print('link satunya bang: $deepLink');
  if (deepLink.queryParameters.containsKey('ref')) {
    final ref = deepLink.queryParameters['ref'];
    if (ref == 'borrower') {
      if (navigatorState != null) {
        await navigatorState.pushNamed(
          EmailDeepLinkPage.routeName,
          arguments: EmailDeepLinkPage(
            keys: deepLink.queryParameters['keys'].toString(),
            isVerifikasi: deepLink.queryParameters['isVerifikasi'].toString(),
          ),
        );
      }
    }
    if (ref == 'borrowerverifikasiemail') {
      if (navigatorState != null) {
        print(' ini email baru aku loh ${rxPrefs.getString('email_baru')}');
        await navigatorState.pushNamed(DeepLinkPage.routeName);
      }
    }

    if (ref == 'borrowerverifikasi') {
      if (navigatorState != null) {
        await navigatorState.pushNamed(
          UpdateHpPage.routeName,
          arguments: UpdateHpPage(
            deepLink: link,
          ),
        );
      }
    }

    if (ref == 'lender') {
      if (deepLink.queryParameters['type'] == 'resetPassword') {
        await rxPrefs.setInt('user_status', 1);
        print('check kode ${deepLink.queryParameters['kode']}');
        deepLink.queryParameters['status'] == '1' ||
                deepLink.queryParameters['kode'] == ''
            ? await navigatorState?.pushNamed(ExpiredScreen.routeName)
            : await navigatorState?.pushNamed(
                MakeNewPasswordPage.routeName,
                arguments: MakeNewPasswordPage(
                  kodeVerifkasi: deepLink.queryParameters['kode'],
                ),
              );
      } else {
        await navigatorState?.pushNamed(EmailStatusVerifSuccess.routeName);
      }
    }

    if (ref == 'borrower') {
      await navigatorState
          ?.pushNamed(EmailStatusVerifSuccessBorrower.routeName);
    }

    if (ref == 'borrowerverifikasreseti') {
      await rxPrefs.setInt('user_status', 2);
      if (deepLink.queryParameters.containsKey('type') &&
          deepLink.queryParameters['type'] == 'forgotpw') {
        final bool isNotValid = deepLink.queryParameters['status'] == '1' ||
            deepLink.queryParameters['status'] == '2' ||
            deepLink.queryParameters['exp'] == '1';
        if (navigatorState != null) {
          isNotValid
              ? await navigatorState.pushNamed(ExpiredScreen.routeName)
              : await navigatorState.pushNamed(
                  MakeNewPasswordPage.routeName,
                  arguments: MakeNewPasswordPage(
                    kodeVerifkasi: deepLink.queryParameters['kode'],
                  ),
                );
        }
      } else {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('step_sementara');
        if (navigatorState != null) {
          await navigatorState
              .pushNamed(EmailStatusVerifSuccessBorrower.routeName);
        }
      }
    }
  }
}

Future<String> getCurrentAppVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

Future<void> clearSharedPreferencesData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 3));
}

void _setupLoggers() {
  // set loggers to `null` to disable logging.
  DisposeBagConfigs.logger = kReleaseMode ? null : disposeBagDefaultLogger;

  RxSharedPreferencesConfigs.logger =
      kReleaseMode ? null : const RxSharedPreferencesDefaultLogger();

  debugPrint = kReleaseMode
      ? (String? message, {int? wrapWidth}) {}
      : debugPrintSynchronously;
}
