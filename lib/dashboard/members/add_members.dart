import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/enums.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController oldMemberController = TextEditingController();
  late DateTime dateOfBirth;
  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      titleText: 'Add Member',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            'Profile',
            fontsize: Sizes.w25,
            fontweight: FontWeight.w600,
          ),
          customDivider(height: Sizes.h10),
          textWidget(
            "Enter the member's info",
            fontcolor: Color(0xffabaeb3),
            fontsize: Sizes.w17,
            fontweight: FontWeight.w400,
          ),
          customDivider(height: Sizes.h15),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyWidgets().formText('First name'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: firstNameController,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Last name'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: lastNameController,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Gender'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: genderController,
                      suffixicon: dropDownWidget(),
                      readOnly: true,
                      onTap: genderSheet,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Date of birth'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: dateOfBirthController,
                      readOnly: true,
                      suffixicon: dropDownWidget(),
                      onTap: datePicker,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Phone number'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isPhoneNumberValid,
                      controller: phoneNumberController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Email', showRequired: false),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.noValidation,
                      controller: emailController,
                    ),

                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Height (CM)', showRequired: false),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.noValidation,
                      controller: heightController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Weight (KG)', showRequired: false),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.noValidation,
                      controller: weightController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Branch'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: branchController,
                      suffixicon: dropDownWidget(),
                      onTap: branchSheet,
                      readOnly: true,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Old Member?'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: oldMemberController,
                      readOnly: true,
                      suffixicon: dropDownWidget(),
                      onTap: oldMemberSheet,
                    ),
                    customDivider(height: Sizes.h30),
                    MyWidgets().button(context: context, proceed: proceed),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  proceed() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      bool success = await dbHelper.insertClient(
        ClientProfileData(
          firstName: trimController(firstNameController),
          lastName: trimController(lastNameController),
          emailAddress: trimController(emailController),
          branch: trimController(branchController),
          height: jsonToDouble(trimController(heightController)),
          weight: jsonToDouble(trimController(weightController)),
          isOldCustomer: oldMemberController.text == 'Yes' ? 1 : 0,
          phoneNumber: trimController(phoneNumberController),
          gender: genderController.text,
          dateJoined: oldMemberController.text == 'Yes'
              ? DateTime(1914, 1, 1)
              : DateTime.now(),
          dateOfBirth: dateOfBirth,
        ),
      );
      if (success) {
        if (mounted) {
          snackalert(
            context,
            'Member added successfully',
            type: SnackType.success,
          );
          emailController.clear();
          firstNameController.clear();
          lastNameController.clear();
          heightController.clear();
          weightController.clear();
          branchController.clear();
          oldMemberController.clear();
          dateOfBirthController.clear();
          genderController.clear();
          phoneNumberController.clear();

          viewMembersListener.rebuild();
          dashboardListener.rebuild();
        }
      } else {
        if (mounted) {
          snackalert(context, 'Failed to add member. Please try again.');
        }
      }
    }
  }

  genderSheet() {
    bottomSheet(
      context: context,
      title: 'Gender',
      body: Column(
        children: [
          tileOptions('Male', context, () {
            genderController.text = 'Male';
            Navigator.pop(context);
          }),
          tileOptions('Female', context, () {
            genderController.text = 'Female';
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  branchSheet() {
    bottomSheet(
      context: context,
      title: 'Branch',
      body: Column(
        children: [
          tileOptions('Jedo', context, () {
            branchController.text = 'Jedo';
            Navigator.pop(context);
          }),
          tileOptions('Refinery Road', context, () {
            branchController.text = 'Refinery Road';
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  oldMemberSheet() {
    bottomSheet(
      context: context,
      title: 'Old Member?',
      body: Column(
        children: [
          tileOptions('Yes', context, () {
            oldMemberController.text = 'Yes';
            Navigator.pop(context);
          }),
          tileOptions('No', context, () {
            oldMemberController.text = 'No';
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  datePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1914, 1, 1),
      switchToInputEntryModeIcon: const Icon(Icons.edit, color: Colors.white),

      switchToCalendarEntryModeIcon: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: datePickerTheme(context), child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        dateOfBirth = DateTime(picked.year, picked.month, picked.day);
        dateOfBirthController.text =
            '${picked.day} ${DateFormat('MMMM').format(picked)} ${picked.year}';
      });
    } else {
      return null;
    }
  }

  String trimController(TextEditingController controller) {
    return controller.text.trim();
  }
}
