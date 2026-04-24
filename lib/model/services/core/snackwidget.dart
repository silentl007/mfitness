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
    return Container(
      height: Sizes.h70,
      width: double.infinity,
      decoration: MyDecor().container(
        context: context,
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
              context: context,
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
                    color: type == SnackType.failure
                        ? Colors.red
                        : Colors.green,
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
                                fontcolor: Colors.black,
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
}
