import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/custom_safearea.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
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
    endpoint = endPoint();
  }

  late Future<bool> endpoint;
  String backendMessage = '';
  Future<bool> endPoint() async {
    NetworkResponse netCall =
        await NetworkService.instance.get(path: 'path', customHeader: header);
    if (netCall.statusCode == 200 || netCall.statusCode == 201) {
      try {
        return true;
      } catch (e) {
        myLog(name: 'error occurred', logContent: e);
        return false;
      }
    } else {
      backendMessage = errorMessage(netCall.networkData!);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      body: futureBuild(),
    );
  }

  Widget futureBuild() {
    return FutureBuilder(
      future: endpoint,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return futureLoading();
        } else if (snapshot.data == true) {
          return body();
        } else {
          return networkfailed(
            context,
            errorMessage: backendMessage,
            () {
              setState(() {
                endpoint = endPoint();
              });
            },
          );
        }
      },
    );
  }

  Widget body() => Container();
}
