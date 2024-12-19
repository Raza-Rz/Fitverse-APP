import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/view/activity/workout_cards.dart';

import 'package:flutter/material.dart';
import 'package:fitverse/view/profile/profile_new.dart';
import 'package:permission_handler/permission_handler.dart';

import '../home/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/DashboardScreen";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectTab = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ActivityScreen(),
    const RefinedProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();  // Call permission check on screen load
  }

  Future<void> _checkNotificationPermission() async {
    // Check for notification permissions
    if (Platform.isIOS) {
      // iOS-specific code
      final permissionStatus = await Permission.notification.status;
      if (!permissionStatus.isGranted) {
        _requestNotificationPermission();
      }
    } else if (Platform.isAndroid) {
      // Android-specific code
      final permissionStatus = await Permission.notification.status;
      if (!permissionStatus.isGranted) {
        _requestNotificationPermission();
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    // Request permission for notifications
    if (Platform.isIOS) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        print('Notification Permission granted');
      } else {
        print('Notification Permission denied');
      }
    } else if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        print('Notification Permission granted');
      } else {
        print('Notification Permission denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: IndexedStack(
        index: selectTab,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomAppBar(
        height: Platform.isIOS ? 70 : 65,
        color: Colors.transparent,
        padding: const EdgeInsets.all(0),
        child: Container(
          height: Platform.isIOS ? 70 : 65,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadiusDirectional.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(31, 49, 49, 49),
                  blurRadius: 6,
                  offset: Offset(0, -2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                icon: "assets/icons/home_icon.png",
                selectIcon: "assets/icons/home_select_icon.png",
                isActive: selectTab == 0,
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectTab = 0;
                    });
                  }
                },
              ),
              TabButton(
                icon: "assets/icons/activity_icon.png",
                selectIcon: "assets/icons/activity_select_icon.png",
                isActive: selectTab == 1,
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectTab = 1;
                    });
                  }
                },
              ),
              TabButton(
                icon: "assets/icons/user_icon.png",
                selectIcon: "assets/icons/user_select_icon.png",
                isActive: selectTab == 2,
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectTab = 2;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final bool isActive;
  final VoidCallback onTap;

  const TabButton({
    Key? key,
    required this.icon,
    required this.selectIcon,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? selectIcon : icon,
            width: 25,
            height: 25,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: isActive ? 8 : 12),
          Visibility(
            visible: isActive,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.secondaryG),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
        ],
      ),
    );
  }
}
