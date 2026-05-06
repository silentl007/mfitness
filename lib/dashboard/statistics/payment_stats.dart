import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mfitness/dashboard/payments/payment_tile.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/enums.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
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
                        (index) => Slidable(
                          key: ValueKey(filterActiveSubs[index].id),
                          startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),

                            // All actions are defined in the children parameter.
                            children: [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: (_) {
                                  paymentId = jsonToInt(
                                    filterActiveSubs[index].id,
                                  );
                                  confirmPaymentDeletion();
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: PaymentTile(
                            paymentData: filterActiveSubs[index],
                            isSub: widget.isSub,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  late int paymentId;

  confirmPaymentDeletion() {
    bottomSheet(
      context: context,
      title: 'Confirm Payment Deletion',
      height: Sizes.h350,
      body: Column(
        children: [
          customDivider(height: Sizes.h10),
          textWidget(
            'Are you sure you want to delete payment? This action is irreversible and will affect the overall stats',
            fontsize: Sizes.w18,
            fontweight: FontWeight.w700,
          ),
          const Spacer(),
          MyWidgets().button(
            context: context,
            proceed: () async {
              Navigator.pop(context);
              deletePayment();
            },
            buttonText: 'Yes, delete payment',
          ),
          customDivider(height: Sizes.h10),
          MyWidgets().button(
            context: context,
            buttonColor: Colors.red,
            buttonTextColor: Colors.white,
            proceed: () {
              Navigator.pop(context);
            },
            buttonText: 'No, cancel',
          ),
        ],
      ),
    );
  }

  deletePayment() async {
    bool deleted = await dbHelper.deletePayment(paymentId);
    if (deleted) {
      dashboardListener.rebuild();
      fullStatsListener.rebuild();
      filterActiveSubs.removeWhere((data) => data.id == paymentId.toString());
      setState(() {});
      if (mounted) {
        snackalert(
          context,
          'Payment deleted successfully ',
          type: SnackType.success,
        );
      }
    } else {
      if (mounted) {
        snackalert(context, 'Failed to delete payment');
      }
    }
  }
}
