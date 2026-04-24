import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
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

  getSubs() async {
    activeSubs = await dbHelper.getActiveSubs();
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
        textWidget(
          '${filterActiveSubs.length} SUBSCRIPTIONS',
          fontcolor: myColors.formTextColor,
        ),
        customDivider(height: Sizes.h10),
        Expanded(
          child: filterActiveSubs.isEmpty
              ? Center(
                  child: noItem(
                    context: context,
                    message: 'No members found',
                    showButton: false,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    spacing: Sizes.h10,
                    children: List.generate(
                      filterActiveSubs.length,
                      (index) => paymentWidget(filterActiveSubs[index]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget paymentWidget(ClientPaymentData data) => CustomGestureDetector(
    onTap: () {
      myLog(name: 'id', logContent: data.id);
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
                  'Expires: ${stringDateFormatter(data.expirationDate.toIso8601String())}',
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
