import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:flutter/material.dart';

class MyDecor {
  textstyle({
    Color? fontcolor,
    Color? underlinecolor,
    double? fontsize,
    FontWeight? fontweight,
    double? letterspace,
    double? sentenceSpace,
    bool useDefaultFont = false,
    bool underline = false,
    int? maxLines,
  }) {
    return TextStyle(
      letterSpacing: letterspace ?? 0,
      height: sentenceSpace ?? 1.3,
      color: fontcolor ?? Colors.white,
      fontSize: fontsize,
      fontFamily: useDefaultFont ? null : 'Outfit',
      fontWeight: fontweight ?? FontWeight.w500,
      decoration: underline ? TextDecoration.underline : null,
      decorationColor: underlinecolor ?? fontcolor ?? Colors.black,
    );
  }

  buttonDecor({
    Color? buttoncolor,
    Color? bordercolor,
    Color? elevationColor,
    double? elevation,
    double? bordercurver,
    required BuildContext context,
  }) {
    double size = MediaQuery.of(context).size.width;
    double w5 = size * .0118;
    return ElevatedButton.styleFrom(
      elevation: elevation,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.transparent,
      backgroundColor: buttoncolor,
      side: BorderSide(color: bordercolor ?? myColors.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(bordercurver ?? w5)),
      ),
    );
  }

  container({
    Color? containerColor,
    double? curve,
    Color? borderColor,
    BoxFit? boxFit,
    String? backgroundimage,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      border: Border.all(
        color: borderColor ?? containerColor ?? Color(0xff2b2e32),
      ),
      color: containerColor ?? Color(0xff16181b),
      image: backgroundimage != null
          ? DecorationImage(
              image: AssetImage(backgroundimage),
              fit: boxFit ?? BoxFit.cover,
            )
          : null,
      borderRadius:
          borderRadius ?? BorderRadius.all(Radius.circular(curve ?? Sizes.w10)),
    );
  }

  bottomSheetContainer() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Sizes.w20),
        topRight: Radius.circular(Sizes.w20),
      ),
      color: Colors.white,
    );
  }

  form({
    Widget? prefixicon,
    String? prefixText,
    Widget? suffixicon,
    String? hinttext,
    String? labeltext,
    Color? fillColor,
    Color? borderColor,
    double? borderCurve,
    TextStyle? hintStyle,
    bool? usetoppadding,
    bool? disableBorder,
    bool usePrefixPadding = true,
    bool removeLeftPadding = false,
  }) {
    double defaultCurve = Sizes.w20;
    return InputDecoration(
      prefixIcon: prefixicon == null
          ? null // 👈 don't render anything if no icon
          : usePrefixPadding
          ? Padding(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: prefixicon,
            )
          : prefixicon,
      prefixText: prefixText,
      // alignLabelWithHint: true,
      prefixIconConstraints: const BoxConstraints(minHeight: 4, minWidth: 4),
      suffixIconConstraints: const BoxConstraints(minHeight: 4, minWidth: 4),

      suffixIcon: Padding(
        padding: const EdgeInsets.all(4.0),
        child: suffixicon,
      ),
      suffixIconColor: darkModeColor(
        darkMode: Colors.white,
        lightMode: Colors.black,
      ),
      labelStyle: MyDecor().textstyle(
        fontcolor: darkModeColor(darkMode: myColors.formHintColor),
        fontweight: FontWeight.w400,
      ),
      label: labeltext == null ? null : Text(labeltext),
      contentPadding: EdgeInsets.only(
        left: removeLeftPadding ? 0 : Sizes.h20,
        top: usetoppadding == true ? 20 : 0,
      ),
      hintText: hinttext,
      hintStyle:
          hintStyle ??
          TextStyle(
            color: darkModeColor(
              darkMode: Colors.grey[300],
              lightMode: rgbaStringToColor('rgba(0, 0, 0, 1)'),
            ),
            fontWeight: FontWeight.w400,
          ),
      fillColor: fillColor ?? Colors.white,
      filled: true,
      errorMaxLines: 3,
      enabledBorder: disableBorder == true
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
              borderSide: BorderSide(
                color: borderColor ?? myColors.formBorder,
                width: 1,
              ),
            ),
      focusedBorder: disableBorder == true
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
              borderSide: BorderSide(
                color: borderColor ?? myColors.primaryColor,
                width: 1,
              ),
            ),
      errorBorder: disableBorder == true
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
      focusedErrorBorder: disableBorder == true
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
              borderSide: BorderSide(
                color: borderColor ?? myColors.primaryColor,
                width: 1,
              ),
            ),
    );
  }

  noBorderForm({
    String? hintText,
    double? hintSize,
    FontWeight hintWeight = FontWeight.normal,
  }) {
    InputBorder borderDetails = OutlineInputBorder(
      // borderRadius: BorderRadius.circular(borderCurve ?? defaultCurve),
      gapPadding: 0,
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
    );
    return InputDecoration(
      hintText: hintText,

      hintStyle: MyDecor().textstyle(
        fontsize: hintSize ?? Sizes.w22,
        fontweight: hintWeight,
      ),
      labelStyle: MyDecor().textstyle(),
      contentPadding: EdgeInsets.only(left: 0, right: 0, top: 20),
      enabledBorder: borderDetails,
      focusedBorder: borderDetails,
      errorBorder: borderDetails,
      focusedErrorBorder: borderDetails,
    );
  }
}
