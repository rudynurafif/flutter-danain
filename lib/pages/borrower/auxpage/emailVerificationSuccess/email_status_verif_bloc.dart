import 'package:disposebag/disposebag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

import '../../../../domain/models/app_error.dart';
import '../../../../domain/usecases/get_beranda_user_use_case.dart';
import '../../../../utils/utils.dart';

class EmailStatusVerifBloc extends DisposeCallbackBaseBloc {
  final Function0<void> setBeranda;
  final Stream<dynamic> messageBeranda$;
  EmailStatusVerifBloc._({
    required this.messageBeranda$,
    required this.setBeranda,
    required Function0<void> dispose,
  }) : super(dispose);

  factory EmailStatusVerifBloc(
    final GetBerandaUserUseCase getBeranda,
  ) {
    final setBerandas = PublishSubject<void>();
    final checkBerandaMessage$ = setBerandas
        .debug(identifier: 'checkBeranda masuk [1]', log: debugPrint)
        .exhaustMap((_) => getBeranda())
        .asBroadcastStream();
    final messageBeranda$ =
        Rx.merge([checkBerandaMessage$]).whereNotNull().publish();
    return EmailStatusVerifBloc._(
      setBeranda: () => setBerandas.add(null),
      messageBeranda$: messageBeranda$,
      dispose: DisposeBag([
        messageBeranda$.connect(),
      ]).dispose,
    );
  }
}
