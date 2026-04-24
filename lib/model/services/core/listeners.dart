import 'package:flutter/material.dart';

class NotificationPageListener extends ChangeNotifier {
  rebuild() {
    notifyListeners();
  }
}

NotificationPageListener notificationPageListener = NotificationPageListener();
