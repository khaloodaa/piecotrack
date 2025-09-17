import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piecotrack/layout/cubit/cubit.dart';
import 'package:piecotrack/model/activity_model.dart';
import '../model/model_screen.dart';
import 'walking_tracker_screen.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  String? _selectedType;
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _plasticController = TextEditingController();
  final TextEditingController _canController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _treeController = TextEditingController();

  bool _isProcessingWalking = false;

  @override
  void dispose() {
    _descController.dispose();
    _plasticController.dispose();
    _canController.dispose();
    _energyController.dispose();
    _treeController.dispose();
    super.dispose();
  }

  /// ========= حسابات CO₂ =========
  double _calculateRecyclingCo2(int plasticBottles, int aluminumCans) {
    return double.parse(((plasticBottles * 0.082) + (aluminumCans * 0.5)).toStringAsFixed(5));
  }

  double _calculateEnergySavingCo2(double savedKWh) {
    return double.parse((savedKWh * 0.5).toStringAsFixed(5));
  }

  double _calculateTreeCo2(int trees) {
    return double.parse(((trees * 21) / 365).toStringAsFixed(5)); // يومياً
  }

  double _calculateWalkingCo2(double distanceKm) {
    return double.parse((distanceKm * 0.21).toStringAsFixed(5));
  }

  // ====== START WALKING FLOW ======
  Future<void> _startWalkingFlow() async {
    if (_isProcessingWalking) return;
    setState(() => _isProcessingWalking = true);

    final result = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => const WalkingTrackerScreen()),
    );

    if (result != null && result.containsKey('steps') && result.containsKey('distance')) {
      final int steps = result['steps'] as int;
      final double distance = result['distance'] as double;

      final cubit = context.read<ActivityCubit>();
      final double co2Saved = _calculateWalkingCo2(distance / 1000.0);
      final double piReward = double.parse(cubit.calculatePiReward(co2Saved).toStringAsFixed(5));

      final activity = ActivityModel(
        type: 'Walking',
        description: 'Walked ${distance.toStringAsFixed(0)} m ($steps steps)',
        co2Saved: co2Saved,
        piReward: piReward,
        date: DateTime.now(),
        steps: steps,
        distance: distance,
      );

      cubit.addActivity(activity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Walking activity saved — +${piReward.toStringAsFixed(3)} Pi')),
      );

      if (mounted) Navigator.of(context).pop();
    } else {
      setState(() => _selectedType = null);
    }

    setState(() => _isProcessingWalking = false);
  }

  // ====== SAVE NON-WALKING ACTIVITY ======
  void _saveNonWalkingActivity() {
    final type = _selectedType;
    final desc = _descController.text.trim();

    if (type == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an activity type.')));
      return;
    }

    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a description.')));
      return;
    }

    double co2 = 0.0;

    switch (type) {
      case 'Recycling':
        final bottles = int.tryParse(_plasticController.text.trim()) ?? 0;
        final cans = int.tryParse(_canController.text.trim()) ?? 0;
        co2 = _calculateRecyclingCo2(bottles, cans);
        break;
      case 'Energy Saving':
        final savedKWh = double.tryParse(_energyController.text.trim()) ?? 0.0;
        co2 = _calculateEnergySavingCo2(savedKWh);
        break;
      case 'Tree Planting':
        final trees = int.tryParse(_treeController.text.trim()) ?? 0;
        co2 = _calculateTreeCo2(trees);
        break;
    }

    final cubit = context.read<ActivityCubit>();
    final piReward = double.parse(cubit.calculatePiReward(co2).toStringAsFixed(5));

    final activity = ActivityModel(
      type: type,
      description: desc,
      co2Saved: co2,
      piReward: piReward,
      date: DateTime.now(),
    );

    cubit.addActivity(activity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activity saved — +${piReward.toStringAsFixed(3)} Pi')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final types = <String>[
      'Walking',
      'Recycling',
      'Energy Saving',
      'Tree Planting',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Activity'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Select Activity'),
              items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedType = val;
                });

                if (val == 'Walking') {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _startWalkingFlow();
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            if (_selectedType != null && _selectedType != 'Walking') ...[
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              if (_selectedType == 'Recycling') ...[
                TextField(
                  controller: _plasticController,
                  decoration: const InputDecoration(labelText: 'Plastic bottles recycled'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _canController,
                  decoration: const InputDecoration(labelText: 'Aluminum cans recycled'),
                  keyboardType: TextInputType.number,
                ),
              ] else if (_selectedType == 'Energy Saving') ...[
                TextField(
                  controller: _energyController,
                  decoration: const InputDecoration(labelText: 'Saved kWh'),
                  keyboardType: TextInputType.number,
                ),
              ] else if (_selectedType == 'Tree Planting') ...[
                TextField(
                  controller: _treeController,
                  decoration: const InputDecoration(labelText: 'Number of trees planted'),
                  keyboardType: TextInputType.number,
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveNonWalkingActivity,
                child: const Text('Save Activity'),
              ),
            ] else if (_selectedType == 'Walking') ...[
              const SizedBox(height: 20),
              const Text('Preparing walking tracker...', style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ],
        ),
      ),
    );
  }
}
