import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  static String routeName = "/workoutScreen";

  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDaySelector(),
            const SizedBox(height: 20),
            _buildWorkoutDetailsCard(context),
            const SizedBox(height: 20),
            _buildSectionHeader('Equipment'),
            _buildEquipmentList(),
            const SizedBox(height: 20),
            _buildSectionHeader('Warmup'),
            _buildExerciseList(),
            const SizedBox(height: 20),
            _buildSectionHeader('Focus'),
            _buildFocusAreaSection(),
            const SizedBox(height: 20),
            _buildFooterButtons(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        children: [
          const Text(
            'Workout',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.5, // Example value for progress
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDaySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDBE7FF), Color(0xFFE7F1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _dayButton('Day 1', false),
          _dayButton('Day 2', true),
          _dayButton('Day 3', false),
          _dayButton('Day 4', false),
        ],
      ),
    );
  }

  Widget _dayButton(String day, bool isSelected) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: () {},
      child: Text(
        day,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildWorkoutDetailsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/pp_4.png'), // Update image path
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Body Tone', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.fitness_center, color: Colors.green),
                          SizedBox(width: 5),
                          Text('High Intensity'),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.green),
                          SizedBox(width: 5),
                          Text('20 min'),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.accessibility, color: Colors.green),
                          SizedBox(width: 5),
                          Text('220 cal'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              onPressed: () {},
              child: const Text('Start Workout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildEquipmentList() {
    // Example equipment list with dummy data
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _equipmentItem('Dumbbells', 'assets/icons/barbell.png'), // Update image path
          _equipmentItem('Barbell', 'assets/icons/choose_workout.png'),
          _equipmentItem('Abs bench', 'assets/icons/skipping_rope.png'),
        ],
      ),
    );
  }

  Widget _equipmentItem(String name, String imagePath) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            // color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              // fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(name, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildExerciseList() {
    // Example exercise list with dummy data
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _exerciseItem('Squat', '00:30', 'assets/images/pp_4.png'), // Update image path
          _exerciseItem('Split Squat One Leg', '00:30', 'assets/images/squat.png'),
          _exerciseItem('Star Jump', '00:30', 'assets/images/squat.png'),
          _exerciseItem('Rest', '00:20', 'assets/images/squat.png'),
        ],
      ),
    );
  }

  Widget _exerciseItem(String name, String time, String imagePath) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      contentPadding: EdgeInsets.zero, // Remove default padding
      leading: Container(
        width: 80,  // Adjust width as needed
        height: 100, // Adjust height as needed
        decoration: BoxDecoration(
          color: Colors.grey[200], // Background color to handle empty space
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        time,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow, color: Colors.black),
        onPressed: () {},
      ),
    ),
  );
}


  Widget _buildFocusAreaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Image.asset('assets/images/squat.png'), // Update image path
          ),
          const SizedBox(width: 10), // Adjust spacing as needed
          Expanded(
            child: Image.asset('assets/images/squat.png'), // Update image path
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: const Text('Schedule Workout'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: const Text('Download Workout'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: const Text('Choose a Playlist'),
          ),
        ],
      ),
    );
  }
}
