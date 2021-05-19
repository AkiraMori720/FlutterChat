import 'package:chat/services/cloud_messaging_service/cloud_message_repository.dart';
import 'package:chat/utils/failure.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessagingImpl implements CloudMessageRepository {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  static bool isConfigured = false;
  static String previousMessageId = '';
  @override
  void configure({onAppMessage, onAppLaunch, onAppResume}) {
    if (!isConfigured) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          if (onAppMessage != null ) {
            final String senderId = message.senderId;
            onAppMessage(senderId);
          }
        });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        if (onAppLaunch != null && previousMessageId == message.messageId) {
          previousMessageId = message.messageId;
          final String senderId = message.senderId;
          print('firebase');
          onAppLaunch(senderId);
        }
      });
        // onResume: (message) async {
        //   if (onAppResume != null) {
        //     final String senderId = message['data']['senderId'];
        //     onAppResume(senderId);
        //   }
        // },
      isConfigured = true;
    }
  }

  @override
  Future<String> getToken() async {
    try {
      String token = await fcm.getToken();
      return token;
    } catch (e) {
      throw UnImplementedFailure();
    }
  }
}
