import 'package:intl/intl.dart';

String rupiahFormat(dynamic number) {
  return NumberFormat.currency(symbol: 'Rp ', locale: 'id_ID', decimalDigits: 0)
      .format(number)
      .replaceAll(',', '.');
}

String rupiahFormat2(dynamic number) {
  return NumberFormat.currency(symbol: '', locale: 'id_ID', decimalDigits: 0)
      .format(number)
      .replaceAll(',', '.');
}

String rupiahFormat3(dynamic number) {
  return NumberFormat.currency(symbol: 'Rp ', locale: 'id_ID', decimalDigits: 2)
      .format(number)
      .replaceAll('.', '.');
}

String rupiahFormatNum(num number) {
  return NumberFormat.currency(symbol: 'Rp ', locale: 'id_ID', decimalDigits: 0)
      .format(number)
      .replaceAll(',', '.');
}
