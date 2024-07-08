import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/response/general_response.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/info_product_use_case.dart';
import 'package:flutter_danain/utils/utils.dart';

class InfoProductBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getInfoProduct;
  final Stream<List<dynamic>?> listProduct;

  InfoProductBloc._({
    required this.getInfoProduct,
    required this.listProduct,
    required Function0<void> dispose,
  }) : super(dispose);

  factory InfoProductBloc(
    GetAuthStateStreamUseCase getAuthState,
    GetProdukUseCase getProduk,
  ) {
    final listProduct = BehaviorSubject<List<dynamic>?>();

    Future<void> getInfoProduct() async {
      final response = await getProduk.call(
        params: const GetProdukParams(
          page: 1,
          pageSize: 20,
        ),
      );
      response.fold(
        ifLeft: (String value) {},
        ifRight: (GeneralResponse response) {
          // final data = response.data as Map<String, dynamic>;
          // listProduct.add(data['data']);
          listProduct.add(response.data);
        },
      );
    }

    void dispose() {
      listProduct.close();
    }

    return InfoProductBloc._(
      getInfoProduct: getInfoProduct,
      listProduct: listProduct.stream,
      dispose: dispose,
    );
  }
}
