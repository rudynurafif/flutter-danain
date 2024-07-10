import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/update_bank_state.dart';
import 'package:flutter_danain/utils/type_defs.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

import 'info_bank_state.dart';

class InformasiBankBloc extends DisposeCallbackBaseBloc {
  final Function0<void> getDataBank;
  final Function({
    required int idBank,
    required String noRek,
    required String kota,
  }) updateBank;

  final BehaviorSubject<int> step;
  final BehaviorSubject<List<dynamic>> listBank;
  final BehaviorSubject<Map<String, dynamic>?> bank;
  final Stream<String?> errorMessage;
  final Stream<bool> isLoading;

  InformasiBankBloc._({
    required this.getDataBank,
    required this.step,
    required this.bank,
    required this.listBank,
    required this.errorMessage,
    required this.isLoading,
    required this.updateBank,
    required Function0<void> dispose,
  }) : super(dispose);

  factory InformasiBankBloc(
    GetDataUser getUser,
    GetRequestUseCase getRequest,
    GetRequestV2UseCase getV2,
    PostRequestUseCase postRequest,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final errorMessage = BehaviorSubject<String?>();
    final isLoading = BehaviorSubject<bool>.seeded(false);
    final listBank = BehaviorSubject<List<dynamic>>.seeded([]);
    final bankBorrower = BehaviorSubject<Map<String, dynamic>?>();

    Future<void> getDataBank() async {
      bankBorrower.add(null);
      try {
        final response = await getRequest.call(
          url: 'api/beeborroweruser/v1/user/detail/bank',
        );
        response.fold(
          ifLeft: (error) {
            bankBorrower.add(null);
            bankBorrower.addError(error);
          },
          ifRight: (value) {
            if (value.data != null) {
              bankBorrower.add(value.data[0]);
            } else {
              bankBorrower.addError(
                'Mohon maaf saat ini anda tidak memiliki akun bank yang terdaftar di aplikasi Danain!',
              );
            }
          },
        );
      } catch (e) {
        bankBorrower.addError(e.toString());
      }
    }

    Future<void> updateBank({
      required int idBank,
      required String noRek,
      required String kota,
    }) async {
      isLoading.add(true);
      final infoBank = bankBorrower.valueOrNull ?? {};

      try {
        final response = await postRequest.call(
          url: 'api/beeborroweruser/v1/user/update/bank',
          body: {
            'idRekening': infoBank['id_peminjam_rekening'] ?? 0,
            'no_rekening': noRek,
            'an_rekening': infoBank['an_rekening'] ?? '',
            'id_bank': idBank,
            'kota_bank': kota,
            'is_active': 1
          },
        );
        response.fold(
          ifLeft: (error) {
            isLoading.add(false);
            errorMessage.add(error);
          },
          ifRight: (value) {
            getDataBank();
            isLoading.add(false);
            stepController.add(1);
          },
        );
      } catch (e) {
        isLoading.add(false);
        errorMessage.add(e.toString());
      }
    }

    Future<void> getBankList() async {
      try {
        final response = await getV2.call(
          url: 'api/borrowerlist/master/listactive/bank',
          queryParam: {},
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

    Future<void> dispose() async {
      await stepController.close();
      await bankBorrower.close();
    }

    return InformasiBankBloc._(
      getDataBank: () async {
        await getDataBank();
        await getBankList();
      },
      listBank: listBank,
      step: stepController,
      bank: bankBorrower,
      dispose: dispose,
      errorMessage: errorMessage.stream,
      isLoading: isLoading.stream,
      updateBank: ({
        required int idBank,
        required String noRek,
        required String kota,
      }) async {
        await updateBank(idBank: idBank, noRek: noRek, kota: kota);
      },
    );
  }
}

class InfoBankBloc {
  //step 1 untuk di data bank
  //step 2 untuk update data bank
  final stepController = BehaviorSubject<int>.seeded(1);
  Stream<int> get stepStream => stepController.stream;
  final pinController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get pinStream => pinController.stream;

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

  Stream<bool> get buttonEditStream => Rx.combineLatest3(
        bankSelectedStream,
        noRekStream,
        kotaBankStream,
        (int bank, String? rek, String? kota) {
          return bank != 0 && rek != null && kota != null;
        },
      );

  final validateBankStatus = BehaviorSubject<InfoBankState?>();
  Stream<InfoBankState?> get validateBankStream => validateBankStatus.stream;

  final updateBankMessage = BehaviorSubject<UpdateBankState?>();
  Stream<UpdateBankState?> get updateBankMessageStream =>
      updateBankMessage.stream;

  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoadingStream => isLoadingButton.stream;

  void getBankData() async {
    isReady.sink.add(1);
    try {
      final response = await _apiService.getDataBank();
      dataController.sink.add(response[0]);
      print('showing detail data ${response[0]}');
      bankSelected.sink.add(response.isNotEmpty
          ? response[0]['id_bank'] ?? response[0]['idbank']
          : 0);

      idRekening.sink
          .add(response.isNotEmpty ? response[0]['id_rekening'] ?? 0 : 0);
      anRek.sink.add(response[0]['an_rekening'] ?? response[0]['anrekening']);
      noRek.sink.add(response[0]['no_rekening'] ?? response[0]['norekening']);
      kotaBank.sink.add(response[0]['kota_bank'] ?? "");

      final responseBank = await _apiService.getMaster('bank', null);
      if (responseBank.statusCode == 200) {
        final List<dynamic> data = jsonDecode(responseBank.body)['data'];
        listBank.sink.add(data);
      }
      isReady.sink.add(2);
    } catch (e) {
      isReady.sink.add(3);

      debugPrint(e.toString());
    }
  }

  void validateBank() async {
    try {
      final idBank = bankSelected.valueOrNull ?? 1;
      final rek = noRek.valueOrNull ?? '';
      final response = await _apiService.validateBank(idBank, rek);
      final data = jsonDecode(response.body);
      print(response.body);
      if (data['status'] == 200) {
        validateBankStatus.sink.add(InfoBankSuccess(data['data']));
        anRek.sink.add(data['data']['customerName']);
      } else if (data['status'] == 201) {
        print('namanya bang heheh');
        validateBankStatus.sink.add(
          InfoBankErrorName(data['data']['data']),
        );
      } else {
        validateBankStatus.sink.add(InfoBankError(data['message'], data));
      }
    } catch (e) {
      print(e.toString());
      validateBankStatus.sink.add(InfoBankError(e.toString(), e));
    }
  }

  Future<void> updateBankLender() async {
    try {
      final idBank = bankSelected.valueOrNull;
      final rek = noRek.valueOrNull;
      final kota = kotaBank.valueOrNull;
      final idRek = idRekening.valueOrNull;

      if (idBank != null && rek != null && kota != null && idRek != null) {
        final Map<String, dynamic> response =
            await _apiService.updateDataBankLender(
          idBank,
          rek,
          kota,
        );

        final statusCode = response['status'];
        final message = response['message'];
        final data = response['data'];

        if (statusCode == 200) {
          // Handle a successful response
          // For example:
          // print('Message: $message');
          updateBankMessage.sink.add(const UpdateBankSuccess());
        } else {
          // Handle an unsuccessful response
          // For example:
          // print('Error Message: $message');
          updateBankMessage.sink.add(UpdateBankError(message, data));
        }
      } else {
        updateBankMessage.sink.add(const InvalidInformationMessageBank());
      }
    } catch (e) {
      print(e);
      updateBankMessage.sink.add(UpdateBankError(e.toString(), e));
    }
  }

  void sendingPin() async {
    try {
      // final idBank = bankSelected.valueOrNull;
      // final rek = noRek.valueOrNull;
      // final an = anRek.valueOrNull;
      // final kota = kotaBank.valueOrNull;
      // final idRek = idRekening.valueOrNull;
    } catch (e) {
      print(e.toString());
    }
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
