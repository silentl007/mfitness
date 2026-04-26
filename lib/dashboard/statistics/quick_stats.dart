import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mfitness/dashboard/payments/payment_tile.dart';
import 'package:mfitness/dashboard/statistics/full_stats.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class QuickStats extends StatefulWidget {
  final PageController pageController;
  const QuickStats({super.key, required this.pageController});

  @override
  State<QuickStats> createState() => _QuickStatsState();
}

class _QuickStatsState extends State<QuickStats> {
  @override
  void initState() {
    super.initState();
    dashboardListener.addListener(() {
      if (mounted) {
        getStats();
      }
    });
    getStats();
  }

  int thisMonthAmount = 0;
  int lastMonthAmount = 0;
  getStats() async {
    thisMonthPayments = await dbHelper.getPaymentsByDateRange(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      DateTime.now(),
    );
    lastMonthPayments = await dbHelper.getPaymentsByDateRange(
      DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
      DateTime(DateTime.now().year, DateTime.now().month - 1, 31),
    );
    thisMonthAmount = thisMonthPayments.fold(
      0,
      (sum, payment) => sum + payment.amountPaid,
    );
    lastMonthAmount = lastMonthPayments.fold(
      0,
      (sum, payment) => sum + payment.amountPaid,
    );
    newSignUps = await dbHelper.getClientsByDateJoinedRange(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      DateTime.now(),
    );
    lastMonthSignUps = await dbHelper.getClientsByDateJoinedRange(
      DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
      DateTime(DateTime.now().year, DateTime.now().month - 1, 31),
    );
    myLog(name: 'this month payments', logContent: thisMonthPayments.length);
    myLog(name: 'last month payments', logContent: lastMonthPayments.length);
    setState(() {});
  }

