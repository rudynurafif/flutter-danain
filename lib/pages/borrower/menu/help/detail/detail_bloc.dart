import 'dart:async';
import 'dart:convert';
import 'package:flutter_danain/data/remote/response/faq_detail_response.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../data/remote/api_service.dart';
import 'package:http/http.dart' as http;

class FaqDetailBloc {
  final ApiService _apiService =
      ApiService(SimpleHttpClient(client: http.Client()));

  BehaviorSubject<List<FaqDetailResponse>> _faqDetailListController =
      BehaviorSubject<List<FaqDetailResponse>>();

  Stream<List<FaqDetailResponse>> get faqDetailStream =>
      _faqDetailListController.stream;

  void getFaqDetailList(dynamic id_faq) async {
    try {
      final response = await _apiService.getFaqDetail(id_faq);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> dataResponse = jsonData['data'];

        List<FaqDetailResponse> data = dataResponse
            .map(
              (item) => FaqDetailResponse.fromJson(item),
            )
            .toList();
        _faqDetailListController.add(data);
      } else {
        _faqDetailListController.addError('Sepertinya ada yang salah');
      }
    } catch (e) {
      print(e.toString());
      _faqDetailListController.addError(e);
    }
  }

  void dispose() {
    _faqDetailListController.close();
  }
}
