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

  @override
  void initState() {
    super.initState();
    _requestPermissions(); 
    _fetchDataForSelectedDay(); // Fetch today's data on init
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
      _logStepsLocally(); 
    });
  }

  double calculateCaloriesBurned(int steps) {
    return steps * 0.04; 
  }

  void _logStepsLocally() async {
    if (user != null) {
      LocalStorage localStorage = LocalStorage();
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Use a standard date format
      await localStorage.writeData(currentDate, _totalSteps, _caloriesBurned, _duration);
    }
  }

  Future<void> _fetchDataForSelectedDay() async {
    LocalStorage localStorage = LocalStorage();
    String selectedDate = _getDateForSelectedDay();

    Map<String, dynamic> data = await localStorage.readData();
    if (data.containsKey(selectedDate)) {
      setState(() {
        _totalSteps = data[selectedDate]['totalSteps'];
        _caloriesBurned = data[selectedDate]['caloriesBurned'];
        _duration = data[selectedDate]['duration'];
      });
    } else {
      // Handle case where no data is available for the selected day
      setState(() {
        _totalSteps = 0;
        _caloriesBurned = 0;
        _duration = 0;
      });
    }
  }

  String _getDateForSelectedDay() {
    // Get the current date
    DateTime today = DateTime.now();

    // Calculate the date for the selected day index
    DateTime selectedDate = today.subtract(Duration(days: today.weekday - (selectedDayIndex + 1)));
    return DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEEE, dd MMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView( // Enable scrolling for the entire screen
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor1,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
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
                          color: isSelected ? AppColors.primaryColor2 : const Color.fromARGB(255, 255, 255, 255),
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
                      activityCard('Steps', '$_totalSteps steps', Icons.directions_walk, AppColors.whiteColor, AppColors.primaryColor2),
                    ],
                  ),
                  const SizedBox(height: 10), // Space between rows
                  // Second Row with Calories and Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      activityCard('Calories', '${_caloriesBurned.toInt()} kcal', Icons.local_fire_department, Colors.red, Colors.green),
                      activityCard('Duration', '$_duration min', Icons.access_time, Colors.blue, Colors.orange),
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
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28), // Increased icon size for better visibility
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), // Increased font size
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // Increased font size
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Trending Workout Section
  Widget trendingWorkoutSection() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('workouts')
          .where('trending', isEqualTo: true)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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
              child: Container(
                width: 150,
                child: Column(
                  children: [
                    Image.network(workout['image'], fit: BoxFit.cover), // Assuming 'image' field exists
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(workout['title'], textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class LocalStorage {
  Future<void> writeData(String date, int totalSteps, double caloriesBurned, int duration) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/activity_data.json');

    Map<String, dynamic> data = {};
    if (await file.exists()) {
      String contents = await file.readAsString();
      data = json.decode(contents);
    }

    data[date] = {
      'totalSteps': totalSteps,
      'caloriesBurned': caloriesBurned,
      'duration': duration,
    };

    await file.writeAsString(json.encode(data));
  }

  Future<Map<String, dynamic>> readData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/activity_data.json');

    if (await file.exists()) {
      String contents = await file.readAsString();
      return json.decode(contents);
    }

    return {};
  }
}
