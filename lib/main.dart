import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitverse/routes.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/view/dashboard/dashboard_screen.dart';
import 'package:fitverse/view/login/login_screen.dart';
import 'package:fitverse/view/on_boarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;
import 'package:flutter_timezone/flutter_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initializeNotifications();

  if (Platform.isAndroid) {
    await checkAndRequestExactAlarmPermission(); // Request alarm permission for Android
  }

  runApp(const MyApp());
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  final bool? initialized = await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: _onSelectNotification,
  );

  if (initialized != null && initialized) {
    print("Notifications initialized successfully.");
  } else {
    print("Error initializing notifications.");
  }

  // Initialize Timezones globally
  tzData.initializeTimeZones();
  
  try {
    // Fetch current timezone and set it
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    print("Current Time Zone: $currentTimeZone");
  } catch (e) {
    print("Error fetching time zone: $e");
  }
}

Future<void> checkAndRequestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    const MethodChannel channel = MethodChannel('dexterx.dev/flutter_local_notifications');
    try {
      final bool isPermitted = await channel.invokeMethod('checkExactAlarmPermission');
      if (!isPermitted) {
        final bool granted = await channel.invokeMethod('requestExactAlarmPermission');
        if (!granted) {
          print("Exact alarm permission was not granted.");
        }
      }
    } catch (e) {
      print("Error requesting exact alarm permission: $e");
    }
  }
}

void _onSelectNotification(NotificationResponse response) async {
  print('Notification tapped: ${response.payload}');

  // You can use the payload to navigate or show a dialog.
  if (response.payload != null) {
    // Handle the action for the notification, example navigation or screen action
    if (response.payload == 'motivationalNotification') {
      print('Navigating to Motivational Screen...');
    } else if (response.payload == 'stepCountReminder') {
      print('Navigating to Step Count Screen...');
    }
  }
}

// Rest of the code remains unchanged (MyApp, SplashScreen, etc.)


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _initialScreen = const SplashScreen();

  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!seenOnboarding) {
      _initialScreen = const OnBoardingScreen();
    } else if (isLoggedIn) {
      _initialScreen = const DashboardLoader();
    } else {
      _initialScreen = const LoginScreen();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitverse',
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor1,
        scaffoldBackgroundColor: AppColors.whiteColor,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: _initialScreen,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/splash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class DashboardLoader extends StatefulWidget {
  const DashboardLoader({Key? key}) : super(key: key);

  @override
  State<DashboardLoader> createState() => _DashboardLoaderState();
}

class _DashboardLoaderState extends State<DashboardLoader> {
  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn && savedEmail != null && savedPassword != null) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: savedEmail,
          password: savedPassword,
        );

        _scheduleDailyNotifications();
        _navigateToScreen(const DashboardScreen());
      } catch (e) {
        print('Auto-login failed: $e');
        _navigateToScreen(const LoginScreen());
      }
    } else {
      _navigateToScreen(const LoginScreen());
    }
  }

  void _scheduleDailyNotifications() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_motivation_channel',
      'Daily Motivations',
      channelDescription: 'Daily motivational workout reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );

    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time for your workout!',
      'Let\'s crush those fitness goals today!',
      _nextInstanceOfTime(8, 0),
      const NotificationDetails(android: androidDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  void _navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
