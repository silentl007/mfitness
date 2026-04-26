import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mfitness/dashboard/data_sync/google_drive.dart';
import 'package:mfitness/model/services/core/enums.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/mycolors.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/mywidgets.dart';
import 'package:mfitness/model/services/notification/database/notification_database.dart';
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
          proceed: importBackUp,
        ),
      ],
    );
  }

  String dbPath = '';
  importBackUp() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowedExtensions: ['db'],
      type: FileType.custom
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      bool isValid = await dbHelper.isValidBackupDb(file.path);
      if (isValid) {
        dbPath = file.path;
        confirmRestore();
      } else {
        if (mounted) {
          snackalert(
            context,
            'Invalid database. Please restore using a database you backed up using the app',
          );
        }
      }
    } else {
      if (mounted) {
        snackalert(context, 'Operation cancelled');
      }
    }
  }

  confirmRestore() {
    bottomSheet(
      context: context,
      title: 'Confirm Import',
      height: Sizes.h500,
      body: Column(
        children: [
          textWidget(warning, fontsize: Sizes.w18, fontweight: FontWeight.w700),
          const Spacer(),
          MyWidgets().button(
            context: context,
            proceed: () async {
              Navigator.pop(context);
              bool isRestored = await dbHelper.restoreDatabaseFromFile(dbPath);
              if (isRestored) {
                await ClientDatabaseHelper().database;
                if (mounted) {
                  snackalert(
                    context,
                    'Backup restored',
                    type: SnackType.success,
                  );
                }
              } else {
                if (mounted) {
                  snackalert(context, 'Unable to restore. Please try again');
                }
              }
            },
            buttonText: 'I accept, continue',
          ),
          customDivider(height: Sizes.h10),
          MyWidgets().button(
            context: context,
            buttonColor: Colors.red,
            buttonTextColor: Colors.white,
            proceed: () {
              Navigator.pop(context);
            },
            buttonText: 'No, stop',
          ),
        ],
      ),
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

String warning =
    '''⚠️ Warning: Completing this process will permanently overwrite all existing data currently stored in the app and replace it with the selected backup data. This action cannot be undone or reversed. Please ensure you have selected the correct backup file before continuing.
 ''';
