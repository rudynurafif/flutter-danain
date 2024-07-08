import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/utils.dart';

class DetailPortoBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepChange;
  final Function1<int, void> getDataDetail;

  //stream
  final Stream<int> stepStream;
  final Stream<Map<String, dynamic>> detailDataStream;
  final Stream<Map<String, dynamic>> riwayatPengembalian;
  final Stream<dynamic> documentPerjanjian;

  final Stream<String?> errorMessage;
  DetailPortoBloc._({
    required this.stepChange,
    required this.getDataDetail,
    required this.detailDataStream,
    required this.documentPerjanjian,
    required this.riwayatPengembalian,
    required this.stepStream,
    required this.errorMessage,
    required Function0<void> dispose,
  }) : super(dispose);

  factory DetailPortoBloc(
    GetAuthStateStreamUseCase getAuthState,
    GetRequestUseCase getRequest,
    GetDokumenUseCase getDokumen,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final detailData = BehaviorSubject<Map<String, dynamic>>();
    final documentPerjanjian = BehaviorSubject<dynamic>();
    final riwayatPengembalian = BehaviorSubject<Map<String, dynamic>>();
    final errorMessage = BehaviorSubject<String?>();
    Future<void> getDocumentPerjanjian(int idAgreement) async {
      try {
        final response = await getDokumen.call(
          url: 'api/beedanaingenerate/v1/dokumen/PP',
          isUseToken: false,
          service: serviceBackend.dokumen,
        );
        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) => documentPerjanjian.add(value),
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    Future<void> getData(int idAgreement) async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/portofolio',
          queryParam: {
            'idAgreement': idAgreement,
          },
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            detailData.add(value.data);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    void dispose() {
      detailData.close();
    }

    return DetailPortoBloc._(
      documentPerjanjian: documentPerjanjian.stream,
      getDataDetail: (idAgreement) async {
        await getData(idAgreement);
        // await getDocumentPerjanjian(idAgreement);
      },
      errorMessage: errorMessage.stream,
      riwayatPengembalian: riwayatPengembalian.stream,
      stepChange: (int val) => stepController.add(val),
      stepStream: stepController.stream,
      detailDataStream: detailData.stream,
      dispose: dispose,
    );
  }
}
