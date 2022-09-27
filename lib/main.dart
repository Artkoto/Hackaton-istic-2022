import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackaton_obsidian/pages/error_page.dart';
import 'package:hackaton_obsidian/pages/home_page.dart';
import 'package:hackaton_obsidian/pages/loading_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late final Future<FirebaseApp> _initialization;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.notification!.title,
    message.notification!.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        icon: 'launch_background',
      ),
    ),
  );
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize firebase app (required)
  _initialization = Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State {
  String? token;

  @override
  initState() {
    super.initState();

    if (!kIsWeb) {
      FirebaseMessaging.instance.subscribeToTopic("all");

      var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);


      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'launch_background',
              ),
            ),
          );
        }
      });
      getToken();
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Trans Musicales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // Call HomePage from pages/home_page.dart

      home: FutureBuilder(future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const ErrorPage();
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return const LoadingPage();
        },
    )
    );
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print(token);
  }
}
