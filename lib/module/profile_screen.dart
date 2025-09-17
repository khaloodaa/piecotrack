import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),

        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text("Khaled Elroby",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const Text("Eco Warrior 🌍"),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 20),

          // Rewards & Stats Section
          Card(
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.stacked_bar_chart, color: Colors.indigo),
              title: const Text("My Statistics"),
              onTap: () {
                // يفتح شاشة الـ Charts القديمة
              },
            ),
          ),
          Card(
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.monetization_on,
                  color: Colors.deepPurple),
              title: const Text("My Rewards"),
              onTap: () {
                // يفتح شاشة المكافآت القديمة
              },
            ),
          ),

          const SizedBox(height: 20),

          // Settings
          const Text("Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          SwitchListTile(
            value: true,
            onChanged: (val) {},
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Change Language"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
