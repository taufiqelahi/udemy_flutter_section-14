import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:udemy_flutter_section14/auth_screen.dart';
import 'package:udemy_flutter_section14/splash_screen.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
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
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
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
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          1,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'message') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    }
  }
  Future<void>setupInteraction(BuildContext context)async{
RemoteMessage?intialMessage=await FirebaseMessaging.instance.getInitialMessage();
if(intialMessage!=null){
  handleMessage(context, intialMessage);
}
await FirebaseMessaging.onMessageOpenedApp.listen((event){
  handleMessage(context, event);
});
  }
  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {

    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client
    );

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;

  }
Future<void>sendNotification(data)async{
  final String serverKey = await getAccessToken() ; // Your FCM server key
  final String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/udemy-flutter-a2778/messages:send';
try{
 final response=await http.post(Uri.parse(fcmEndpoint),
      body: json.encode(data),
      headers: {

        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      }
  );

 if(response.statusCode==200){
print("successfully");
 }else{
   print(response.statusCode);
 }
}catch(e){
  print(e);
}
}
}
