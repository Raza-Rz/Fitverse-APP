import 'package:flutter/material.dart';
import 'package:fitverse/view/activity/workout-details.dart';

class ActivityScreen extends StatelessWidget {
  final List<Map<String, dynamic>> workoutCategories = [
      {
    'title': 'Chest & Abdominal',
    'subtitle': '12 Exercises',
    'color': Colors.orangeAccent,
    'imagePath': 'assets/images/chest_abdominal.png',
    'workouts': [
      {
        'name': 'Push Ups',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'A basic chest workout to strengthen pectoral muscles.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '15 reps',
        'tips': 'Keep your body straight, and engage your core.',
      },
      {
        'name': 'Crunches',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Target your abdominal muscles with crunch exercises.',
        'duration': '5 minutes',
        'sets': '3 sets',
        'reps': '20 reps',
        'tips': 'Don\'t pull your neck; focus on your abs.',
      },
      {
        'name': 'Bench Press',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Build chest strength with this classic barbell exercise.',
        'duration': '15 minutes',
        'sets': '4 sets',
        'reps': '10 reps',
        'tips': 'Control the barbell and avoid locking your elbows.',
      },
      {
        'name': 'Incline Dumbbell Press',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Focus on your upper chest muscles using dumbbells.',
        'duration': '12 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Keep your movement controlled and avoid swinging.',
      },
      {
        'name': 'Cable Crossover',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Engage your chest with cable movements.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '15 reps',
        'tips': 'Maintain tension throughout the movement.',
      },
      {
        'name': 'Dumbbell Flyes',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Isolate your chest muscles with dumbbell flyes.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Keep a slight bend in your elbows for safety.',
      },
      {
        'name': 'Push-Up Variations',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Mix up your push-ups with incline and decline variations.',
        'duration': '8 minutes',
        'sets': '3 sets',
        'reps': '15 reps',
        'tips': 'Adjust hand positions for targeting different areas of the chest.',
      },
      {
        'name': 'Pec Deck Machine',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Isolate your chest muscles using the pec deck machine.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Avoid overextending to protect your shoulders.',
      },
    ],
  },

      {
    'title': 'Back',
    'subtitle': '12 Exercises',
    'color': Colors.lightBlue,
    'imagePath': 'assets/images/back_shoulder.png',
    'workouts': [
      {
        'name': 'Pull Ups',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Build back muscles with pull-ups.',
        'duration': '15 minutes',
        'sets': '4 sets',
        'reps': '10 reps',
        'tips': 'Pull yourself all the way up, engaging your lats.',
      },
      {
        'name': 'Shoulder Press',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Strengthen your shoulder with presses.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Keep your elbows at a 90-degree angle.',
      },
      {
        'name': 'Deadlifts',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'A compound exercise to target the entire back.',
        'duration': '20 minutes',
        'sets': '4 sets',
        'reps': '8 reps',
        'tips': 'Keep your back straight and engage your core.',
      },
      {
        'name': 'Bent-Over Rows',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Strengthen your upper and lower back with rows.',
        'duration': '12 minutes',
        'sets': '3 sets',
        'reps': '10 reps',
        'tips': 'Maintain a flat back and pull the barbell towards your waist.',
      },
      {
        'name': 'Lat Pulldowns',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Focus on the lat muscles using a cable machine.',
        'duration': '15 minutes',
        'sets': '4 sets',
        'reps': '12 reps',
        'tips': 'Avoid leaning back too far; focus on controlled movements.',
      },
      {
        'name': 'T-Bar Rows',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Target your middle back with T-bar rows.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Keep your chest up and squeeze your shoulder blades.',
      },
      {
        'name': 'Seated Cable Rows',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Work your upper and mid-back muscles.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Sit upright and pull the handle towards your waist.',
      },
      {
        'name': 'Face Pulls',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Strengthen your upper back and rear deltoids.',
        'duration': '8 minutes',
        'sets': '3 sets',
        'reps': '15 reps',
        'tips': 'Pull the rope towards your face with controlled motion.',
      },
    ],
  },


      {
    'title': 'Shoulder',
    'subtitle': '12 Exercises',
    'color': Colors.lightBlue,
    'imagePath': 'assets/images/back_shoulder.png',
    'workouts': [
      {
        'name': 'Pull Ups',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Build back muscles with pull-ups.',
        'duration': '15 minutes',
        'sets': '4 sets',
        'reps': '10 reps',
        'tips': 'Pull yourself all the way up, engaging your lats.',
      },
      {
        'name': 'Shoulder Press',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Strengthen your shoulder with presses.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Keep your elbows at a 90-degree angle.',
      },
      {
        'name': 'Lateral Raises',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Target your deltoid muscles with lateral raises.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '15 reps',
        'tips': 'Keep a slight bend in your elbows and raise to shoulder height.',
      },
      {
        'name': 'Front Raises',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Strengthen the front part of your shoulders.',
        'duration': '8 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Lift the weights straight in front of you without swinging.',
      },
      {
        'name': 'Arnold Press',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'A variation of shoulder press for complete deltoid engagement.',
        'duration': '12 minutes',
        'sets': '4 sets',
        'reps': '10 reps',
        'tips': 'Twist your palms inward as you lower the weights.',
      },
      {
        'name': 'Reverse Flys',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Target the rear deltoids and upper back.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Keep your back straight and squeeze your shoulder blades together.',
      },
      {
        'name': 'Face Pulls',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Strengthen the rear delts and improve shoulder health.',
        'duration': '8 minutes',
        'sets': '3 sets',
        'reps': '15 reps',
        'tips': 'Pull the rope towards your face with controlled motion.',
      },
      {
        'name': 'Upright Rows',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Focus on your traps and deltoids with upright rows.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Keep the barbell close to your body as you lift.',
      },
    ],
  },


      {
    'title': 'Arms Workout',
    'subtitle': '12 Exercises',
    'color': Colors.orangeAccent,
    'imagePath': 'assets/images/back_shoulder.png',
    'workouts': [
      {
        'name': 'Pull Ups',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Build back muscles with pull-ups.',
        'duration': '15 minutes',
        'sets': '4 sets',
        'reps': '10 reps',
        'tips': 'Pull yourself all the way up, engaging your lats.',
      },
      {
        'name': 'Shoulder Press',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Strengthen your shoulder with presses.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Keep your elbows at a 90-degree angle.',
      },
      {
        'name': 'Bicep Curls',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Build arm strength with bicep curls.',
        'duration': '8 minutes',
        'sets': '3 sets',
        'reps': '15 reps',
        'tips': 'Keep your elbows close to your body and curl the weight slowly.',
      },
      {
        'name': 'Tricep Dips',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Strengthen your triceps using bodyweight exercises.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Lower your body until your arms form a 90-degree angle.',
      },
      {
        'name': 'Hammer Curls',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Target both biceps and forearms with hammer curls.',
        'duration': '10 minutes',
        'sets': '4 sets',
        'reps': '12 reps',
        'tips': 'Use a neutral grip and control the weight on the way down.',
      },
      {
        'name': 'Overhead Tricep Extensions',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Focus on tricep muscles with overhead extensions.',
        'duration': '12 minutes',
        'sets': '3 sets',
        'reps': '10 reps',
        'tips': 'Keep your elbows stable and only move your forearms.',
      },
      {
        'name': 'Concentration Curls',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Isolate your biceps with concentration curls.',
        'duration': '10 minutes',
        'sets': '3 sets',
        'reps': '12 reps',
        'tips': 'Rest your elbow on your thigh and curl the weight slowly.',
      },
      {
        'name': 'Close-Grip Push-Ups',
        'imagePath': 'assets/images/pp_3.png',
        'description': 'Work on triceps and chest with close-grip push-ups.',
        'duration': '8 minutes',
        'sets': '3 sets',
        'reps': '15 reps',
        'tips': 'Keep your hands close together and focus on the triceps.',
      },
    ],
  },


    {
  'title': 'Legs',
  'subtitle': '12 Exercises',
  'color': Colors.lightBlue,
  'imagePath': 'assets/images/back_shoulder.png',
  'workouts': [
    {
      'name': 'Squats',
      'imagePath': 'assets/images/pp_3.png',
      'description': 'Strengthen your legs and glutes with squats.',
      'duration': '15 minutes',
      'sets': '4 sets',
      'reps': '15 reps',
      'tips': 'Keep your back straight and engage your core.',
    },
    {
      'name': 'Lunges',
      'imagePath': 'assets/images/pp_3.png',
      'description': 'Build leg strength with forward lunges.',
      'duration': '12 minutes',
      'sets': '3 sets',
      'reps': '12 reps each leg',
      'tips': 'Make sure your front knee doesn’t go past your toes.',
    },
    {
      'name': 'Leg Press',
      'imagePath': 'assets/images/pp_3.png',
      'description': 'Target your quads and hamstrings with leg presses.',
      'duration': '10 minutes',
      'sets': '4 sets',
      'reps': '10 reps',
      'tips': 'Adjust the weight to maintain proper form.',
    },
    {
      'name': 'Calf Raises',
      'imagePath': 'assets/images/pp_3.png',
      'description': 'Strengthen your calves with raises.',
      'duration': '8 minutes',
      'sets': '3 sets',
      'reps': '20 reps',
      'tips': 'Pause briefly at the top for maximum contraction.',
    },
    {
      'name': 'Step-Ups',
      'imagePath': 'assets/images/pp_3.png',
      'description': 'Work your glutes and quads with step-ups.',
      'duration': '12 minutes',
      'sets': '3 sets',
      'reps': '15 reps each leg',
      'tips': 'Keep your upper body upright during the movement.',
    },
    {
      'name': 'Deadlifts',
      'imagePath': 'assets/images/pp_3.png',
      'description': 'Target your hamstrings and glutes with deadlifts.',
      'duration': '15 minutes',
      'sets': '3 sets',
      'reps': '12 reps',
      'tips': 'Keep your back straight and lift with your legs.',
    },
    {
      'name': 'Glute Bridges',
      'imagePath': 'assets/images/pp_3.png',
      'description': 'Activate your glutes and hamstrings with bridges.',
      'duration': '10 minutes',
      'sets': '4 sets',
      'reps': '15 reps',
      'tips': 'Squeeze your glutes at the top for better activation.',
    },
    {
      'name': 'Bulgarian Split Squats',
      'imagePath': 'assets/images/pp_3.png',
      'description': 'Challenge your balance and strengthen your legs.',
      'duration': '12 minutes',
      'sets': '3 sets',
      'reps': '10 reps each leg',
      'tips': 'Lower yourself slowly to maintain control.',
    },
  ],
},

    // Other categories ...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
        title: const Text('Activity'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
  itemCount: workoutCategories.length,
  itemBuilder: (context, index) {
    final category = workoutCategories[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutCategoryScreen(
              title: category['title'],
              workoutList: category['workouts'],
            ),
          ),
        );
      },
      child: Container(
        height: 110,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: category['color'],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category['subtitle'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(10)),
              child: Image.asset(
                category['imagePath'],
                fit: BoxFit.cover,
                width: 100,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  },
),

      ),
    );
  }
}
