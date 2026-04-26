import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/payments/payment_tile.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class MemberDetails extends StatefulWidget {
  final ClientProfileData profileData;
  const MemberDetails({super.key, required this.profileData});

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  @override
  void initState() {
    super.initState();
    profileData = widget.profileData;
    getAllTransactions();
  }

  late ClientProfileData profileData;
  getAllTransactions() async {
    allPayments = await dbHelper.getPaymentHistoryByClientId(
      widget.profileData.id,
    );
    totalAmount = await dbHelper.getTotalPaidByClient(widget.profileData.id);
    setState(() {});
  }

  int totalAmount = 0;
  List<ClientPaymentData> allPayments = [];
  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: Sizes.w50,
                    backgroundColor: LetterColorDecider.getColor(
                      profileData.firstName[0],
                    ),
                    child: textWidget(
                      stringInitials(
                        '${profileData.firstName} ${profileData.lastName}',
                      ),
                      fontcolor: Colors.black,
                      fontsize: Sizes.w30,
                      fontweight: FontWeight.w700,
                    ),
                  ),

                  customDivider(height: Sizes.h15),
                  textWidget(
                    '${profileData.firstName} ${profileData.lastName}',
                    fontsize: Sizes.w25,
                    fontweight: FontWeight.w700,
                  ),
                  customDivider(height: Sizes.h5),
                  textWidget(
                    profileData.isOldCustomer == 1
                        ? 'Old Member'
                        : 'Member since ${stringDateFormatter(profileData.dateJoined.toIso8601String())}',
                    fontcolor: myColors.formTextColor,
                  ),
                ],
              ),
            ),
            customDivider(height: Sizes.h20),
            Row(
              children: [
                statWidget('Payments', numberFormat(allPayments.length)),
                customhorizontal(width: Sizes.w10),
                Expanded(
                  child: statWidget(
                    'Total amount',
                    moneyformatter(totalAmount),
                    expand: true,
                  ),
                ),
              ],
            ),
            customDivider(height: Sizes.h20),
            titleText('Contact'),
            customDivider(height: Sizes.h10),
            Container(
              width: double.infinity,
              decoration: MyDecor().container(),
              child: Column(
                children: [
                  profileDetails(
                    title: 'Email',
                    value: profileData.emailAddress,
                    icon: Icons.email_outlined,
                  ),
                  Divider(color: myColors.formTextColor),
                  CustomGestureDetector(
                    onTap: () {
                      snackCopy(
                        context: context,
                        copyData: profileData.phoneNumber,
                        message: 'Phone number copied',
                      );
                    },
                    child: profileDetails(
                      title: 'Phone',
                      value: profileData.phoneNumber,
                      icon: Icons.phone,
                    ),
                  ),
                  Divider(color: myColors.formTextColor),
                  profileDetails(
                    title: 'Date of Birth',
                    value: stringDateFormatter(
                      profileData.dateOfBirth.toIso8601String(),
                    ),
                    icon: Icons.calendar_month_outlined,
                  ),
                  Divider(color: myColors.formTextColor),
                  profileDetails(
                    title: 'Branch',
                    value: profileData.branch,
                    icon: Icons.gps_fixed_sharp,
                  ),
                ],
              ),
            ),
            customDivider(height: Sizes.h20),
            titleText('Payments'),
            customDivider(height: Sizes.h10),
            ...allPayments.map((data) => PaymentTile(paymentData: data)),
          ],
        ),
      ),
    );
  }

  Widget profileDetails({
    required String title,
    required String value,
    required IconData icon,
  }) => Padding(
    padding: internalPadding(context, top: Sizes.h10, bottom: Sizes.h10),
    child: Row(
      children: [
        Icon(icon, color: myColors.formTextColor),
        customhorizontal(width: Sizes.w10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(title, fontcolor: myColors.formTextColor),
              customDivider(height: Sizes.h2),
              textWidget(value.isEmpty ? 'N/A' : value),
            ],
          ),
        ),
      ],
    ),
  );

  Widget titleText(String title) => textWidget(
    title.toUpperCase(),
    fontcolor: myColors.formTextColor,
    fontsize: Sizes.w18,
    fontweight: FontWeight.w600,
  );

  Widget statWidget(String title, String value, {bool expand = false}) =>
      Container(
        height: Sizes.h70,
        width: expand ? double.infinity : Sizes.w120,
        decoration: MyDecor().container(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textWidget(value),
            textWidget(title, fontcolor: myColors.formTextColor),
          ],
        ),
      );
}
