import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmRepository {
  final Dio _dio;

  FcmRepository(this._dio);

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus;
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> sendTokenToBackend(String userId, String fcmToken) async {
    await _dio.patch(
      'usuari/fcm-token',
      data: {'fcmToken': fcmToken},
      options: Options(
        headers: {'usuari-id': userId},
        contentType: 'application/json',
      ),
    );
  }
}
