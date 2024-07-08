import '../../../../../data/api/api_service_helper.dart';
import '../../../../../data/remote/response/general_response.dart';
import '../../../../../domain/models/app_error.dart';
import '../../../../../domain/usecases/api_use_case.dart';
import '../../../../../utils/utils.dart';

class DetailTransaksiBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getDataDetailTransaksi;

  final Stream<Map<String, dynamic>> dataStream;

  DetailTransaksiBloc._({
    required this.getDataDetailTransaksi,
    required this.dataStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory DetailTransaksiBloc(
    int idKasbankDtl2,
    GetRequestUseCase getRequest,
  ) {
    final dataController = BehaviorSubject<Map<String, dynamic>>();

    void dispose() {
      dataController.close();
    }

    void getDataDetailTransaksi() async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/riwayatTransaksiLender',
          service: serviceBackend.authLender,
          queryParam: {'idKasbankDtl2': idKasbankDtl2},
        );
        response.fold(
          ifLeft: (String value) {
            print('Api Response: $value');
          },
          ifRight: (GeneralResponse response) {
            dataController.add(response.data['dataDetail']);
          },
        );
      } catch (e) {
        print('Exception: $e');
      }
    }

    return DetailTransaksiBloc._(
      dataStream: dataController.stream,
      dispose: dispose,
      getDataDetailTransaksi: getDataDetailTransaksi,
    );
  }
}
