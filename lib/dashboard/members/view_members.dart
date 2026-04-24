import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/members/add_members.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/gesture_detector.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
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

  getMembers() async {
    members = [];
    members = await dbHelper.getAllClients();
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
          hinttext: 'Search by name or email',
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
                        ) ||
                        member.emailAddress.toLowerCase().contains(
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
              ? noItem(
                  context: context,
                  message: 'No members found',
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
                      (index) => memberWidget(filterMembers[index]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget memberWidget(ClientProfileData data) => CustomGestureDetector(
    onTap: () {
      myLog(name: 'id', logContent: data.id);
    },
    child: Container(
      height: Sizes.h80,
      width: double.infinity,
      padding: internalPadding(context),
      decoration: MyDecor().container(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: LetterColorDecider.getColor(data.firstName[0]),
            child: textWidget(
              stringInitials('${data.firstName} ${data.lastName}'),
            ),
          ),
          customhorizontal(width: Sizes.w10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWidget(
                  '${data.firstName} ${data.lastName}',
                  fontsize: Sizes.w18,
                ),
                customDivider(height: Sizes.h5),
                textWidget(
                  data.phoneNumber.toString(),
                  fontcolor: myColors.formTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
