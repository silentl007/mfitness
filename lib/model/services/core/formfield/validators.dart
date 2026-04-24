import 'package:flutter/services.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mytexts.dart';

class FormValidators {
  static String? isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) return MyTexts.errorText;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    return emailRegex.hasMatch(email) ? null : 'Invalid email!';
  }

  static String? isFieldEmpty(String? text) {
    if (text == null || text.trim().isEmpty) return MyTexts.errorText;
    return null;
  }

  static String? enoughMoney(String? text) {
    if (text == null || text.trim().isEmpty) {
      return MyTexts.errorText;
    } else if (currencyToNumberResolver(text) > 0) {
      return 'Insufficient wallet balance';
    }
    return null;
  }

  static String? penntag(String? text) {
    if (text == null || text.trim().isEmpty) {
      return MyTexts.errorText;
    } else if (text.length != 9) {
      return 'Incomplete PennTag';
    }
    return null;
  }

  static String? bankAccount(String? text) {
    if (text == null || text.trim().isEmpty) {
      return MyTexts.errorText;
    } else if (text.length != 10) {
      return 'Incomplete account number';
    }
    return null;
  }

  static String? isNumber(String? text) {
    if (text == null || text.trim().isEmpty) {
      return MyTexts.errorText;
    } else if (num.tryParse(text) == null) {
      return 'Invalid number';
    }

    return null;
  }

  static String? minimumKG(String? text) {
    if (text == null || text.trim().isEmpty) {
      return MyTexts.errorText;
    } else if (num.tryParse(text) == null) {
      return 'Invalid number';
    } else if (double.tryParse(text)! < 5) {
      return 'Minimum required KG to recycle is 5KG';
    }
    return null;
  }

  static String? minimumPlastics(String? text) {
    if (text == null || text.trim().isEmpty) {
      return MyTexts.errorText;
    } else if (num.tryParse(text) == null) {
      return 'Invalid number';
    } else if (double.tryParse(text)! < 250) {
      return 'Minimum required number of plastics to recycle is 250';
    }
    return null;
  }

  static String? isPasswordValid(String? password) {
    if (password == null || password.trim().isEmpty) {
      return MyTexts.errorText;
    } else if (password.length < 8) {
      return 'Minimum length of 8 characters';
    } else if (!password.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Must contain at least one letter';
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Must contain at least one number';
    } else if (!password.contains(RegExp(r'[-!@#$%^&*(),.?":{}|<>_]'))) {
      return 'Must contain at least one special character';
    }

    return null;
  }

  static String? isPhoneNumberValid(String? phoneNumber) {
    final RegExp regex = RegExp(r'^(\+234|0)?[789]\d{9}$');

    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return MyTexts.errorText;
    } else if (!regex.hasMatch(phoneNumber)) {
      return 'Invalid phone number';
    } else {
      return null;
    }
  }

  static String? noValidation(String? phoneNumber) {
    return null;
  }
}

class KeyBoardText {
  static TextInputType numbers() =>
      const TextInputType.numberWithOptions(decimal: false);
}
