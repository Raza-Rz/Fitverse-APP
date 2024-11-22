import 'package:flutter/material.dart';
import 'package:fitverse/utils/app_colors.dart';

 // Ensure you have your AppColors file imported

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> workoutCategories = [
      {
        'title': 'Chest & Abdominal',
        'subtitle': '12 Exercises',
        'color': AppColors.primaryColor2, // Use AppColors
        'imagePath': 'assets/images/chest_abdominal.png',
        'route': const ChestAbdominalScreen(),
      },
      {
        'title': 'Back & Shoulder',
        'subtitle': '12 Exercises',
        'color': AppColors.primaryColor2, // Use AppColors
        'imagePath': 'assets/images/back_shoulder.png',
        'route': const BackShoulderScreen(),
      },
      {
        'title': 'Shoulder',
        'subtitle': '10 Exercises',
        'color': AppColors.primaryColor2, // Use AppColors
        'imagePath': 'assets/images/shoulder.png',
        'route': const ShoulderScreen(),
      },
      {
        'title': 'Arms',
        'subtitle': '15 Exercises',
        'color': AppColors.primaryColor2, // Use AppColors
        'imagePath': 'assets/images/arms.png',
        'route': const ArmsScreen(),
      },
      {
        'title': 'Legs',
        'subtitle': '18 Exercises',
        'color': AppColors.primaryColor2, // Use AppColors
        'imagePath': 'assets/images/legs.png',
        'route': const LegsScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workouts',
          style: TextStyle(
            fontSize: 18, // Change the font size
            fontWeight: FontWeight.bold, // Change the font weight
            color: Colors.black, // Optional: Customize the text color
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.whiteColor, // Use AppColors for app bar background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: workoutCategories.length,
          itemBuilder: (context, index) {
            final category = workoutCategories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => category['route'],
                  ),
                );
              },
              child: WorkoutCard(
                title: category['title'] ?? 'No Title',
                subtitle: category['subtitle'] ?? 'No Subtitle',
                color: category['color'] ?? AppColors.whiteColor, // Default fallback to AppColors
                imagePath: category['imagePath'] ?? '',
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String imagePath;

  const WorkoutCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.8),
                  color.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Card content
          Row(
            children: [
              // Left image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
                child: Image.asset(
                  imagePath,
                  width: 120,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Right content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color.fromARGB(179, 26, 26, 26),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Separate workout screens
class ChestAbdominalScreen extends StatelessWidget {
  const ChestAbdominalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildWorkoutDetailScreen(
      context,
      title: 'Chest & Abdominal',
      description: 'A detailed workout for Chest and Abdominal muscles.',
    );
  }
}

class BackShoulderScreen extends StatelessWidget {
  const BackShoulderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildWorkoutDetailScreen(
      context,
      title: 'Back & Shoulder',
      description: 'Targeted exercises for your back and shoulders.',
    );
  }
}

class ShoulderScreen extends StatelessWidget {
  const ShoulderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildWorkoutDetailScreen(
      context,
      title: 'Shoulder',
      description: 'Strengthen and sculpt your shoulders.',
    );
  }
}

class ArmsScreen extends StatelessWidget {
  const ArmsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildWorkoutDetailScreen(
      context,
      title: 'Arms',
      description: 'Effective arm exercises to build strength.',
    );
  }
}

class LegsScreen extends StatelessWidget {
  const LegsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildWorkoutDetailScreen(
      context,
      title: 'Legs',
      description: 'Comprehensive workout for legs.',
    );
  }
}

// Shared detail screen layout
Widget _buildWorkoutDetailScreen(BuildContext context, {required String title, required String description}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      backgroundColor: Colors.white,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          description,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
