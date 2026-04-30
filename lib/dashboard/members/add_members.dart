import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/enums.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myclass.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  @override
  void initState() {
    super.initState();
    dateJoined = DateTime.now();
    dateJoinedController.text = stringDateFormatter(
      dateJoined.toIso8601String(),
    );
  }

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
  TextEditingController dateJoinedController = TextEditingController();
  TextEditingController oldMemberController = TextEditingController();
  late DateTime dateOfBirth;
  late DateTime dateJoined;
  // EMERGENCY CONTACT
  TextEditingController ecFirstNameController = TextEditingController();
  TextEditingController ecLastNameController = TextEditingController();
  TextEditingController ecDobController = TextEditingController();
  TextEditingController ecPhoneController = TextEditingController();
  TextEditingController ecSexController = TextEditingController();
  late DateTime ecDob;

  // PRE-EXERCISE
  TextEditingController physicalConditionController = TextEditingController();

  // Medical YES/NO
  Map<String, TextEditingController> medicalControllers = {
    'stroke': TextEditingController(),
    'heart_condition': TextEditingController(),
    'diabetes': TextEditingController(),
    'epilepsy': TextEditingController(),
    'dizziness': TextEditingController(),
    'panting': TextEditingController(),
    'chest_pain': TextEditingController(),
    'high_bp': TextEditingController(),
    'low_bp': TextEditingController(),
  };

  // Recent conditions
  Map<String, TextEditingController> recentControllers = {
    'medication': TextEditingController(),
    'pregnant': TextEditingController(),
    'recent_birth': TextEditingController(),
    'dieting': TextEditingController(),
    'hospitalized': TextEditingController(),
  };

  // Injury areas
  Map<String, TextEditingController> injuryControllers = {
    'neck': TextEditingController(),
    'knee': TextEditingController(),
    'back': TextEditingController(),
    'waist': TextEditingController(),
  };

  TextEditingController majorInjuryController = TextEditingController();
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
                      inputFormatters: [LengthLimitingTextInputFormatter(11)],
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Email', showRequired: false),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.noValidation,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
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
                    if (oldMemberController.text == 'No')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customDivider(height: Sizes.h20),
                          MyWidgets().formText('Date joined'),
                          customDivider(height: Sizes.h10),
                          CustomFormField(
                            validator: FormValidators.isFieldEmpty,
                            controller: dateJoinedController,
                            readOnly: true,
                            suffixicon: dropDownWidget(),
                            onTap: dateJoinedPicker,
                          ),
                        ],
                      ),
                    customDivider(height: Sizes.h30),
                    titleHeader('Emergency Contact'),
                    customDivider(height: Sizes.h20),

                    MyWidgets().formText('First name'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: ecFirstNameController,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Last name'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: ecLastNameController,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Date of Birth'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      controller: ecDobController,
                      validator: FormValidators.isFieldEmpty,
                      readOnly: true,
                      suffixicon: dropDownWidget(),
                      onTap: ecDatePicker,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Phone number'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      controller: ecPhoneController,
                      validator: FormValidators.isPhoneNumberValid,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(11)],
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Gender'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      controller: ecSexController,
                      validator: FormValidators.isFieldEmpty,
                      readOnly: true,
                      suffixicon: dropDownWidget(),
                      onTap: () =>
                          yesNoSheet(ecSexController, ['Male', 'Female']),
                    ),
                    customDivider(height: Sizes.h30),
                    titleHeader('Pre-Exercise Questionnaire'),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Physical Condition'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      controller: physicalConditionController,
                      validator: FormValidators.noValidation,
                      readOnly: true,
                      suffixicon: dropDownWidget(),
                      onTap: () => yesNoSheet(physicalConditionController, [
                        'Overweight',
                        'Fit',
                      ]),
                    ),
                    customDivider(height: Sizes.h30),
                    titleHeader('Medical Conditions'),
                    customDivider(height: Sizes.h20),
                    yesNoField('Stroke', medicalControllers['stroke']!),
                    yesNoField(
                      'Heart Condition',
                      medicalControllers['heart_condition']!,
                    ),
                    yesNoField('Diabetes', medicalControllers['diabetes']!),
                    yesNoField('Epilepsy', medicalControllers['epilepsy']!),
                    yesNoField('Dizziness', medicalControllers['dizziness']!),
                    yesNoField(
                      'Steady Panting',
                      medicalControllers['panting']!,
                    ),
                    yesNoField('Chest Pain', medicalControllers['chest_pain']!),
                    yesNoField(
                      'High Blood Pressure',
                      medicalControllers['high_bp']!,
                    ),
                    yesNoField(
                      'Low Blood Pressure',
                      medicalControllers['low_bp']!,
                    ),
                    titleHeader('Recent Conditions'),
                    customDivider(height: Sizes.h20),
                    yesNoField(
                      'Prescribed Medication',
                      recentControllers['medication']!,
                    ),
                    yesNoField('Pregnant', recentControllers['pregnant']!),
                    if (recentControllers['pregnant']!.text == 'Yes')
                      yesNoField(
                        'Recent Birth',
                        recentControllers['recent_birth']!,
                      ),
                    yesNoField(
                      'Dieting/Fasting',
                      recentControllers['dieting']!,
                    ),
                    yesNoField(
                      'Hospitalized Recently',
                      recentControllers['hospitalized']!,
                    ),
                    titleHeader('Injuries'),
                    customDivider(height: Sizes.h20),
                    yesNoField('Neck', injuryControllers['neck']!),
                    yesNoField('Knee', injuryControllers['knee']!),
                    yesNoField('Back', injuryControllers['back']!),
                    yesNoField('Waist', injuryControllers['waist']!),

                    yesNoField('Major Injuries', majorInjuryController),
                    customDivider(height: Sizes.h10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: accepted,
                          activeColor: myColors.primaryColor,
                          onChanged: (val) {
                            setState(() {
                              accepted = !accepted;
                            });
                          },
                        ),
                        customhorizontal(width: Sizes.w10),
                        Expanded(
                          child: textWidget(
                            'i apply to join the gym and agree to and will observe rules and regulations.\n\ni also acknowledge that the activity i am to undertake is a strenuous activity and that by participating in it, i might be exposed to certain risks'
                                .toUpperCase(),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
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

  bool accepted = false;

  Widget titleHeader(String text) =>
      textWidget(text, fontsize: Sizes.w18, fontweight: FontWeight.w600);

  proceed() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      if (accepted) {
        confirmAddMember();
      } else {
        snackalert(
          context,
          'Please accept the terms and conditions before continuing ',
        );
      }
    }
  }

  confirmAddMember() {
    bottomSheet(
      context: context,
      title: 'Confirm Member',
      height: Sizes.h350,
      body: Column(
        children: [
          customDivider(height: Sizes.h10),
          textWidget(
            'Are you sure you want to add member? You cannot delete member once added.\n\nAdd member ${firstNameController.text} ${lastNameController.text} to branch ${branchController.text}',
            fontsize: Sizes.w18,
            fontweight: FontWeight.w700,
          ),
          const Spacer(),
          MyWidgets().button(
            context: context,
            proceed: () async {
              Navigator.pop(context);
              addMember();
            },
            buttonText: 'Yes, add member',
          ),
          customDivider(height: Sizes.h10),
          MyWidgets().button(
            context: context,
            buttonColor: Colors.red,
            buttonTextColor: Colors.white,
            proceed: () {
              Navigator.pop(context);
            },
            buttonText: 'No, cancel',
          ),
        ],
      ),
    );
  }

  addMember() async {
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
            : dateJoined,
        dateOfBirth: dateOfBirth,

        // ✅ EMERGENCY CONTACT
        emergencyContact: {
          "firstName": trimController(ecFirstNameController),
          "lastName": trimController(ecLastNameController),
          "dob": ecDob.toIso8601String(),
          "phone": trimController(ecPhoneController),
          "sex": ecSexController.text,
        },

        // ✅ QUESTIONNAIRE
        questionnaire: {
          "physicalCondition": physicalConditionController.text,

          "medical": {
            "stroke": medicalControllers['stroke']?.text,
            "heartCondition": medicalControllers['heart_condition']?.text,
            "diabetes": medicalControllers['diabetes']?.text,
            "epilepsy": medicalControllers['epilepsy']?.text,
            "dizziness": medicalControllers['dizziness']?.text,
            "panting": medicalControllers['panting']?.text,
            "chestPain": medicalControllers['chest_pain']?.text,
            "highBP": medicalControllers['high_bp']?.text,
            "lowBP": medicalControllers['low_bp']?.text,
          },

          "recent": {
            "medication": recentControllers['medication']?.text,
            "pregnant": recentControllers['pregnant']?.text,
            "recentBirth": recentControllers['recent_birth']?.text,
            "dieting": recentControllers['dieting']?.text,
            "hospitalized": recentControllers['hospitalized']?.text,
          },

          "injuries": {
            "neck": injuryControllers['neck']?.text,
            "knee": injuryControllers['knee']?.text,
            "back": injuryControllers['back']?.text,
            "waist": injuryControllers['waist']?.text,
            "majorInjury": majorInjuryController.text,
          },
        },
      ),
    );
    if (success) {
      if (mounted) {
        snackalert(
          context,
          'Member added successfully',
          type: SnackType.success,
        );
        clearAllControllers();
      }
    } else {
      if (mounted) {
        snackalert(context, 'Failed to add member. Please try again.');
      }
    }
  }

  void clearAllControllers() {
    // Basic fields
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    branchController.clear();
    heightController.clear();
    weightController.clear();
    genderController.clear();
    dateOfBirthController.clear();
    dateJoinedController.clear();
    oldMemberController.clear();

    // Emergency Contact
    ecFirstNameController.clear();
    ecLastNameController.clear();
    ecDobController.clear();
    ecPhoneController.clear();
    ecSexController.clear();

    // Physical condition
    physicalConditionController.clear();

    // Medical
    for (var controller in medicalControllers.values) {
      controller.clear();
    }

    // Recent
    for (var controller in recentControllers.values) {
      controller.clear();
    }

    // Injuries
    for (var controller in injuryControllers.values) {
      controller.clear();
    }

    majorInjuryController.clear();

    // Reset dates safely
    dateOfBirth = DateTime.now();
    dateJoined = DateTime.now();
    ecDob = DateTime.now();
    viewMembersListener.rebuild();
    dashboardListener.rebuild();
    // Optional: reset UI
    setState(() {});
  }

  Widget yesNoField(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyWidgets().formText(title, showRequired: true),
        customDivider(height: Sizes.h10),
        CustomFormField(
          controller: controller,
          validator: FormValidators.isFieldEmpty,
          readOnly: true,
          suffixicon: dropDownWidget(),
          onTap: () => yesNoSheet(controller, ['Yes', 'No']),
        ),
        customDivider(height: Sizes.h20),
      ],
    );
  }

  yesNoSheet(TextEditingController controller, List<String> options) {
    bottomSheet(
      context: context,
      title: 'Select',
      body: Column(
        children: options.map((e) {
          return tileOptions(e, context, () {
            controller.text = e;
            Navigator.pop(context);
            setState(() {});
          });
        }).toList(),
      ),
    );
  }

  ecDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1914, 1, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: datePickerTheme(context), child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        ecDob = picked;
        ecDobController.text = stringDateFormatter(ecDob.toIso8601String());
      });
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
          tileOptions('Refinery Road', context, () {
            branchController.text = 'Refinery Road';
            Navigator.pop(context);
          }),
          tileOptions('Jedo', context, () {
            branchController.text = 'Jedo';
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
            setState(() {});
          }),
          tileOptions('No', context, () {
            oldMemberController.text = 'No';
            Navigator.pop(context);
            setState(() {});
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
        dateOfBirthController.text = stringDateFormatter(
          dateOfBirth.toIso8601String(),
        );
      });
    } else {
      return null;
    }
  }

  dateJoinedPicker() async {
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
        dateJoined = DateTime(picked.year, picked.month, picked.day);
        dateJoinedController.text = stringDateFormatter(
          dateJoined.toIso8601String(),
        );
      });
    } else {
      return null;
    }
  }

  String trimController(TextEditingController controller) {
    return controller.text.trim();
  }
}
