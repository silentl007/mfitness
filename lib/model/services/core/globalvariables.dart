import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mfitness/model/services/notification/database/notification_class.dart';
import 'package:mfitness/model/services/notification/database/notification_database.dart';

double textScale = 0.9;
Map<String, String> header = {'Content-Type': 'application/json'};
late Flushbar flushbar;
final GlobalKey<ScaffoldState> customdrawerScaffold = GlobalKey();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
ValueNotifier<bool> hasNotificationNotifier = ValueNotifier(false);
List<NotificationData> notifs = [];
bool isLogged = false;
late ClientDatabaseHelper dbHelper;
