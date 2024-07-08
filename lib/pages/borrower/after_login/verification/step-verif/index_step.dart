import 'dart:async';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/step_ktp/step_1_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/step_selfie/step_2_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/step_data_pribadi/step_3_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/step_data_pribadi/step_4_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/verif_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/verif_state.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/verification_complete_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/loading/loading_payung.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class IndexStepPage extends StatefulWidget {
  static const routeName = '/index_step_verification';
  const IndexStepPage({super.key});

  @override
  State<IndexStepPage> createState() => _IndexStepPageState();
}

class _IndexStepPageState extends State<IndexStepPage>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final _stepBloc = StepVerifBloc();

  List<String> currentTitle = [
    'Foto KTP',
    'Foto Selfie',
    'Data Pribadi',
    'Data Alamat',
    ''
  ];

  bool isLoading = true;

  @override
  void dispose() {
    _stepBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _stepBloc.initGetMasterData();
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => _stepBloc.messageStream)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const LoadingDanain();
    } else {
      return StreamBuilder<int>(
        stream: _stepBloc.currentStep,
        builder: (context, snapshot) {
          final data = snapshot.data ?? 0;
          return Scaffold(
            appBar: appBarIndex(context, data),
            body: WillPopScope(
              child: _bodyBuilder(context, data),
              // child: Step3Verif(stepBloc: _stepBloc),
              onWillPop: () async {
                data == 0 ? Navigator.pop(context) : _stepBloc.prevStep();
                return false;
              },
            ),
          );
        },
      );
    }
  }

  Stream<void> handleMessage(message) async* {
    if (message is VerificationSuccess) {
      unawaited(Navigator.pushNamedAndRemoveUntil(
        context,
        VerificationCompletePage.routeName,
        (route) => false,
      ));
    }

    if (message is VerificationError) {
      context.showSnackBarError(message.message);
    }
  }

  Widget _bodyBuilder(BuildContext context, int data) {
    switch (data) {
      case 0:
        return Step1Verif(stepBloc: _stepBloc);
      case 1:
        return Step2Verif(stepBloc: _stepBloc);
      case 2:
        return Step3Verif(stepBloc: _stepBloc);
      case 3:
        return Step4Verif(stepBloc: _stepBloc);
      default:
        return Container();
    }
  }

  PreferredSizeWidget appBarIndex(
    BuildContext context,
    int data,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          data == 0 ? Navigator.pop(context) : _stepBloc.prevStep();
        },
        icon: SvgPicture.asset('assets/images/icons/back.svg'),
      ),
      title: Text(
        currentTitle[data],
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      surfaceTintColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Visibility(
          visible: data == 4 ? false : true,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StepProgressIndicator(
              totalSteps: 5,
              currentStep: data + 1,
              selectedColor: HexColor(primaryColorHex),
              unselectedColor: HexColor('#EDEDED'),
            ),
          ),
        ),
      ),
    );
  }
}
