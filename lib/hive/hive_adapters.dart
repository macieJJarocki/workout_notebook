import 'package:hive_ce/hive.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';

@GenerateAdapters([AdapterSpec<Exercise>(), AdapterSpec<Workout>()])
part 'hive_adapters.g.dart';
