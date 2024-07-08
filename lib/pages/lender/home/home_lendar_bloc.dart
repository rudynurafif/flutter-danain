import 'package:disposebag/disposebag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/lender/home/home_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeLenderBloc extends DisposeCallbackBaseBloc {
  //beranda
  final Function0<void> getDataHome;
  final Stream<Map<String, dynamic>?> dataHome;
  final Stream<List<dynamic>?> listPemula;
  final Stream<dynamic> messageBeranda$;

  //portofolio
  final Function0<void> getDataPortofolio;
  final Function({Map<String, dynamic> params}) getPendanaanAktif;
  final Function({Map<String, dynamic> params}) infiniteAktif;
  final Function({Map<String, dynamic> params}) getPendanaanSelesai;
  final Function({Map<String, dynamic> params}) infiniteSelesai;
  final Stream<List<dynamic>?> listPendanaanAktif;
  final Stream<List<dynamic>?> listPendanaanSelesai;
  final Stream<Map<String, dynamic>?> summaryData;
  final Stream<int> totalAktif;
  final Stream<int> totalSelesai;

  //profile
  final Function0<void> getDataProfile;
  final Stream<User?> user;

  //message
  final Stream<String?> errorMessage;

  //logout
  final Function0<void> logout;
  final Stream<HomeLenderMessage> logoutMessage$;
  HomeLenderBloc._({
    required this.getDataHome,
    required this.dataHome,
    required this.messageBeranda$,
    required this.logoutMessage$,
    required this.listPendanaanAktif,
    required this.listPendanaanSelesai,
    required this.listPemula,
    required this.errorMessage,
    required this.summaryData,
    required this.getPendanaanAktif,
    required this.infiniteAktif,
    required this.getPendanaanSelesai,
    required this.infiniteSelesai,
    required this.getDataPortofolio,
    required this.user,
    required this.getDataProfile,
    required this.totalAktif,
    required this.totalSelesai,
    required this.logout,
    required Function0<void> dispose,
  }) : super(dispose);

  factory HomeLenderBloc(
    final GetAuthStateStreamUseCase getAuth,
    final GetRequestUseCase getRequest,
    final GetBerandaUseCase getBeranda,
    final LogoutUseCase logout,
  ) {
    final homeController = BehaviorSubject<Map<String, dynamic>?>();
    final messageError = BehaviorSubject<String?>();
    final listPengajuanPemula = BehaviorSubject<List<dynamic>?>();

    final summaryData = BehaviorSubject<Map<String, dynamic>?>();
    final authenticationState$ = getAuth();
    Future<void> getBerandaFunction() async {
      final auth = getAuth();
      try {
        final event = await auth.first;
        final data = event.orNull()!.userAndToken;
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(
          data!.beranda,
        );
        homeController.add(decodedToken['beranda']);
      } catch (e) {
        homeController.addError(e.toString());
      }
    }

    Future<void> getPengajuanPemula() async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanainpendanaan/v1/pendanaan/list-pendanaan?isPeluang=1',
          isUseToken: true,
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (value) {
            messageError.add(value);
          },
          ifRight: (value) {
            listPengajuanPemula.add(value.data['data'] as List<dynamic>);
          },
        );
      } catch (e) {
        listPengajuanPemula.add([]);
        messageError.add(e.toString());
      }
    }

    Future<void> getSummary() async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/summary',
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (value) {
            messageError.add(value);
          },
          ifRight: (value) {
            summaryData.add(value.data);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    final setBerandas = PublishSubject<void>();
    final checkBerandaMessage$ = setBerandas
        .debug(identifier: 'checkBeranda [1]', log: debugPrint)
        .exhaustMap((_) => getBeranda())
        .asBroadcastStream();
    final messageBeranda$ =
        Rx.merge([checkBerandaMessage$]).whereNotNull().publish();

    final setLogout = PublishSubject<void>();
    final logoutMessage$ = Rx.merge([
      setLogout.exhaustMap((_) => logout()).map(_resultToLogoutLenderMessage),
      authenticationState$
          .where((result) => result.orNull()?.userAndToken == null)
          .mapTo(const LogoutLenderSuccessMessage()),
    ]);
    final messageLogout$ = Rx.merge([logoutMessage$]).whereNotNull().publish();

    //portofolio
    final listPendanaanAktif = BehaviorSubject<List<dynamic>?>();
    final totalAktif = BehaviorSubject<int>.seeded(0);
    final listPendanaanSelesai = BehaviorSubject<List<dynamic>?>();
    final totalSelesai = BehaviorSubject<int>.seeded(0);

    Future<void> getPendanaanAktif({
      Map<String, dynamic> params = const {},
    }) async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/portofolio',
          queryParam: params,
          isUseToken: true,
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            if (value.data != null) {
              listPendanaanAktif.add(
                (value.data['ResponseData'] ?? []) as List<dynamic>,
              );
              totalAktif.add(value.data['totalData'] ?? 0);
            } else {
              listPendanaanAktif.add([]);
              totalAktif.add(0);
            }
          },
        );
      } catch (e) {
        messageError.add(e.toString());
        listPendanaanAktif.add([]);
      }
    }

    Future<void> infinitePendanaanAktif({
      Map<String, dynamic> params = const {},
    }) async {
      final listAktif = listPendanaanAktif.valueOrNull ?? [];
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/portofolio',
          queryParam: params,
          isUseToken: true,
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            listAktif.addAll(
              (value.data['ResponseData'] ?? []) as List<dynamic>,
            );
            print('ini lengthnya ${listAktif.length}');
            listPendanaanAktif.add(listAktif);
          },
        );
      } catch (e) {
        print('masuk bang');
        print(e.toString());
        messageError.add(e.toString());
      }
    }

    Future<void> getPendanaanSelesai({
      Map<String, dynamic> params = const {},
    }) async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/portofolio',
          queryParam: params,
          isUseToken: true,
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
            listPendanaanSelesai.add([]);
          },
          ifRight: (value) {
            if (value.data != null) {
              listPendanaanSelesai.add(
                (value.data['ResponseData'] ?? []) as List<dynamic>,
              );
              totalSelesai.add(value.data['totalData'] ?? 0);
            } else {
              listPendanaanSelesai.add([]);
              totalSelesai.add(0);
            }
          },
        );
      } catch (e) {
        messageError.add(e.toString());
        listPendanaanSelesai.add([]);
      }
    }

    Future<void> infinitePendanaanSelesai({
      Map<String, dynamic> params = const {},
    }) async {
      final listSelesai = listPendanaanSelesai.valueOrNull ?? [];
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/portofolio',
          queryParam: params,
          isUseToken: true,
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (error) {
            messageError.add(error);
          },
          ifRight: (value) {
            listSelesai.addAll(
              (value.data['ResponseData'] ?? []) as List<dynamic>,
            );
            listPendanaanSelesai.add(listSelesai);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    //profile
    final userController = BehaviorSubject<User?>();
    Future<void> getUser() async {
      final auth = getAuth();
      try {
        final event = await auth.first;
        final data = event.orNull()!.userAndToken;
        final user = data?.user;
        userController.add(user);
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    return HomeLenderBloc._(
      getDataHome: () async {
        homeController.add(null);
        setBerandas.add(null);
        await getBerandaFunction();
        await getSummary();
        await getPengajuanPemula();
      },
      getDataProfile: () async {
        homeController.add(null);
        userController.add(null);
        setBerandas.add(null);
        await getBerandaFunction();
        await getUser();
      },
      user: userController.stream,
      logout: () => setLogout.add(null),
      logoutMessage$: messageLogout$,
      dataHome: homeController.stream,
      listPendanaanAktif: listPendanaanAktif.stream,
      listPendanaanSelesai: listPendanaanSelesai.stream,
      messageBeranda$: messageBeranda$,
      errorMessage: messageError.stream,
      listPemula: listPengajuanPemula,
      summaryData: summaryData.stream,
      getDataPortofolio: () async {
        await getSummary();
      },
      getPendanaanAktif: getPendanaanAktif,
      infiniteAktif: infinitePendanaanAktif,
      getPendanaanSelesai: getPendanaanSelesai,
      infiniteSelesai: infinitePendanaanSelesai,
      totalAktif: totalAktif.stream,
      totalSelesai: totalSelesai.stream,
      dispose: DisposeBag([
        messageBeranda$.connect(),
        messageLogout$.connect(),
      ]).dispose,
    );
  }

  static LogoutLenderMessage? _resultToLogoutLenderMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const LogoutLenderSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : LogoutLenderErrorMessage(appError.message!, appError.error!),
    );
  }
}
