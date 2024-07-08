import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_riwayat_transaksi_v3.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/utils.dart';

class ProsesPengajuanBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getDataDetail;
  final Function0<void> infiniteScroll;

  final Stream<String?> errorMessage;
  final Stream<Map<String, dynamic>?> beranda;
  final Stream<List<dynamic>?> listData;

  ProsesPengajuanBloc._({
    required this.getDataDetail,
    required this.infiniteScroll,
    required this.listData,
    required this.beranda,
    required this.errorMessage,
    required Function0<void> dispose,
  }) : super(dispose);

  factory ProsesPengajuanBloc(
    GetAuthStateStreamUseCase getAuthState,
    GetRequestUseCase getRequest,
    GetRiwayatTransaksiUseCase getRiwayatTransaksiUseCase,
  ) {
    final detailData = BehaviorSubject<Map<String, dynamic>>();
    final pageController = BehaviorSubject<int>.seeded(1);
    final errorMessage = BehaviorSubject<String?>();
    final berandaData = BehaviorSubject<Map<String, dynamic>?>();
    final authState$ = getAuthState();

    //params
    final responseController = BehaviorSubject<List<dynamic>?>();

    Future<void> getData() async {
      pageController.add(1);
      responseController.add(null);
      try {
        final event = await authState$.first;
        final response = await getRiwayatTransaksiUseCase.call(
          endpoint: '/api/beeborrowertransaksi/v1/cnd/riwayattransaksiborrower',
          params: {
            'page': 1,
            'pageSize': 10,
            'proses': 1,
          },
          token: event.orNull()!.userAndToken!.token.toString(),
        );
        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            responseController.add(value.data);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    Future<void> getBeranda() async {
      try {
        final response = await getRequest.call(
          url: 'api/beeborroweruser/v1/user/dashboard',
        );

        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            berandaData.add(value.data);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    Future<void> infiniteScroll() async {
      final page = pageController.valueOrNull ?? 1;
      final data = responseController.valueOrNull ?? [];
      try {
        final event = await authState$.first;
        final response = await getRiwayatTransaksiUseCase.call(
          endpoint: '/api/beeborrowertransaksi/v1/cnd/riwayattransaksiborrower',
          params: {
            'page': page + 1,
            'pageSize': 10,
            'proses': 1,
          },
          token: event.orNull()!.userAndToken!.token.toString(),
        );
        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            data.addAll(value.data ?? []);
            responseController.add(data);
            pageController.add(page + 1);
          },
        );
      } catch (e) {
        detailData.addError('Maaf sepertinya terjadi kesalahan');
      }
    }

    void dispose() {
      detailData.close();
    }

    return ProsesPengajuanBloc._(
      getDataDetail: () async {
        await getData();
        await getBeranda();
      },
      beranda: berandaData.stream,
      infiniteScroll: infiniteScroll,
      dispose: dispose,
      listData: responseController.stream,
      errorMessage: errorMessage.stream,
    );
  }
}
