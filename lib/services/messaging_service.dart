import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  const MessagingService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<void> initializeForRole(String role) async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await _messaging.getToken();
    if (role == 'collector') {
      await _messaging.subscribeToTopic('collectors');
    } else {
      await _messaging.subscribeToTopic('generators');
    }
  }
}
