import 'dart:async';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mytexts.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;
import 'package:number_display/number_display.dart';
import 'package:mfitness/model/services/core/themes.dart';
import 'package:url_launcher/url_launcher.dart';

EdgeInsets internalPadding(
  BuildContext context, {
  double? top,
  double? bottom,
  double? right,
  double? left,
}) {
  Sizes().heightSizeCalc(context);
  Sizes().widthSizeCalc(context);
  return EdgeInsets.only(
    top: top ?? Sizes.h15,
    bottom: bottom ?? Sizes.h15,
    right: right ?? Sizes.w20,
    left: left ?? Sizes.w20,
  );
}

resolveSizes(BuildContext context) {
  Sizes().heightSizeCalc(context);
  Sizes().widthSizeCalc(context);
}

Timer? timerModel;
void initializeTimer(BuildContext context) {
  if (timerModel != null) {
    timerModel!.cancel();
  }
  // setup action after 3 minutes
  timerModel = Timer(const Duration(minutes: 300), () {
    // navigatorKey.currentState!.pushNamed('/login');
  });
}

RoundedRectangleBorder bottomSheetShape() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(Sizes.w20),
      topLeft: Radius.circular(Sizes.w20),
    ),
  );
}

myLog({required String name, required var logContent}) {
  dev.log('my $name result ===> $logContent');
}

List<TextInputFormatter> textLimit(int limit) => [
  LengthLimitingTextInputFormatter(limit),
];

final displayNumber = createDisplay(
  length: 19,
  decimal: 2,
  decimalPoint: '.',
  roundingType: RoundingType.floor,
);
String moneyformatter(num amount, {String? currency = 'NGN'}) {
  return NumberFormat.simpleCurrency(
    name: currency,
    decimalDigits: 2,
  ).format(amount);
}

String stringInitials(String name, {bool doubleInitial = true}) {
  String trimName = name.trimRight();
  List stringList = trimName.split(' ');
  if (doubleInitial) {
    if (stringList.length > 1) {
      return '${stringList.first[0]}${stringList.last[0]}'.toUpperCase();
    } else {
      return '${stringList.first[0]}'.toUpperCase();
    }
  } else {
    return '${stringList.first[0]}'.toUpperCase();
  }
}

String stringDateFormatter(String dateString) {
  DateTime input = DateTime.tryParse(dateString)!;
  return '${DateFormat.d().format(input)} ${DateFormat.MMM().format(input)}, ${DateFormat.y().format(input)}';
}

String transactionDateFormatter(String dateString) {
  DateTime input = DateTime.tryParse(dateString)!;
  return '${DateFormat.MMM().format(input)} ${DateFormat.d().format(input)} ${DateFormat.y().format(input)} | ${DateFormat.jm().format(input)}';
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}

double stringToAmount(String amountString) =>
    double.tryParse(amountString.replaceAll(',', '')) ?? 0;

String dateformatterdash(DateTime input) {
  return '${DateFormat.y().format(input)}-${DateFormat.M().format(input).length == 1 ? '0${DateFormat.M().format(input)}' : DateFormat.M().format(input)}-${DateFormat.d().format(input).length == 1 ? '0${DateFormat.d().format(input)}' : DateFormat.d().format(input)}';
}

String dateformatter(DateTime input) {
  return DateFormat.yMMMd().format(input);
}

double currencyToNumberResolver(String text) {
  return double.tryParse(
    text.substring(1).replaceAll(',', '').replaceAll('-', ''),
  )!;
}

CurrencyTextInputFormatter formatCurrencyText() {
  return CurrencyTextInputFormatter.currency(
    locale: 'en',
    name: 'NGN',
    decimalDigits: 2,
    symbol: NumberFormat.simpleCurrency(name: 'NGN').currencySymbol,
  );
}

