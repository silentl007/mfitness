import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/payments/payment_tile.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class ValidSubscription extends StatefulWidget {
  const ValidSubscription({super.key});

  @override
  State<ValidSubscription> createState() => _ValidSubscriptionState();
}

class _ValidSubscriptionState extends State<ValidSubscription> {
  @override
  void initState() {
    super.initState();
    viewMembersListener.addListener(() {
      if (mounted) {
        getSubs();
      }
    });
    getSubs();
  }

  String branch = 'All';
  getSubs() async {
    activeSubs = await dbHelper.getActiveSubs(branch: branch);
    filterActiveSubs = activeSubs;
    setState(() {});
  }

  List<ClientPaymentData> activeSubs = [];
  List<ClientPaymentData> filterActiveSubs = [];

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomFormField(
          validator: FormValidators.noValidation,
          prefixicon: Icon(Icons.search),
          controller: searchController,
          hinttext: 'Search by name',
          onChanged: (text) {
            if (text != null) {
              filterActiveSubs = activeSubs
                  .where(
                    (member) =>
                        member.firstName.toLowerCase().contains(
                          text.toLowerCase(),
                        ) ||
                        member.lastName.toLowerCase().contains(
                          text.toLowerCase(),
                        ),
                  )
                  .toList();
              setState(() {});
            } else {
              filterActiveSubs = activeSubs;
              setState(() {});
            }
          },
        ),
        customDivider(height: Sizes.h10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textWidget(
              '${filterActiveSubs.length} SUBSCRIPTIONS',
              fontcolor: myColors.formTextColor,
            ),
            branchFilter(),
          ],
        ),
        customDivider(height: Sizes.h10),
        Expanded(
          child: filterActiveSubs.isEmpty
              ? Center(
                  child: noItem(
                    context: context,
                    message: 'No active subscription found',
                    showButton: false,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    spacing: Sizes.h10,
                    children: List.generate(
                      filterActiveSubs.length,
                      (index) => PaymentTile(
                        paymentData: filterActiveSubs[index],
                        isSub: true,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget branchFilter() => CustomGestureDetector(
    onTap: branchSheet,
    child: Container(
      color: Colors.transparent,
      child: Row(
        children: [
          textWidget('Filter by branch: ', fontcolor: myColors.formTextColor),
          customhorizontal(width: Sizes.w5),
          textWidget(branch, fontcolor: Colors.white),
          dropDownWidget(),
        ],
      ),
    ),
  );
  List<String> branchOptions = ['All', 'Refinery Road', 'Jedo'];
  branchSheet() {
    bottomSheet(
      context: context,
      title: 'Branch',
      body: Column(
        children: List.generate(
          branchOptions.length,
          (index) => tileOptions(branchOptions[index], context, () {
            branch = branchOptions[index];
            getSubs();
            Navigator.pop(context);
          }),
        ),
      ),
    );
  }
}
