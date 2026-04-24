import 'package:mfitness/model/services/core/enums.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/snackwidget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class MyWidgets {
  appbar({
    required BuildContext context,
    String? titletext,
    Color? color,
    Widget? action,
    bool showBack = true,
  }) {
    return AppBar(
      // backgroundColor: color ?? Colors.white,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      title: titletext != null
          ? Text(
              titletext,
              style: MyDecor().textstyle(
                // fontcolor: Colors.black,
                fontweight: FontWeight.w700,
                fontsize: Sizes.w20,
              ),
            )
          : null,
      leading: showBack
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: Sizes.w18,
              ),
            )
          : Container(),
      actions: [if (action != null) action],
    );
  }

  drawerAppbar({required BuildContext context, String? title}) {
    return AppBar(
      backgroundColor: myColors.appBar,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
      title: title == null
          ? null
          : Text(
              title,
              style: MyDecor().textstyle(
                fontsize: Sizes.w18,
                fontweight: FontWeight.w500,
                fontcolor: Colors.white,
              ),
            ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {
            customdrawerScaffold.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }

  Widget button({
    required BuildContext context,
    required Function proceed,
    bool useIcon = false,
    Color? buttonColor,
    Color? buttonTextColor,
    Color? bordercolor,
    String? buttonText,
    double? buttonTextSize,
    double? curve,
    double? boxHeight,
    double? boxWidth,
    double? iconTextSpacing,
    bool? useDefaultStyle,
    Widget? buttonTextIcon,
  }) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    Widget textWidget = Text(
      buttonText ?? 'Proceed',
      textScaler: TextScaler.linear(textScale),
      style: useDefaultStyle == true
          ? TextStyle(
              fontSize: buttonTextSize ?? Sizes.w18,
              color: buttonTextColor ?? Colors.black,
              fontWeight: FontWeight.w500,
            )
          : MyDecor().textstyle(
              fontsize: buttonTextSize ?? Sizes.w18,
              fontcolor: buttonTextColor ?? Colors.black,
              fontweight: FontWeight.w500,
            ),
    );
    return Center(
      child: SizedBox(
        height: boxHeight ?? Sizes.h50,
        width: boxWidth ?? double.infinity,
        child: ElevatedButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            proceed();
          },
          style: MyDecor().buttonDecor(
            context: context,
            bordercurver: curve ?? Sizes.w10,
            buttoncolor: buttonColor ?? myColors.primaryColor,
            bordercolor: bordercolor ?? buttonColor ?? myColors.primaryColor,
          ),
          child: useIcon
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonTextIcon!,
                    customhorizontal(width: iconTextSpacing ?? Sizes.w15),
                    textWidget,
                  ],
                )
              : textWidget,
        ),
      ),
    );
  }

  Widget pageTitleandDescription(
    String title,
    String desc, {
    CrossAxisAlignment crossAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAlignment,
      children: [
        Text(
          title,
          style: MyDecor().textstyle(
            fontsize: Sizes.w25,
            fontweight: FontWeight.w700,
            fontcolor: myColors.primaryColor,
          ),
        ),
        customDivider(height: Sizes.h10),
        Text(
          desc,
          textAlign: TextAlign.left,
          style: MyDecor().textstyle(
            fontsize: Sizes.w18,
            sentenceSpace: 1.3,
            fontcolor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget formText(String text, {bool showRequired = true}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: MyDecor().textstyle(
          fontsize: Sizes.w15,
          fontweight: FontWeight.w500,
          fontcolor: myColors.formTextColor,
        ),
        children: [
          if (showRequired)
            TextSpan(
              text: ' *',
              style: MyDecor().textstyle(fontcolor: Colors.red),
            ),
        ],
      ),
    );
  }
}

Widget separator({Color? color}) => Container(
  width: double.infinity,
  height: 1,
  color: color ?? Colors.grey[200],
);

Widget customDivider({double? height, Color? color, double? thickness}) {
  return SizedBox(height: height ?? 1);
}

Widget customhorizontal({double? width}) {
  return SizedBox(width: width ?? 1);
}

networkfeedback(BuildContext context, String info) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pop(context);
    snackalert(context, info);
  });
}

