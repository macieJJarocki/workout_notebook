import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocsObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    // debugPrint('--------${bloc.runtimeType} created');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint(
      'bloc: ${bloc.runtimeType} crr_state: ${transition.currentState} event: ${transition.event} next_state: ${transition.nextState}',
    );
  }
}
