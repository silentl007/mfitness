import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      useAppBar: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: PageView(children: []))],
      ),
    );
  }
}

class OnboardingData {
  String imagePath;
  String title;
  String description;
  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
