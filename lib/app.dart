import 'dart:io';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/data/remote/onesignal.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/home_page.dart';
import 'package:flutter_danain/widgets/animation/custom_animation_route.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/pages/borrower/register/register_page.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/login/login.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_pendanaan.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/portofolio_detail_page.dart';
import 'package:flutter_danain/router.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/modal/modalPopUp.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_use_case.dart';
import 'package:flutter_danain/utils/streams.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:localstorage/localstorage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'pages/lender/check_pin/check_pin_page.dart';
import 'pages/lender/home/home_page.dart';

mixin AppLocale {
  static const String title = 'title';
  static const String thisIs = 'thisIs';

  static const Map<String, dynamic> ID = {
    title: 'Local',
    thisIs: 'message bang',
  };
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalStorage storage = LocalStorage('todo_app.json');
  // bool _tryAgain = false;
  // late ConnectivityResult _connectionStatus;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final ApiService apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );

  @override
  void initState() {
    super.initState();
    initOnesignal();
    // _checkWifi();
    // checkVersion();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  void checkVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    try {
      final Map<String, dynamic> dataVersion = await apiService.checkVersion();
      if (version != dataVersion['versi']) {
        // ignore: use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: ModalPopUpNoClose2(
                icon: 'assets/images/icons/update.svg',
                title: 'Versi Baru Tersedia',
                message:
                    'Saat ini sudah tersedia aplikasi versi terbaru untuk Anda. Silahkan update aplikasi Danain di Play Store',
                actions: [
                  Button2(
                    btntext: 'Perbarui Sekarang',
                    color: HexColor(lenderColor),
                    action: () async {
                      const url =
                          'https://play.google.com/store/apps/details?id=com.danainwbv.lender&hl=id&gl=US&pli=1';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          },
        );
      }
    } catch (e) {}
  }
  //
  // _checkWifi() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   _updateConnectionStatus(connectivityResult);
  //
  //   Connectivity().onConnectivityChanged.listen((result) {
  //     _updateConnectionStatus(result);
  //   });
  // }
  //
  // void _updateConnectionStatus(ConnectivityResult result) {
  //   print('check status connection ${result.toString()}');
  //
  //   bool connectedToWifi = (result == ConnectivityResult.wifi);
  //   if (!connectedToWifi) {
  //     _showAlert(context);
  //   } else {
  //     // Hide the alert dialog when connected to WiFi
  //     Navigator.of(context).pop();
  //   }
  //
  //
  //   if (_tryAgain != connectedToWifi) {
  //     setState(() => _tryAgain = connectedToWifi);
  //   }
  // }
  //
  // void _showAlert(BuildContext context) {
  //   if (mounted) {
  //     showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text("WiFi"),
  //         content: Text("WiFi not detected. Please activate it."),
  //       ),
  //     );
  //   }
  //
  // }
  //

  @override
  Widget build(BuildContext context) {
    final themeData =
        ThemeData(brightness: Brightness.dark, fontFamily: 'Poppins');
    return Provider<Map<String, WidgetBuilder>>.value(
      Routers.routes,
      child: OKToast(
        child: ScreenUtilInit(
          minTextAdapt: true,
          designSize: const Size(375, 667),
          child: MaterialApp(
            title: 'Flutter Demo',
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            theme: themeData.copyWith(
              bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.transparent),
              colorScheme: themeData.colorScheme.copyWith(
                  secondary: const Color(0xff24663F),
                  primary: const Color(0xff24663F)),
              primaryColor: const Color(0xff24663F),
              scaffoldBackgroundColor: Colors.white,
              buttonTheme: ButtonThemeData(
                colorScheme: themeData.colorScheme.copyWith(
                    secondary: const Color(0xff24663F),
                    primary: const Color(0xff24663F)),
              ),
              checkboxTheme: const CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            routes: Routers.routes,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with DisposeBagMixin {
  late final StateStream<Result<AuthenticationState>?> authState$;
  SharedPreferences? _prefs;
  final LocalStorage storage = LocalStorage('todo_app.json');

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
    final getAuthState = Provider.of<GetAuthStateUseCase>(context);
    authState$ = getAuthState().castAsNullable().publishState(null)
      ..connect().disposedBy(bag);
  }

  Future<void> _loadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      // Trigger a rebuild to reflect the changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final routes = Provider.of<Map<String, WidgetBuilder>>(context);
    return RxStreamBuilder<Result<AuthenticationState>?>(
      stream: authState$,
      builder: (context, result) {
        if (result == null) {
          debugPrint('[HOME] home [1] >> [waiting...]');

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).cardColor,
            child: Center(
              child: Image.asset(
                'assets/lender/loading/danain.png',
              ),
            ),
          );
        }

        return result.fold(
          ifLeft: (appError) {
            if (_prefs?.getInt('step_sementara') != null) {
              return routes[RegisterIndex.routeName]!(context);
            }
            return routes[PreferencePage.routeName]!(context);
          },
          ifRight: (authState) {
            if (authState is UnauthenticatedState) {
              debugPrint('[HOME] home [3] >> [Unauthenticated]');
              final tokenSementara = _prefs?.getString('token_sementara');
              if (_prefs?.getInt('step_sementara') != null) {
                // Check if tokenSementara is not null before navigating to EmailStatusVerif
                if (tokenSementara != null) {
                  return routes[RegisterIndex.routeName]!(context);
                } else {
                  // Handle the case where tokenSementara is null
                  return routes[PreferencePage.routeName]!(context);
                }
              } else {
                return routes[PreferencePage.routeName]!(context);
              }
            }

            if (authState is AuthenticatedState) {
              debugPrint('[HOME] home [4] >> [Authenticated]');
              final rxPrefs = RxSharedPreferences.getInstance();
              return FutureBuilder(
                future: getUserStatus(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data ?? 1;
                    if (data == 1) {
                      if (rxPrefs.getBool('first_launch') == false) {
                        return routes[CheckPinLenderPage.routeName]!(context);
                      } else {
                        return routes[HomePageLender.routeNeme]!(context);
                      }
                    }
                    if (data == 2) {
                      return routes[HomePage.routeName]!(context);
                    }
                  }
                  return routes[HomePage.routeName]!(context);
                },
              );
            }

            throw StateError('Unknown auth state: $authState');
          },
        );
      },
    );
  }
}
