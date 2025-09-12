import '../../model/model_screen.dart';

abstract class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<ActivityModel> activities;
  ActivityLoaded(this.activities);
}
