import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/payments/payment_tile.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  void initState() {
    super.initState();
    paymentListener.addListener(() {
      if (mounted) {
        getPayments();
      }
    });
    getPayments();
  }

  getPayments() async {
    thisMonthPayments = await dbHelper.getPaymentsByDateRange(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      DateTime.now(),
    );
    setState(() {});
  }

  List<ClientPaymentData> thisMonthPayments = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget('This month payments'),
        customDivider(height: Sizes.h10),
        Expanded(
          child: thisMonthPayments.isEmpty
              ? Center(child: textWidget('No payment this month'))
              : SingleChildScrollView(
                  child: Column(
                    spacing: Sizes.h10,
                    children: List.generate(
                      thisMonthPayments.length,
                      (index) =>
                          PaymentTile(paymentData: thisMonthPayments[index]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
