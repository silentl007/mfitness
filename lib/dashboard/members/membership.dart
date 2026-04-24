import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/members/valid_subs.dart';
import 'package:mfitness/dashboard/members/view_members.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  late TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          indicatorColor: myColors.primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: myColors.primaryColor,
          tabs: [
            const Tab(text: 'All Members'),
            const Tab(text: 'Active Subscriptions'),
          ],
        ),
        customDivider(height: Sizes.h20),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [ViewMembers(), ValidSubscription()],
          ),
        ),
      ],
    );
  }
}
