import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/utils.dart';

class InfoPribadiBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getData;
  final Stream<Map<String, dynamic>> dataStream;

  InfoPribadiBloc._({
    required this.getData,
    required this.dataStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory InfoPribadiBloc(GetDataUser getUser) {
    final dataController = BehaviorSubject<Map<String, dynamic>>();
    Future<void> getData() async {
      try {
        final response = await getUser.call(urlParam: 'ktp');
        response.fold(
          ifLeft: (error) {
            dataController.addError('Terjadi Kesalahan: $error');
          },
          ifRight: (value) {
            dataController.add(value.data as Map<String, dynamic>);
          },
        );
      } catch (e) {
        dataController.addError('Terjadi kesalahan ${e.toString()}');
      }
    }

    return InfoPribadiBloc._(
      getData: getData,
      dataStream: dataController.stream,
      dispose: () {
        dataController.close();
      },
    );
  }
}
