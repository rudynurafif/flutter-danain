import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:disposebag/disposebag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/usecases/check_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_beranda_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_riwayat_transaksi_v3.dart';
import 'package:flutter_danain/domain/usecases/logout_use_case.dart';
import 'package:flutter_danain/domain/usecases/post_konfirmasi_penyerahan_pinjaman.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/borrower/home/home_state.dart';
import 'package:flutter_danain/pages/lender/check_pin/check_pin_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

/// BLoC that handles user profile and logout
class HomeBloc extends DisposeCallbackBaseBloc {
  final ApiService apiService;

  /// Input functions
  final Function0<void> changeAvatar;
  final Function0<void> logout;
  final Function0<void> checkFdc;
  final Function0<void> checkFdcCicilEmas;
  final Function0<void> checkFdcTest;
  final Function0<void> setBeranda;
  final Function0<void> setPortofolio;
  final Function0<void> getInfoPromoDanain;

  /// Output stream
  final StateStream<Result<AuthenticationState>?> authState$;
  final Stream<HomeMessage> message$;
  final Stream<dynamic> messageFdc$;
  final Stream<dynamic> messageFdcCicilEmas$;
  final Stream<dynamic> messageFdcTest$;
  final Stream<dynamic> messageBeranda$;
  final Stream<dynamic> messagePortofolio$;
  final StateStream<bool> isUploading$;

  //lender
  final Function0<void> setPortofolioLender;
  final Function2<int, String, void> getListPendanaan;
  final Function2<int, String, void> infiniteAktif;
  final Function2<int, String, void> infiniteSelesai;
  final Function0<void> getJenisProduk;

  //borrower
  final Function1<Map<String, dynamic>, void> getRiwayatTransaksi;
  final Function1<Map<String, dynamic>, void> infiniteRiwayat;

  //lender output
  final Stream<Map<String, dynamic>> portofolioStream;
  final Stream<int> totalAktifStream;
  final Stream<int> totalSelesaiStream;
  final Stream<List<dynamic>> recordAktifStream;
  final Stream<List<dynamic>> recoredSelesaiStream;
  final Stream<int> isLoadingStream;
  final Stream<List<dynamic>> jenisProdukStream;
  // is loading
  // 1 diem
  // 2 loading
  // 3 udah abis

  //cicil emas borrower
  final Function0<void> getInitData;
  final Function0<void> infiniteScroll;
  final Function0<void> terapkanFilter;

  //stream
  final Stream<int> isLoadingCicilEmas;
  final Stream<List<dynamic>> listCicilanStream$;
  final Stream<List<dynamic>> listInfoPromoStream$;
  final Stream<int> totalStream$;
  final Stream<num> totalHargaStream$;
  final Stream<bool> isInfinite$;
  final Stream<bool> isTerapkanCicil;

  //params
  final Function1<List<String>, void> statusChange;
  final Function1<String, void> sortChange;
  final Stream<List<String>> statusStream;
  final Stream<String> sortStream;

  //check pin
  final Function0<void> checkPin;
  final Function1<String, void> pinChange;

  final Function1<String?, void> pinErrorChange;
  final Stream<String?> pinErrorController;

  final Stream<CheckPinMessage?> messageCheckPin;
  final Function0<void> postKonfirmasiPenyerahanKonfirmasPinjamanCND;
  final Stream<String?> konfirmasiError;

