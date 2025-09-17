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
  double _totalDistance = 0.0; // meters
  int _stepsCount = 0;
  Position? _lastPosition;
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    // don't auto-start — let user press Start
  }

  void _startTracking() async {
    // Request permission if needed (especially on mobile)
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied')));
        return;
      }
    }

    setState(() {
      _isTracking = true;
      _totalDistance = 0.0;
      _stepsCount = 0;
      _lastPosition = null;
    });

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5, // finer updates for better distance estimate
      ),
    ).listen((Position position) {
      _updateSteps(position);
    });
  }

  void _stopTrackingAndReturn() {
    _positionStream?.cancel();
    setState(() {
      _isTracking = false;
    });

    // Return collected data to caller (AddActivityScreen)
    Navigator.of(context).pop({
      'steps': _stepsCount,
      'distance': _totalDistance,
    });
  }

  void _updateSteps(Position newPosition) {
    if (_lastPosition != null) {
      double speedKmH = newPosition.speed * 3.6;

      if (speedKmH > MAX_WALKING_SPEED_KMH) {
        // ignore unrealistic movement (e.g., car)
        _lastPosition = newPosition;
        return;
      }

      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      if (distance > 0) {
        _totalDistance += distance;
        _stepsCount = (_totalDistance / 0.76).round(); // approximate step length ~0.76m
        setState(() {});
      }
    } else {
      // first position set
      setState(() {
        _lastPosition = newPosition;
      });
    }
    // update last position
    _lastPosition = newPosition;
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walking Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
        child: Column(
          children: [
            const Text('Track your walk', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Steps', style: TextStyle(color: Colors.grey[700])),
            Text('$_stepsCount', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Distance: ${_totalDistance.toStringAsFixed(1)} m', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Speed: ${_lastPosition != null ? (_lastPosition!.speed * 3.6).toStringAsFixed(2) : '0.00'} km/h'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isTracking ? null : _startTracking,
                  child: const Text('Start'),
                ),
                ElevatedButton(
                  onPressed: _isTracking ? _stopTrackingAndReturn : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text('Finish'),
                ),
                TextButton(
                  onPressed: () {
                    // cancel and return null so AddActivityScreen can reset
                    _positionStream?.cancel();
                    Navigator.of(context).pop(null);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
