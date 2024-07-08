import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/utils/utils.dart';

class SetorDanaBloc extends DisposeCallbackBaseBloc {
  //function
  final Function0<void> getData;
  final Function1<int, void> getTutorial;

  //stream
  final BehaviorSubject<int> idBankSelected;
  final BehaviorSubject<int> step;
  final Stream<List<dynamic>> listBank;
  final Stream<Map<String, dynamic>?> tutorial;
  final Stream<String?> errorMessage;

  SetorDanaBloc._({
    required this.step,
    required this.getData,
    required this.listBank,
    required this.idBankSelected,
    required this.getTutorial,
    required this.errorMessage,
    required this.tutorial,
    required Function0<void> dispose,
  }) : super(dispose);

  factory SetorDanaBloc(
    final GetAuthStateStreamUseCase getAuthState,
    final GetRequestUseCase getRequest,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final listBank = BehaviorSubject<List<dynamic>>();
    final tutorialController = BehaviorSubject<Map<String, dynamic>?>();
    final errorMessage = BehaviorSubject<String?>();
    final idBankSelected = BehaviorSubject<int>.seeded(1);

    Future<void> getListBank() async {
      listBank.add(Constants.get.listBank);
      // try {
      //   final response = await getRequest.call(
      //     url: 'api/beedanaintransaksi/v1/trx/listBank',
      //     service: serviceBackend.authLender,
      //   );
      //   response.fold(
      //     ifLeft: (message) {
      //       errorMessage.add(message);
      //       listBank.add(Constants.get.listBank);
      //     },
      //     ifRight: (value) {
      //       listBank.add(value.data as List<dynamic>);
      //     },
      //   );
      // } catch (e) {
      //   errorMessage.add(e.toString());
      // }
    }

    Future<void> getTutorial(int idBank) async {
      idBankSelected.add(idBank);
      tutorialController.add(null);
      try {
        final response = await getRequest.call(
          url: 'api/beedanaintransaksi/v1/trx/tutorsetordana',
          queryParam: {
            'metode': idBank,
          },
          service: serviceBackend.authLender,
        );
        response.fold(
          ifLeft: (message) {
            errorMessage.add(message);
          },
          ifRight: (value) {
            tutorialController.add(value.data as Map<String, dynamic>);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    void dispose() {}

    return SetorDanaBloc._(
      idBankSelected: idBankSelected,
      step: stepController,
      getData: () async {
        await getListBank();
      },
      getTutorial: getTutorial,
      errorMessage: errorMessage.stream,
      tutorial: tutorialController.stream,
      listBank: listBank.stream,
      dispose: dispose,
    );
  }
}
