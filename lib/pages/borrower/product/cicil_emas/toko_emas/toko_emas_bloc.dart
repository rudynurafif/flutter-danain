import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class SupplierEmasBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> getData;
  final Function1<int, void> stepChange;
  final Function1<int, void> setCurrentRating;
  final Function1<List<dynamic>, void> setCurrentList;

  final Stream<Map<String, dynamic>> dataSupplier;
  final Stream<int> stepStream;
  final Stream<int> currentRating;
  final Stream<List<dynamic>> currentList;

  SupplierEmasBloc._({
    required this.getData,
    required this.dataSupplier,
    required this.stepChange,
    required this.stepStream,
    required this.currentRating,
    required this.currentList,
    required this.setCurrentList,
    required this.setCurrentRating,
    required Function0<void> dispose,
  }) : super(dispose);

  factory SupplierEmasBloc() {
    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );
    final dataController = BehaviorSubject<Map<String, dynamic>>();
    final stepController = BehaviorSubject<int>.seeded(1);
    final currentRatingController = BehaviorSubject<int>.seeded(0);
    final currentListController = BehaviorSubject<List<dynamic>>();

    void getData(int idSupplier) async {
      try {
        final response = await apiService.getDataSupplier(idSupplier);
        print(response);
        dataController.add(response);
        currentListController.add(response['dataRating']);
      } catch (e) {
        dataController
            .addError('Maaf sepertinya terjadi kesalahan ${e.toString()}');
      }
    }

    void dispose() {
      stepController.close();
      dataController.close();
    }

    return SupplierEmasBloc._(
      currentList: currentListController.stream,
      currentRating: currentRatingController.stream,
      setCurrentList: (List<dynamic> val) => currentListController.add(val),
      setCurrentRating: (int val) => currentRatingController.add(val),
      getData: getData,
      dataSupplier: dataController.stream,
      stepChange: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      dispose: dispose,
    );
  }
}
