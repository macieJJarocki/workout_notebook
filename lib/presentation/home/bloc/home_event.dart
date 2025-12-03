part of 'home_bloc.dart';

sealed class HomeEvent {
  @override
  String toString() {
    return '$runtimeType';
  }
}

class HomeDataRequested extends HomeEvent {}
