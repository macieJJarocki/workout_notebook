import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';

@GenerateAdapters([AdapterSpec<Exercise>(), AdapterSpec<Workout>()])
part 'hive_adapters.g.dart';
