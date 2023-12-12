import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mero_store/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../request.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'loading_screen.dart';

Timer? timer;
bool waitingForResponse = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.request();
  NotificationService().initNotification();
  await initializeService();

  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  int delaySeconds =  20;

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(seconds: delaySeconds), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        if (!waitingForResponse) {
          waitingForResponse = true;
          if (kDebugMode) {
            print("Background request made");
          }
          await Requests.getNotifications('#true#');
          if (kDebugMode) {
            print("Background request successful");
          }
          waitingForResponse = false;
        }
      }
    }
  });
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> globalNavKey = GlobalKey();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavKey,
      home: const LoadingScreen(), // Use the SplashScreen widget as the initial screen
    );
  }
}