  final BehaviorSubject<List<dynamic>?> response;
  final BehaviorSubject<int> totalResponsetransaksi;
  final Function0<void> getBeranda;
  final Stream<Map<String, dynamic>?> berandaData;
  HomeBloc._({
    required this.changeAvatar,
    required this.message$,
    required this.messageFdc$,
    required this.messageFdcTest$,
    required this.messageBeranda$,
    required this.messagePortofolio$,
    required this.checkFdc,
    required this.checkFdcTest,
    required this.setBeranda,
    required this.setPortofolio,
    required this.logout,
    required this.authState$,
    required this.isUploading$,
    required this.apiService,
    required this.setPortofolioLender,
    required this.portofolioStream,
    required this.getListPendanaan,
    required this.infiniteAktif,
    required this.infiniteSelesai,
    required this.totalAktifStream,
    required this.totalSelesaiStream,
    required this.recordAktifStream,
    required this.recoredSelesaiStream,
    required this.isLoadingStream,
    required this.checkFdcCicilEmas,
    required this.messageFdcCicilEmas$,
    required this.getInitData,
    required this.listCicilanStream$,
    required this.totalStream$,
    required this.sortStream,
    required this.statusStream,
    required this.sortChange,
    required this.statusChange,
    required this.totalHargaStream$,
    required this.infiniteScroll,
    required this.isLoadingCicilEmas,
    required this.terapkanFilter,
    required this.isInfinite$,
    required this.getJenisProduk,
    required this.jenisProdukStream,
    required this.isTerapkanCicil,
    required this.getInfoPromoDanain,
    required this.listInfoPromoStream$,
    required this.checkPin,
    required this.pinChange,
    required this.pinErrorChange,
    required this.pinErrorController,
    required this.messageCheckPin,
    required Function0<void> dispose,
    required this.postKonfirmasiPenyerahanKonfirmasPinjamanCND,
    required this.konfirmasiError,
    required this.getRiwayatTransaksi,
    required this.response,
    required this.totalResponsetransaksi,
    required this.infiniteRiwayat,
    required this.getBeranda,
    required this.berandaData,
  }) : super(dispose);

