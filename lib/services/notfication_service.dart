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
      "type": "service_account",
      "project_id": "udemy-flutter-a2778",
      "private_key_id": "cb3aed0b9d87d7aa443ac690344d22329e8df4ac",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDR1ijJjgrx3Gdz\n5XR612D6HZ0BOQxdQW6VPQB7ushdyxrv0evvYg+qCk2NAT+DIZvPUbfwiuLJqXQO\nz2YddeecfDk6qFSB2kdfkFMwo6jgYgj5QfD6BMC3UfafS5KHN6IUD6pNn7nOL997\nm+A0NVbNo5dS+/DfVpNw/la/yT22tPjXb/ebp+VL6ODV3Jh2HrjJFkp64tWdI1nO\nuFDE2bmyoTgMXTXCVR0cZ8d9w6r+XujKa6h0vDvFsMXF5W4xGE9vDl9wbG1iObrn\nfIk5MN5Vs3O4+AUBlBuYJ/2MrLG3dMjSXCGZFisg9RmNB8eL0ZWch56f2Wt+q3tE\noN00i1v9AgMBAAECggEAMwYgZOJlRuqRPV1ONZCpxCfvRZzZpNOEUEXFGFES57u7\nkRU6ibsOlAptURw8lWZWvNLiJ1ueSesqjW9hJUjGSQbr45eK9Qhe0p4FnI4vQmCU\nTgf60NDXC7yie5mkx7x/bOFiR/3O8JQzg5sjqY5OzTI6WbNpnuUudQtjjL8igoqO\nF/Lu2HYCFB0nN/oJK0VAMI3G98otl9VSfAmyKYT4+IJu4wqLfnUeFn3d4AQA3gjR\nlq28uVFB0ZlCXsET6uoDpN22BEGSyFiwX+vmQpWuIMKwqe0HCCvYebwj3YXx93aj\nyfldRvuwjq9JYzk3AogpIH8iNW6pu1hhyssxK4/gAQKBgQD0WTFfn5kFPsQn19kP\naABSdpZxhisqdCoFlu80I0g6HILW3odiz4v0B8ED508YHfZ4u3GqxcEB1t2NzVkN\nbc5pxGPN1juqmHNBX2vKhptTh5jpiKmgs56dIzrSw6zQfkxowlY8CA51ZWp/3JMo\nBR+AtLKxD7pTc5+Y5/68jZn5XQKBgQDb16x+GUgF7cxhQ2Qo12WrXpzFVRWnh4Nx\nwRmXLo/qjPCCgTfGd2cH/pyrdgomYMQz7AgSpYD1hH6XtrGaqJdJJ49n7qF7sGb6\nKg2Pr5ClsIhElqP3f4Tnv6XAejD697v8U2j+PFLl4yBRbI7uwlboCys+97CV036Q\nk23CNtyjIQKBgC3y59n3hSr7Vp+3c1X2VLktG7VVaaCeH5jVfT3stJRY8DG/vu3R\n4ZuOKbm2MaVzXPnvJbzbWyQhZ6BW0Tw5PeudxrbaZnX6HRJaA0cecO8QPK0Nyfgy\nTs115oXjzgeW+H9qrBS13yIsZA6PSAzqibYGROQO9RbkU0rJtZl3d1DxAoGBAL65\nwOtxUXvbT5n+VnHcVVc0cPv+EhhSx+Wzqljvy2motqvyIQps4pUb/p3+fVXIU8/b\n8TEEJvpZ5V4H4NOVehK8YHzBmZVueBiGzVcf8HTez4n5yuzY09we91UibUX+ETga\nwRb4DM9mmc4qSWK4dZ9AuVcamjeR0dbqIKoC4K4hAoGAZLEO82RG2i79FbPzE312\noUwOglLfmWfZr++7UN2VRe0unaTwzQ6qHzjy5Nklcu5epAVj6QJrz+c2dYsPhv5v\nkhQ8tzeqvrE6alrSITKEe77v1dJlb5UVt9e6pzQYQ4F1BZAdf9ik7KDUHV85Jx7y\naCgJVoXwP1xmOGx4Sss0nYU=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-cgirt@udemy-flutter-a2778.iam.gserviceaccount.com",
      "client_id": "115525569496216657628",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-cgirt%40udemy-flutter-a2778.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
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
