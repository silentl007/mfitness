import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mfitness/accountAuth/login.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:flutter/material.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mysizes.dart';
import 'package:mfitness/model/services/core/themes.dart';
import 'package:mfitness/model/services/network/network.dart';
import 'package:mfitness/model/services/notification/database/notification_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dbHelper = ClientDatabaseHelper();
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeClass.themeNotifier,
      builder: (_, mode, __) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp(
            title: 'MFitness',
            debugShowCheckedModeBanner: false,
            // themeMode: mode,
            themeMode: ThemeMode.dark,
            theme: themeClass.lightMode,
            darkTheme: themeClass.darkMode,
            routes: {'/login': (context) => const Login()},
            navigatorKey: navigatorKey,
            builder: (context, child) {
              final screenWidth = MediaQuery.of(context).size.width;
              final isTablet = screenWidth >= 600;
              if (isTablet == false) {
                resolveSizes(context);
              }

              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(textScale)),
                child: isTablet
                    ? Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: LayoutBuilder(
                            builder: (_, constraints) {
                              final height = MediaQuery.of(context).size.height;
                              Sizes().initWithSize(400, height);
                              return child!; // handling for tabs
                            },
                          ),
                        ),
                      )
                    : child!, // handling for regular devices
              );
            },
            home: Login(),
          ),
        );
      },
    );
  }
}

serviceInitialization() async {}
