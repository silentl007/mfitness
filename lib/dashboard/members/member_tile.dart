import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/members/member_details.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class MemberTile extends StatelessWidget {
  final ClientProfileData data;
  const MemberTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(animateRoute(MemberDetails(profileData: data)));
      },
      child: Container(
        height: Sizes.h80,
        width: double.infinity,
        padding: internalPadding(context),
        decoration: MyDecor().container(),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: LetterColorDecider.getColor(data.firstName[0]),
              child: textWidget(
                stringInitials('${data.firstName} ${data.lastName}'),
                fontcolor: Colors.black,
              ),
            ),
            customhorizontal(width: Sizes.w10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                    '${data.firstName} ${data.lastName}',
                    fontsize: Sizes.w18,
                  ),
                  customDivider(height: Sizes.h5),
                  textWidget(
                    data.phoneNumber.toString(),
                    fontcolor: myColors.formTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
