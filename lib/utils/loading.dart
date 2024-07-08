import 'package:flutter/material.dart';

extension ShowLoading on BuildContext {
  static late BuildContext ctx;
  Future<void> showLoading() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (c) {
        ctx = c;
        return WillPopScope(
          onWillPop: () async => false,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Image.asset('assets/images/icons/loading_danain.png'),
            ),
          ),
        );
      },
    );
  }

  void dismiss() {
    try {
      Navigator.pop(ctx);
    } catch (_) {}
  }
}
