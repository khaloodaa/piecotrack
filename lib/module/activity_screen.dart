import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:js/js.dart';

import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';
import '../model/model_screen.dart';

/// ---- JS Interop ----
@JS('Pi.authenticate')
external void _piAuthenticate(
    List<String> scopes,
    Function onSuccess,
    Function onError,
    );

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _authMessage = "🔑 Awaiting Pi authentication...";

  @override
  void initState() {
    super.initState();
    _initiatePiAuth();
  }

  void _initiatePiAuth() {
    if (kIsWeb) {
      try {
        _piAuthenticate(
          ['username', 'wallet_address'],
          allowInterop((authResult) {
            setState(() {
              _authMessage = "✅ Auth Success: $authResult";
            });
          }),
          allowInterop((error) {
            setState(() {
              _authMessage = "❌ Auth Error: ${error.toString()}";
            });
          }),
        );
      } catch (e) {
        setState(() {
          _authMessage = "⚠️ Error calling Pi.authenticate: $e";
        });
      }
    } else {
      setState(() {
        _authMessage = "ℹ️ Auth only works on web (Pi Browser).";
      });
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
        title: const Text("Eco Activities"),
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
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: "Test Pi Auth",
            onPressed: _initiatePiAuth, // زرار التست
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add_activity'),
      ),
      body: Column(
        children: [
          /// رسالة الحالة فوق
          Container(
            width: double.infinity,
            color: Colors.black12,
            padding: const EdgeInsets.all(12),
            child: Text(
              _authMessage,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),

          /// بقية الأنشطة
          Expanded(
            child: BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                if (state is ActivityLoaded) {
                  final activities = List<ActivityModel>.from(state.activities)
                    ..sort((a, b) => b.date.compareTo(a.date));

                  if (activities.isEmpty) {
                    return const Center(
                      child: Text("No activities yet. Add your first!"),
                    );
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
                                  borderRadius: BorderRadius.circular(16),
                                ),
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
                                      fontSize: 16,
                                    ),
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
                                duration: 400.ms,
                                delay: 100.ms,
                              );
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
    );
  }
}
