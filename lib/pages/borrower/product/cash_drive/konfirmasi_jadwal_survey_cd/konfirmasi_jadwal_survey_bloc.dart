
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_jadwal_survey_cd/konfirmasi_jadwal_survey_state.dart';
import 'package:flutter_danain/utils/utils.dart';

class KonfirmasiJadwalSurveyBloc extends DisposeCallbackBaseBloc {
  //STREAM
  final Stream<Map<String, dynamic>> dataStream;
  final Stream<String> stepStream;

  //PROCCESS
  final Function2<int, int, void> getDataDetail;
  final Function0<void> postDataDetail;

  final Stream<KonfirmasiJadwalSurveyMessage?> messagePostDetail;
  KonfirmasiJadwalSurveyBloc._({
    required this.dataStream,
    required this.getDataDetail,
    required this.postDataDetail,
    required this.messagePostDetail,
    required this.stepStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory KonfirmasiJadwalSurveyBloc(
    GetAuthStateStreamUseCase getAuthState,
    PostKonfirmasiJadwalSurveyUseCase postKonfirmasiJadwalSurvey,
    GetRequestUseCase getRequest,
  ) {
    final dataController = BehaviorSubject<Map<String, dynamic>>();
    final idTaskPengajuanController = BehaviorSubject<int>();
    final idPengajuanController = BehaviorSubject<int>();
    final postDataDetailController = PublishSubject<void>();
    final stepController = BehaviorSubject<String>.seeded('1');
    final authState = getAuthState();
    Future<String> getToken() async {
      final event = await authState.first;

      final token = event.orNull()!.userAndToken!.token.toString();
      return token;
    }


    Future<void> getDataDetail(
      int idTaskPengajuan,
      int idPengajuan,
    ) async {
      idTaskPengajuanController.add(idTaskPengajuan);
      idPengajuanController.add(idPengajuan);
      try {
        final response = await getRequest.call(
          url: 'api/beeborrowertransaksi/v1/cnd/konfirmasi/survey',
          queryParam: {
            'idTaskPengajuan': idTaskPengajuan,
          },
        );
        response.fold(
          ifLeft: (error) {
            dataController.addError(
              'Terjadi kesalahan saat memproses data: $error',
            );
          },
          ifRight: (value) {
            dataController.add(value.data);
          },
        );
      } catch (e) {
        dataController.addError('Terjadi kesalahan saat memproses data: $e');
      }
    }

    final credentialReg = Rx.combineLatest2(
      idTaskPengajuanController.stream,
      idPengajuanController.stream,
      (
        int idTaskPengajuan,
        int idPengajuan,
      ) {
        return CredReq(
          idTaskPengajuan: idTaskPengajuan,
          idPengajuan: idPengajuan,
        );
      },
    );

    final messagePostDetailS = Rx.merge(
      [
        postDataDetailController
            .withLatestFrom(credentialReg, (_, CredReq cred) => cred)
            .exhaustMap((value) => postKonfirmasiJadwalSurvey(
                  idPengajuan: value.idPengajuan,
                  idTaskPengajuan: value.idTaskPengajuan,
                ))
            .map(_responseMessage)
      ],
    );
    return KonfirmasiJadwalSurveyBloc._(
      dataStream: dataController.stream,
      getDataDetail: getDataDetail,
      messagePostDetail: messagePostDetailS,
      stepStream: stepController.stream,
      postDataDetail: () => postDataDetailController.add(null),
      dispose: () {
        dataController.close();
      },
    );
  }
  static KonfirmasiJadwalSurveyMessage? _responseMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const KonfirmasiJadwalSurveySuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : KonfirmasiJadwalSurveyErrorMessage(
              appError.message!, appError.error!),
    );
  }
}

class CredReq {
  final int idTaskPengajuan;
  final int idPengajuan;

  const CredReq({
    required this.idTaskPengajuan,
    required this.idPengajuan,
  });
}
