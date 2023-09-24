import 'package:af_haberleri/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'api/noti_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
    NotifyHelper().initializeNotification();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Af Haberleri',
      theme: ThemeData(
          brightness: Brightness.light, // Normal (açık) mod
          primaryColor: Colors.blue, // Ana renk
          useMaterial3: true
          // Diğer tema ayarları...
          ),
      home: const SplashScreen(),
    );
  }
}
