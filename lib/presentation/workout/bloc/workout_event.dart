part of 'workout_bloc.dart';

sealed class WorkoutEvent {
  @override
  String toString() {
    return '$runtimeType';
  }
}

class WorkoutDataRequested extends WorkoutEvent {}
