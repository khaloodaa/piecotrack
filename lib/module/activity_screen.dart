// activity_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:js/js.dart';
import 'package:piecotrack/shared/component/component.dart';

import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';
import '../model/model_screen.dart';

// JS binding
@JS()
external dynamic get Pi;

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _initiatePiAuth();
  }

  Future<void> _initiatePiAuth() async {
    if (kIsWeb) {
      try {
        Pi.authenticate(
          ['username', 'wallet_address'],
          allowInterop((authResult) {
            setState(() {
              _username = authResult['user']['username'];
            });
            print('✅ Pi Auth Success: $_username');
          }),
          allowInterop((error) {
            print('❌ Pi Auth Error: ${error['name']} - ${error['message']}');
          }),
        );
      } catch (e) {
        print('Error calling Pi.authenticate: $e');
      }
    }
  }

  /// زرار للتست manual
  void _testPiAuth() {
    if (kIsWeb) {
      try {
        Pi.authenticate(
          ['username', 'wallet_address'],
          allowInterop((authResult) {
            setState(() {
              _username = authResult['user']['username'];
              showToast(text: _username!, state: ToastStates.success);
            });
            print('✅ Test Auth Success: $_username');
          }),
          allowInterop((error) {
            print('❌ Test Auth Error: ${error['name']} - ${error['message']}');
          }),
        );
      } catch (e) {
        print('Error in testPiAuth: $e');
      }
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case "Walking":
        return Icons.directions_walk;
      case "Recycling":
        return Icons.recycling;
      case "Energy Saving":
        return Icons.lightbulb;
      case "Public Transport":
        return Icons.directions_bus;
      default:
        return Icons.eco;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activities"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.bug_report),
          //   tooltip: "Test Pi Auth",
          //   onPressed: _testPiAuth, // ✅ زرار للتست
          // ),
        ],
      ),
      body: Column(
        children: [
          if (_username != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "👋 Welcome, $_username",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),

          Expanded(
            child: BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                if (state is ActivityLoaded) {
                  final activities = List<ActivityModel>.from(state.activities)
                    ..sort((a, b) => b.date.compareTo(a.date));

                  if (activities.isEmpty) {
                    return const Center(
                        child: Text("No activities yet. Add your first!"));
                  }

                  final grouped = <String, List<ActivityModel>>{};
                  for (var activity in activities) {
                    final dateKey =
                    DateFormat("yyyy-MM-dd").format(activity.date);
                    grouped.putIfAbsent(dateKey, () => []).add(activity);
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: grouped.entries.map((entry) {
                      final dateLabel = DateFormat("EEE, d MMM yyyy")
                          .format(entry.value.first.date);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateLabel,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 8),

                          Column(
                            children: entry.value.map((activity) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 3,
                                margin:
                                const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.green.shade100,
                                    child: Icon(
                                      _getIcon(activity.type),
                                      color: Colors.green,
                                    ),
                                  ),
                                  title: Text(
                                    activity.type,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    "${activity.description}\n${activity.co2Saved} kg CO₂ saved",
                                  ),
                                  trailing: Text(
                                    "+${activity.piReward} Pi",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn(
                                  duration: 400.ms, delay: 100.ms);
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add_activity'
        ),
      ),
    );
  }
}
