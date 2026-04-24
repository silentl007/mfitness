import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/enums.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/myassets.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class SnackMessageWidget extends StatelessWidget {
  final String? title;
  final String message;
  final SnackType type;
  const SnackMessageWidget({
    super.key,
    this.title,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return type == SnackType.failure ? alertBox(context) : snackModal(context);
  }

  Widget alertBox(BuildContext context) => AlertDialog(
    backgroundColor: Color(0xff1F1F1F),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Sizes.w24),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [circleClose(context)],
    ),
    content: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      // height: Sizes.h200 + Sizes.h10,
      constraints: BoxConstraints(
        maxHeight: Sizes.h200 + Sizes.h10,
        minHeight: Sizes.h150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: Sizes.w60),
          customDivider(height: Sizes.h15),
          textWidget(
            'Error',
            fontcolor: Colors.white,
            fontsize: Sizes.w20,
            textAlign: TextAlign.center,
          ),
          customDivider(height: Sizes.h15),
          textWidget(
            message,
            fontcolor: Color(0xff8F8F8F),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWidget('Close', fontcolor: myColors.primaryColor),
          ),

          customDivider(height: Sizes.h10),
        ],
      ),
    ),
  );
  Widget snackModal(BuildContext context) => Container(
    height: Sizes.h70,
    width: double.infinity,
    decoration: MyDecor().container(
   
      borderColor: type == SnackType.failure
          ? Colors.red.withOpacity(.1)
          : myColors.primaryColor,
    ),
    child: Row(
      children: [
        Container(
          height: Sizes.h70,
          width: 10,
          decoration: MyDecor().container(
          
            containerColor: type == SnackType.failure
                ? Colors.red
                : myColors.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Sizes.w10),
              bottomLeft: Radius.circular(Sizes.w10),
            ),
          ),
        ),
        customhorizontal(width: Sizes.w20),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: Sizes.h10,
              bottom: Sizes.h5,
              right: Sizes.w10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                svgImage(
                  svgPath: type == SnackType.failure
                      ? myAssets.failedSVG
                      : myAssets.successSVG,
                  color: type == SnackType.failure ? Colors.red : Colors.green,
                  size: Sizes.w25,
                ),
                customhorizontal(width: Sizes.w15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title!,
                            style: MyDecor().textstyle(
                              fontsize: Sizes.w16,
                              fontweight: FontWeight.w700,
                              fontcolor: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (flushbar.isDismissed() == false) {
                                flushbar.dismiss();
                              }
                            },
                            child: Icon(Icons.close, size: Sizes.w20),
                          ),
                        ],
                      ),
                      Text(
                        message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: MyDecor().textstyle(
                          fontsize: Sizes.w15,
                          fontweight: FontWeight.w500,
                          fontcolor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
