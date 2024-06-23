import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        provisional: true,
        sound: true,
        carPlay: true,
        criticalAlert: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted   permission");
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print(token);
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void inItLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var andriodIntialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = DarwinInitializationSettings();
    var intilizationSettings = InitializationSettings(
        android: andriodIntialization, iOS: iosInitialization);
    await flutterLocalNotificationsPlugin.initialize(intilizationSettings,
        onDidReceiveNotificationResponse: (payload) {});
  }

  firbaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      print("...................onMessage.......................");
      print(
          "onMessage: ${message.notification!.title} / ${message.notification!.body}  / ${message.data['id']}");

      print(message.data["id"]);
      if (Platform.isIOS) {
      //  forgroundMessage();
      }

      if (Platform.isAndroid) {
        inItLocalNotification(context, message);
        showNotification(context, message);
      } else {
        showNotification(context, message);
      }
    });
  }

  Future<void> showNotification(
      BuildContext context, RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(), 'name',
        importance: Importance.max, showBadge: true);
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: "hello",
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: bigTextStyleInformation,
            ticker: "ticker",
            playSound: true);
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );
    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          1,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }
}
