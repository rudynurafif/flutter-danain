import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/utils.dart';

class InfoKerjaBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getData;
  final Stream<Map<String, dynamic>> dataStream;

  InfoKerjaBloc._({
    required this.getData,
    required this.dataStream,
    required Function0<void> dispose,
  }) : super(dispose);

  factory InfoKerjaBloc(GetDataUser getUser) {
    final dataController = BehaviorSubject<Map<String, dynamic>>();
    Future<void> getData() async {
      try {
        final response = await getUser.call(urlParam: 'pribadi');
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

    return InfoKerjaBloc._(
      getData: getData,
      dataStream: dataController.stream,
      dispose: () {
        dataController.close();
      },
    );
  }
}
