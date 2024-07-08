import 'dart:async';
import 'dart:convert';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../data/remote/api_service.dart';
import '../../../../data/remote/response/faq_response.dart';
import 'package:http/http.dart' as http;

class FaqBloc {
  final ApiService _apiService =
      ApiService(SimpleHttpClient(client: http.Client()));

  final _faqListController = BehaviorSubject<List<FaqResponse2>>();

  Stream<List<FaqResponse2>> get faqStream => _faqListController.stream;


  void getFaqList() async {
    try {
      final response = await _apiService.getFaqList();
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> dataResponse = jsonData['data'];
        final List<FaqResponse2> data =
            dataResponse.map((item) => FaqResponse2.fromJson(item)).toList();
        _faqListController.add(data);
      } else {
        _faqListController.addError('Sepertinya ada yang salah');
      }
    } catch (e) {
      print(e.toString());
      _faqListController.addError(e);
    }
  }

  void dispose() {
    _faqListController.close();
  }
}
