// walking_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

// Max allowed speed for walking in km/h to prevent cheating.
const double MAX_WALKING_SPEED_KMH = 8.0;

class WalkingTrackerScreen extends StatefulWidget {
  const WalkingTrackerScreen({Key? key}) : super(key: key);

  @override
  _WalkingTrackerScreenState createState() => _WalkingTrackerScreenState();
}

class _WalkingTrackerScreenState extends State<WalkingTrackerScreen> {
  double _totalDistance = 0;
  int _stepsCount = 0;
  Position? _lastPosition;
  late StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  // Function to start tracking the user's location
  void _startTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10, // Update location every 10 meters
      ),
    ).listen((Position position) {
      _updateSteps(position);
    });
  }

  // Function to calculate distance and convert it to steps
  void _updateSteps(Position newPosition) {
    if (_lastPosition != null) {
      // Calculate current speed in km/h
      double speedKmH = newPosition.speed * 3.6;

      // Check if the user's speed is within the walking range
      if (speedKmH > MAX_WALKING_SPEED_KMH) {
        // If speed is too high, ignore the data
        return;
      }

      // Calculate the distance between the last position and the new position
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      if (distance > 0) {
        _totalDistance += distance;
        // Convert distance to steps (assuming a step is 0.76 meters)
        _stepsCount = (_totalDistance / 0.76).round();
      }
    }
    _lastPosition = newPosition;
    setState(() {});
  }

  @override
  void dispose() {
    _positionStream.cancel(); // Stop tracking when leaving the page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your steps:', style: TextStyle(fontSize: 24)),
            Text(
              '$_stepsCount',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Distance: ${_totalDistance.toStringAsFixed(2)} meters'),
            Text('Speed: ${_lastPosition != null ? (_lastPosition!.speed * 3.6).toStringAsFixed(2) : '0.00'} km/h'),
          ],
        ),
      ),
    );
  }
}