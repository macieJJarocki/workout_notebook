// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final typeId = 0;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      uuid: fields[0] as String,
      isCompleted: fields[2] as bool,
      name: fields[3] as String,
      weight: (fields[4] as num).toDouble(),
      repetitions: (fields[5] as num).toInt(),
      sets: (fields[6] as num).toInt(),
      comment: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.comment)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.repetitions)
      ..writeByte(6)
      ..write(obj.sets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final typeId = 1;

  @override
  Workout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout(
      uuid: fields[0] as String,
      name: fields[2] as String,
      exercises: (fields[3] as List).cast<Exercise>(),
      isCompleted: fields[4] as bool,
      dateTime: fields[5] as DateTime?,
      comment: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.comment)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.exercises)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
