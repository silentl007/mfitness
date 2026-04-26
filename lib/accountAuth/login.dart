import 'package:flutter/foundation.dart';
import 'package:mfitness/dashboard/dashboard.dart';
import 'package:mfitness/model/services/core/formfield/customformfield.dart';
import 'package:mfitness/model/services/core/formfield/validators.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/mydecor.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';
import 'package:flutter/material.dart';
import 'package:mfitness/model/services/shared_prefs/shared_prefs.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: const EdgeInsets.all(0),
          textScaler: TextScaler.linear(textScale),
        ),
        child: Scaffold(
          body: Padding(
            padding: internalPadding(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: Sizes.h50,
                        width: Sizes.h50,
                        decoration: MyDecor().container(
                          containerColor: myColors.primaryColor,
                          curve: Sizes.w15,
                        ),
                        alignment: Alignment.center,
                        child: textWidget(
                          'M',
                          fontsize: Sizes.w30,
                          fontcolor: Colors.black,
                        ),
                      ),
                      customhorizontal(width: Sizes.w10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(
                            'MFitness',
                            fontweight: FontWeight.bold,
                            fontsize: Sizes.w20,
                          ),
                          customDivider(height: Sizes.h5),
                          textWidget(
                            'ADMIN CONSOLE',
                            fontcolor: Color(0xff6e7277),
                          ),
                        ],
                      ),
                    ],
                  ),
                  customDivider(height: Sizes.h50),
                  textWidget(
                    'Welcome back.',
                    fontsize: Sizes.w25,
                    fontweight: FontWeight.w600,
                  ),
                  customDivider(height: Sizes.h10),
                  textWidget(
                    'Sign in to manage members,\npayments, and performance.',
                    fontcolor: Color(0xffabaeb3),
                    fontsize: Sizes.w20,
                  ),
                  customDivider(height: Sizes.h40),
                  MyWidgets().formText('Email address'),
                  customDivider(height: Sizes.h10),
                  CustomFormField(
                    validator: FormValidators.noValidation,
                    controller: emailController,
                    prefixicon: Icon(Icons.email_outlined),
                  ),
                  customDivider(height: Sizes.h20),
                  MyWidgets().formText('Password'),
                  customDivider(height: Sizes.h10),
                  CustomFormField(
                    validator: FormValidators.noValidation,
                    controller: passwordController,
                    prefixicon: Icon(Icons.lock_outline),
                  ),
                  customDivider(height: Sizes.h50),
                  MyWidgets().button(
                    context: context,
                    proceed: proceed,
                    buttonText: 'Sign in',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  proceed() {
    if (kDebugMode) {
      emailController.text = 'admin@mfitness.com';
      passwordController.text = 'admin123dave';
    }
    if (emailController.text == 'admin@mfitness.com' &&
        passwordController.text == 'admin123dave') {
      prefsHandler.savePrefData(
        type: PrefsType.boolean,
        key: 'skipLogin',
        boolValue: true,
      );
      Navigator.pushReplacement(context, animateRoute(const Dashboard()));
    } else {
      snackalert(context, 'Invalid credentials');
    }
  }
}
