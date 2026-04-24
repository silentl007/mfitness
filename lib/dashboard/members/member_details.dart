import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class MemberDetails extends StatefulWidget {
  final ClientProfileData profileData;
  const MemberDetails({super.key, required this.profileData});

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [customDivider(height: Sizes.h15)],
      ),
    );
  }
}
