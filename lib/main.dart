import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:udemy_flutter_section14/screen/auth_screen.dart';
import 'package:udemy_flutter_section14/screen/all_chat_screen.dart';
import 'package:udemy_flutter_section14/firebase_options.dart';
import 'package:udemy_flutter_section14/screen/splash_screen.dart';
import 'package:udemy_flutter_section14/screen/user_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

@pragma('vm:entry-point')
Future<void> firbaseMessageBackgroundHandeler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handler a background message${message.messageId}');
  }
}
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  await dotenv.load(fileName: ".env");
  //Stripe.publishableKey= dotenv.env["STRIPE_PUBLISH_KEY"]!;
  //await Stripe.instance.applySettings();
  FirebaseMessaging.onBackgroundMessage(firbaseMessageBackgroundHandeler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(App(navigatorKey: navigatorKey));
  });
}

class App extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const App({super.key, required this.navigatorKey});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.hasData) {
              return  UserListScreen();
            }

            return const AuthScreen();
          }),
    );
  }
}