Future<T?> bottomSheet<T>({
  required BuildContext context,
  required Widget body,
  bool isdismissble = true,
  Color? sheetColor,
  bool showTitle = true,
  String title = '',
  bool showClose = true,
  bool enableDrag = true,
  double? height,
  bool? middleTitle = true,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: sheetColor ?? Colors.black,
    isScrollControlled: true,
    isDismissible: isdismissble,
    enableDrag: enableDrag,
    shape: bottomSheetShape(),
    builder: (context) => SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: showTitle
            ? Padding(
                padding: internalPadding(context),
                child: SizedBox(
                  height: height ?? Sizes.h300,
                  child: Column(
                    children: [
                      bottomSheetTop(
                        context: context,
                        title: title,
                        showClose: showClose,
                        fontSize: fontSize,
                        middleTitle: middleTitle,
                        fontWeight: fontWeight,
                      ),
                      Expanded(child: body),
                    ],
                  ),
                ),
              )
            : body,
      ),
    ),
  );
}

bottomSheetTop({
  required BuildContext context,
  required String title,
  bool? middleTitle = true,
  bool showClose = true,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return Column(
    children: [
      customDivider(height: Sizes.h10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (middleTitle == true) Container(),
          Text(
            title,
            style: MyDecor().textstyle(
              fontsize: fontSize ?? Sizes.w18,
              fontweight: fontWeight ?? FontWeight.bold,
            ),
          ),
          showClose ? circleClose(context) : Container(),
        ],
      ),
    ],
  );
}

Widget circleClose(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      height: Sizes.h30,
      width: Sizes.w40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Icon(Icons.close, size: Sizes.w15, color: Colors.black),
      ),
    ),
  );
}

Widget pageTitle(String text) => Center(
  child: textWidget(text, fontweight: FontWeight.w700, fontsize: Sizes.w22),
);

Widget textWidget(
  String text, {
  Color? fontcolor,
  double? fontsize,
  FontWeight? fontweight,
  double? letterspace,
  double? sentenceSpace,
  bool useDefaultFont = false,
  bool underline = false,
  int? maxLines,
  TextAlign? textAlign,
  TextOverflow? textOverflow,
}) => Text(
  text,
  maxLines: maxLines,
  textAlign: textAlign,
  overflow: textOverflow,
  style: MyDecor().textstyle(
    fontcolor: fontcolor,
    fontsize: fontsize ?? Sizes.w15,
    fontweight: fontweight,
    letterspace: letterspace,
    sentenceSpace: sentenceSpace,
    useDefaultFont: useDefaultFont,
    underline: underline,
  ),
);

Widget futureLoading({double? iconSize}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SpinKitWanderingCubes(color: myColors.primaryColor, size: iconSize ?? 30),
      customDivider(height: Sizes.h25),
      Text(
        'please wait ...',
        style: MyDecor().textstyle(
          fontcolor: Colors.black,
          fontsize: Sizes.w15,
        ),
      ),
    ],
  );
}

Widget networkfailed(
  BuildContext context,
  Function retry, {
  String? errorMessage,
  bool? showButton = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Text(
          errorMessage ?? 'Fetching content failed',
          textAlign: TextAlign.center,
          style: MyDecor().textstyle(),
        ),
      ),
      customDivider(height: Sizes.h10),
      if (showButton == true)
        GestureDetector(
          onTap: () {
            retry();
          },
          child: Container(
            height: 40,
            width: 100,
            decoration: MyDecor().container(
              containerColor: Colors.red,
              curve: 10,
            ),
            child: Center(
              child: Text(
                'Retry',
                style: MyDecor().textstyle(fontcolor: Colors.white),
              ),
            ),
          ),
        ),
    ],
  );
}

