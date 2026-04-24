import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfitness/model/services/core/myassets.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';
import 'package:mfitness/model/services/core/themes.dart';

class SearchFormField extends StatelessWidget {
  final void Function(String? text)? onChanged;
  final void Function()? onTap;
  final Function cusTomSetState;
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
  const SearchFormField({
    super.key,
    required this.controller,
    required this.cusTomSetState,
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
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeClass.themeNotifier,
        builder: (context, value, child) {
          return TextFormField(
            controller: controller,
            onChanged: (value) {
              cusTomSetState(() {
                if (onChanged != null) {
                  onChanged!(value);
                }
              });
            },

            readOnly: readOnly,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onTap: onTap,
            // style: MyDecor().textstyle(fontcolor: Colors.black),
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            decoration: MyDecor().form(
                borderColor: value == ThemeMode.light
                    ? fillColor
                    : const Color.fromRGBO(255, 255, 255, 0.1),
                borderCurve: Sizes.w10,
                // borderCurve: borderCurve ?? Sizes.w20,
                disableBorder: disableBorder,
                fillColor: value == ThemeMode.light
                    ? fillColor
                    : const Color.fromRGBO(255, 255, 255, 0.1),
                hintStyle: hintStyle,
                hinttext: 'Search',
                labeltext: labeltext,
                // prefixText: 'Search',
                prefixicon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: svgImage(svgPath: myAssets.searchSVG, size: Sizes.w30),
                ),
                suffixicon: suffixicon),
          );
        });
  }
}
