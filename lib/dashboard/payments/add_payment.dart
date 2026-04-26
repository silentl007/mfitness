import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/enums.dart';
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

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  @override
  void initState() {
    super.initState();
    startDateController.text = stringDateFormatter(
      DateTime.now().toIso8601String(),
    );
    getMembers();
  }

  getMembers() async {
    members = [];
    members = await dbHelper.getAllClients();
    filterMembers = members;
    setState(() {});
  }

  late ClientProfileData selectedMember;
  List<ClientProfileData> members = [];
  List<ClientProfileData> filterMembers = [];
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullNameMemberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController durationTypeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  DateTime startDate = DateTime.now();
  late DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      titleText: 'Add Payment',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            'Payment',
            fontsize: Sizes.w25,
            fontweight: FontWeight.w600,
          ),
          customDivider(height: Sizes.h10),
          textWidget(
            "Enter the payment info",
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
                    MyWidgets().formText('Member'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: fullNameMemberController,
                      suffixicon: dropDownWidget(),
                      readOnly: true,
                      onTap: memberSheet,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Amount'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isNumber,
                      controller: amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Duration'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isNumber,
                      controller: durationController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      onChanged: (text) {
                        if (text != null &&
                            int.tryParse(text) != null &&
                            durationTypeController.text.isNotEmpty) {
                          calculateEndDate();
                        }
                      },
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Duration type'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: durationTypeController,
                      suffixicon: dropDownWidget(),
                      readOnly: true,
                      onTap: durationTypeSheet,
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Start date'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: startDateController,
                      readOnly: true,
                      onTap: () {
                        if (durationController.text.trim().isNotEmpty &&
                            durationController.text.trim().isNotEmpty) {
                          startDatePicker();
                        } else {
                          snackalert(
                            context,
                            'Please set both duration and duration type before proceeding',
                          );
                        }
                      },
                    ),
                    customDivider(height: Sizes.h20),
                    MyWidgets().formText('Expiration date'),
                    customDivider(height: Sizes.h10),
                    CustomFormField(
                      validator: FormValidators.isFieldEmpty,
                      controller: endDateController,
                      readOnly: true,
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
      confirmPayment();
    }
  }

  confirmPayment() {
    bottomSheet(
      context: context,
      title: 'Confirm Payment',
      height: Sizes.h350,
      body: Column(
        children: [
          customDivider(height: Sizes.h10),
          textWidget(
            'Are you sure you want to add payment? You cannot delete payment once added.\n\nAdd payment for member ${selectedMember.firstName} ${selectedMember.lastName} the sum of ${moneyformatter(double.tryParse(amountController.text) ?? 0)} for the duration of ${durationController.text} ${durationTypeController.text} to branch ${branchController.text}',
            fontsize: Sizes.w18,
            fontweight: FontWeight.w700,
          ),
          const Spacer(),
          MyWidgets().button(
            context: context,
            proceed: () async {
              Navigator.pop(context);
              addPayment();
            },
            buttonText: 'Yes, add payment',
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

  addPayment() async {
    bool success = await dbHelper.insertPayment(
      ClientPaymentData(
        clientId: selectedMember.id,
        firstName: selectedMember.firstName,
        lastName: selectedMember.lastName,
        durationType: durationTypeController.text,
        datePaid: startDate,
        expirationDate: endDate,
        duration: jsonToInt(durationController.text),
        amountPaid: jsonToInt(amountController.text),
        branch: branchController.text,
      ),
    );
    if (success) {
      if (mounted) {
        snackalert(
          context,
          'Payment added successfully',
          type: SnackType.success,
        );
        fullNameMemberController.clear();
        amountController.clear();
        durationController.clear();
        durationTypeController.clear();
        endDateController.clear();
        branchController.clear();
        paymentListener.rebuild();
        dashboardListener.rebuild();
      }
    } else {
      if (mounted) {
        snackalert(context, 'Failed to add member. Please try again.');
      }
    }
  }

  List<String> durationOptions = ['Day', 'Week', 'Month', 'Year'];

  durationTypeSheet() {
    bottomSheet(
      context: context,
      title: 'Duration Type',
      body: Column(
        children: List.generate(
          durationOptions.length,
          (index) => tileOptions(durationOptions[index], context, () {
            durationTypeController.text = durationOptions[index];
            Navigator.pop(context);
            if (int.tryParse(durationController.text) != null) {
              calculateEndDate();
            }
          }),
        ),
      ),
    );
  }

  startDatePicker() async {
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
        startDate = DateTime(picked.year, picked.month, picked.day);
        startDateController.text = stringDateFormatter(
          startDate.toIso8601String(),
        );
        calculateEndDate();
      });
    } else {
      return null;
    }
  }

  calculateEndDate() {
    String type = durationTypeController.text;
    if (type == 'Day') {
      endDate = startDate.add(
        Duration(days: jsonToInt(durationController.text)),
      );
    } else if (type == 'Week') {
      endDate = startDate.add(
        Duration(days: jsonToInt(durationController.text) * 7),
      );
    } else if (type == 'Month') {
      endDate = startDate.add(
        Duration(days: jsonToInt(durationController.text) * 30),
      );
    } else {
      endDate = startDate.add(
        Duration(days: jsonToInt(durationController.text) * 365),
      );
    }
    endDateController.text = stringDateFormatter(endDate.toIso8601String());
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

  memberSheet() {
    bottomSheet(
      context: context,
      title: 'Select Member',
      height: Sizes.h600,
      body: StatefulBuilder(
        builder: (context, newState) {
          return Column(
            children: [
              customDivider(height: Sizes.h20),
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
              customDivider(height: Sizes.h20),
              Expanded(
                child: filterMembers.isEmpty
                    ? noItem(
                        context: context,
                        message: 'No members found',
                        showButton: false,
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
        },
      ),
    );
  }

  Widget memberWidget(ClientProfileData data) => CustomGestureDetector(
    onTap: () {
      Navigator.pop(context);
      fullNameMemberController.text = '${data.firstName} ${data.lastName}';
      selectedMember = data;
      branchController.text = selectedMember.branch;
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