snackalert(
  BuildContext context,
  String message, {
  Color? snackColor,
  String? title,
  SnackType type = SnackType.failure,
}) {
  if (type == SnackType.failure) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SnackMessageWidget(
        message: message,
        type: type,
        title: type == SnackType.failure
            ? 'Process Failed'
            : 'Process Completed',
      ),
    );
  } else {
    flushbar = Flushbar(
      messageText: SnackMessageWidget(
        message: message,
        type: type,
        title: type == SnackType.failure
            ? 'Process Failed'
            : 'Process Completed',
      ),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 10),
      padding: const EdgeInsets.all(10),
    );
    flushbar.show(context);
  }
}

loadingDiag() {
  return PopScope(
    canPop: false,
    child: Container(
      color: Colors.black.withOpacity(.7),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.symmetric(horizontal: 130),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        content: SizedBox(
          height: 100,
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitWanderingCubes(color: myColors.primaryColor, size: 30),
              customDivider(height: 25),
              const Text(
                'please wait ...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget moneyText(
  num amount, {
  String? currency = 'NGN',
  String? extraString = '',
  Color? fontcolor,
  double? fontsize,
  FontWeight? fontweight,
  double? letterspace,
  double? sentenceSpace,
}) => Text(
  extraString!.isNotEmpty
      ? '$extraString ${moneyformatter(amount, currency: currency)}'
      : moneyformatter(amount, currency: currency),
  style: MyDecor().textstyle(
    fontcolor: fontcolor,
    fontsize: fontsize,
    fontweight: fontweight,
    letterspace: letterspace,
    sentenceSpace: sentenceSpace,
    useDefaultFont: true,
  ),
);

Widget pageDescription(String text, {double? height}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    textWidget(
      text,
      fontsize: Sizes.w16,
      sentenceSpace: 1.3,
      fontweight: FontWeight.w500,
      fontcolor: Colors.grey,
    ),
    customDivider(height: height ?? Sizes.h15),
  ],
);

// Widget noItem(
//     {required BuildContext context,
//     required String message,
//     String? imagePath,
//     double? boxWidth,
//     bool showButton = false,
//     String? buttonText,
//     Function? function}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Image.asset(
//         imagePath ?? myAssets.notransaction,
//         width: Sizes.w150,
//       ),
//       customDivider(height: Sizes.h15),
//       Center(
//         child: Text(
//           message,
//           textAlign: TextAlign.center,
//           style: MyDecor()
//               .textstyle(fontsize: Sizes.w15, fontweight: FontWeight.w400),
//         ),
//       ),
//       customDivider(height: Sizes.h20),
//       if (showButton)
//         MyWidgets().button(
//             context: context,
//             boxWidth: boxWidth ?? Sizes.w200,
//             boxHeight: Sizes.h40,
//             useIcon: false,
//             buttonText: buttonText ?? 'Create New',
//             buttonTextSize: Sizes.w16,
//             proceed: () {
//               if (function != null) {
//                 function();
//               }
//             })
//     ],
//   );
// }

snackCopy({
  required BuildContext context,
  required String copyData,
  required String message,
}) {
  Clipboard.setData(ClipboardData(text: copyData));
  snackalert(context, message, snackColor: Colors.black);
}

Widget stringInitialsWidget(
  String name, {
  double? radius,
  double? fontSize,
  bool doubleInitial = true,
}) => CircleAvatar(
  radius: radius ?? Sizes.w25,
  backgroundColor: myColors.formBorder,
  child: Center(
    child: Text(
      stringInitials(name, doubleInitial: doubleInitial),
      style: MyDecor().textstyle(
        fontcolor: Colors.black,
        fontsize: fontSize ?? Sizes.w20,
      ),
    ),
  ),
);

Widget resolveWidget(String resolveState) {
  // initial, resolving, failed, completed states
  return SizedBox(
    width: 30,
    child: resolveState == 'resolving'
        ? resolvingWidget
        : resolveState == 'failed'
        ? failedWidget
        : resolveState == 'completed'
        ? resolvedWidget
        : Container(),
  );
}

Widget resolvingWidget = SpinKitChasingDots(
  color: myColors.primaryColor,
  size: 20,
);
Widget resolvedWidget = const Icon(Icons.check, color: Colors.green);
Widget failedWidget = const Icon(Icons.close, color: Colors.red);

Widget imageLoader(String url, {double? width, double? height}) => SizedBox(
  width: width ?? Sizes.w80,
  height: height ?? Sizes.h80,
  child: Image.asset(url),
);

Widget tileOptions(
  String title,
  BuildContext context,
  Function function, {
  bool useSubtitle = false,
  bool useLeading = false,
  String? subtitle,
  String? imagePath,
  Widget? leadingWidget,
  Widget? trailingWidget,
  Widget? subtitleWidget,
  Color? subtitleColor,
  Color? titleColor,
}) => ListTile(
  onTap: () {
    function();
  },
  contentPadding: const EdgeInsets.only(left: 0),
  minLeadingWidth: 0,
  horizontalTitleGap: 10,
  leading: useLeading
      ? imagePath != null
            ? Image.asset(imagePath, width: Sizes.w25)
            : leadingWidget
      : null,
  trailing:
      trailingWidget ??
      Icon(Icons.arrow_right_outlined, color: Colors.grey[350]),
  title: Text(
    title,
    overflow: TextOverflow.ellipsis,
    style: MyDecor().textstyle(fontsize: Sizes.w16, fontcolor: titleColor),
  ),
  subtitle: useSubtitle
      ? subtitleWidget ??
            Text(
              subtitle!,
              style: MyDecor().textstyle(
                fontsize: Sizes.w13,
                fontweight: FontWeight.w400,
                fontcolor: subtitleColor ?? myColors.primaryColor,
              ),
            )
      : null,
);

Widget summaryWidget({
  required String title,
  required String valueText,
  Widget? customWidget,
  double? titleFontSize,
  double? valueFontSize,
  bool isAmount = false,
  bool useCustomWidget = false,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: Sizes.h10, top: Sizes.h10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MyDecor().textstyle(
            fontsize: titleFontSize ?? Sizes.w15,
            fontweight: FontWeight.normal,
            fontcolor: myColors.fadedGrey,
          ),
        ),
        customhorizontal(width: Sizes.w10),
        useCustomWidget
            ? customWidget!
            : Expanded(
                child: Text(
                  // valueText,
                  isAmount
                      ? moneyformatter(double.tryParse(valueText)!)
                      : valueText,
                  textAlign: TextAlign.end,
                  style: isAmount
                      ? TextStyle(
                          fontSize: valueFontSize ?? Sizes.w15,
                          fontWeight: FontWeight.bold,
                          color: myColors.fadedGrey,
                        )
                      : MyDecor().textstyle(
                          fontsize: valueFontSize ?? Sizes.w15,
                          fontweight: FontWeight.bold,
                          fontcolor: myColors.fadedGrey,
                        ),
                ),
              ),
      ],
    ),
  );
}

Widget svgImage({
  required String svgPath,
  double? size,
  Color? color,
  BoxFit? boxFit,
}) => SvgPicture.asset(
  svgPath,
  fit: boxFit ?? BoxFit.contain,
  width: size ?? Sizes.w50,
  // ignore: deprecated_member_use
  color: color,
);
Widget titleTextWidget(String text) =>
    textWidget(text, fontcolor: Colors.grey[400]);
Widget noItem({
  required BuildContext context,
  required String message,
  String? imagePath,
  double? boxWidth,
  bool showButton = true,
  String? buttonText,
  Function? function,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        message,
        textAlign: TextAlign.center,
        style: MyDecor().textstyle(
          fontsize: Sizes.w15,
          fontweight: FontWeight.w400,
        ),
      ),
      customDivider(height: Sizes.h20),
      if (showButton)
        MyWidgets().button(
          context: context,
          boxWidth: boxWidth ?? Sizes.w200,
          boxHeight: Sizes.h40,
          buttonText: buttonText ?? 'Create New',
          proceed: () {
            if (function != null) {
              function();
            }
          },
        ),
    ],
  );
}

Widget dropDownWidget() =>
    Icon(Icons.arrow_drop_down_sharp, color: Colors.white);
