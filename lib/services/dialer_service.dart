import 'package:flutter/services.dart';

class DialerService {
  static const MethodChannel _channel = MethodChannel('rekollect/dialer');

  static Future<void> openDialer(String phoneNumber) async {
    if (phoneNumber.trim().isEmpty) return;
    await _channel.invokeMethod<void>('openDialer', phoneNumber.trim());
  }
}
