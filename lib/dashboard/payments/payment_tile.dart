import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class PaymentTile extends StatefulWidget {
  final ClientPaymentData paymentData;
  final bool isSub;
  const PaymentTile({super.key, required this.paymentData, this.isSub = false});

  @override
  State<PaymentTile> createState() => _PaymentTileState();
}

class _PaymentTileState extends State<PaymentTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.h80,
      width: double.infinity,
      padding: internalPadding(context),
      decoration: MyDecor().container(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: LetterColorDecider.getColor(
              widget.paymentData.firstName[0],
            ),
            child: textWidget(
              stringInitials(
                '${widget.paymentData.firstName} ${widget.paymentData.lastName}',
              ),
            ),
          ),
          customhorizontal(width: Sizes.w10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWidget(
                  widget.isSub
                      ? '${widget.paymentData.firstName} ${widget.paymentData.lastName}'
                      : '${widget.paymentData.firstName} .${widget.paymentData.lastName[0]}.',
                ),
                customDivider(height: Sizes.h5),
                textWidget(
                  widget.isSub
                      ? 'Expires: ${stringDateFormatter(widget.paymentData.expirationDate.toIso8601String())}'
                      : transactionDateFormatter(
                          widget.paymentData.datePaid.toIso8601String(),
                        ),
                ),
              ],
            ),
          ),
          if (!widget.isSub) customhorizontal(width: Sizes.w10),
          if (!widget.isSub) moneyText(widget.paymentData.amountPaid),
        ],
      ),
    );
  }
}
