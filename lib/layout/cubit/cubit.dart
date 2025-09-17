import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piecotrack/layout/cubit/states.dart';
import 'package:piecotrack/model/model_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitial());

  final List<ActivityModel> _activities = [
    // ActivityModel( type: 'Walking', description: 'Walked 5km instead of driving', co2Saved: 0.5, piReward: 2.0, date: DateTime.now() ),
    // ActivityModel( type: 'Recycling', description: 'Recycled 10 plastic bottles', co2Saved: 0.2, piReward: 1.0,date: DateTime.now() ),
  ];


  double _roundTo5(double value) {
    return double.parse(value.toStringAsFixed(5));
  }

  double calculateTotalCo2() {
    final total = _activities.fold(0.0, (sum, activity) => sum + activity.co2Saved);
    return _roundTo5(total);
  }

  double calculatePiReward(double co2) {
    final reward = co2 * 4.0;
    return _roundTo5(reward);
  }

  void addActivity(ActivityModel activity) {
    _activities.add(activity);
    emit(ActivityLoaded(List.from(_activities)));
  }

  void loadActivities() {
    emit(ActivityLoaded(List.from(_activities)));
  }



}