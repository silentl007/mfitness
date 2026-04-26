import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/members/member_tile.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class MemberStats extends StatefulWidget {
  final List memberList;
  final String title;
  const MemberStats({super.key, required this.memberList, required this.title});

  @override
  State<MemberStats> createState() => _MemberStatsState();
}

class _MemberStatsState extends State<MemberStats> {
  @override
  void initState() {
    super.initState();
    members = (widget.memberList as List<ClientProfileData>);
    filterMembers = members;
  }

  List<ClientProfileData> members = [];
  List<ClientProfileData> filterMembers = [];
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
                filterMembers = members
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
                filterMembers = members;
                setState(() {});
              }
            },
          ),
          customDivider(height: Sizes.h10),
          textWidget(
            '${filterMembers.length} MEMBERS',
            fontcolor: myColors.formTextColor,
          ),
          customDivider(height: Sizes.h10),
          Expanded(
            child: filterMembers.isEmpty
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
                        filterMembers.length,
                        (index) => MemberTile(data: filterMembers[index]),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
