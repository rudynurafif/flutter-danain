class Validator {
  Validator._();

  static const _emailRegExpString =
      r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  static final _emailRegex = RegExp(_emailRegExpString, caseSensitive: false);

  static bool isValidPassword(String password) => password.length >= 8;

  static bool isValidEmail(String email) => _emailRegex.hasMatch(email);

  static bool isValidUserName(String userName) => userName.length >= 3;

  static bool isValidNumber(int num) => num > 0;

  static bool isValidPhoneNumber(String num) => num.length >= 10;

  static bool isLessThan18YearsFromNow(DateTime date) {
    final currentDate = DateTime.now();
    final difference = currentDate.difference(date);
    final ageInYears = difference.inDays ~/ 365;

    return ageInYears < 18;
  }

  static bool isValidLowerCase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  static bool isValidLength(String? data, int length) {
    return data!.length == length;
  }

  static bool isValidUpperCase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  static bool isValidPasswordNumber(String password) {
    return password.contains(RegExp(r'\d'));
  }

  static bool isValidLengthPassWord(String password) {
    return password.length > 7;
  }

  static bool isValidPasswordRegis(String password) {
    return isValidLowerCase(password) &&
        isValidLengthPassWord(password) &&
        isValidUpperCase(password) &&
        isValidPasswordNumber(password);
  }

  static bool isValidPlat(String? p0) {
    final value = p0 ?? '';
    final List<String> val = value.split(' ');

    if (val.length < 3) {
      return false;
    }

    final val0 = val[0];
    final val1 = val[1];
    final val2 = val[2];
    print(val2);

    if (val0.length > 2 || val0.length < 1) {
      return false;
    }
    if (val1.length > 4 || val1.length < 1) {
      return false;
    }
    if (val2.length > 3 || val2.length < 1) {
      return false;
    }
    if (!val2.contains(RegExp(r'^[A-Za-z]*$'))) {
      return false;
    } else if (!val0.contains(RegExp(r'^[A-Za-z]*$'))) {
      return false;
    } else if (!val1.contains(RegExp(r'^[0-9]*$'))) {
      return false;
    } else {
      return true;
    }
  }
}