  factory HomeBloc(
    final LogoutUseCase logout,
    final GetAuthStateStreamUseCase getAuthState,
    final GetBerandaUseCase getBeranda,
    final CheckPinUseCase checkPinUseCase,
    PostKonfirmasiPenyerahanPinjamanUseCase
        postKonfirmasiPenyerahanPinjamanUseCase,
    GetRiwayatTransaksiUseCase getRiwayatTransaksiUseCase,
    GetRequestUseCase getRequest,
  ) {
    final changeAvatarS = PublishSubject<void>();
    final logoutS = PublishSubject<void>();
    final checkFdcs = PublishSubject<void>();
    final checkFdcCicilEmas = PublishSubject<void>();
    final checkFdcsTest = PublishSubject<void>();
    final setBerandas = PublishSubject<void>();
    final setPortofolios = PublishSubject<void>();
    final isUploading$ = StateSubject(false);
    final KonfirmasiErrorController = BehaviorSubject<String?>();
    final responseController = BehaviorSubject<List<dynamic>?>();
    final totalResponseTransaksiController = BehaviorSubject<int>();
    final berandaController = BehaviorSubject<Map<String, dynamic>?>();
    final errorMessage = BehaviorSubject<String?>();
    final authenticationState$ = getAuthState();
    Future<String> getToken() async {
      final event = await authenticationState$.first;

      final token = event.orNull()!.userAndToken!.token.toString();
      return token;
    }

    Future<void> getBerandaFunction() async {
      berandaController.add(null);
      try {
        final response = await getRequest.call(
          url: 'api/beeborroweruser/v1/user/dashboard',
        );

        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            berandaController.add(value.data);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    final logoutMessage$ = Rx.merge([
      logoutS.exhaustMap((_) => logout()).map(_resultToLogoutMessage),
      authenticationState$
          .where((result) => result.orNull()?.userAndToken == null)
          .mapTo(const LogoutSuccessMessage()),
    ]);

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    final checkFdcMessage$ = checkFdcs
        .debug(identifier: 'checkFdcs [1]', log: debugPrint)
        .switchMap((_) {
      return Stream.fromIterable([null]).asyncExpand((_) async* {
        await for (final event in authenticationState$) {
          try {
            final response = await apiService.getCheckFdcs(
              event.orNull()!.userAndToken!.token,
            );
            print('fdc message ${response.body}');
            final responseBody = jsonDecode(response.body);

            yield responseBody;
          } catch (e) {
            yield e.toString();
          }
        }
      });
    }).asBroadcastStream();
    final messageFdcCicilEmas$ = checkFdcCicilEmas
        .debug(identifier: 'checkFdcs [1]', log: debugPrint)
        .switchMap((_) {
      return Stream.fromIterable([null]).asyncExpand((_) async* {
        await for (final event in authenticationState$) {
          try {
            final response = await apiService.getCheckFdcs(
              event.orNull()!.userAndToken!.token,
            );
            final responseBody = jsonDecode(response.body);
            yield responseBody;
          } catch (e) {
            yield e.toString();
          }
        }
      });
    }).asBroadcastStream();
    final checkFdcTestMessage$ = checkFdcsTest
        .debug(identifier: 'checkFdcs [1]', log: debugPrint)
        .switchMap((_) {
      return Stream.fromIterable([null]).asyncExpand((_) async* {
        await for (final event in authenticationState$) {
          try {
            final response = await apiService.getPortofolios(
              event.orNull()!.userAndToken!.token,
            );
            final responseBody = jsonDecode(response);
            final sendingData = responseBody['data'];
            yield sendingData;
          } catch (e) {
            yield e.toString();
          }
        }
      });
    }).asBroadcastStream();

    final checkPortofolioMessage$ = checkFdcs
        .debug(identifier: 'checkFdcs [1]', log: debugPrint)
        .switchMap((_) {
      return Stream.fromIterable([null]).asyncExpand((_) async* {
        await for (final event in authenticationState$) {
          try {
            final response = await apiService.getPortofolios(
              event.orNull()!.userAndToken!.token,
            );
            final responseBody = jsonDecode(response);
            final sendingData = responseBody['data']['data_pinjaman_aktif'];
            yield sendingData;
          } catch (e) {
            yield e.toString();
          }
        }
      });
    }).asBroadcastStream();

    final checkBerandaMessage$ = setBerandas
        .debug(identifier: 'checkBeranda [1]', log: debugPrint)
        .exhaustMap((_) => getBeranda())
        .asBroadcastStream();

    final messageFdc$ =
        Rx.merge([checkFdcMessage$]).whereType<HomeMessage>().publish();
    final messageFdcTest$ =
        Rx.merge([checkFdcTestMessage$]).whereType<HomeMessage>().publish();

    final messagePortofolio$ =
        Rx.merge([checkFdcMessage$]).whereType<HomeMessage>().publish();

    final messageBeranda$ =
        Rx.merge([checkBerandaMessage$]).whereNotNull().publish();

    final authState$ = authenticationState$.castAsNullable().publishState(null);

    final message$ = Rx.merge([logoutMessage$]).whereNotNull().publish();

    //cicil emas borrower
    final listCicilanController = BehaviorSubject<List<dynamic>>();
    final listInfoPromoController = BehaviorSubject<List<dynamic>>();
    final totalListController = BehaviorSubject<int>();
    final totalHargaController = BehaviorSubject<num>();
    final sortController = BehaviorSubject<String>.seeded('terbaru');
    final statusController = BehaviorSubject<List<String>>.seeded([]);
    final pageController = BehaviorSubject<int>.seeded(1);
    final isLoadingController = BehaviorSubject<int>.seeded(1);
    final isTerapkanController = BehaviorSubject<bool>.seeded(false);
    final isInfinteController = BehaviorSubject<bool>.seeded(false);
    final responseKonfirmasiController =
        BehaviorSubject<Map<String, dynamic>?>();

    String getStatusFilter(List<String> value) {
      if (value.isNotEmpty) {
        final queryString = value.map((id) => 'status=$id').join('&');
        return '&$queryString';
      }
      return '';
    }

    String getParams() {
      final status = statusController.valueOrNull ?? [];
      final statusVal = getStatusFilter(status);
      final sort = sortController.valueOrNull ?? 'terbaru';
      final sortVal = 'sort=$sort';
      return '$sortVal$statusVal';
    }

    void getInitData() async {
      final token = await getToken();
      isTerapkanController.add(false);
      sortController.add('terbaru');
      statusController.add([]);
      try {
        final response = await apiService.getTransaksiCicilEmas(
          token,
          1,
          getParams(),
        );
        // print(response);
        final List<dynamic> listData = response['data'];
        listCicilanController.add(listData);
        totalListController.add(response['total']);
        totalHargaController.add(response['saldo']);
        isLoadingController.add(2);
      } catch (e) {
        isLoadingController.add(3);
      }
    }

    void getInfoPromoDanain() async {
      final event = await authState$.first;
      final token = event?.orNull()!.userAndToken!.token.toString();

      try {
        final response = await apiService.getInfoPromoDanain(
          token!,
        );
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> listData = jsonResponse['data'];
        print('list Data Get Info Promo Danain $listData');
        listInfoPromoController.add(listData);
      } catch (e) {
        print('error Data Get Info Promo Danain $e');
        // isLoadingController.add(3);
      }
    }

    void terapkan() async {
      final token = await getToken();
      isTerapkanController.add(true);
      try {
        final response = await apiService.getTransaksiCicilEmas(
          token,
          1,
          getParams(),
        );
        final List<dynamic> listData = response['data'];
        listCicilanController.add(listData);
        totalListController.add(response['total']);
        totalHargaController.add(response['saldo']);
        isLoadingController.add(2);
      } catch (e) {
        isLoadingController.add(3);
      }
    }

    void infiniteScroll() async {
      isInfinteController.add(true);
      final token = await getToken();
      final page = pageController.valueOrNull ?? 1;
      final isTerapkan = isTerapkanController.valueOrNull ?? false;
      final data = listCicilanController.valueOrNull ?? [];
      try {
        final response = await apiService.getTransaksiCicilEmas(
          token,
          page + 1,
          isTerapkan == true ? getParams() : 'sort=terbaru',
        );
        final List<dynamic> listData = response['data'];
        data.addAll(listData);
        listCicilanController.add(data);
        pageController.add(page + 1);
      } catch (e) {
        isLoadingController.add(3);
      }
      isInfinteController.add(false);
    }

    //portofolio lender
    final portofolioController = BehaviorSubject<Map<String, dynamic>>();
    final totalRecordAktif = BehaviorSubject<int>();
    final totalRecordSelesai = BehaviorSubject<int>();
    final recordAktif = BehaviorSubject<List<dynamic>>();
    final recordSelesai = BehaviorSubject<List<dynamic>>();
    final isLoading = BehaviorSubject<int>.seeded(1);
    final jenisProductController = BehaviorSubject<List<dynamic>>();
    void getPortofolioLender() async {
      final event = await authenticationState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        final response = await apiService.getPortofolioLender(token);
        portofolioController.add(response);
      } catch (e) {
        portofolioController.addError('Maaf sepertinya ada kesalaha');
      }
    }

    void getProduct() async {
      final event = await authenticationState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        final response = await apiService.getProductPendaanan1(token);
        print(response);
        jenisProductController.add(response);
        print('ini produk: ${jenisProductController.value}');
      } catch (e) {
        print('error: ${e.toString()}');
        jenisProductController.addError(e.toString());
      }
    }

    void getPendanaan(int status, String params) async {
      final event = await authenticationState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      try {
        isLoading.add(1);
        final response =
            await apiService.getPendanaanList(status, 1, token, params);
        final List<dynamic> list = response['data'];

        switch (status) {
          case 1:
            recordAktif.add(list);
            totalRecordAktif.add(response['total_record']);
            break;
          case 2:
            recordSelesai.add(response['data']);
            totalRecordSelesai.add(response['total_record']);
            break;
          default:
        }
      } catch (e) {
        switch (status) {
          case 1:
            recordAktif.addError('Sepertinya ada yang salah');
            totalRecordAktif.addError('Sepetinya ada yang salah');
            break;
          case 2:
            recordSelesai.addError('Sepertinya ada yang salah');
            totalRecordSelesai.addError('Sepertinya ada yang salah');
            break;
          default:
        }
      }
    }

    void infiniteAktif(int page, String params) async {
      final event = await authenticationState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      isLoading.add(2);
      final listPinjaman = recordAktif.valueOrNull ?? [];
      try {
        final response =
            await apiService.getPendanaanList(1, page, token, params);
        final List<dynamic> list = response['data'];
        if (list.isEmpty) {
          isLoading.add(3);
        } else {
          isLoading.add(1);
        }
        listPinjaman.addAll(response['data']);
        recordAktif.add(listPinjaman);
      } catch (e) {
        recordAktif.addError('Maaf Sepertinya terjadi Kesalahan');
      }
    }

    void infiniteSelesai(int page, String params) async {
      final event = await authenticationState$.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      isLoading.add(2);
      final listPinjaman = recordSelesai.valueOrNull ?? [];
      try {
        final response =
            await apiService.getPendanaanList(2, page, token, params);
        final List<dynamic> list = response['data'];
        if (list.isEmpty) {
          isLoading.add(3);
        } else {
          isLoading.add(1);
        }
        listPinjaman.addAll(response['data']);
        recordSelesai.add(listPinjaman);
      } catch (e) {
        recordSelesai.addError('Maaf Sepertinya terjadi Kesalahan');
      }
    }

    Future<void> postKonfirmasiPenyerahanKonfirmasPinjamanCND() async {
      Map<String, dynamic> dataHome = {};

      final event = await authenticationState$.first;

      final beranda = event?.orNull()!.userAndToken!.beranda.toString();

      final Map<String, dynamic> decodedToken = JwtDecoder.decode(beranda!);

      dataHome = decodedToken['beranda']['penyerahanBPKB'];
      final payload = {
        'idPengajuan': dataHome['idPengajuan'],
        'idTaskPengajuan': dataHome['idTaskPengajuan'],
        'isPenyerahanBpkb': 3,
      };
      final response =
          await postKonfirmasiPenyerahanPinjamanUseCase.call(payload: payload);
      response.fold(
        ifLeft: (value) {
          errorMessage.add(value);
        },
        ifRight: (value) {
          KonfirmasiErrorController.add('Berhasil');
          responseKonfirmasiController.add(value.data);
        },
      );
    }

    //check pin
    final pinController = BehaviorSubject<String>();
    final pinErrorController = BehaviorSubject<String?>();
    final checkPinButton = PublishSubject<void>();

    final checkPinClick = checkPinButton.stream.share();
    final messageCheckPin = Rx.merge([
      checkPinClick
          .withLatestFrom(pinController.stream, (_, String val) => val)
          .exhaustMap(
            (value) => checkPinUseCase(pin: value),
          )
          .map(_responseToMessage)
    ]);

    Future<void> getRiwayatTransaksi(Map<String, dynamic> params) async {
      responseController.add(null);
      try {
        final event = await authenticationState$.first;
        final response = await getRiwayatTransaksiUseCase.call(
          endpoint: '/api/beeborrowertransaksi/v1/cnd/riwayattransaksiborrower',
          params: params,
          token: event.orNull()!.userAndToken!.token.toString(),
        );
        response.fold(
          ifLeft: (error) {
            print('masuk left bang $error');
            errorMessage.add(error);
            responseController.add([]);
          },
          ifRight: (value) {
            print('masuk right bang ${value.data}');
            totalResponseTransaksiController.add(value.data['total']);
            responseController.add(value.data['data']);
          },
        );
      } catch (e) {
        print('masuk error bang bang ${e.toString()}');
        errorMessage.add(e.toString());
      }
    }

    Future<void> infiniteRiwayat(Map<String, dynamic> params) async {
      final data = responseController.valueOrNull ?? [];
      try {
        final event = await authenticationState$.first;
        final response = await getRiwayatTransaksiUseCase.call(
          endpoint: '/api/beeborrowertransaksi/v1/cnd/riwayattransaksiborrower',
          params: params,
          token: event.orNull()!.userAndToken!.token.toString(),
        );
        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            data.addAll(value.data['data'] ?? []);
            responseController.add(data);
          },
        );
      } catch (e) {
        print('masuk error bang bang ${e.toString()}');
        errorMessage.add(e.toString());
      }
    }

    return HomeBloc._(
      apiService: apiService,
      changeAvatar: () => changeAvatarS.add(null),
      logout: () => logoutS.add(null),
      checkFdc: () => checkFdcs.add(null),
      checkFdcTest: () => checkFdcsTest.add(null),
      setBeranda: () => setBerandas.add(null),
      setPortofolio: () => setPortofolios.add(null),
      authState$: authState$,
      isUploading$: isUploading$,
      dispose: DisposeBag([
        authState$.connect(),
        message$.connect(),
        messageFdc$.connect(),
        messageFdcTest$.connect(),
        messageBeranda$.connect(),
        messagePortofolio$.connect(),
        changeAvatarS,
        logoutS,
        isUploading$,
      ]).dispose,
      message$: message$,
      getJenisProduk: getProduct,
      jenisProdukStream: jenisProductController.stream,
      messageBeranda$: messageBeranda$,
      checkFdcCicilEmas: () => checkFdcCicilEmas.add(null),
      messageFdcCicilEmas$: messageFdcCicilEmas$,
      messagePortofolio$: checkPortofolioMessage$,
      messageFdc$: checkFdcMessage$,
      messageFdcTest$: checkFdcTestMessage$,
      portofolioStream: portofolioController.stream,
      setPortofolioLender: getPortofolioLender,
      getListPendanaan: getPendanaan,
      infiniteAktif: infiniteAktif,
      infiniteSelesai: infiniteSelesai,
      recordAktifStream: recordAktif.stream,
      recoredSelesaiStream: recordSelesai.stream,
      totalAktifStream: totalRecordAktif.stream,
      totalSelesaiStream: totalRecordSelesai.stream,
      isLoadingStream: isLoading.stream,
      getInitData: getInitData,
      listCicilanStream$: listCicilanController.stream,
      listInfoPromoStream$: listInfoPromoController.stream,
      totalStream$: totalListController.stream,
      sortStream: sortController.stream,
      sortChange: (String val) => sortController.add(val),
      statusChange: (List<String> val) => statusController.add(val),
      statusStream: statusController.stream,
      totalHargaStream$: totalHargaController.stream,
      isLoadingCicilEmas: isLoadingController.stream,
      infiniteScroll: infiniteScroll,
      terapkanFilter: terapkan,
      isInfinite$: isInfinteController.stream,
      isTerapkanCicil: isTerapkanController.stream,
      getInfoPromoDanain: getInfoPromoDanain,
      checkPin: () => checkPinButton.add(null),
      pinChange: (String val) => pinController.add(val),
      pinErrorChange: (String? val) => pinErrorController.add(val),
      pinErrorController: pinErrorController.stream,
      messageCheckPin: messageCheckPin,
      postKonfirmasiPenyerahanKonfirmasPinjamanCND:
          postKonfirmasiPenyerahanKonfirmasPinjamanCND,
      konfirmasiError: KonfirmasiErrorController.stream,
      getRiwayatTransaksi: getRiwayatTransaksi,
      infiniteRiwayat: infiniteRiwayat,
      response: responseController,
      totalResponsetransaksi: totalResponseTransaksiController,
      berandaData: berandaController.stream,
      getBeranda: getBerandaFunction,
    );
  }

  static CheckPinMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const CheckPinSuccess(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : CheckPinError(appError.message!, appError.error!),
    );
  }

  static LogoutMessage? _resultToLogoutMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const LogoutSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : LogoutErrorMessage(appError.message!, appError.error!),
    );
  }
}
