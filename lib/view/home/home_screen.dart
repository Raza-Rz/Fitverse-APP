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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitverse/view/home/ChatBotScreen.dart';


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

 @override
  void initState() {
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
int _stepsAtLastReset = 0; // Steps count at the start of the day

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
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    // Check if the date has changed
    SharedPreferences.getInstance().then((prefs) {
      String? lastSavedDate = prefs.getString('lastSavedDate');
      if (lastSavedDate != formattedDate) {
        // New day detected: reset steps
        _stepsAtLastReset = event.steps;
        prefs.setString('lastSavedDate', formattedDate);
        prefs.setInt('stepsAtLastReset', _stepsAtLastReset);
      } else {
        // Load stepsAtLastReset for the current day
        _stepsAtLastReset = prefs.getInt('stepsAtLastReset') ?? event.steps;
      }

      // Update daily step count
      setState(() {
        _totalSteps = event.steps - _stepsAtLastReset;
        _caloriesBurned = calculateCaloriesBurned(_totalSteps);
        _duration = (_totalSteps / 1000).round();
      });

      _saveData(); // Save the updated daily step count
    });
  }).onError((error) {
    print("Error listening to step count stream: $error");
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
              // Blog Cards Section (Replacing Trending Workouts)
              Text(
                'Latest Blogs',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              blogCardSection(),
            ],
          ),
        ),
      ),
          // Add the floating action button here
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate to the ChatBotScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotScreen()),
              );
            },
            backgroundColor: AppColors.primaryColor1, // Use your preferred color
            child: Icon(
              Icons.chat, // Chat icon for the floating button
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position it at the bottom-right corner
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
 // Blog card section replacing the "Trending Workouts"
  Widget blogCardSection() {
  return Column(
    children: [
      blogCard(
        'Benefits of Regular Exercise',
        'Exercise is essential for a healthy lifestyle. see more...',
        'assets/images/benefits of excercise.jpg',
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailScreen(
                'Benefits of Regular Exercise', 
                '''Regular exercise has numerous benefits for both the body and mind. 
                It not only helps to maintain a healthy weight, but it also boosts cardiovascular health, strengthens muscles and bones, and improves mental health.

                1. Physical Benefits:
                - Increased Strength and Flexibility: Regular strength training helps improve muscle mass and bone density.
                - Improved Cardiovascular Health: Aerobic exercises like running, cycling, or swimming strengthen the heart and lungs.
                - Weight Management: Exercise, along with a balanced diet, helps regulate body weight and reduces the risk of obesity.
                
                2. Mental Health Benefits:
                - Reduced Stress and Anxiety: Physical activity stimulates the production of endorphins, which help reduce stress levels and promote a feeling of well-being.
                - Better Sleep Quality: Regular exercise can help regulate sleep patterns, leading to deeper and more restful sleep.

                3. Tips for Getting Started:
                - Start with simple exercises like walking or yoga.
                - Gradually increase the intensity and duration of your workouts.
                - Incorporate strength training and aerobic exercises into your routine for balanced fitness.

                By making exercise a daily habit, you'll not only feel better physically but also experience improved mental clarity and emotional stability.''',
                'assets/images/benefits of excercise.jpg',
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 15),
      blogCard(
        'Nutrition for Athletes',
        'Discover the best see more...',
        'assets/images/nutrition.jpg',
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailScreen(
                'Nutrition for Athletes', 
                '''For athletes, nutrition plays a key role in performance and recovery. Eating the right foods can provide the energy needed for intense training and speed up recovery afterward.

                1. Macronutrients:
                - Carbohydrates: Carbs are the body's primary energy source, especially for high-intensity workouts. Foods like whole grains, fruits, and vegetables are excellent sources.
                - Protein: Protein helps repair and build muscle tissue. Lean meats, eggs, beans, and legumes are rich sources of protein.
                - Fats: Healthy fats, such as those found in avocados, nuts, and olive oil, provide long-lasting energy and are essential for hormone production.

                2. Hydration:
                - Staying hydrated is crucial for athletic performance. Water helps regulate body temperature, lubricate joints, and prevent dehydration during long workouts.
                - For longer endurance activities, consider sports drinks that replenish electrolytes like sodium and potassium.

                3. Pre-Workout Nutrition:
                - Eat a balanced meal 1-2 hours before your workout, including carbs and protein for energy and muscle support.
                - A quick snack, such as a banana with peanut butter, 30 minutes before a workout can also provide a quick energy boost.

                4. Post-Workout Recovery:
                - After exercise, aim to eat a meal with protein and carbs within 30-60 minutes to aid muscle recovery and replenish glycogen stores.
                - A smoothie made with protein powder, fruits, and leafy greens is an excellent post-workout option.

                By paying attention to your nutrition, you can improve endurance, strength, and recovery, ultimately enhancing your athletic performance.''',
                'assets/images/nutrition.jpg',
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 15),
      blogCard(
        'Advanced Strength Training Techniques',
        'Explore advanced see more...',
        'assets/images/advanced-strength-training.jpg',
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailScreen(
                'Advanced Strength Training Techniques', 
                '''As you progress in your fitness journey, you may want to incorporate advanced strength training techniques to continue building muscle and strength. Here are some key methods to consider:

                1. Periodization:
                Periodization involves cycling through different phases of training (e.g., strength, hypertrophy, and endurance) to allow for optimal recovery and prevent plateaus.
                - Macrocycle: The longest cycle, typically lasting 6 months to a year.
                - Mesocycle: A medium cycle, usually lasting 3-4 weeks, focusing on specific goals.
                - Microcycle: The shortest cycle, lasting 1-2 weeks, and typically involves the highest intensity training.

                2. Progressive Overload:
                This technique involves gradually increasing the weight, reps, or sets in your workouts to force your muscles to adapt and grow stronger. It's a fundamental principle in building strength.

                3. Hypertrophy Training:
                To increase muscle size, focus on high-repetition sets (8-12 reps per set) with moderate weights. Compound exercises like squats, deadlifts, and bench presses are excellent for hypertrophy.

                4. Supersets and Drop Sets:
                - Supersets: Perform two exercises back-to-back with no rest in between. This can be done for opposing muscle groups (e.g., biceps and triceps) or the same muscle group.
                - Drop Sets: Start with a heavy weight and gradually reduce the weight as you reach failure. This technique helps to push muscles beyond their normal fatigue point.

                5. Recovery and Rest:
                - Never underestimate the power of rest. Muscles grow during recovery, not during the workout itself. Make sure to get 7-8 hours of sleep each night and allow for 48 hours of rest between training the same muscle group.

                By incorporating these advanced techniques into your workout routine, you can continue to build muscle and strength, pushing past plateaus and achieving your fitness goals more efficiently.''',
                'assets/images/advanced-strength-training.jpg',
              ),
            ),
          );
        },
      ),
    ],
  );
}


  // Blog card widget
  Widget blogCard(String title, String description, String imageUrl, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 120, // Adjust card height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Black overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Content on top of the overlay
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class BlogDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;

  BlogDetailScreen(this.title, this.content, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent, // Modern and bold color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ..._formatContent(content),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _formatContent(String content) {
    final List<Widget> widgets = [];
    final lines = content.split('\n');

    for (String line in lines) {
      if (line.trim().isEmpty) continue;

      if (line.startsWith('- ')) {
        widgets.add(Text(
          line.substring(2).trim(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
        widgets.add(const SizedBox(height: 10));
      } else if (line.startsWith(RegExp(r'\d\.'))) {
        final match = RegExp(r'(\d+)\. (.+)').firstMatch(line);
        if (match != null) {
          widgets.add(Row(
            children: [
              Text(
                '${match.group(1)}. ${match.group(2)}', // Entire heading as bold
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Bold entire heading
                  color: Colors.black,
                ),
              ),
            ],
          ));
        }
        widgets.add(const SizedBox(height: 10));
      } else {
        widgets.add(Text(
          line.trim(),
          style: TextStyle(fontSize: 16, height: 1.6),
        ));
        widgets.add(const SizedBox(height: 10));
      }
    }
    return widgets;
  }
}


class LocalStorage {
  Future<void> writeData(String date, int totalSteps, double caloriesBurned, int duration) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/steps_data.json');
    Map<String, dynamic> data = {};
    if (file.existsSync()) {
      String content = await file.readAsString();
      data = jsonDecode(content);
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
    final file = File('${directory.path}/steps_data.json');
    if (file.existsSync()) {
      String content = await file.readAsString();
      return jsonDecode(content);
    }
    return {};
  }
}

