// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/layout/appBar_previousTitle.dart';
import 'package:flutter_danain/pages/borrower/after_login/case_privy/case_privy_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:hexcolor/hexcolor.dart';

import '../pengajuan_pinjaman/pengajuan_pinjaman_page.dart';
import 'case_privy_borrower_bloc.dart';
import 'case_privy_borrower_state.dart';

class CasePrivyBorrower extends StatefulWidget {
  static const routeName = '/case_privy_borrower';
  final String? caseCode;
  final List<dynamic>? dataUpdate;
  const CasePrivyBorrower({super.key, this.caseCode, this.dataUpdate});

  @override
  State<CasePrivyBorrower> createState() => _CasePrivyBorrowerState();
}

class _CasePrivyBorrowerState extends State<CasePrivyBorrower>
    with DisposeBagMixin, DidChangeDependenciesStream {
  final caseBloc = CasePrivyBorrowerBloc();
  List<String> mustUploadData = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as CasePrivyBorrower?;
    if (args != null) {
      caseBloc.initGetCase(args.caseCode!, args.dataUpdate!);
    }
  }

  @override
  void initState() {
    super.initState();
    print('mustupload 2 ${widget.dataUpdate}');
    caseBloc.uploadController.add((widget.dataUpdate as List<String>?) ?? []);

    didChangeDependencies$
        .exhaustMap((_) => caseBloc.casePrivyMessage)
        .exhaustMap(handleMessage)
        .collect()
        .disposedBy(bag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> mustUploadList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: previousTitle(context, 'Pembaruan Data'),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: caseBloc.casePrivyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              Map<String, dynamic> dataCase = snapshot.data!;

              return bodyContent(context, dataCase);
            } else {
              return Container();
            }
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            FutureBuilder<int?>(
              future: getUserStatus(),
              builder: (context, snapshot) {
                int user = snapshot.data ?? 1;
                return StreamBuilder<bool>(
                  stream: caseBloc.isValidButton,
                  builder: (context, snapshot) {
                    bool isValid = snapshot.data ?? false;
                    return Button1(
                      btntext: 'Kirim',
                      color: isValid ? null : Colors.grey,
                      action: isValid
                          ? () {
                              caseBloc.postPrivy(user);
                            }
                          : null,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<void> handleMessage(message) async* {
    if (message is PrivyCaseBorrowerSuccess) {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (route) => false,
      );
    } else if (message is PrivyCaseError) {
      context.showSnackBarError(message.message);
    } else {
      context.showSnackBarError('Invalid information');
    }
  }

  Widget bodyContent(BuildContext context, Map<String, dynamic> privyCase) {
    List<String>? mustUpload = caseBloc.uploadController.valueOrNull;
    print('mustupload $privyCase');
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Headline3500(text: 'Unggah ${privyCase['txtUpload']}'),
          SizedBox(height: 8),
          Subtitle2(text: privyCase['word']),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: mustUpload!.length,
              itemBuilder: (BuildContext context, int index) {
                var dataUpload = mustUpload[index];
                Stream<File?> stream = caseBloc.supportStream;
                BehaviorSubject<File?> _controller = caseBloc.supportController;
                if (dataUpload == "KTP") {
                  stream = caseBloc.ktpStream;
                  _controller = caseBloc.ktpController;
                } else if (dataUpload == "Selfie") {
                  stream = caseBloc.selfieStream;
                  _controller = caseBloc.selfieController;
                }

                return StreamBuilder<File?>(
                  stream: stream,
                  builder: (context, snapshot) {
                    return contentUpload(
                      context,
                      dataUpload,
                      snapshot.hasData,
                      () {
                        openBottom(dataUpload, _controller);
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget contentUpload(
    BuildContext context,
    String contentTitle,
    bool isHave,
    VoidCallback action,
  ) {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: HexColor('#DDDDDD'),
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titlenDesc('Ambil Foto $contentTitle'),
            checkCircle(isHave)
          ],
        ),
      ),
    );
  }

  void openBottom(String type, BehaviorSubject<File?> controllerBloc) {
    Widget modalContent = ktpPanduanWidget(context, () {});
    VoidCallback action = () {
      Navigator.pop(context);
      openCam(type, controllerBloc);
    };
    switch (type) {
      case 'SIM':
        modalContent = panduanSimWidget(context, action);
        break;
      case 'KK':
        modalContent = panduanKkWidget(context, action);
        break;
      case 'Selfie':
        modalContent = panduanSelfieWidget(context, action);
        break;
      case 'Selfie Dengan KTP':
        modalContent = selfieKtpPanduanWidget(context, action);
        break;
      default:
        modalContent = ktpPanduanWidget(context, action);
        break;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => modalContent,
    );
  }

  void openCam(String type, BehaviorSubject<File?> controllerBloc) async {
    final cameras = await availableCameras();
    var firstCamera = cameras.first;

    if (type == 'Selfie' || type == 'Selfie Dengan KTP') {
      firstCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
    }

    final picturePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraWidget(
          camera: firstCamera,
          typeCamera: type,
        ),
      ),
    );

    if (picturePath != null) {
      unawaited(
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (context) {
            return PreviewImage(
              filePath: picturePath,
              type: type,
              retakeAction: () async {
                try {
                  final file = File(picturePath);
                  if (await file.exists()) {
                    await file.delete();
                    print('File deleted');
                  } else {
                    print('File not found');
                  }
                } catch (e) {
                  print('Error deleting file: $e');
                }
                Navigator.pop(context);
                openCam(type, controllerBloc);
              },
              takeAction: () {
                if (controllerBloc.hasValue) {
                  String filePath = controllerBloc.value!.path;
                  mustUploadList.removeWhere((item) => item == filePath);
                }
                controllerBloc.sink.add(File(picturePath));
                mustUploadList.add(picturePath);
                caseBloc.fileLengthController.add(mustUploadList);
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    }
  }

  Widget checkCircle(bool data) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: data ? HexColor(primaryColorHex) : Colors.transparent,
        ),
        child: data
            ? Center(
                child: Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
