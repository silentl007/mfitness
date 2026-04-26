import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/data_sync/google_drive.dart';
import 'package:mfitness/model/services/core/enums.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';
import 'package:mfitness/model/services/shared_prefs/shared_prefs.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DataSync extends StatefulWidget {
  const DataSync({super.key});

  @override
  State<DataSync> createState() => _DataSyncState();
}

class _DataSyncState extends State<DataSync> {
  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  late String filePath;
  bool isLoggedIn = false;
  String email = 'N/A';
  String name = 'N/A';
  DateTime? dateBackedUp;
  checkLoggedIn() async {
    filePath = path.join(await getDatabasesPath(), 'client_management.db');
    isLoggedIn = await prefsHandler.isLogged;
    if (isLoggedIn) {
      email = await prefsHandler.emailAddress;
      dateBackedUp = jsonStringToDate(await prefsHandler.lastBacked);
      name = await prefsHandler.name;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset('assets/icons/png/googleIcon.png', width: Sizes.w30),
            customhorizontal(width: Sizes.w10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                    email,
                    fontsize: Sizes.w18,
                    fontweight: FontWeight.w700,
                  ),
                  textWidget(name, fontcolor: myColors.formTextColor),
                ],
              ),
            ),
          ],
        ),
        customDivider(height: Sizes.h20),
        MyWidgets().button(
          context: context,
          buttonText: isLoggedIn ? 'Backup Data' : 'Sign in with Google',
          proceed: inappwait,
        ),
        customDivider(height: Sizes.h3),
        textWidget(
          'Last backup: ${dateBackedUp == null ? 'Never' : transactionDateFormatter(dateBackedUp!.toIso8601String())}',
        ),
        const Spacer(),
        MyWidgets().button(
          context: context,
          buttonText: 'Import Backup',
          buttonColor: Colors.blue,
          buttonTextColor: Colors.white,
          proceed: () async {
            // after picking file and restores successfully, run await ClientDatabaseHelper().database; to open db again
          },
        ),
      ],
    );
  }

  backupData() async {
    try {
      GoogleSignInResult signIn = isLoggedIn
          ? await gDriveInstance.silentLogin()
          : await gDriveInstance.signInWithGoogle();
      if (signIn.state == EmailAuthState.success) {
        return await uploadBackup(signIn.token);
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadBackup(String oAuth) async {
    String? id = await gDriveInstance.uploadFileHTTP(
      file: File(filePath),
      accessToken: oAuth,
    );
    if (id != null) {
      return true;
    }
    return false;
  }

  inappwait() {
    Future future = backupData();
    return showDialog(
      context: context,
      builder: (context) => FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return loadingDiag();
          } else if (snapshot.data == true) {
            success();
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  success() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      prefsHandler.savePrefData(
        key: 'lastBacked',
        stringValue: DateTime.now().toIso8601String(),
        type: PrefsType.string,
      );
      snackalert(context, 'Backed up successfully', type: SnackType.success);
      checkLoggedIn();
    });
  }

  failed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      snackalert(context, 'Backed up failed');
    });
  }
}
