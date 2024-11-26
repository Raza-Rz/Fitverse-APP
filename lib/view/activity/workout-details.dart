import 'package:flutter/material.dart';

class WorkoutCategoryScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> workoutList;

  const WorkoutCategoryScreen({
    Key? key,
    required this.title,
    required this.workoutList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: workoutList.length,
        itemBuilder: (context, index) {
          final workout = workoutList[index];
          return GestureDetector(
            onTap: () {
              _showWorkoutDetailsPopup(
                context,
                title: workout['name'] ?? 'Workout',
                imagePath: workout['imagePath'] ?? '',
                description: workout['description'] ?? '',
                duration: workout['duration'] ?? 'N/A',
                sets: workout['sets'] ?? 'N/A',
                reps: workout['reps'] ?? 'N/A',
                tips: workout['tips'] ?? 'N/A',
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        workout['imagePath'] ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            workout['description'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showWorkoutDetailsPopup(
    BuildContext context, {
    required String title,
    required String imagePath,
    required String description,
    required String duration,
    required String sets,
    required String reps,
    required String tips,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedDialog(
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Workout Image
                  Center(
                    child: Image.asset(
                      imagePath,
                      height: 150,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Workout Name
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 16),

                  // Duration
                  Text(
                    'Duration: $duration',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  // Sets
                  Text(
                    'Sets: $sets',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  // Reps
                  Text(
                    'Reps: $reps',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  // Tips
                  Text(
                    'Tips: $tips',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 16),

                  // Close button at the bottom
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  final Widget child;

  const AnimatedDialog({required this.child});

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with TickerProviderStateMixin {
  late final AnimationController _opacityController;
  late final AnimationController _scaleController;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _opacityController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _opacityController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _opacityController.forward();
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
