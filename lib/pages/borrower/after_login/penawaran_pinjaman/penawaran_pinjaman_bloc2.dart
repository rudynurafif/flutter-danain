import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:flutter_danain/domain/usecases/post_penawaran_use_case.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:http/http.dart' as http;

class PenawaranPinjamanBloc2 extends DisposeCallbackBaseBloc {
  final Function1<int, void> stepControl;
  final Function2<int, int, void> getPinjamanControl;
  final Function1<bool, void> checkPinjamanControl;
  final Function1<String, void> otpControl;
  final Function1<String, void> otpControlError;
  final Function1<Map<String, dynamic>, void> responseControl;
  final Function0<void> konfirmasiPinjaman;
  final Function0<void> submit;
  final Stream<dynamic> documentPerjanjian;

  final Stream<int> stepStream;
  final Stream<String> noHpStream;
  final Stream<bool> checkPinjaman;
  final Stream<Map<String, dynamic>> dataPinjamanStream;
  final Stream<PenawaranPinjamanMessage?> messageReqOtp;
  final Stream<PenawaranPinjamanMessage?> message;
  final Stream<String?> otpError;
  final Stream<Map<String, dynamic>> responseData;

  PenawaranPinjamanBloc2._({
    required this.stepControl,
    required this.stepStream,
    required this.getPinjamanControl,
    required this.dataPinjamanStream,
    required this.checkPinjaman,
    required this.checkPinjamanControl,
    required this.submit,
    required this.message,
    required this.noHpStream,
    required this.otpControl,
    required this.otpControlError,
    required this.messageReqOtp,
    required this.konfirmasiPinjaman,
    required this.otpError,
    required this.responseData,
    required this.responseControl,
    required this.documentPerjanjian,
    required Function0<void> dispose,
  }) : super(dispose);

