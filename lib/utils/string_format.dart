import 'package:intl/intl.dart';

String maskCreditCard(String cardNumber) {
  cardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

  if (cardNumber.length <= 3) {
    return cardNumber;
  }

  final maskedPart = '*' * (cardNumber.length - 4);
  final visiblePart = cardNumber.substring(cardNumber.length - 4);

  final formattedMasked = maskedPart.replaceAllMapped(
      RegExp(r'.{4}'), (match) => '${match.group(0)} ');

  return '$formattedMasked$visiblePart';
}

String formatBungaDanain(num bunga) {
  final double percentage = (bunga * 100).truncateToDouble() / 100;
  return percentage % 1 == 0
      ? '${percentage.toInt()} % p.a'
      : '${percentage.toStringAsFixed(2)} % p.a';
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  }

  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

String shortenText(String text) {
  if (text.length <= 7) {
    return text;
  } else {
    return '${text.substring(0, 7)}...';
  }
}

String shortenTextCustom(String text, int longText) {
  if (text.length <= longText) {
    return text;
  } else {
    return '${text.substring(0, longText)}...';
  }
}

String shortenTextReal(String text, int longText) {
  if (text.length <= longText) {
    return text;
  } else {
    return text.substring(0, longText);
  }
}

String shortenStringDynamic(String input, int count) {
  if (input.length > count) {
    return '${input.substring(0, count)}...';
  } else {
    return input;
  }
}

String dateFormat(String inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate).toLocal();
    final formatter = DateFormat('d MMMM yyyy', 'id_ID');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String dateFormatComplete(String inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate).toLocal();
    final formatter = DateFormat('d MMMM yyyy', 'id_ID');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String dateFormatComplete2(String inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate).toLocal();
    final formatter = DateFormat('d MMMM yyyy, HH:mm', 'id_ID');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String dateSurvey(String inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate).toLocal();
    final formatter = DateFormat('d/M/yyyy', 'id_ID');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String timeSurvey(String inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate).toLocal();
    final formatter = DateFormat('HH:mm', 'id_ID');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String dateFormatTime(String inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate).toLocal();
    final formatter = DateFormat('d MMM yyyy HH.mm', 'id_ID');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String dateTimeModified(String inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate).toLocal();
    final formatter = DateFormat('dd MMM yyyy, HH:mm z', 'id_ID');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String formatDateFull(String date) {
  try {
    final parsedDate = DateTime.parse(date).toLocal();
    final outputFormat = DateFormat('EEEE, d MMMM y, HH:mm', 'id_ID');

    final formattedDate = outputFormat.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String formatDateFull2(String date) {
  try {
    final parsedDate =
        DateTime.parse(date.replaceAll('-', '').replaceAll(':', '')).toLocal();
    final outputFormat = DateFormat('EEEE, d MMM y,  HH:mm', 'id_ID');

    final formattedDate = outputFormat.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String formatDayInd(String date) {
  try {
    final parsedDate = DateTime.parse(date).toLocal();
    final outputFormat = DateFormat('EEEE', 'id_ID');

    final formattedDate = outputFormat.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String formatDayDate(String date) {
  try {
    final parsedDate = DateTime.parse(date).toLocal();
    final outputFormat = DateFormat('EEEE, d MMMM y', 'id_ID');

    final formattedDate = outputFormat.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String formatDateNormal(String date) {
  try {
    final parsedDate = DateTime.parse(date).toLocal();
    final outputFormat = DateFormat('MM-dd-yyyy HH:mm:ss', 'id_ID');

    final formattedDate = outputFormat.format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Tanggal tidak valid';
  }
}

String formatDateFullWithHour(String date) {
  try {
    final parsedDate = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUtc(date);
    final outputFormat = DateFormat('EEEE, d MMMM y • HH:mm', 'id_ID');
    return outputFormat.format(parsedDate);
  } catch (e) {
    print('Error parsing date: $e');
    return 'Invalid date'; // Handle error gracefully
  }
}
