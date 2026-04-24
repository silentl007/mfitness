import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/themes.dart';

class CustomFormField extends StatelessWidget {
  final String? Function(String? text) validator;
  final String? Function(String? text)? customValidator;
  final void Function(String? text)? onChanged;
  final void Function()? onTap;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Widget? prefixicon;
  final String? prefixText;
  final Widget? suffixicon;
  final String? hinttext;
  final String? labeltext;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderCurve;
  final TextStyle? hintStyle;
  final bool? usetoppadding;
  final bool? disableBorder;
  final bool readOnly;
  final bool useCustomValidator;
  final bool obscureText;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool usePrefixPadding;
  final bool removeLeftPadding;
  const CustomFormField({
    super.key,
    required this.validator,
    required this.controller,
    this.customValidator,
    this.maxLines = 1,
    this.readOnly = false,
    this.useCustomValidator = false,
    this.obscureText = false,
    this.onTap,
    this.keyboardType,
    this.onChanged,
    this.borderColor,
    this.borderCurve,
    this.disableBorder,
    this.fillColor,
    this.hintStyle,
    this.hinttext,
    this.labeltext,
    this.prefixText,
    this.prefixicon,
    this.suffixicon,
    this.usetoppadding,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.words,
    this.usePrefixPadding = true,
    this.removeLeftPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeClass.themeNotifier,
      builder: (context, value, child) {
        return TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: useCustomValidator ? customValidator : validator,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onTap: onTap,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          decoration: MyDecor().form(
            removeLeftPadding: removeLeftPadding,
            borderColor: darkModeColor(
              darkMode:
                  borderColor ?? rgbaStringToColor('rgba(255, 255, 255, 0.32)'),
              lightMode: borderColor ?? rgbaStringToColor('rgba(0, 0, 0, 1)'),
            ),
            usePrefixPadding: usePrefixPadding,
            borderCurve: borderCurve,
            disableBorder: disableBorder,
            fillColor:
                fillColor ??
                darkModeColor(darkMode: Colors.black, lightMode: Colors.white),

            hintStyle:
                hintStyle ?? MyDecor().textstyle(fontcolor: Color(0xffE0E0E0)),
            hinttext: hinttext,
            labeltext: labeltext,
            prefixText: prefixText,
            prefixicon: prefixicon,
            suffixicon: suffixicon,
          ),
        );
      },
    );
  }
}