  factory PenawaranPinjamanBloc2(
    final GetAuthStateStreamUseCase getAuthState,
    final PenawaranPinjamanUseCase postPenawaran,
  ) {
    final stepController = BehaviorSubject<int>.seeded(1);
    final dataPinjamanController = BehaviorSubject<Map<String, dynamic>>();
    final checkPinjaman = BehaviorSubject<bool>.seeded(false);
    final otpController = BehaviorSubject<String>();
    final otpError = BehaviorSubject<String?>();
    final noHpController = BehaviorSubject<String>();
    final submitController = PublishSubject<void>();
    final messageReqOtp = BehaviorSubject<PenawaranPinjamanMessage?>();
    final responseController = BehaviorSubject<Map<String, dynamic>>();
    final documentPerjanjianController = BehaviorSubject<dynamic>();
    final authState = getAuthState();

    final ApiService apiService = ApiService(
      SimpleHttpClient(
        client: Platform.isIOS || Platform.isMacOS
            ? CupertinoClient.defaultSessionConfiguration()
            : http.Client(),
      ),
    );

    void getDocumentPerjanjian(String url) async {
      // final event = await authState$.first;
      // final token = event.orNull()!.userAndToken!.token.toString();
      print('get Document ${url}');
      Uri uri = Uri.parse(url);
      try {
        print('Response data: $uri');

        final response = await http.get(uri);
        if (response.statusCode == 200) {
          // Request was successful
          final responseData = response.body;

          documentPerjanjianController.add(responseData);
        } else {
          // Request failed
          print('Failed to fetch data. Status code: ${response.statusCode}');
          documentPerjanjianController
              .addError('Maaf Sepertinya ada yang salah');
        }
      } catch (e) {
        documentPerjanjianController.addError('Maaf Sepertinya ada yang salah');
        print('Error: $e');
      }
    }

    void getPinjaman(int idjaminan, int idproduk) async {
      final event = await authState.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      final noTelp = event.orNull()!.userAndToken!.user.tlpmobile.toString();
      noHpController.add(noTelp);
      try {
        final response = await apiService.getDetailPinjaman(
          token,
          idjaminan,
          idproduk,
        );
        getDocumentPerjanjian(response['syarat_ketentuan']);
        dataPinjamanController.add(response);
        print(
            'check detail pinjaman ${dataPinjamanController.value['jaminans']}');
      } catch (e) {
        dataPinjamanController.addError('Maaf Sepertinya terjadi Kesalahan');
      }
    }

    void konfirmasiPinjaman() async {
      // ...

      final event = await authState.first;
      final token = event.orNull()!.userAndToken!.token.toString();
      final pinjaman = dataPinjamanController.valueOrNull ?? {};

      // Making a network request using apiService
      final response = await apiService.reqOtpPenawaranPinjaman(
        token,
        pinjaman['jaminans']['idjaminan'],
      );

      // Parsing the response body
      final body = jsonDecode(response.body);

      // Handling the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
        await _analytics.logEvent(name: 'purchase', parameters: {
          'nilai_pinjaman': dataPinjamanController.value['jaminans']
              ['nilai_pinjaman'],
          'idjaminan': dataPinjamanController.value['jaminans']['idjaminan'],
          'idborrower': dataPinjamanController.value['jaminans']['idborrower'],
          'nama_produk': dataPinjamanController.value['jaminans']
              ['nama_produk'],
          'currency': 'IDR',
          'item_id': dataPinjamanController.value['jaminans']['idjaminan'],
          'item_name': dataPinjamanController.value['jaminans']['nama_produk'],
          'price': dataPinjamanController.value['jaminans']['nilai_pinjaman'],
          'value': dataPinjamanController.value['jaminans']['nilai_pinjaman'],
        });
        await Firebase.initializeApp();

        final firebaseApp = Firebase.app();

        final rtdb = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL:
                'https://danain-70baa-default-rtdb.asia-southeast1.firebasedatabase.app/');

        DatabaseReference reference =
            rtdb.reference().child('history_Purchase');
        await reference.push().set({
          'nilai_pinjaman': dataPinjamanController.value['jaminans']
              ['nilai_pinjaman'],
          'idjaminan': dataPinjamanController.value['jaminans']['idjaminan'],
          'idborrower': dataPinjamanController.value['jaminans']['idborrower'],
          'nama_produk': dataPinjamanController.value['jaminans']
              ['nama_produk'],
          'currency': 'IDR',
          'item_id': dataPinjamanController.value['jaminans']['idjaminan'],
          'item_name': dataPinjamanController.value['jaminans']['nama_produk'],
          'price': dataPinjamanController.value['jaminans']['nilai_pinjaman'],
          'value': dataPinjamanController.value['jaminans']['nilai_pinjaman'],
        });

        // Adding a success message to messageReqOtp
        messageReqOtp.add(const PenawaranPinjamanSuccessMessage());
      } else {
        // Adding an error message to messageReqOtp
        messageReqOtp.add(PenawaranPinjamanErrorMessage(body['message'], body));
      }
    }

    final credential = Rx.combineLatest2(
      dataPinjamanController.stream,
      otpController,
      (Map<String, dynamic> pinjaman, String otp) {
        return CredentialPenawaran(
          idproduk: pinjaman['pinjamans']['idproduk'],
          idjaminan: pinjaman['jaminans']['idjaminan'],
          otp: otp,
          idRekening: pinjaman['data_bank']['id_peminjam_rekening'],
          tujuanPinjaman: 'Konsumtif',
        );
      },
    );

    final submit = submitController.stream.share();
    final message = Rx.merge([
      submit
          .withLatestFrom(credential, (_, CredentialPenawaran cred) => cred)
          .exhaustMap(
            (credential) => postPenawaran(
              idRekening: credential.idRekening,
              idjaminan: credential.idjaminan,
              idproduk: credential.idproduk,
              otp: credential.otp,
              tujuanPinjaman: credential.tujuanPinjaman,
            ),
          )
          .map(_responseToMessage)
    ]);

    return PenawaranPinjamanBloc2._(
      stepControl: (int val) => stepController.add(val),
      checkPinjamanControl: (bool val) => checkPinjaman.add(val),
      checkPinjaman: checkPinjaman.stream,
      stepStream: stepController.stream,
      responseControl: (Map<String, dynamic> val) =>
          responseController.add(val),
      responseData: responseController.stream,
      otpControl: (String val) => otpController.add(val),
      otpError: otpError.stream,
      otpControlError: (String val) => otpError.add(val),
      getPinjamanControl: getPinjaman,
      dataPinjamanStream: dataPinjamanController.stream,
      submit: () => submitController.add(null),
      noHpStream: noHpController.stream,
      konfirmasiPinjaman: konfirmasiPinjaman,
      messageReqOtp: messageReqOtp.stream,
      documentPerjanjian: documentPerjanjianController.stream,
      message: message,
      dispose: () {
        stepController.close();
      },
    );
  }

  static PenawaranPinjamanMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const PenawaranPinjamanSuccessMessage(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : PenawaranPinjamanErrorMessage(appError.message!, appError.error!),
    );
  }
}

class CredentialPenawaran {
  final int idproduk;
  final int idjaminan;
  final String otp;
  final int idRekening;
  final String tujuanPinjaman;

  const CredentialPenawaran({
    required this.idproduk,
    required this.idjaminan,
    required this.otp,
    required this.idRekening,
    required this.tujuanPinjaman,
  });
}
