import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDayIndex = DateTime.now().weekday - 1;
  final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final User? user = FirebaseAuth.instance.currentUser;
  late Stream<StepCount> _stepCountStream;
  int _totalSteps = 0;
  double _caloriesBurned = 0;
  int _duration = 0;

  Map<String, dynamic> localData = {};

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadDataForSelectedDay();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _initializeStepCounter();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activity recognition permission denied')),
      );
    }
  }

  void _initializeStepCounter() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      setState(() {
        _totalSteps = event.steps;
        _caloriesBurned = calculateCaloriesBurned(_totalSteps);
        _duration = (_totalSteps / 1000).round();
      });
      _saveData();
    });
  }

  double calculateCaloriesBurned(int steps) {
    return steps * 0.04;
  }

  Future<void> _saveData() async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    LocalStorage localStorage = LocalStorage();
    await localStorage.writeData(currentDate, _totalSteps, _caloriesBurned, _duration);

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'stepsData': {
          currentDate: {
            'totalSteps': _totalSteps,
            'caloriesBurned': _caloriesBurned,
            'duration': _duration,
          }
        }
      }, SetOptions(merge: true));
    }
  }

  Future<void> _loadDataForSelectedDay() async {
    String selectedDate = _getDateForSelectedDay();
    bool dataFetched = false;

    // Try fetching from Firestore first
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists && userDoc['stepsData'] != null && userDoc['stepsData'][selectedDate] != null) {
        setState(() {
          _totalSteps = userDoc['stepsData'][selectedDate]['totalSteps'] ?? 0;
          _caloriesBurned = userDoc['stepsData'][selectedDate]['caloriesBurned'] ?? 0.0;
          _duration = userDoc['stepsData'][selectedDate]['duration'] ?? 0;
        });
        dataFetched = true;
      }
    }

    // Fallback to local storage if Firestore data is unavailable
    if (!dataFetched) {
      LocalStorage localStorage = LocalStorage();
      localData = await localStorage.readData();
      if (localData.containsKey(selectedDate)) {
        setState(() {
          _totalSteps = localData[selectedDate]['totalSteps'];
          _caloriesBurned = localData[selectedDate]['caloriesBurned'];
          _duration = localData[selectedDate]['duration'];
        });
      } else {
        setState(() {
          _totalSteps = 0;
          _caloriesBurned = 0;
          _duration = 0;
        });
      }
    }
  }

  String _getDateForSelectedDay() {
    DateTime today = DateTime.now();
    DateTime selectedDate = today.subtract(Duration(days: today.weekday - (selectedDayIndex + 1)));
    return DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEEE, dd MMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentDate,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedDayIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                        _loadDataForSelectedDay();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryColor2 : const Color.fromARGB(255, 245, 245, 245),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            daysOfWeek[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Recent Activity',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  activityCard('Steps Counter', '$_totalSteps steps', Icons.directions_walk, Colors.white, Colors.pink),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  activityCard('Calories Burned', '${_caloriesBurned.toInt()} kcal', Icons.local_fire_department, Colors.white, Colors.red),
                  activityCard('Duration', '$_duration min', Icons.access_time, Colors.white, Colors.blue),
                ],
              ),
              const SizedBox(height: 20),
              // Placeholder for Trending Workout Section
              Text(
                'Trending Workouts',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              trendingWorkoutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget activityCard(String title, String value, IconData icon, Color iconColor, Color cardColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: iconColor),
              const SizedBox(height: 10),
              Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(value, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  // Dummy trending workout section, replace with actual data and UI components
  Widget trendingWorkoutSection() {
    return ListView.builder(
      shrinkWrap: true,  // Prevent scrolling from affecting the layout
      physics: NeverScrollableScrollPhysics(), // Disable scrolling
      itemCount: 5, // Replace with actual number of workouts
      itemBuilder: (context, index) {
        return Card(
          color: Colors.blueAccent,
          child: ListTile(
            title: Text('Trending Workout ${index + 1}', style: TextStyle(color: Colors.white)),
            subtitle: Text('Description for trending workout ${index + 1}', style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
}

class LocalStorage {
  Future<void> writeData(String date, int totalSteps, double caloriesBurned, int duration) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/step_data.json');
    Map<String, dynamic> data = {};
    if (await file.exists()) {
      data = jsonDecode(await file.readAsString());
    }
    data[date] = {
      'totalSteps': totalSteps,
      'caloriesBurned': caloriesBurned,
      'duration': duration,
    };
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>> readData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/step_data.json');
    if (await file.exists()) {
      return jsonDecode(await file.readAsString());
    }
    return {};
  }
}
