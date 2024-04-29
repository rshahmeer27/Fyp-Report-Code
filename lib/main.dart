// ignore_for_file: unnecessary_const

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:skoop/screens/user/splash.dart';

import 'constant.dart';
import 'firebase-options.dart';
import 'notification.dart';

// void main() {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(
//   //     // options: DefaultFirebaseOptions.currentPlatform,
//   //     );
//   runApp(const MyApp());
// }
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Noti.showBigTextNotification(
    title: message.notification!.title.toString(),
    body: message.notification!.body.toString(),
    fln: flutterLocalNotificationsPlugin,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // StripePayment.setOptions(
  //   StripeOptions(publishableKey: apiKey),
  // );
  await Firebase.initializeApp(
    // name: 'skoop-customer',
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(() => print('connecteddddddd'));
  // Firebase.initializeApp().whenComplete(() {
  //   print("completed");
  //   // setState(() {});
  // });
  Stripe.publishableKey = apiKey;
  // Stripe.publishableKey = stripePublishableKey;
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  // await Stripe.instance.applySettings();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      Noti.showBigTextNotification(
        title: message.notification!.title.toString(),
        body: message.notification!.body.toString(),
        fln: flutterLocalNotificationsPlugin,
      );
    } else {}
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
              scaffoldBackgroundColor: kBG, primarySwatch: Colors.orange),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
