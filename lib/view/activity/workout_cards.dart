import 'package:flutter/material.dart';
import 'package:fitverse/view/activity/workout-details.dart';

class ActivityScreen extends StatelessWidget {
  final List<Map<String, dynamic>> workoutCategories = [
    {
      'title': 'Chest & Abdominal',
      'subtitle': '05 Exercises',
      
      'imagePath': 'assets/images/chest.jpg',
      'workouts': [
        {
          'name': 'Push Ups',
          'imagePath': 'assets/images/pushup.gif',
          'description':
              'A basic chest workout to strengthen pectoral muscles.',
          'duration': '10 minutes',
          'sets': '3 sets',
          'reps': '15 reps',
          'tips': 'Keep your body straight, and engage your core.',
        },
        {
          'name': 'Crunches',
          'imagePath': 'assets/images/crunches.gif',
          'description': 'Target your abdominal muscles with crunch exercises.',
          'duration': '5 minutes',
          'sets': '3 sets',
          'reps': '20 reps',
          'tips': 'Don\'t pull your neck; focus on your abs.',
        },
        {
          'name': 'Bench Press',
          'imagePath': 'assets/images/bench-press.gif',
          'description':
              'Build chest strength with this classic barbell exercise.',
          'duration': '15 minutes',
          'sets': '4 sets',
          'reps': '10 reps',
          'tips': 'Control the barbell and avoid locking your elbows.',
        },
        {
          'name': 'Incline Dumbbell Press',
          'imagePath': 'assets/images/bench-press-regular-bench-press.gif',
          'description': 'Focus on your upper chest muscles using dumbbells.',
          'duration': '12 minutes',
          'sets': '3 sets',
          'reps': '12 reps',
          'tips': 'Keep your movement controlled and avoid swinging.',
        },
        {
          'name': 'Dumbbell Flyes',
          'imagePath': 'assets/images/chest-fly-dumbells.gif',
          'description': 'Isolate your chest muscles with dumbbell flyes.',
          'duration': '10 minutes',
          'sets': '3 sets',
          'reps': '12 reps',
          'tips': 'Keep a slight bend in your elbows for safety.',
        },
      ],
    },
    {
      'title': 'Back',
      'subtitle': '05 Exercises',
      
      'imagePath': 'assets/images/back.jpg',
      'workouts': [
        {
          'name': 'Pull Ups',
          'imagePath': 'assets/images/pull-ups.gif',
          'description': 'Build back muscles with pull-ups.',
          'duration': '15 minutes',
          'sets': '4 sets',
          'reps': '10 reps',
          'tips': 'Pull yourself all the way up, engaging your lats.',
        },
        {
          'name': 'Deadlifts',
          'imagePath': 'assets/images/workouts-deadlift.gif',
          'description': 'A compound exercise to target the entire back.',
          'duration': '20 minutes',
          'sets': '4 sets',
          'reps': '8 reps',
          'tips': 'Keep your back straight and engage your core.',
        },
        {
          'name': 'Bent-Over Rows',
          'imagePath': 'assets/images/weights-skinny-guy.gif',
          'description': 'Strengthen your upper and lower back with rows.',
          'duration': '12 minutes',
          'sets': '3 sets',
          'reps': '10 reps',
          'tips':
              'Maintain a flat back and pull the barbell towards your waist.',
        },
        {
          'name': 'Lat Pulldowns',
          'imagePath': 'assets/images/lat-pull-down.gif',
          'description': 'Focus on the lat muscles using a cable machine.',
          'duration': '15 minutes',
          'sets': '4 sets',
          'reps': '12 reps',
          'tips': 'Avoid leaning back too far; focus on controlled movements.',
        },
        {
          'name': 'Seated Cable Rows',
          'imagePath': 'assets/images/cable-row-back.gif',
          'description': 'Work your upper and mid-back muscles.',
          'duration': '10 minutes',
          'sets': '3 sets',
          'reps': '12 reps',
          'tips': 'Sit upright and pull the handle towards your waist.',
        },
      ],
    },
    {
      'title': 'Shoulder',
      'subtitle': '05 Exercises',
      
      'imagePath': 'assets/images/shoulder.jpg',
      'workouts': [
        {
          'name': 'Pull Ups',
          'imagePath': 'assets/images/pull-ups.gif',
          'description': 'Build back muscles with pull-ups.',
          'duration': '15 minutes',
          'sets': '4 sets',
          'reps': '10 reps',
          'tips': 'Pull yourself all the way up, engaging your lats.',
        },
        {
          'name': 'Shoulder Press',
          'imagePath': 'assets/images/shoulder-press-machine.gif',
          'description': 'Strengthen your shoulder with presses.',
          'duration': '10 minutes',
          'sets': '3 sets',
          'reps': '12 reps',
          'tips': 'Keep your elbows at a 90-degree angle.',
        },
        {
          'name': 'Lateral Raises',
          'imagePath': 'assets/images/seated-lateral-raise.gif',
          'description': 'Target your deltoid muscles with lateral raises.',
          'duration': '10 minutes',
          'sets': '3 sets',
          'reps': '15 reps',
          'tips':
              'Keep a slight bend in your elbows and raise to shoulder height.',
        },
        {
          'name': 'Front Raises',
          'imagePath': 'assets/images/dumbells-front-raise.gif',
          'description': 'Strengthen the front part of your shoulders.',
          'duration': '8 minutes',
          'sets': '3 sets',
          'reps': '12 reps',
          'tips': 'Lift the weights straight in front of you without swinging.',
        },
        {
          'name': 'Arnold Press',
          'imagePath': 'assets/images/arnold-press.gif',
          'description':
              'A variation of shoulder press for complete deltoid engagement.',
          'duration': '12 minutes',
          'sets': '4 sets',
          'reps': '10 reps',
          'tips': 'Twist your palms inward as you lower the weights.',
        },
      ],
    },
    {
      'title': 'Arms Workout',
      'subtitle': '05 Exercises',
      
      'imagePath': 'assets/images/arm.jpg',
      'workouts': [
        {
          'name': 'Dumbel Curls',
          'imagePath': 'assets/images/dumbel curl.gif',
          'description': 'Build arm strength with bicep curls.',
          'duration': '8 minutes',
          'sets': '3 sets',
          'reps': '15 reps',
          'tips':
              'Keep your elbows close to your body and curl the weight slowly.',
        },
        {
          'name': 'Tricep Dips',
          'imagePath': 'assets/images/Tricep_Dips_2.webp',
          'description': 'Strengthen your triceps using bodyweight exercises.',
          'duration': '10 minutes',
          'sets': '3 sets',
          'reps': '12 reps',
          'tips': 'Lower your body until your arms form a 90-degree angle.',
        },
        {
          'name': 'Hammer Curls',
          'imagePath': 'assets/images/hammercurl-1456956209.gif',
          'description': 'Target both biceps and forearms with hammer curls.',
          'duration': '10 minutes',
          'sets': '4 sets',
          'reps': '12 reps',
          'tips': 'Use a neutral grip and control the weight on the way down.',
        },
        {
          'name': 'Concentration Curls',
          'imagePath': 'assets/images/con-curls.gif',
          'description': 'Isolate your biceps with concentration curls.',
          'duration': '10 minutes',
          'sets': '3 sets',
          'reps': '12 reps',
          'tips': 'Rest your elbow on your thigh and curl the weight slowly.',
        },
        {
          'name': 'Close-Grip Push-Ups',
          'imagePath': 'assets/images/closehandspushup-1456956569.gif',
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
      'subtitle': '05 Exercises',
      
      'imagePath': 'assets/images/legs.jpg',
      'workouts': [
        {
          'name': 'Squats',
          'imagePath': 'assets/images/squats.gif',
          'description': 'Strengthen your legs and glutes with squats.',
          'duration': '15 minutes',
          'sets': '4 sets',
          'reps': '15 reps',
          'tips': 'Keep your back straight and engage your core.',
        },
        {
          'name': 'Lunges',
          'imagePath': 'assets/images/lundges.gif',
          'description': 'Build leg strength with forward lunges.',
          'duration': '12 minutes',
          'sets': '3 sets',
          'reps': '12 reps each leg',
          'tips': 'Make sure your front knee doesn’t go past your toes.',
        },
        {
          'name': 'Step-Ups',
          'imagePath': 'assets/images/stepups.gif',
          'description': 'Work your glutes and quads with step-ups.',
          'duration': '12 minutes',
          'sets': '3 sets',
          'reps': '15 reps each leg',
          'tips': 'Keep your upper body upright during the movement.',
        },
        {
          'name': 'Deadlifts',
          'imagePath': 'assets/images/workouts-deadlift.gif',
          'description': 'Target your hamstrings and glutes with deadlifts.',
          'duration': '15 minutes',
          'sets': '3 sets',
          'reps': '12 reps',
          'tips': 'Keep your back straight and lift with your legs.',
        },
        {
          'name': 'Bulgarian Split Squats',
          'imagePath': 'assets/images/bul-squats.gif',
          'description': 'Challenge your balance and strengthen your legs.',
          'duration': '12 minutes',
          'sets': '3 sets',
          'reps': '10 reps each leg',
          'tips': 'Lower yourself slowly to maintain control.',
        },
      ],
    },

   
  ];

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Workouts',
        style: TextStyle(
        color: Colors.black,
         fontSize: 22,
          fontWeight: FontWeight.bold,
           ),
           ),
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
                height: 120,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // Background image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        category['imagePath'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    // Black overlay
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Foreground content
                    Padding(
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
            );
          },
        ),
      ),
    );
  }
}
