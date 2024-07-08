import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class DokumenBloc extends DisposeCallbackBaseBloc {
  final Function({
    required String url,
    required Map<String, dynamic> param,
  }) getDokumen;
  final Stream<String?> dokumen;

  DokumenBloc._({
    required this.getDokumen,
    required this.dokumen,
    required Function0<void> dispose,
  }) : super(dispose);

  factory DokumenBloc(
    GetDokumenUseCase getDoc,
  ) {
    final dokumenController = BehaviorSubject<String?>();

    Future<void> getDokumen({
      required String url,
      required Map<String, dynamic> param,
    }) async {
      try {
        final response = await getDoc.call(
          url: url,
          queryParam: param,
        );
        response.fold(
          ifLeft: (error) {
            dokumenController.addError('Terjadi kesalahan: $error');
          },
          ifRight: (value) {
            dokumenController.add(value.toString());
          },
        );
      } catch (e) {
        dokumenController.addError(e.toString());
      }
    }

    return DokumenBloc._(
      getDokumen: getDokumen,
      dokumen: dokumenController.stream,
      dispose: () => dokumenController.close(),
    );
  }
}
