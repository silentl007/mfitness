import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/data_sync/data_sync.dart';
import 'package:mfitness/dashboard/members/add_members.dart';
import 'package:mfitness/dashboard/members/membership.dart';
import 'package:mfitness/dashboard/payments/add_payment.dart';
import 'package:mfitness/dashboard/payments/view_payments.dart';
import 'package:mfitness/dashboard/statistics/quick_stats.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<BottomNavData> bottomNavOptions = [
    BottomNavData(index: 0, icon: Icons.home, title: 'Home'),
    BottomNavData(index: 1, icon: Icons.groups_2_outlined, title: 'Members'),
    BottomNavData(index: 2, icon: Icons.payment, title: 'Payments'),
    BottomNavData(index: 3, icon: Icons.sync_outlined, title: 'Sync Data'),
  ];
  int currentIndex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      titleText: currentIndex == 0
          ? 'Dashboard'
          : bottomNavOptions[currentIndex].title,
      useBackButton: false,
      canPop: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingButton: currentIndex > 0 && currentIndex < 3
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  animateRoute(
                    currentIndex == 1 ? const AddMembers() : const AddPayment(),
                  ),
                );
              },
              backgroundColor: myColors.primaryColor,
              child: Icon(Icons.add),
            )
          : null,
      bottomBar: bottomNavWidget(),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        children: [
          QuickStats(pageController: pageController),
          Membership(),
          PaymentHistory(),
          DataSync(),
        ],
      ),
    );
  }

  Widget bottomNavWidget() => BottomAppBar(
    color: Colors.black,
    // height: Sizes.h70,
    padding: EdgeInsets.symmetric(horizontal: Sizes.w15, vertical: Sizes.h15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Sizes.w50,
      children: bottomNavOptions
          .map(
            (data) => CustomGestureDetector(
              onTap: () {
                pageController.jumpToPage(data.index);
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      data.icon,
                      size: Sizes.w25,
                      color: !(currentIndex == data.index)
                          ? myColors.formTextColor
                          : myColors.primaryColor,
                    ),
                    customDivider(height: Sizes.h5),
                    textWidget(
                      data.title,
                      fontcolor: !(currentIndex == data.index)
                          ? myColors.formTextColor
                          : myColors.primaryColor,
                      fontsize: Sizes.w17,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}
