class Validator {
  Validator._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*/?,~."]).{8,}$',
  );

  static final RegExp _mobileRegExp = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
  static final RegExp _zipcodeRegExp = RegExp(r'^[0-9]{1,45}$');

  //r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'
  //r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidMobileNo(String mobile) {
    return _mobileRegExp.hasMatch(mobile);
  }

  static isValidZipcode(String zipcode) {
    return _zipcodeRegExp.hasMatch(zipcode);
  }

  static bool isValidMobile(String data) {
    if (data.trim().isNotEmpty) {
      if (data.trim().contains(".") || data.trim().contains("-"))
        return data.length == 10;
      else
        return true;
    }
    return false;
  }

  static bool isValidNumber(String data) {
    if (data.trim().isNotEmpty) {
      if (data.trim().contains(".") || data.trim().contains("-"))
        return data.length == 10;
      else
        return true;
    }
    return false;
  }

  static bool isValidText(String data) {
    return data.trim().isNotEmpty;
  }


  static bool isValidNull(Object data) {
    return data != null ? true : false;
  }

  static bool isValidUsername(String data) {
    if (data.trim().isNotEmpty) {
      if (data.trim().contains(".") || data.trim().contains("-"))
        return data.length == 8;
      else
        return true;
    }
    return false;
  }

  static String? validateEmail(dynamic value) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regExp = RegExp(pattern);
    var emptyResult = valueExists(value);
    if (emptyResult != null) {
      return emptyResult;
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  static String? valueExists(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Please fill this field';
    } else {
      return null;
    }
  }


  static String? validatePassword(dynamic value) {
    var regExp = _passwordRegExp;
    var emptyResult = valueExists(value);
    if (emptyResult != null) {
      return emptyResult;
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid password';
    } else {
      return null;
    }
  }
}