  List<ClientProfileData> newSignUps = [];
  List<ClientProfileData> lastMonthSignUps = [];
  List<ClientPaymentData> thisMonthPayments = [];
  List<ClientPaymentData> lastMonthPayments = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
          '${DateFormat('MMMM').format(DateTime.now()).toUpperCase()} ${DateTime.now().year}',
          fontcolor: myColors.formTextColor,
          fontweight: FontWeight.w500,
        ),
        customDivider(height: Sizes.h5),
        textWidget(
          'Hi, Admin.',
          fontsize: Sizes.w25,
          fontweight: FontWeight.w600,
        ),
        customDivider(height: Sizes.h10),
        textWidget(
          'This is a quick overview of how MFitness is doing this month',
          fontcolor: Color(0xffabaeb3),
          fontsize: Sizes.w17,
          fontweight: FontWeight.w400,
        ),
        customDivider(height: Sizes.h20),
        Expanded(child: body()),
      ],
    );
  }

  Widget body() => NestedScrollView(
    floatHeaderSlivers: true,
    headerSliverBuilder: (context, innerBoxIsScrolled) {
      return [
        SliverList(
          delegate: SliverChildListDelegate([
            revenueWidget(),
            customDivider(height: Sizes.h10),
            Row(
              children: [
                statBox(
                  title: 'New sign-ups',
                  currentStat: newSignUps.length,
                  previousStat: lastMonthSignUps.length,
                ),
                customhorizontal(width: Sizes.w10),
                statBox(
                  title: 'Payments',
                  currentStat: thisMonthPayments.length,
                  previousStat: lastMonthPayments.length,
                ),
              ],
            ),
            customDivider(height: Sizes.h10),
            CustomGestureDetector(
              onTap: () {
                Navigator.of(context).push(animateRoute(const FullStats()));
              },
              child: Container(
                height: Sizes.h70,
                width: double.infinity,
                decoration: MyDecor().container(),
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.w10,
                  vertical: Sizes.h15,
                ),
                child: Row(
                  children: [
                    Container(
                      height: Sizes.h50,
                      width: Sizes.w50,
                      decoration: MyDecor().container(
                        containerColor: Color(0xff1f2225),
                      ),
                      child: Icon(
                        Icons.insert_chart_outlined_rounded,
                        color: myColors.primaryColor,
                      ),
                    ),
                    customhorizontal(width: Sizes.w10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWidget(
                            'View full statistics',
                            fontweight: FontWeight.w700,
                            fontsize: Sizes.w18,
                          ),
                          customDivider(height: Sizes.h3),
                          textWidget(
                            'Filter by period and other metrics',
                            fontcolor: myColors.formTextColor,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xff1f2225),
                    ),
                  ],
                ),
              ),
            ),
            customDivider(height: Sizes.h20),
          ]),
        ),
      ];
    },
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
          'RECENT PAYMENTS',
          fontcolor: Color(0xffabaeb3),
          fontsize: Sizes.w17,
          fontweight: FontWeight.w800,
        ),
        customDivider(height: Sizes.h20),
        Expanded(
          child: thisMonthPayments.isEmpty
              ? Center(child: textWidget('No payment this month'))
              : SingleChildScrollView(
                  child: Column(
                    spacing: Sizes.h10,
                    children: List.generate(
                      payments().length,
                      (index) => PaymentTile(paymentData: payments()[index]),
                    ),
                  ),
                ),
        ),
      ],
    ),
  );

  Widget revenueWidget() {
    double change = percentageChange(thisMonthAmount, lastMonthAmount);
    bool isPositive = change >= 0;
    return Container(
      width: double.infinity,
      decoration: MyDecor().container(containerColor: myColors.primaryColor),
      padding: internalPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            'TOTAL REVENUE • ${DateFormat('MMM').format(DateTime.now()).toUpperCase()}',
            fontcolor: Colors.black,
            fontsize: Sizes.w17,
            fontweight: FontWeight.w500,
          ),
          customDivider(height: Sizes.h5),
          moneyText(
            thisMonthAmount,
            fontcolor: Colors.black,
            fontsize: Sizes.w25,
            fontweight: FontWeight.w800,
          ),
          customDivider(height: Sizes.h5),
          Row(
            children: [
              Container(
                decoration: MyDecor().container(
                  containerColor: isPositive
                      ? Colors.green.withOpacity(.2)
                      : Colors.red.withOpacity(.2),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.w10,
                  vertical: Sizes.h2,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.show_chart_sharp,
                      size: Sizes.w20,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    customhorizontal(width: Sizes.w5),
                    textWidget(
                      '${isPositive ? '+' : '-'}$change%',
                      fontcolor: isPositive ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<ClientPaymentData> payments() {
    if (thisMonthPayments.length > 5) {
      return thisMonthPayments.sublist(0, 4);
    } else {
      return thisMonthPayments;
    }
  }

  Widget statBox({
    required String title,
    required int currentStat,
    required int previousStat,
  }) {
    double change = percentageChange(currentStat, previousStat);
    bool isPositive = change >= 0;
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: MyDecor().container(),
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.w10,
          vertical: Sizes.h15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(title.toUpperCase(), fontcolor: myColors.formTextColor),
            customDivider(height: Sizes.h10),
            textWidget(
              numberFormat(currentStat),
              fontsize: Sizes.w25,
              fontweight: FontWeight.w800,
            ),
            customDivider(height: Sizes.h10),
            Container(
              decoration: MyDecor().container(
                containerColor: isPositive
                    ? Colors.green.withOpacity(.2)
                    : Colors.red.withOpacity(.2),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.w10,
                vertical: Sizes.h2,
              ),
              child: textWidget(
                '${isPositive ? '+' : '-'}$change%',
                fontcolor: isPositive ? myColors.primaryColor : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double percentageChange(int current, int previous) {
    if (current == 0 && previous == 0) return 0;
    if (previous == 0) return 100.0;
    return ((current - previous) / previous) * 100;
  }
}
