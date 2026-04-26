import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/payments/payment_tile.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class PaymentStats extends StatefulWidget {
  final List paymentList;
  final String title;
  final bool isSub;
  const PaymentStats({
    super.key,
    required this.paymentList,
    required this.title,
    required this.isSub,
  });

  @override
  State<PaymentStats> createState() => _PaymentStatsState();
}

class _PaymentStatsState extends State<PaymentStats> {
  @override
  void initState() {
    super.initState();
    activeSubs = (widget.paymentList as List<ClientPaymentData>);
    filterActiveSubs = activeSubs;
  }

  List<ClientPaymentData> activeSubs = [];
  List<ClientPaymentData> filterActiveSubs = [];

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      titleText: widget.title,
      body: Column(
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
            children: [
              textWidget(
                '${filterActiveSubs.length} ${widget.isSub ? 'subscription' : 'payment'}'
                    .toUpperCase(),
                fontcolor: myColors.formTextColor,
              ),
            ],
          ),
          customDivider(height: Sizes.h10),
          Expanded(
            child: filterActiveSubs.isEmpty
                ? Center(
                    child: noItem(
                      context: context,
                      message:
                          'No ${widget.isSub ? 'active subscription' : 'payment'} found',
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
                          isSub: widget.isSub,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
