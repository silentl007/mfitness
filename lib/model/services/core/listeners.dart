import 'package:flutter/material.dart';

class NotificationPageListener extends ChangeNotifier {
  rebuild() {
    notifyListeners();
  }
}

class DashboardListener extends ChangeNotifier {
  rebuild() {
    notifyListeners();
  }
}

class ViewMembersListener extends ChangeNotifier {
  rebuild() {
    notifyListeners();
  }
}

class PaymentListener extends ChangeNotifier {
  rebuild() {
    notifyListeners();
  }
}

DashboardListener dashboardListener = DashboardListener();
ViewMembersListener viewMembersListener = ViewMembersListener();
PaymentListener paymentListener = PaymentListener();

NotificationPageListener notificationPageListener = NotificationPageListener();