String jsonToGroupDate(String stringDate) {
  DateTime resolvedDate = DateTime.tryParse(stringDate)!;
  return DateTime(
    resolvedDate.year,
    resolvedDate.month,
    resolvedDate.day,
  ).toString();
}

DateTime stringToDateTime(String stringDate) {
  return DateTime.tryParse(stringDate) ?? DateTime.now();
}

String errorMessage(Map networkMap) {
  if (networkMap['message'] != null &&
      networkMap['message'].toString().trim().isNotEmpty) {
    return networkMap['message'].toString();
  } else if (networkMap['error'] != null &&
      networkMap['error'].toString().trim().isNotEmpty) {
    return networkMap['error'].toString();
  } else {
    return MyTexts.servererror;
  }
}

String numbershort(num number) {
  return NumberFormat.compact().format(number).toString();
}

DateTime jsonStringToDate(var stringDate) =>
    DateTime.tryParse(stringDate.toString()) ?? DateTime.now();
double jsonStringToDouble(var stringAmount) =>
    double.tryParse(stringAmount.toString()) ?? 0;

String resolvePhoneNumber(String userNumber) {
  if (userNumber.startsWith('0')) {
    return '+234${userNumber.substring(1)}';
  } else if (userNumber.startsWith('+234')) {
    return userNumber;
  } else {
    return '+234$userNumber';
  }
}

openURL(String link) async {
  Uri parsedLink = Uri.parse(link);
  try {
    launchUrl(parsedLink, mode: LaunchMode.externalApplication);
  } catch (e) {
    // if (context.mounted) {
    //   snackalert(context, 'Unable to open link. Please try again');
    // }
  }
}

myPrint(var data) {
  // print('<<<<<<<<<< print function >>>>>>>>>>> $data');
}
Color rgbaStringToColor(String rgba) {
  final regex = RegExp(r'rgba?\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)');
  final match = regex.firstMatch(rgba);
  try {
    if (match != null) {
      final r = int.parse(match.group(1)!);
      final g = int.parse(match.group(2)!);
      final b = int.parse(match.group(3)!);
      final a = double.parse(match.group(4)!);
      return Color.fromRGBO(r, g, b, a);
    } else {
      return Colors.black;
    }
  } catch (e) {
    myLog(name: 'error rgbaStringToColor', logContent: e);
    return Colors.black;
  }
}

Color parseRgba(String rgba) {
  final m = RegExp(
    r'rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)',
  ).firstMatch(rgba);
  if (m == null) return Colors.black;

  final r = int.parse(m.group(1)!);
  final g = int.parse(m.group(2)!);
  final b = int.parse(m.group(3)!);
  final a = double.parse(m.group(4) ?? '255'); // 0-255 or 0-1

  // if alpha > 1  treat it as 0-255 and scale to 0-1
  final opacity = a > 1 ? a / 255.0 : a;

  return Color.fromRGBO(r, g, b, opacity);
}

Route animateRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

bool isDarkMode() {
  return themeClass.theme == ThemeMode.dark;
}

Color darkModeColor({
  Color lightMode = Colors.black,
  Color? darkMode = Colors.white,
}) {
  return isDarkMode() ? darkMode! : lightMode;
}

String numberFormat(num number) => NumberFormat('#,###').format(number);

ThemeData datePickerTheme(BuildContext context) => Theme.of(context).copyWith(
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    primary: myColors.primaryColor, // Selected date background
    onPrimary: Colors.black, // Selected date text
    surface: Colors.black, // Calendar background
    onSurface: Colors.white, // Calendar text
  ),
);
String separateAndCapitalize(String input) {
  // Use RegExp to split the string at each capital letter
  final RegExp exp = RegExp(r'(?=[A-Z])|_');

  // Split the string at each capital letter
  List<String> words = input.split(exp);

  // Capitalize the first letter of each word
  String result = words
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');

  return result;
}

// String pickedDateFormat(DateTime date) =>
//     '${date.day} ${DateFormat('MMMM').format(date)} ${date.year}';
