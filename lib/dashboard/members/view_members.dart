import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/members/add_members.dart';
import 'package:mfitness/dashboard/members/member_tile.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class ViewMembers extends StatefulWidget {
  const ViewMembers({super.key});

  @override
  State<ViewMembers> createState() => _ViewMembersState();
}

class _ViewMembersState extends State<ViewMembers> {
  @override
  void initState() {
    super.initState();
    viewMembersListener.addListener(() {
      if (mounted) {
        getMembers();
      }
    });
    getMembers();
  }

  String branch = 'All';
  getMembers() async {
    members = [];
    members = await dbHelper.getAllClients(branch: branch);
    filterMembers = members;
    setState(() {});
  }

  List<ClientProfileData> members = [];
  List<ClientProfileData> filterMembers = [];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textWidget(
              '${filterMembers.length} MEMBERS',
              fontcolor: myColors.formTextColor,
            ),
            branchFilter(),
          ],
        ),
        customDivider(height: Sizes.h10),
        Expanded(
          child: filterMembers.isEmpty
              ? noItem(
                  context: context,
                  message: 'No member found',
                  function: () {
                    Navigator.of(
                      context,
                    ).push(animateRoute(const AddMembers()));
                  },
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
    );
  }

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
            getMembers();
            Navigator.pop(context);
          }),
        ),
      ),
    );
  }
}
