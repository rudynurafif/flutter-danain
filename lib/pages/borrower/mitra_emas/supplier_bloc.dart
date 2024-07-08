import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class GetSupplierBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getSupplier;

  final Stream<List<dynamic>> dataStream;

  GetSupplierBloc._({
    required this.getSupplier,
    required this.dataStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory GetSupplierBloc() {
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    final dataController = BehaviorSubject<List<dynamic>>();

    void getSupplier() async {
      try {
        final response = await apiService.getSupplierEmas(null, 1);
        final body = jsonDecode(response.body);
        if (response.statusCode == 200) {
          dataController.add(body['data']['data']);
        } else {
          dataController.addError(body['message']);
        }
      } catch (e) {
        dataController.addError('Maaf terjadi kesalahan ${e.toString()}');
      }
    }

    return GetSupplierBloc._(
      getSupplier: getSupplier,
      dataStream: dataController.stream,
      dispose: () {
        dataController.close();
      },
    );
  }
}
