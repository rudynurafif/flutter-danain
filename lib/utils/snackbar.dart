import 'package:flutter/material.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:hexcolor/hexcolor.dart';

extension ShowSnackBarBuildContextExtension on BuildContext {
  void showSnackBar(
    String message, [
    Duration duration = const Duration(seconds: 1),
  ]) {
    final messengerState = ScaffoldMessenger.of(this);
    messengerState.hideCurrentSnackBar();
    messengerState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  void showSnackBarError(
    String message, [
    Duration duration = const Duration(seconds: 1),
  ]) {
    final messengerState = ScaffoldMessenger.of(this);
    messengerState.hideCurrentSnackBar();
    messengerState.showSnackBar(
      SnackBar(
        content: Subtitle2(
          text: message,
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.fixed,
        duration: duration,
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSnackBarSuccess(
    String message, [
    Duration duration = const Duration(seconds: 1),
  ]) {
    final messengerState = ScaffoldMessenger.of(this);

    messengerState.hideCurrentSnackBar();

    getUserStatus().then((status) {
      messengerState.showSnackBar(
        SnackBar(
          content: Subtitle2(
            text: message,
            color: Colors.white,
          ),
          duration: duration,
          backgroundColor:
              status == 1 ? HexColor(lenderColor) : HexColor(primaryColorHex),
        ),
      );
    });
  }

  void hideCurrentSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
}
