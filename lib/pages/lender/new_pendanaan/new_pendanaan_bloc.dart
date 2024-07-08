import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../data/api/api_service_helper.dart';
import '../../../data/remote/response/general_response.dart';
import '../../../domain/models/app_error.dart';
import '../../../domain/usecases/api_use_case.dart';
import '../../../domain/usecases/get_auth_state_stream_use_case.dart';
import '../../../utils/type_defs.dart';

class NewPendanaanBloc extends DisposeCallbackBaseBloc {
  // pendanaan
  final Function({Map<String, dynamic> params}) getNewListPendanaan;
  final Function({Map<String, dynamic> params}) getFilterListPendanaan;
  final Function({Map<String, dynamic> params}) infiniteListPendanaan;
  final Stream<List<dynamic>?> listPendanaan;
  final Stream<List<dynamic>?> listFilterPendanaan;

  // beranda
  final Function0<void> getDataHome;
  final Stream<Map<String, dynamic>?> dataHome;
  final Stream<Map<String, dynamic>?> summaryData;

  // message
  final Stream<String?> errorMessage;

  NewPendanaanBloc._({
    required this.getNewListPendanaan,
    required this.getFilterListPendanaan,
    required this.infiniteListPendanaan,
    required this.dataHome,
    required this.getDataHome,
    required this.listPendanaan,
    required this.listFilterPendanaan,
    required Function0<void> dispose,
    required this.errorMessage,
    required this.summaryData,
  }) : super(dispose);

  factory NewPendanaanBloc(
    GetRequestUseCase getRequest,
    PostRequestUseCase postRequest,
    GetAuthStateStreamUseCase getAuthState,
  ) {
    final listPendanaan = BehaviorSubject<List<dynamic>?>();
    final listFilterPendanaan = BehaviorSubject<List<dynamic>?>();
    final homeController = BehaviorSubject<Map<String, dynamic>?>();
    final messageError = BehaviorSubject<String?>();
    final summaryData = BehaviorSubject<Map<String, dynamic>?>();

    Future<void> getBerandaFunction() async {
      final auth = getAuthState();
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

    Future<void> getNewListPendanaan({
      Map<String, dynamic> params = const {},
    }) async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanainpendanaan/v1/pendanaan/list-pendanaan',
          service: serviceBackend.authLender,
          queryParam: params,
        );
        response.fold(
          ifLeft: (String error) {
            messageError.add(error);
          },
          ifRight: (GeneralResponse response) {
            listPendanaan.add(response.data['data']);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
        listPendanaan.add([]);
      }
    }

    Future<void> getFilterListPendanaan({
      Map<String, dynamic> params = const {},
    }) async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanainpendanaan/v1/pendanaan/list-pendanaan',
          service: serviceBackend.authLender,
          queryParam: params,
        );
        response.fold(
          ifLeft: (String error) {
            messageError.add(error);
          },
          ifRight: (GeneralResponse response) {
            listFilterPendanaan.add(response.data['data']);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
        listFilterPendanaan.add([]);
      }
    }

    Future<void> infiniteListPendanaan({
      Map<String, dynamic> params = const {},
    }) async {
      final listData = listPendanaan.valueOrNull ?? [];
      try {
        final response = await getRequest.call(
          url: 'api/beedanainpendanaan/v1/pendanaan/list-pendanaan',
          service: serviceBackend.authLender,
          queryParam: params,
        );
        response.fold(
          ifLeft: (String error) {
            messageError.add(error);
          },
          ifRight: (GeneralResponse response) {
            listData.addAll(response.data['data']);
            listPendanaan.add(listData);
          },
        );
      } catch (e) {
        messageError.add(e.toString());
      }
    }

    void dispose() {
      listPendanaan.close();
    }

    return NewPendanaanBloc._(
      getNewListPendanaan: getNewListPendanaan,
      infiniteListPendanaan: infiniteListPendanaan,
      getFilterListPendanaan: getFilterListPendanaan,
      getDataHome: () async {
        homeController.add(null);
        await getBerandaFunction();
        await getSummary();
      },
      dataHome: homeController.stream,
      listPendanaan: listPendanaan.stream,
      listFilterPendanaan: listFilterPendanaan.stream,
      dispose: dispose,
      summaryData: summaryData.stream,
      errorMessage: messageError.stream,
    );
  }
}
