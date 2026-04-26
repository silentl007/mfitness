import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/statistics/member_stats.dart';
import 'package:mfitness/dashboard/statistics/payment_stats.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class FullStats extends StatefulWidget {
  const FullStats({super.key});

  @override
  State<FullStats> createState() => _FullStatsState();
}

class _FullStatsState extends State<FullStats> {
  @override
  void initState() {
    super.initState();
    endDate = DateTime.now();
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    getStats();
  }

  getStats() async {
    allPayments = isAllTimeStat
        ? await dbHelper.getAllPayments(branch: branch)
        : await dbHelper.getPaymentsByDateRange(
            startDate,
            endDate,
            branch: branch,
          );
    allClients = await dbHelper.getAllClients(branch: branch);
    activeSubs = await dbHelper.getActiveSubs(branch: branch);
    birthDayClients = allClients
        .where((data) => data.dateOfBirth.month == DateTime.now().month)
        .toList();
    maleClients = allClients.where((data) => data.gender == 'Male').toList();
    femaleClients = allClients
        .where((data) => data.gender == 'Female')
        .toList();
    totalRevenue = allPayments.fold(
      0,
      (sum, payment) => sum + payment.amountPaid,
    );
    setState(() {});
  }

  int totalRevenue = 0;
  List<ClientProfileData> allClients = [];
  List<ClientProfileData> birthDayClients = [];

  List<ClientProfileData> maleClients = [];
  List<ClientProfileData> femaleClients = [];
  List<ClientPaymentData> allPayments = [];
  List<ClientPaymentData> activeSubs = [];
  late DateTime startDate;
  late DateTime endDate;
  String branch = 'All';
  bool isAllTimeStat = true;
  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      titleText: 'Full Stats',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dateFilter(),
          branchFilter(),
          customDivider(height: Sizes.h15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  revenueWidget(),
                  customDivider(height: Sizes.h10),
                  Row(
                    children: [
                      statBox(title: 'Total Members', currentStat: allClients),
                      customhorizontal(width: Sizes.w10),
                      statBox(title: 'Active Subs', currentStat: activeSubs),
                    ],
                  ),
                  customDivider(height: Sizes.h10),
                  Row(
                    children: [
                      statBox(title: 'Male Members', currentStat: maleClients),
                      customhorizontal(width: Sizes.w10),
                      statBox(
                        title: 'Female Members',
                        currentStat: femaleClients,
                      ),
                    ],
                  ),
                  customDivider(height: Sizes.h10),
                  Row(
                    children: [
                      statBox(title: 'Payments', currentStat: allPayments),
                      customhorizontal(width: Sizes.w10),
                      statBox(title: 'Birthday', currentStat: birthDayClients),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget revenueWidget() => Container(
    width: double.infinity,
    decoration: MyDecor().container(containerColor: myColors.primaryColor),
    padding: internalPadding(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
          'TOTAL REVENUE • $filterText',
          fontcolor: Colors.black,
          fontsize: Sizes.w17,
          fontweight: FontWeight.w500,
        ),
        customDivider(height: Sizes.h5),
        moneyText(
          totalRevenue,
          fontcolor: Colors.black,
          fontsize: Sizes.w25,
          fontweight: FontWeight.w800,
        ),
      ],
    ),
  );

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

  Widget dateFilter() => CustomGestureDetector(
    onTap: () {},
    child: Container(
      color: Colors.transparent,
      child: Row(
        children: [
          textWidget('Filter by date: ', fontcolor: myColors.formTextColor),
          customhorizontal(width: Sizes.w5),
          textWidget(filterText, fontcolor: Colors.white),
          dropDownWidget(),
        ],
      ),
    ),
  );
  List<String> branchOptions = ['All', 'Jedo', 'Refinery Road'];
  branchSheet() {
    bottomSheet(
      context: context,
      title: 'Branch',
      body: Column(
        children: List.generate(
          branchOptions.length,
          (index) => tileOptions(branchOptions[index], context, () {
            branch = branchOptions[index];
            getStats();
            Navigator.pop(context);
          }),
        ),
      ),
    );
  }

  List<String> dateOptions = ['All time', 'This Month', 'Custom Range'];

  dateSheet() {
    bottomSheet(
      context: context,
      title: 'Date',
      body: Column(
        children: List.generate(
          dateOptions.length,
          (index) => tileOptions(dateOptions[index], context, () {
            String type = branchOptions[index];
            if (type == 'All time') {
              isAllTimeStat = true;
              getStats();
            } else {
              if (type == 'This Month') {
                endDate = DateTime.now();
                startDate = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  1,
                );
                getStats();
              } else {}
            }
            Navigator.pop(context);
          }),
        ),
      ),
    );
  }

  Widget statBox({required String title, required List currentStat}) {
    return Expanded(
      child: CustomGestureDetector(
        onTap: () {
          if (title == 'Active Subs' || title == 'Payments') {
            Navigator.of(context).push(
              animateRoute(
                PaymentStats(
                  paymentList: currentStat,
                  title: title,
                  isSub: title == 'Active Subs',
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              animateRoute(MemberStats(memberList: currentStat, title: title)),
            );
          }
        },
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
              textWidget(
                title.toUpperCase(),
                fontcolor: myColors.formTextColor,
              ),
              customDivider(height: Sizes.h10),
              textWidget(
                numberFormat(currentStat.length),
                fontsize: Sizes.w25,
                fontweight: FontWeight.w800,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get filterText => isAllTimeStat
      ? 'All time'
      : '${stringDateFormatter(startDate.toIso8601String())} - ${stringDateFormatter(endDate.toIso8601String())}';
}
