import 'dart:async';

import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/simulasi_pinjaman_use_case.dart';
import 'package:flutter_danain/pages/borrower/simulasi/pinjaman/simulasi_pinjaman_state.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/utils/validators.dart';

class SimulasiPinjamanBloc extends DisposeCallbackBaseBloc {
  //input Function

  final Function1<int, void> gramChange;
  final Function1<int, void> karatChange;
  final Function0<void> postPinjaman;
  final Function1<int, void> nilaiPinjamanChange;
  final Function1<int, void> jangkaWaktuChange;

  //stream

  final Stream<SimulasiPinjamanMessage> message$;
  final Stream<String?> gramError$;
  final Stream<String?> karatError$;
  final Stream<String?> jangkaWaktuError$;
  final Stream<bool> isValids$;

  SimulasiPinjamanBloc._({
    required Function0<void> dispose,
    required this.gramChange,
    required this.karatError$,
    required this.karatChange,
    required this.gramError$,
    required this.message$,
    required this.jangkaWaktuError$,
    required this.isValids$,
    required this.nilaiPinjamanChange,
    required this.jangkaWaktuChange,
    required this.postPinjaman,
  }) : super(dispose);

  factory SimulasiPinjamanBloc(final SimulasiPinjamanUseCase simulasiPinjam) {
    final gramController = PublishSubject<int>();
    final karatController = PublishSubject<int>();
    final nilaiPengajuanController = PublishSubject<int>();
    final jangkaWaktuController = PublishSubject<int>();
    final postPinjamanController = PublishSubject<void>();
    final controllers = {
      gramController,
      karatController,
      nilaiPengajuanController,
      jangkaWaktuController,
      postPinjamanController,
    };

    final credential$ = Rx.combineLatest4(
        gramController.stream,
        karatController.stream,
        jangkaWaktuController.stream
            .startWith(1), // Convert to int? with a default value of 0
        nilaiPengajuanController.stream.startWith(0),
        (
          int gram,
          int karat,
          int? jangkaWaktu,
          int? nilaiPinjaman,
        ) =>
            CredentialSimulasiPinjaman(
              gram: gram,
              karat: karat,
              jangkaWaktu: jangkaWaktu,
              nilaiPinjaman: nilaiPinjaman,
            ));

    jangkaWaktuController.stream.listen((event) {
      print('check jangka');
      print(event);
    });

    final gramValid$ = gramController.stream
        .map((value) => value)
        .map((parsedValue) =>
            parsedValue != null && Validator.isValidNumber(parsedValue))
        .startWith(false); // Start with an initial value of false

    final karatValid$ = karatController.stream
        .map((value) => value)
        .map((parsedValue) =>
            parsedValue != null && Validator.isValidNumber(parsedValue))
        .startWith(false); // Start with an initial value of false

    final isValidSubmit$ = Rx.combineLatest2(
      gramValid$,
      karatValid$,
      (bool isValidGram, bool isValidKarat) => isValidGram && isValidKarat,
    ).shareValueSeeded(false);

    final submit$ = postPinjamanController.stream
        .withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid)
        .share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential$, (_, CredentialSimulasiPinjaman c) => c)
          .exhaustMap(
            (credential) => simulasiPinjam(
              gram: credential.gram,
              karat: credential.karat,
              jangkaWaktu: credential.jangkaWaktu,
              nilaiPinjaman: credential.nilaiPinjaman,
            ).map(_responseToMessage),
          ),
      submit$.where((isValid) => !isValid).map(
            (_) => const InvalidInformationMessage(),
          )
    ]).whereNotNull().share();

    final gramError$ = gramController.stream
        .map((gram) {
          if (Validator.isValidNumber(gram)) return null;
          return 'Gram is required';
        })
        .distinct()
        .share();

    final karatError$ = karatController.stream
        .map((karat) {
          if (Validator.isValidNumber(karat)) return null;
          return 'karat is required';
        })
        .distinct()
        .share();

    final jangkaWaktuError$ = jangkaWaktuController.stream
        .map((jangka) {
          if (Validator.isValidNumber(jangka)) return null;
          return 'Jangka Waktu is required';
        })
        .distinct()
        .share();

    final subscriptions = <String, Stream>{
      'message': message$,
    }.debug();

    return SimulasiPinjamanBloc._(
      dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
      nilaiPinjamanChange: nilaiPengajuanController.add,
      jangkaWaktuChange: jangkaWaktuController.add,
      message$: message$,
      gramError$: gramError$,
      karatError$: karatError$,
      isValids$: submit$,
      jangkaWaktuError$: jangkaWaktuError$,
      postPinjaman: () => postPinjamanController.add(null),
      gramChange: gramController.add,
      karatChange: (int value) => karatController.add(value),
    );
  }

  static SimulasiPinjamanMessage? _responseToMessage(UnitResult result) {
    return result.fold(
      ifRight: (_) => const SimulasiPinjamanSuccess(),
      ifLeft: (appError) => appError.isCancellation
          ? null
          : SimulasiPinjamanError(appError.message!, appError.error!),
    );
  }
}
