import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class PinjamanMenuBloc {
  final pageController = BehaviorSubject<int>.seeded(1);
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final totalHargaPinjaman = BehaviorSubject<int>();
  final totalPinjaman = BehaviorSubject<int>();
  final pinjamanListController = BehaviorSubject<List<dynamic>>();
  final ApiService apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );

  void initGetData(String parameter) async {
    try {
      print('get data $parameter');
      final listPinjaman = await apiService.getPinjamanList(1, parameter);
      pinjamanListController.add(listPinjaman['data']);
      totalHargaPinjaman.add(listPinjaman['total_pinjaman']);
      totalPinjaman.add(listPinjaman['total']);
      print('sip ${pinjamanListController.value}');
    } catch (e) {
      pinjamanListController.addError('Maaf sepertinya terjadi kesalahan');
    }
  }

  void getNewList(String parameter) async {
    isLoading.add(true);
    final page = pageController.valueOrNull ?? 1;
    final listPinjaman = pinjamanListController.valueOrNull ?? [];
    try {
      print('get data $parameter');
      pageController.add(page + 1);
      final response = await apiService.getPinjamanList(page + 1, parameter);
      listPinjaman.addAll(response['data']);
      pinjamanListController.add(listPinjaman);
      isLoading.add(false);
    } catch (e) {
      pinjamanListController.addError('Maaf Sepertinya terjadi Kesalahan');
    }
  }
}
