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

  Map<String, dynamic> localData = {}; // Store local data for all days

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadLocalData(); // Load data on init
  }

  Future<void> _requestPermissions() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _initializeStepCounter();
    } else {
      print('Activity recognition permission denied');
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
      _logStepsLocally(); // Log steps in local storage
    });
  }

  double calculateCaloriesBurned(int steps) {
    return steps * 0.04;
  }

  void _logStepsLocally() async {
    if (user != null) {
      LocalStorage localStorage = LocalStorage();
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await localStorage.writeData(currentDate, _totalSteps, _caloriesBurned, _duration);
    }
  }

  Future<void> _loadLocalData() async {
    LocalStorage localStorage = LocalStorage();
    Map<String, dynamic> data = await localStorage.readData();
    setState(() {
      localData = data;
      _fetchDataForSelectedDay(); // Fetch data for current day on init
    });
  }

  Future<void> _fetchDataForSelectedDay() async {
    String selectedDate = _getDateForSelectedDay();
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
              // Top bar with date and profile icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentDate,
                    style: TextStyle(color: const Color.fromARGB(255, 12, 12, 12), fontSize: 14),
                  ),
                  // CircleAvatar(
                  //   backgroundColor: AppColors.primaryColor1,
                  //   child: Icon(Icons.person, color: Colors.white),
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Dashboard',
                style: TextStyle(
                  color: const Color.fromARGB(255, 26, 26, 26),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Weekday Selector
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
                        _fetchDataForSelectedDay(); // Fetch the data when a day is tapped
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryColor2 : const Color.fromARGB(255, 247, 247, 247),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            daysOfWeek[index],
                            style: TextStyle(
                              color: isSelected ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
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

              // Recent Activity Section
              Text(
                'Recent Activity',
                style: TextStyle(
                  color: const Color.fromARGB(255, 36, 36, 36),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Display the tracked steps in one row, and calories and duration in a second row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Row with Steps
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      activityCard('Steps Counter', '$_totalSteps steps', Icons.directions_walk, AppColors.whiteColor, const Color.fromARGB(255, 238, 42, 107)),
                    ],
                  ),
                  const SizedBox(height: 10), // Space between rows
                  // Second Row with Calories and Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      activityCard('Calories Burned', '${_caloriesBurned.toInt()} kcal', Icons.local_fire_department, const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 207, 46, 46)),
                      activityCard('Duration', '$_duration min', Icons.access_time, Colors.white, Colors.blue),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Trending Workout Section
              Text(
                'Trending Workout',
                style: TextStyle(
                  color: const Color.fromARGB(255, 8, 8, 8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200, // Adjust height as needed
                child: trendingWorkoutSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Recent Activity Cards
  Widget activityCard(String title, String value, IconData icon, Color iconColor, Color cardColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
            
            Text(
              value,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // Widget for Trending Workouts
  Widget trendingWorkoutSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workouts').where('trending', isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching data'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No trending workouts available'));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var workout = snapshot.data!.docs[index];
            return Card(
              margin: const EdgeInsets.only(right: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  workout['imageUrl'],
                  fit: BoxFit.cover,
                  width: 150,
                  height: 200,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// LocalStorage class for saving and retrieving data locally
class LocalStorage {
  Future<Map<String, dynamic>> readData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/health_data.json');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    }
    return {};
  }

  Future<void> writeData(String date, int steps, double calories, int duration) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/health_data.json');
    Map<String, dynamic> data = await readData();

    data[date] = {
      'totalSteps': steps,
      'caloriesBurned': calories,
      'duration': duration,
    };

    await file.writeAsString(jsonEncode(data));
  }
}