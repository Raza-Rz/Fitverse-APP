import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tzData;

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;


Future<void> _checkAndRequestExactAlarmPermission() async {
  PermissionStatus status = await Permission.notification.status;

  if (!status.isGranted) {
    // Request permission if not granted
    await Permission.notification.request();
  }

  // Request SET_EXACT_ALARM permission
  PermissionStatus alarmStatus = await Permission.sms.request();
  if (alarmStatus.isDenied) {
    print("Exact alarm permission denied.");
  }
}

class SettingsScreen extends StatefulWidget {
  static String routeName = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _motivationalNotificationsEnabled = true;
  bool _stepCountReminderEnabled = true;
  TimeOfDay _motivationalTime = TimeOfDay(hour: 8, minute: 0);  // Default to 8:00 AM
  TimeOfDay _stepCountTime = TimeOfDay(hour: 18, minute: 0);  // Default to 6:00 PM
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadNotificationPreferences();
    _initializeNotifications();
  }

  // Initialize time zone and local notifications
  void _initializeNotifications() async {
    // Initialize timezone data
        tzData.initializeTimeZones();

        try {
          // Get the local timezone using flutter_timezone
          final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

          // Set the timezone dynamically
          tz.setLocalLocation(tz.getLocation(currentTimeZone));

          print("Current Timezone: $currentTimeZone");
        } catch (e) {
          print("Error fetching timezone: $e");
        }
  }

  // Load notification preferences from SharedPreferences
  void _loadNotificationPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _motivationalNotificationsEnabled = prefs.getBool('motivationalNotificationsEnabled') ?? true;
      _stepCountReminderEnabled = prefs.getBool('stepCountReminderEnabled') ?? true;
      _motivationalTime = _getTimeOfDay(prefs.getString('motivationalTime') ?? "08:00");
      _stepCountTime = _getTimeOfDay(prefs.getString('stepCountTime') ?? "18:00");
    });
  }

  // Helper function to convert string time into TimeOfDay
  TimeOfDay _getTimeOfDay(String timeString) {
    final parts = timeString.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Save notification preferences to SharedPreferences
  void _saveNotificationPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('motivationalNotificationsEnabled', _motivationalNotificationsEnabled);
    await prefs.setBool('stepCountReminderEnabled', _stepCountReminderEnabled);
    await prefs.setString('motivationalTime', "${_motivationalTime.hour}:${_motivationalTime.minute}");
    await prefs.setString('stepCountTime', "${_stepCountTime.hour}:${_stepCountTime.minute}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",
        style: TextStyle(
        color: Colors.black,
         fontSize: 22,
          fontWeight: FontWeight.bold,
           ),),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Motivational Notification toggle
            SwitchListTile(
              title: const Text("Motivational Workout Notifications"),
              subtitle: const Text("Receive motivational reminders for your workouts."),
              value: _motivationalNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _motivationalNotificationsEnabled = value;
                  _saveNotificationPreferences();
                  if (value) {
                    _scheduleDailyMotivationalNotification();
                  } else {
                    _cancelMotivationalNotification();
                  }
                });
              },
              activeColor: Colors.green, // Custom toggle color
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade300,
            ),

            // Time Picker for Motivational Notification
            if (_motivationalNotificationsEnabled)
              ListTile(
                title: const Text("Set Notification Time"),
                subtitle: Text("${_motivationalTime.format(context)}"),
                onTap: () async {
                  final TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: _motivationalTime,
                  );
                  if (selectedTime != null && selectedTime != _motivationalTime) {
                    setState(() {
                      _motivationalTime = selectedTime;
                    });
                    _saveNotificationPreferences();
                    _scheduleDailyMotivationalNotification();
                  }
                },
              ),

            const SizedBox(height: 20),

            // Step Count Reminder toggle
            SwitchListTile(
              title: const Text("Step Count & Calorie Reminder"),
              subtitle: const Text("Get reminded to check your step count and calories burned."),
              value: _stepCountReminderEnabled,
              onChanged: (value) {
                setState(() {
                  _stepCountReminderEnabled = value;
                  _saveNotificationPreferences();
                  if (value) {
                    _scheduleStepCountAndCalorieReminder();
                  } else {
                    _cancelStepCountReminder();
                  }
                });
              },
              activeColor: Colors.blue, // Custom toggle color
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade300,
            ),

            // Time Picker for Step Count Reminder
            if (_stepCountReminderEnabled)
              ListTile(
                title: const Text("Set Reminder Time"),
                subtitle: Text("${_stepCountTime.format(context)}"),
                onTap: () async {
                  final TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: _stepCountTime,
                  );
                  if (selectedTime != null && selectedTime != _stepCountTime) {
                    setState(() {
                      _stepCountTime = selectedTime;
                    });
                    _saveNotificationPreferences();
                    _scheduleStepCountAndCalorieReminder();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  // Schedule a daily motivational notification
  void _scheduleDailyMotivationalNotification() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_motivation_channel',
      'Daily Motivations',
      channelDescription: 'Daily motivational workout reminders',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time for your workout!',
      'Let\'s crush those fitness goals today!',
      _nextInstanceOfTime(_motivationalTime.hour, _motivationalTime.minute), // Schedule based on user time
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Schedule daily step count and calorie burn reminder
  void _scheduleStepCountAndCalorieReminder() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'step_count_and_calories_channel',
      'Step Count and Calories',
      channelDescription: 'Reminder to check your step count and calories burned.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Check your steps and calories',
      'Don\'t forget to track your step count and calories burned!',
      _nextInstanceOfTime(_stepCountTime.hour, _stepCountTime.minute), // Schedule based on user time
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Utility function to calculate the next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Cancel motivational notification
  void _cancelMotivationalNotification() {
    flutterLocalNotificationsPlugin.cancel(0);
  }

  // Cancel step count and calorie reminder
  void _cancelStepCountReminder() {
    flutterLocalNotificationsPlugin.cancel(1);
  }
}
