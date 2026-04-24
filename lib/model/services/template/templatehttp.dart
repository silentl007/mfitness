import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';
import 'package:mfitness/model/services/network/network.dart';


class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [customDivider(height: Sizes.h15)],
      ),
    );
  }

  proceed() {
    FocusScope.of(context).unfocus();
    inappwait();
  }

  inappwait() {
    Future future = endpoint();
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return loadingDiag();
              } else if (snapshot.data == 200 || snapshot.data == 201) {
                success();
                return Container();
              } else {
                return Container();
              }
            }));
  }

  endpoint() async {
    Map<String, dynamic> body = {};
    NetworkResponse netCall = await NetworkService.instance
        .post(path: 'path', body: body, customHeader: header);
    if (netCall.statusCode == 200 || netCall.statusCode == 201) {
      return netCall.statusCode;
    } else {
      if (mounted) {
        networkfeedback(context, errorMessage(netCall.networkData!));
      }
      return false;
    }
  }

  success() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const Screen()),
      //     (route) => false);
    });
  }
}
