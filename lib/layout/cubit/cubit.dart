import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piecotrack/layout/cubit/states.dart';
import 'package:piecotrack/model/model_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitial());

  final List<ActivityModel> _activities = [
    ActivityModel( type: 'Walking', description: 'Walked 5km instead of driving', co2Saved: 0.5, piReward: 2.0, date: DateTime.now() ),
    ActivityModel( type: 'Recycling', description: 'Recycled 10 plastic bottles', co2Saved: 0.2, piReward: 1.0,date: DateTime.now() ),
  ];

  void loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    emit(ActivityLoaded(_activities));
  }

  void addActivity(ActivityModel newActivity) async {
    _activities.add(newActivity);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_activity', newActivity.toString());
    emit(ActivityLoaded(_activities));
  }

  double calculateTotalCo2() {
    return _activities.fold(0.0, (sum, activity) => sum + activity.co2Saved);
  }

  double calculatePiReward(double co2) {
    return co2 * 4.0;
  }
}