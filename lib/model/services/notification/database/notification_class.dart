const String tableNotification = 'notification';

class NotificationFields {
  static final List<String> values = [
    /// Add all fields
    id, title, body, username, date, isRead, link, buttonText
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String body = 'body';
  static const String username = 'username';
  static const String date = 'date';
  static const String isRead = 'isRead';
  static const String link = 'link';
  static const String buttonText = 'buttonText';
}

class NotificationData {
  String id = '';
  String title = '';
  String body = '';
  String username = '';
  DateTime date = DateTime.now();
  int isRead = 1;
  String link = '';
  String buttonText = '';
  NotificationData({
    required this.date,
    required this.body,
    required this.title,
    required this.username,
  });
  NotificationData.fromJson(Map data) {
    date = DateTime.tryParse(data['date'].toString())!;
    body = data['body'];
    title = data['title'];
    username = data['username'];
    link = data['link'];
    buttonText = data['button_text'] ?? data['buttonText'] ?? 'Learn more';
    id = data['_id'].toString();
    isRead = data['isRead'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'body': body,
      'title': title,
      'username': username,
      'isRead': isRead,
      'link': link,
      'buttonText': buttonText,
    };
  }
}
