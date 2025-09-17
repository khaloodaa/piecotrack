// challenges_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChallengesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> challenges = [
    {
      "title": "Recycle 5 Plastic Bottles",
      "description": "Help reduce waste by recycling 5 plastic bottles today.",
      "reward": 0.5,
      "progress": 3,
      "goal": 5,
      "deadline": DateTime.now().add(Duration(hours: 12)),
    },
    {
      "title": "Use Public Transport",
      "description": "Take the bus/train instead of driving your car this week.",
      "reward": 1.0,
      "progress": 2,
      "goal": 7,
      "deadline": DateTime.now().add(Duration(days: 5)),
    },
    {
      "title": "Plant a Tree",
      "description": "Plant at least one tree in your area and share a picture.",
      "reward": 2.0,
      "progress": 0,
      "goal": 1,
      "deadline": DateTime.now().add(Duration(days: 10)),
    },
  ];

  String formatDeadline(DateTime deadline) {
    return DateFormat("EEE, d MMM").format(deadline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenges"),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          double progressPercent = challenge["progress"] / challenge["goal"];

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان + المكافأة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        challenge["title"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "+${challenge["reward"]} Pi",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(challenge["description"]),

                  const SizedBox(height: 12),

                  // Progress Bar
                  LinearProgressIndicator(
                    value: progressPercent,
                    color: Colors.green,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${challenge["progress"]}/${challenge["goal"]} completed",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),

                  const SizedBox(height: 12),

                  // Deadline + Join button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Deadline: ${formatDeadline(challenge["deadline"])}",
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Joined ${challenge["title"]}!")),
                          );
                        },
                        child: const Text("Join"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
