import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:http/http.dart' as http;

class NotifBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> getPesan;
  final Function1<int, void> getNotif;
  final Function1<int, void> readNotif;
  final Function1<int, void> setPagePesan;
  final Function1<int, void> setPageNotif;

  final Stream<List<dynamic>?> pesanList;
  final Stream<List<dynamic>?> notifList;

  NotifBloc._({
    required this.getNotif,
    required this.getPesan,
    required this.pesanList,
    required this.notifList,
    required this.readNotif,
    required this.setPageNotif,
    required this.setPagePesan,
    required Function0<void> dispose,
  }) : super(dispose);

  factory NotifBloc(
    GetAuthStateStreamUseCase getAuthState,
  ) {
    final authState = getAuthState();
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    final pesanListController = BehaviorSubject<List<dynamic>?>();
    final notifListController = BehaviorSubject<List<dynamic>?>();
    final pagePesan = BehaviorSubject<int>.seeded(1);
    final pageNotif = BehaviorSubject<int>.seeded(1);

    void getPesan(int status) async {
      final page = pagePesan.valueOrNull ?? 1;
      var param = 'page_pesan=$page';

      if (status == 1) {
        pesanListController.addNull();
        param = 'page_pesan=1';
      }
      final event = await authState.first;
      final token = event.orNull()!.userAndToken!.token;
      final pesan = pesanListController.valueOrNull ?? [];
      try {
        final response = await apiService.getNotifikasi(token, param);
        final List<dynamic> data = response['data_notif_pesan'];
        pesan.addAll(data);
        pesanListController.add(pesan);
        pagePesan.add(page + 1);
      } catch (e) {
        pesanListController.addError('Maaf sepertinya terjadi kesalahan $e');
      }
    }

    void getNotif(int status) async {
      final page = pageNotif.valueOrNull ?? 1;
      var param = 'page=$page';
      if (status == 1) {
        notifListController.addNull();
        param = 'page=1';
      }
      final event = await authState.first;
      final token = event.orNull()!.userAndToken!.token;

      final notif = notifListController.valueOrNull ?? [];
      try {
        final response = await apiService.getNotifikasi(token, param);
        final List<dynamic> data = response['data_notf_transaksi'];
        notif.addAll(data);
        notifListController.add(notif);
        pageNotif.add(page + 1);
      } catch (e) {
        notifListController.addError('Maaf sepertinya terjadi kesalahan $e');
      }
    }

    void readNotif(int idNotif) async {
      final event = await authState.first;
      final token = event.orNull()!.userAndToken!.token;
      try {
        final response = await apiService.readNotif(token, idNotif);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pageNotif.add(1);
          pagePesan.add(1);
          getNotif(1);
          getPesan(1);
        }
      } catch (e) {
        print(e.toString());
      }
    }

    void dispose() {
      pesanListController.close();
      notifListController.close();
    }

    return NotifBloc._(
      getNotif: getNotif,
      getPesan: getPesan,
      pesanList: pesanListController.stream,
      notifList: notifListController.stream,
      setPageNotif: (int val) => pageNotif.add(val),
      setPagePesan: (int val) => pagePesan.add(val),
      dispose: dispose,
      readNotif: readNotif,
    );
  }
}
