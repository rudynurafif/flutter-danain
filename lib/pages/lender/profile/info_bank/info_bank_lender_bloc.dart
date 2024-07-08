import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_danain/data/api/api_service_helper.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/update_bank_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'info_bank_lender_state.dart';

class InfoLenderBankBloc extends DisposeCallbackBaseBloc {
  final BehaviorSubject<int> step;
  final Function0<void> getInfoBank;
  final BehaviorSubject<Map<String, dynamic>?> bankData;
  final Stream<String?> errorMessage;
  final Stream<bool> isReady;

  final BehaviorSubject<List<dynamic>> listBank;
  final BehaviorSubject<Map<String, dynamic>?> bankSelected;
  final BehaviorSubject<String?> cabang;
  final BehaviorSubject<String?> nomorRekening;
  final Stream<String?> anRekening;
  InfoLenderBankBloc._({
    required this.getInfoBank,
    required this.bankData,
    required this.step,
    required this.listBank,
    required this.bankSelected,
    required this.cabang,
    required this.errorMessage,
    required this.nomorRekening,
    required this.anRekening,
    required this.isReady,
    required Function0<void> dispose,
  }) : super(dispose);

  factory InfoLenderBankBloc(
    GetRequestUseCase getRequest,
    GetRequestV2UseCase getV2,
    PostRequestUseCase postRequest,
    PostRequestV2UseCase postV2,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final bankData = BehaviorSubject<Map<String, dynamic>?>();
    final listBank = BehaviorSubject<List<dynamic>>.seeded([]);
    final errorMessage = BehaviorSubject<String?>();
    final isReady = BehaviorSubject<bool>.seeded(false);
    //form
    final bankSelected = BehaviorSubject<Map<String, dynamic>?>();
    final cabang = BehaviorSubject<String?>();
    final noRek = BehaviorSubject<String?>();
    final anRekening = BehaviorSubject<String?>();
    Future<void> getBankData() async {
      try {
        final response = await getRequest.call(
          url: 'api/beedanainuser/v1/users/informasibank',
          service: serviceBackend.authLender,
        );

        response.fold(
          ifLeft: (error) {
            if (error == 'tidak punya akun bank') {
              bankData.add(null);
            } else {
              errorMessage.add(error);
              final constant = Constants.get.bankLender;
              bankData.add(constant);
              cabang.add(constant['cabang']);
              noRek.add(constant['noRekening']);
              anRekening.add(constant['anRekening']);
            }
          },
          ifRight: (value) {
            final data = value.data ?? {};
            bankData.add(data);
            cabang.add(data['cabang']);
            noRek.add(data['noRekening']);
            anRekening.add(data['anRekening']);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    Future<void> getListBank() async {
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/master/listactive/bank',
          queryParam: {},
          isUseToken: false,
        );
        response.fold(
          ifLeft: (error) {
            errorMessage.add(error);
          },
          ifRight: (value) {
            final List<dynamic> listData = value.data ?? [];
            listBank.add(listData);
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    return InfoLenderBankBloc._(
      getInfoBank: () async {
        isReady.add(false);
        await getListBank();
        await getBankData();
        isReady.add(true);
      },
      bankData: bankData,
      step: stepController,
      listBank: listBank,
      bankSelected: bankSelected,
      cabang: cabang,
      nomorRekening: noRek,
      anRekening: anRekening.stream,
      errorMessage: errorMessage.stream,
      isReady: isReady.stream,
      dispose: () async {},
    );
  }
}

class InfoBankLenderBloc {
  //step 1 untuk di data bank
  //step 2 untuk update data bank
  final stepController = BehaviorSubject<int>.seeded(1);
  Stream<int> get stepStream => stepController.stream;

  final dataController = BehaviorSubject<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get dataStream => dataController.stream;

  final isReady = BehaviorSubject<int>.seeded(1);
  Stream<int> get isReadyStream => isReady.stream;

  final idRekening = BehaviorSubject<int>();
  Stream<int> get idRekeningStream => idRekening.stream;

  final bankSelected = BehaviorSubject<int>();
  Stream<int> get bankSelectedStream => bankSelected.stream;

  final noRek = BehaviorSubject<String?>();
  Stream<String?> get noRekStream => noRek.stream;

  final kotaBank = BehaviorSubject<String?>();
  Stream<String?> get kotaBankStream => kotaBank.stream;

  final anRek = BehaviorSubject<String?>();
  Stream<String?> get anRekStream => anRek.stream;

  final errorPinController = BehaviorSubject<String?>();
  Stream<String?> get errorPinStream => errorPinController.stream;

  final pinsController = BehaviorSubject<String?>();
  Stream<String?> get pinsStream => pinsController.stream;

  Stream<bool> get buttonEditStream => Rx.combineLatest3(
        bankSelected.stream,
        noRek.stream,
        kotaBank.stream,
        (int bankVal, String? rekVal, String? kotaVal) {
          return bankVal != 0 && rekVal != null && kotaVal != null;
        },
      );
  final validateBankStatus = BehaviorSubject<InfoBankLenderState?>();
  Stream<InfoBankLenderState?> get validateBankStream =>
      validateBankStatus.stream;

  final updateBankMessage = BehaviorSubject<UpdateBankState?>();
  Stream<UpdateBankState?> get updateBankMessageStream =>
      updateBankMessage.stream;

  final updatePinMessage = BehaviorSubject<bool>();
  Stream<bool> get updatePinMessageStream => updatePinMessage.stream;
  void getListBank() async {
    isReady.sink.add(1);
    try {
      final responseBank = await _apiService.getMaster('bank', null);
      if (responseBank.statusCode == 200) {
        final List<dynamic> data = jsonDecode(responseBank.body)['data'];
        print('data list $data');
        listBank.sink.add(data);
      }
      isReady.sink.add(2);
    } catch (e) {
      isReady.sink.add(3);
    }
  }

  void getBankData() async {
    try {
      final response = await _apiService.getDataBank();
      final data = response[0];

      dataController.sink.add(data);
      print('showing detail data ${data['kotabank']}');
      idRekening.sink.add(response.isNotEmpty ? data['id_rekening'] ?? 0 : 0);
      bankSelected.sink.add(data['idbank']);
      anRek.sink.add(data['anrekening']);
      if (data['norekening'] != null &&
          data['norekening'] != ' ' &&
          data['norekening'] != '') {
        noRek.sink.add(data['norekening']);
      }
      if (data['kotabank'] != null || data['kotabank'].toString().isEmpty) {
        kotaBank.sink.add(data['kotabank']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateBankLender() async {
    try {
      final idBank = bankSelected.valueOrNull;
      final rek = noRek.valueOrNull;
      final kota = kotaBank.valueOrNull;
      final idRek = idRekening.valueOrNull;

      print(' kota $kota, rek $rek, idBank $idBank, idRek $idRek ');
      if (idBank != null && rek != null && kota != null) {
        final Map<String, dynamic> response =
            await _apiService.updateDataBankLender(
          idBank,
          rek,
          kota,
        );

        final statusCode = response['status'];
        final message = response['message'];
        final data = response['data'];
        print('validate bank response $data');
        if (statusCode == 200) {
          print('berhasil bank lender');
          updateBankMessage.sink.add(const UpdateBankSuccess());
        } else {
          print('gagal bank lender');
          updateBankMessage.sink.add(UpdateBankError(message, data));
        }
      } else {
        print('ke 3 bank lender');
        updateBankMessage.sink.add(const InvalidInformationMessageBank());
      }
    } catch (e) {
      print(e);
      updateBankMessage.sink.add(UpdateBankError(e.toString(), e));
    }
  }

  void sendingPin(String pin) async {
    print('data pin $pin');
    try {
      final response = await _apiService.pinSending(pin);
      final dataResponse = json.decode(response.body);
      print('data respon pin ${dataResponse['status']}');
      if (dataResponse['status'] == 200) {
        errorPinController.sink.add(null);
        updatePinMessage.sink.add(true);
      } else {
        updatePinMessage.sink.add(false);
        errorPinController.sink.add(dataResponse['message']);
      }
    } catch (e) {}
  }

  void updateBank() async {
    try {
      final idBank = bankSelected.valueOrNull;
      final rek = noRek.valueOrNull;
      final an = anRek.valueOrNull;
      final kota = kotaBank.valueOrNull;
      final idRek = idRekening.valueOrNull;
      if (idBank != null &&
          rek != null &&
          an != null &&
          kota != null &&
          idRek != null) {
        final response = await _apiService.updateDataBank(
          idBank,
          rek,
          an,
          kota,
          idRek,
        );
        final body = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          updateBankMessage.sink.add(const UpdateBankSuccess());
        } else {
          print(body);
          updateBankMessage.sink.add(UpdateBankError(body['message'], body));
        }
      } else {
        updateBankMessage.sink.add(const InvalidInformationMessageBank());
      }
    } catch (e) {
      updateBankMessage.sink.add(UpdateBankError(e.toString(), e));
    }
  }

  void dispose() {
    dataController.close();
    isReady.close();
  }

  final listBank = BehaviorSubject<List<dynamic>>();

  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
}
