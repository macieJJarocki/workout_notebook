part of 'home_bloc.dart';

sealed class HomeState {
  @override
  String toString() {
    return '$runtimeType';
  }
}

final class HomeStateLoading extends HomeState {}

final class HomeStateSuccess extends HomeState {
  final List<Workout> workouts;
  final List<Exercise> exercises;

  HomeStateSuccess({
    this.workouts = const [],
    this.exercises = const [],
  });
}

final class HomeStateFailure extends HomeState {
  final String message;

  HomeStateFailure({required this.message});
}
