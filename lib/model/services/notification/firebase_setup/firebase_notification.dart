import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mfitness/model/services/core/listeners.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/notification/local_notification/local_notification.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await FirebaseNotification().saveNotificationLocally(message);
}

class FirebaseNotification {
  String? fcmToken;
  String? get getFcmToken => fcmToken;

  initFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  requestPermission() async {
    try {
      var request = await FirebaseMessaging.instance.getNotificationSettings();
      if (request.authorizationStatus == AuthorizationStatus.authorized) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } else {
        await FirebaseMessaging.instance.requestPermission(
          sound: true,
          badge: true,
          alert: true,
          provisional: true,
        );
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      myLog(name: 'notification token', logContent: fcmToken);
    } catch (e) {
      myLog(name: 'botification error', logContent: e);
    }
  }

  notificationInitialization() {
    LocalNotificationService.initilize();
    // Terminated State
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        saveNotificationLocally(event);
      }
    });
    // Foreground State
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.showNotificationOnForeground(event);

      saveNotificationLocally(event);
    });
    // background State
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data['link'] != null &&
          (event.data['link'].contains('http') ||
              event.data['link'].contains('https'))) {
        openURL(event.data['link']);
      }
    });
  }

  /// Save notification message to SharedPreferences
  Future<void> saveNotificationLocally(RemoteMessage message) async {
    myPrint(' received notification ');
    try {
      myPrint('processing notification');
      notificationPageListener.rebuild();
    } catch (e) {
      myPrint(' error notification $e ');
    }
  }
}

FirebaseNotification firebaseNotification = FirebaseNotification();
