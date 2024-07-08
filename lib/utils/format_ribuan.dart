import 'package:intl/intl.dart';

String formatRibuan(String numberString) {
  try {
    final number = num.tryParse(numberString);

    final formatter = NumberFormat('#,###');
    return formatter.format(number).replaceAll(',', '.');
  } catch (e) {
    return '';
  }
}
