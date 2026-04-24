import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';

class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
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
